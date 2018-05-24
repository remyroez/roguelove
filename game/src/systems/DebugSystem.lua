
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
                        label = 'FooBar',
                        children = function ()
                            print('FooBar!')
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
        self:drawEntitiesWindow()
    end

    imgui.Render()
end

function System:drawEntitiesWindow()
    self.showEntitiesWindow = imgui.Begin("Entities", true, { "ImGuiWindowFlags_AlwaysAutoResize" })

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
    if entity then
        self:drawEntityWindow(entity)
    end

    imgui.End()
end

function System:drawEntityWindow(entity)
    self.showEntityWindow = imgui.Begin('Entity ' .. entity.id, true, {'ImGuiWindowFlags_NoSavedSettings'})

    for name, component in pairs(entity.components) do
        self:drawObject(name, component)
        imgui.Spacing()
    end

    imgui.End()
end

function System:drawObject(name, object)
    imgui.PushID(name)
    if imgui.CollapsingHeader(name) then
        imgui.Indent()
        for key, value in pairs(object) do
            if key == 'class' then
                -- skip
            elseif key == 'dirty' then
                -- skip
            elseif type(value) == 'table' then
                self:drawObject(key, value)
            else
                imgui.Text(key .. ": " .. tostring(value))
            end
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
