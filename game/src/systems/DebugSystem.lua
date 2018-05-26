
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
    print('imgui', imgui.GetVersion())
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
        self.showEntitiesWindow = self:drawPropertyWindow(self.showEntitiesWindow)
    end

    imgui.Render()
end

function System:drawPropertyWindow(open)
    local began, opened = imgui.Begin("Entity", open)

    if not began then
        -- collapsed
    elseif not opened then
        -- closed
    else
        local indices = {}
        local displayNames = {}
        
        imgui.BeginChild('entities', 150, 0, true, { 'HorizontalScrollbar' })
        do
            local i = 1
            for index, entity in pairs(self.engine.entities) do
                local displayName = entity.id .. (entity.name and (': ' .. entity.name) or '')
                table.insert(indices, entity.id)
                table.insert(displayNames, displayName)
                if imgui.Selectable(displayName, self.selected == i) then
                    self.selected = i
                end
                i = i + 1
            end
        end
        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginGroup()
        do
            local show_private = true
            local entity = self.engine.entities[indices[self.selected]]
            imgui.Text('Entity ' .. displayNames[self.selected])
            imgui.Separator()
            imgui.BeginChild('property')
            do
                for name, component in pairs(entity.components) do
                    if not self:drawComponent(entity, name, component, show_private) then
                        break
                    end
                    imgui.Spacing()
                end
            end
            imgui.EndChild()
        end
        imgui.EndGroup()
    end
    
    imgui.End()

    return opened
end

function System:drawComponent(entity, name, component, show_private)
    imgui.PushID(name)

    local began, opened = imgui.CollapsingHeader(name, true, { 'DefaultOpen' })

    if not opened then
        -- close
        entity:remove(name)
        print(name, entity:get(name))
    elseif not began then
        -- unCollapse
    else
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

    return opened
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
