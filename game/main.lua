
local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

require 'components.Collider'
require 'components.Displayable'
require 'components.Map'
require 'components.Player'
require 'components.Position'

local DisplaySystem = require 'systems.DisplaySystem'
local MapSystem = require 'systems.MapSystem'
local MoveSystem = require 'systems.MoveSystem'
local PlayerSystem = require 'systems.PlayerSystem'

local KeyPressed = require 'events.KeyPressed'
local Move = require 'events.Move'

local engine = nil

function love.load()
    love.keyboard.setKeyRepeat(true)

    engine = lovetoys.Engine()

    -- player system
    do
        local system = PlayerSystem(engine.eventManager)
        engine:addSystem(system)
        engine:stopSystem(system.class.name)
        engine.eventManager:addListener(KeyPressed.name, system, system.keypressed)
    end

    -- move system
    do
        local system = MoveSystem()
        engine:addSystem(system)
        engine:stopSystem(system.class.name)
        engine.eventManager:addListener(Move.name, system, system.onMove)
    end

    -- map system
    engine:addSystem(MapSystem())
    
    -- display system
    do
        local displaySystem = DisplaySystem(rot.Display())
        engine:addSystem(displaySystem, 'update')
        engine:addSystem(displaySystem, 'draw')
    end

    -- player
    do
        local entity = lovetoys.Entity()

        local Position, Displayable, Collider, Player = lovetoys.Component.load { 'Position', 'Displayable', 'Collider', 'Player' }
        entity:add(Position(10, 10))
        entity:add(Displayable(DisplaySystem.static.layer.actor, 2, 2))
        entity:get('Displayable'):setSymbol('@')
        entity:add(Collider(DisplaySystem.static.layer.actor, 2, 2))
        entity:get('Collider'):setCollision(true)
        entity:add(Player())

        engine:addEntity(entity)
    end
    
    -- map
    do
        local entity = lovetoys.Entity()

        local Position, Displayable, Collider, Map = lovetoys.Component.load { 'Position', 'Displayable', 'Collider', 'Map' }
        entity:add(Position())
        entity:add(Displayable(DisplaySystem.static.layer.map, 80, 24))
        entity:add(Collider(DisplaySystem.static.layer.map, 80, 24))
        entity:add(Map(rot.Map.Brogue(80, 24)))

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
