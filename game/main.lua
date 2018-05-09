
local const = require 'const'

local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

require 'components.Collider'
require 'components.Displayable'
require 'components.Light'
require 'components.Map'
require 'components.Player'
require 'components.Position'
require 'components.Shadow'
require 'components.View'

local DisplaySystem = require 'systems.DisplaySystem'
local LightSystem = require 'systems.LightSystem'
local MapSystem = require 'systems.MapSystem'
local MoveSystem = require 'systems.MoveSystem'
local PlayerSystem = require 'systems.PlayerSystem'
local ShadowSystem = require 'systems.ShadowSystem'
local ViewSystem = require 'systems.ViewSystem'

local Collection = require 'events.Collection'
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

    -- light system
    do
        local system = LightSystem(
            rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()),
            shadowSystem:PreciseLightPassCallback()
        )
        engine:addSystem(system)
        engine.eventManager:addListener(Flush.name, system, system.flush)
        engine.eventManager:addListener(Collection.name, system, system.onCollection)
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

        local Player, Position, Displayable, Collider, Shadow, Light, View = lovetoys.Component.load {
            'Player', 'Position', 'Displayable', 'Collider', 'Shadow', 'Light', 'View'
        }
        entity:add(Player())
        entity:add(Position(10, 10))
        entity:add(Displayable(const.layer.actor))
        entity:add(Collider(const.layer.actor))
        entity:add(Shadow(const.layer.actor))
        entity:add(Light(const.layer.actor))
        entity:add(View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()), 10))

        local tile = tileSet:get('player')
        entity:get('Displayable'):setSymbol(tile.symbol)
        entity:get('Collider'):setCollision(tile.collision)
        entity:get('Shadow'):setShade(tile.shade)
        entity:get('Light'):setColor(rot.Color.fromString('goldenrod'))

        engine:addEntity(entity)
    end
    
    -- map
    do
        local entity = lovetoys.Entity()

        local Map, Position, Displayable, Collider, Shadow, Light = lovetoys.Component.load {
            'Map', 'Position', 'Displayable', 'Collider', 'Shadow', 'Light'
        }
        local w = 80
        local h = 24
        entity:add(Map(rot.Map.Brogue(w, h)))
        entity:add(Position())
        entity:add(Displayable(const.layer.map, w, h))
        entity:add(Collider(const.layer.map, w, h))
        entity:add(Shadow(const.layer.map, w, h))
        entity:add(Light(const.layer.map, w, h))
        
        entity:get('Light'):setColor(rot.Color.fromString('red'), 40, 15)
        entity:get('Light'):setColor(rot.Color.fromString('green'), 10, 15)
        entity:get('Light'):setColor(rot.Color.fromString('blue'), 70, 15)

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
