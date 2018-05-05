
local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}

local engine = nil

function love.load()
    engine = lovetoys.Engine()
end

function love.update(dt)
    engine:update(dt)
end

function love.draw()
    engine:draw()
end
