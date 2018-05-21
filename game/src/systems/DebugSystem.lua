
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

require 'imgui'

local System = class('DebugSystem', lovetoys.System)

function System:initialize(engine)
    lovetoys.System.initialize(self)
    self.engine = engine
    self.showTestWindow = false
end

function System:requires()
    return { 'Debug' }
end

function System:update(dt)
    imgui.NewFrame()
end

function System:draw()
    
    if imgui.BeginMainMenuBar() then
        if imgui.BeginMenu("File") then
            imgui.MenuItem("Test")
            imgui.EndMenu()
        end
        imgui.EndMainMenuBar()
    end

    imgui.Text("Hello, world!")

    if imgui.Button("Test Window") then
        self.showTestWindow = not self.showTestWindow;
    end

    if self.showTestWindow then
        self.showTestWindow = imgui.ShowMetricsWindow(true)
    end

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
