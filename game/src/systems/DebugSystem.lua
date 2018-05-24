
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
            self.showEntityWindow = self:drawEntityWindow(self.showEntityWindow, entity, false)
        end
    end
    
    imgui.End()

    return opened
end

function System:drawEntityWindow(open, entity, hide_private)
    local began, opened = imgui.Begin('Entity ' .. (entity.name and ("[" .. entity.name .. "]") or entity.id), open, {'NoSavedSettings'})

    if not began then
        -- collapsed
    elseif not opened then
        -- closed
    else
        for name, component in pairs(entity.components) do
            self:drawObject(name, component, hide_private)
            imgui.Spacing()
        end
    end

    imgui.End()

    return opened
end

function System:drawObject(name, object, hide_private)
    imgui.PushID(name)
    if imgui.CollapsingHeader(name) then
        imgui.Indent()
        local has_member = false
        for key, value in pairs(object) do
            if hide_private and string.sub(key, 1, 1) == '_' then
                -- hide private
            elseif key == 'class' then
                -- skip
            elseif key == 'dirty' then
                -- skip
            elseif type(value) == 'table' then
                self:drawObject(key, value, hide_private)
                has_member = true
            elseif type(value) == 'string' then
                local change, input = imgui.InputText(key, value, 0xFF)
                if change then object[key] = input end
                has_member = true
            elseif type(value) == 'function' then
                imgui.Text(key .. ": " .. tostring(value))
                has_member = true
            else
                imgui.Value(key, value)
                has_member = true
            end
        end
        if not has_member then
            imgui.Text('empty')
        end
        imgui.Unindent()
    end
    imgui.PopID()
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
