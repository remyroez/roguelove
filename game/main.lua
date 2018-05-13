
local const = require 'const'
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

require 'components.Actor'
require 'components.Collider'
require 'components.Displayable'
require 'components.Layer'
require 'components.Light'
require 'components.Map'
require 'components.Player'
require 'components.Position'
require 'components.Shadow'
require 'components.Size'
require 'components.View'

local ActorSystem = require 'systems.ActorSystem'
local DisplaySystem = require 'systems.DisplaySystem'
local LightSystem = require 'systems.LightSystem'
local MapSystem = require 'systems.MapSystem'
local MoveSystem = require 'systems.MoveSystem'
local PlayerSystem = require 'systems.PlayerSystem'
local ShadowSystem = require 'systems.ShadowSystem'
local ViewSystem = require 'systems.ViewSystem'
local AssetSystem = require 'systems.AssetSystem'

local Collection = require 'events.Collection'
local Flush = require 'events.Flush'
local KeyPressed = require 'events.KeyPressed'
local Move = require 'events.Move'
local NextTurn = require 'events.NextTurn'

local Terminal = require 'core.Terminal'

local Json = require 'asset.Json'
local Schema = require 'asset.Schema'

local Asset = require 'asset.Asset'
require 'asset.Tileset'
require 'asset.Info'
require 'asset.Object'

local engine = nil

local context = {}

function love.load()
    love.keyboard.setKeyRepeat(true)

    engine = lovetoys.Engine()

    -- asset system
    local assetSystem
    do
        local system = AssetSystem()
        engine:addSystem(system)
        engine:stopSystem(system.class.name)

        system:newAsset('assets/core')
        system:newAsset('assets/tileset/simple_mood')

        assetSystem = system
    end
    
    -- actor system
    do
        local system = ActorSystem(rot.Scheduler.Speed())
        engine:addSystem(system)
        engine.eventManager:addListener(lovetoys.ComponentAdded.name, system, system.componentAdded)
        engine.eventManager:addListener(lovetoys.ComponentRemoved.name, system, system.componentRemoved)
        engine.eventManager:addListener(NextTurn.name, system, system.nextTurn)
    end

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
    do
        engine:addSystem(MapSystem())
    end
    
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
        local tileset = assetSystem:get('tileset_simple_mood_ascii')
        tileset:load()
        
        local system = DisplaySystem(engine, Terminal(tileset))
        engine:addSystem(system, 'update')
        engine:addSystem(system, 'draw')
    end

    -- player
    do
        local entity = lovetoys.Entity()

        local Player, Actor, Position, Size, Layer, Displayable, Collider, Shadow, Light, View = lovetoys.Component.load {
            'Player', 'Actor', 'Position', 'Size', 'Layer', 'Displayable', 'Collider', 'Shadow', 'Light', 'View'
        }
        entity:add(Player())
        entity:add(Actor(100))
        entity:add(Position(10, 10))
        entity:add(Size())
        entity:add(Layer(const.layer.actor))
        entity:add(Displayable())
        entity:add(Collider())
        entity:add(Shadow())
        entity:add(Light())
        entity:add(View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()), 10))

        local object = assetSystem:get('object_core_player')
        entity:get('Displayable'):setSymbol(object:symbol())
        entity:get('Collider'):setCollision(object:collision())
        entity:get('Shadow'):setShade(object:shade())
        entity:get('Light'):setColor(rot.Color.fromString('goldenrod'))

        engine:addEntity(entity)
    end

    -- other actor
    do
        local entity = lovetoys.Entity()

        local Actor, Position, Size, Layer, Displayable, Collider, Shadow, Light, View = lovetoys.Component.load {
            'Actor', 'Position', 'Size', 'Layer', 'Displayable', 'Collider', 'Shadow', 'Light', 'View'
        }
        entity:add(Actor(100))
        entity:add(Position(20, 10))
        entity:add(Size())
        entity:add(Layer(const.layer.actor))
        entity:add(Displayable())
        entity:add(Collider())
        entity:add(Shadow())
        entity:add(Light())
        --entity:add(View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()), 10))

        local object = assetSystem:get('object_core_player')
        entity:get('Displayable'):setSymbol(object:symbol())
        entity:get('Collider'):setCollision(object:collision())
        entity:get('Shadow'):setShade(object:shade())
        entity:get('Light'):setColor(rot.Color.fromString('purple'))
        entity:get('Actor'):schedule(function () print('hoge 1') end, 30)
        entity:get('Actor'):schedule(function () print('hoge 2') end, 20)
        entity:get('Actor'):schedule(function () print('hoge 3') end, 10)

        engine:addEntity(entity)
    end
    
    -- map
    do
        local entity = lovetoys.Entity()

        local Map, Position, Size, Layer, Displayable, Collider, Shadow, Light = lovetoys.Component.load {
            'Map', 'Position', 'Size', 'Layer', 'Displayable', 'Collider', 'Shadow', 'Light'
        }
        local w = 80
        local h = 24
        local callback = function (entity)
            return function (x, y, value)
                local obj = nil
                if value == 0 then
                    obj = assetSystem:get('object_core_floor')
                elseif value == 1 then
                    obj = assetSystem:get('object_core_wall')
                elseif value == 2 then
                    obj = assetSystem:get('object_core_door')
                else
                    obj = assetSystem:get('object_core_error')
                end
                entity:get('Displayable'):setSymbol(obj:symbol(), x, y)
                entity:get('Collider'):setCollision(obj:collision(), x, y)
                entity:get('Shadow'):setShade(obj:shade(), x, y)
            end
        end
        entity:add(Map(rot.Map.Brogue(w, h), callback))
        entity:add(Position())
        entity:add(Size(w, h))
        entity:add(Layer(const.layer.map))
        entity:add(Displayable())
        entity:add(Collider())
        entity:add(Shadow())
        entity:add(Light())
        
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
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    else
        engine.eventManager:fireEvent(KeyPressed(key, scancode, isrepeat))
    end
end
