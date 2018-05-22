
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
    self.showEntityWindow = true
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

    self.showEntityWindow = imgui.Begin("Entities", self.showEntityWindow, { "ImGuiWindowFlags_AlwaysAutoResize" })
    
    local entities = {}
    for index, entity in pairs(self.engine.entities) do
        table.insert(entities, entity.id --[[.. (entity.name and (': ' .. entity.name) or '')]])
    end
    
    local select
    select, self.selected = imgui.ListBox('list', self.selected, entities, #entities)

    if select then
        print(self.selected)
    end

    local entity = self.engine.entities[entities[self.selected]]
    if entity then
        imgui.Begin('Entity ' .. entity.id)
        for name, component in pairs(entity.components) do
            if imgui.CollapsingHeader(name) then
                for key, value in pairs(component) do
                    if key == 'class' then
                        -- skip
                    elseif key == 'dirty' then
                        -- skip
                    else
                        imgui.Text(key .. ": " .. tostring(value))
                    end
                end
            end
        end
        imgui.End()
    end

    if imgui.IsMouseDoubleClicked(0) then
        print('double click')
    end

    imgui.End()

    imgui.Render()
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
