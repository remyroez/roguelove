
local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

require 'components.Displayable'
require 'components.Position'

local DisplaySystem = require 'systems.DisplaySystem'

local engine = nil

function love.load()
    engine = lovetoys.Engine()

    do
        local displaySystem = DisplaySystem(rot.Display())
        engine:addSystem(displaySystem, 'update')
        engine:addSystem(displaySystem, 'draw')
    end
    
    do
        local player = lovetoys.Entity()
        local Position, Displayable = lovetoys.Component.load { 'Position', 'Displayable' }
        player:add(Position(1, 1))
        player:add(Displayable(DisplaySystem.static.layer.actor))
        player:get('Displayable'):setSymbol('@')
        engine:addEntity(player)
    end
end

function love.update(dt)
    engine:update(dt)
end

function love.draw()
    engine:draw()
end
