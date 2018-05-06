
local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

require 'components.Displayable'
require 'components.Position'
require 'components.Player'

local DisplaySystem = require 'systems.DisplaySystem'
local PlayerSystem = require 'systems.PlayerSystem'

local KeyPressed = require 'events.KeyPressed'

local engine = nil

function love.load()
    engine = lovetoys.Engine()

    do
        local system = PlayerSystem()
        engine:addSystem(system)
        engine:stopSystem(PlayerSystem.name)
        engine.eventManager:addListener(KeyPressed.name, system, system.keypressed)
    end
    
    do
        local displaySystem = DisplaySystem(rot.Display())
        engine:addSystem(displaySystem, 'update')
        engine:addSystem(displaySystem, 'draw')
    end

    do
        local entity = lovetoys.Entity()
        local Position, Displayable, Player = lovetoys.Component.load { 'Position', 'Displayable', 'Player' }
        entity:add(Position(1, 1))
        entity:add(Displayable(DisplaySystem.static.layer.actor))
        entity:get('Displayable'):setSymbol('@')
        entity:add(Player())
        engine:addEntity(entity)
    end
    
    do
        local entity = lovetoys.Entity()

        local Position, Displayable = lovetoys.Component.load { 'Position', 'Displayable' }
        entity:add(Position())

        local map = rot.Map.Brogue(80, 24)
        entity:add(Displayable(DisplaySystem.static.layer.map, 80, 24))
        local displayable = entity:get('Displayable')
                
        local function generateMap(x, y, value)
            local symbol = nil
            if value == 0 then
                symbol = '.'
            elseif value == 1 then
                symbol = '#'
            elseif value == 2 then
                symbol = '+'
            end
            displayable:setSymbol(symbol, x, y)
        end

        map:create(generateMap)

        engine:addEntity(entity)
    end
end

function love.update(dt)
    engine:update(dt)
end

function love.draw()
    engine:draw()
end

function love.keypressed(key, scancode, isrepeat)
    engine.eventManager:fireEvent(KeyPressed(key, scancode, isrepeat))
end
