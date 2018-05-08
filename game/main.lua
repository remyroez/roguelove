
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
require 'components.Shadow'
require 'components.View'

local DisplaySystem = require 'systems.DisplaySystem'
local MapSystem = require 'systems.MapSystem'
local MoveSystem = require 'systems.MoveSystem'
local PlayerSystem = require 'systems.PlayerSystem'
local ShadowSystem = require 'systems.ShadowSystem'
local ViewSystem = require 'systems.ViewSystem'

local Flush = require 'events.Flush'
local KeyPressed = require 'events.KeyPressed'
local Move = require 'events.Move'

local TileSet = require 'core.TileSet'

local engine = nil

local context = {}

function love.load()
    love.keyboard.setKeyRepeat(true)

    local tileSet = TileSet {
        player = { symbol = { character = 1, fgcolor = 'red' }, collision = true, shade = true },
        floor = { symbol = { character = '.', fgcolor = 'darkslategray' } },
        wall = { symbol = { character = 177, fgcolor = 'lightslategray', bgcolor = 'darkslategray' }, collision = true, shade = true },
        door = { symbol = { character = '+', fgcolor = 'goldenrod' }, shade = true },
        error = { symbol = { character = '?', bgcolor = 'red' } },
    }
    context.tileSet = tileSet

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
        local system = MoveSystem(engine.eventManager)
        engine:addSystem(system)
        engine:stopSystem(system.class.name)
        engine.eventManager:addListener(Move.name, system, system.onMove)
    end

    -- map system
    engine:addSystem(MapSystem(tileSet))
    
    -- shadow system
    local shadowSystem = nil
    do
        local system = ShadowSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(Flush.name, system, system.flush)
        shadowSystem = system
    end

    -- view system
    do
        local system = ViewSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(Flush.name, system, system.flush)
    end

    -- display system
    do
        local system = DisplaySystem(engine, rot.Display())
        engine:addSystem(system, 'update')
        engine:addSystem(system, 'draw')
    end

    -- player
    do
        local entity = lovetoys.Entity()

        local Player, Position, Displayable, Collider, Shadow, View = lovetoys.Component.load {
            'Player', 'Position', 'Displayable', 'Collider', 'Shadow', 'View'
        }
        entity:add(Player())
        entity:add(Position(10, 10))
        entity:add(Displayable(DisplaySystem.static.layer.actor))
        entity:add(Collider(DisplaySystem.static.layer.actor))
        entity:add(Shadow(DisplaySystem.static.layer.actor))
        entity:add(View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback())))

        local tile = tileSet:get('player')
        entity:get('Displayable'):setSymbol(tile.symbol)
        entity:get('Collider'):setCollision(tile.collision)
        entity:get('Shadow'):setShade(tile.shade)

        engine:addEntity(entity)
    end
    
    -- map
    do
        local entity = lovetoys.Entity()

        local Map, Position, Displayable, Collider, Shadow = lovetoys.Component.load {
            'Map', 'Position', 'Displayable', 'Collider', 'Shadow', 
        }
        local w = 80
        local h = 24
        entity:add(Map(rot.Map.Brogue(w, h)))
        entity:add(Position())
        entity:add(Displayable(DisplaySystem.static.layer.map, w, h))
        entity:add(Collider(DisplaySystem.static.layer.map, w, h))
        entity:add(Shadow(DisplaySystem.static.layer.map, w, h))

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
