
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

require 'imgui'
local debugui = require 'debugui'

local System = class('DebugSystem', lovetoys.System)

function System:initialize(engine)
    lovetoys.System.initialize(self)
    self.engine = engine
    self.showTestWindow = false
    self.showEntitiesWindow = true
    self.showEntityWindow = false
    self.selected = 1
    self.mainMenuBar = debugui.MainMenuBar {
        children = {
            debugui.Menu {
                label = 'Menu',
                children = {
                    debugui.MenuItem {
                        label = 'Entities',
                        selected = true,
                        children = function ()
                            self.showEntitiesWindow = not self.showEntitiesWindow
                        end
                    }
                }
            }
        }
    }
end

function System:requires()
    return { 'Debug' }
end

function System:update(dt)
    imgui.NewFrame()
end

function System:draw()
    
    self.mainMenuBar()

    imgui.Text("Hello, world!")

    if imgui.Button("Test Window") then
        self.showTestWindow = not self.showTestWindow;
    end

    if self.showTestWindow then
        self.showTestWindow = imgui.ShowMetricsWindow(true)
    end

    if self.showEntitiesWindow then
        self.showEntitiesWindow = self:drawEntitiesWindow(self.showEntitiesWindow)
    end

    imgui.Render()
end

function System:drawEntitiesWindow(open)
    local began, opened = imgui.Begin("Entities", open, { "AlwaysAutoResize" })

    if not began then
        -- collapsed
    elseif not opened then
        -- closed
    else
        local entities = {}
        for index, entity in pairs(self.engine.entities) do
            table.insert(entities, entity.id --[[.. (entity.name and (': ' .. entity.name) or '')]])
        end
        
        local select
        select, self.selected = imgui.ListBox('list', self.selected, entities, #entities)
    
        if select then
            self.showEntityWindow = true
        end
    
        local entity = self.engine.entities[entities[self.selected]]
        if not self.showEntityWindow then
            -- dont show
        elseif not entity then
            -- no entity
        else
            self.showEntityWindow = self:drawEntityWindow(self.showEntityWindow, entity, true)
        end
    end
    
    imgui.End()

    return opened
end

function System:drawEntityWindow(open, entity, show_private)
    local began, opened = imgui.Begin('Entity ' .. (entity.name and ("[" .. entity.name .. "]") or entity.id), open, {'NoSavedSettings'})

    if not began then
        -- collapsed
    elseif not opened then
        -- closed
    else
        for name, component in pairs(entity.components) do
            self:drawComponent(name, component, show_private)
            imgui.Spacing()
        end
    end

    imgui.End()

    return opened
end

function System:drawComponent(name, component, show_private)
    imgui.PushID(name)

    if imgui.CollapsingHeader(name) then
        local has_value = false

        for key, value in pairs(component) do
            has_value = self:drawMember(component, key, value, show_private) or has_value
        end

        -- no value
        if not has_value then
            imgui.TextDisabled('empty')
        end
    end

    imgui.PopID()
end

function System:drawMember(object, name, member, show_private)
    local has_member = false

    local obj_type = type(member)

    if not show_private and string.sub(name, 1, 1) == '_' then
        -- hide private
    elseif string.sub(name, 1, 2) == '__' then
        -- hide meta
    elseif name == 'class' then
        -- skip
    elseif name == 'dirty' then
        -- skip
    elseif obj_type == 'table' then
        -- table
        imgui.PushID(name)
        
        if imgui.TreeNodeEx(name, { "AllowOverlapMode"}) then
            local has_value = false

            for key, value in pairs(member) do
                has_value = self:drawMember(member, key, value, show_private)
            end

            -- no value
            if not has_value then
                imgui.TextDisabled('empty')
            end

            imgui.TreePop()
        end

        imgui.PopID()

        has_member = true
    elseif obj_type == 'string' then
        -- string
        imgui.Bullet()
        local change, result = imgui.InputText(name, member, 0xFF)
        if change then object[name] = result end
        has_member = true
    elseif obj_type == 'boolean' then
        -- boolean
        imgui.Bullet()
        local change, result = imgui.Checkbox(name, member, 0xFF)
        if change then object[name] = result end
        has_member = true
    elseif obj_type == 'function' then
        -- function
        imgui.BulletText(name .. ": " .. tostring(member))
        has_member = true
    else
        -- value
        imgui.Bullet()
        imgui.Value(name, member)
        has_member = true
    end

    return has_member
end

function System:quit()
    imgui.ShutDown()
end

function System:textinput(t)
    imgui.TextInput(t)
    return imgui.GetWantCaptureKeyboard()
end

function System:keypressed(key)
    imgui.KeyPressed(key)
    return imgui.GetWantCaptureKeyboard()
end

function System:keyreleased(key)
    imgui.KeyReleased(key)
    return imgui.GetWantCaptureKeyboard()
end

function System:mousemoved(x, y)
    imgui.MouseMoved(x, y)
    return imgui.GetWantCaptureMouse()
end

function System:mousepressed(x, y, button, istouch)
    imgui.MousePressed(button)
    return imgui.GetWantCaptureMouse()
end

function System:mousereleased(x, y, button)
    imgui.MouseReleased(button)
    return imgui.GetWantCaptureMouse()
end

function System:wheelmoved(x, y)
    imgui.WheelMoved(y)
    return imgui.GetWantCaptureMouse()
end

return System
