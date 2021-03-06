
require 'autobatch'

local const = require 'const'
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'
lovetoys.initialize {
    debug = true,
    global = false,
    middleclassPath = 'middleclass'
}
local rot = require 'rot'

local components = require 'components'
local systems = require 'systems'
local events = require 'events'
local asset = require 'asset'

local Terminal = require 'core.Terminal'

local engine = nil

local context = {}

function love.load()
    love.keyboard.setKeyRepeat(true)

    engine = lovetoys.Engine()

    -- asset system
    local assetSystem
    do
        local system = systems.AssetSystem()
        engine:addSystem(system)
        engine:stopSystem(system.class.name)

        system:newAsset('assets/core')
        system:newAsset('assets/tileset/simple_mood')

        assetSystem = system
    end
    
    -- tag system
    do
        local system = systems.TagSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(events.FindEntitiesWithTag.name, system, system.onFindEntitiesWithTag)
    end

    -- attribute system
    do
        local system = systems.AttributeSystem(engine)
        engine:addSystem(system)
        engine.eventManager:addListener(events.NextTurn.name, system, system.nextTurn)
    end

    -- behavior system
    do
        local system = systems.BehaviorSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(events.NextTurn.name, system, system.nextTurn)
    end

    -- actor system
    do
        local system = systems.ActorSystem(rot.Scheduler.Speed())
        engine:addSystem(system)
        engine.eventManager:addListener(lovetoys.ComponentAdded.name, system, system.componentAdded)
        engine.eventManager:addListener(lovetoys.ComponentRemoved.name, system, system.componentRemoved)
        engine.eventManager:addListener(events.NextTurn.name, system, system.nextTurn)
    end

    -- player system
    do
        local system = systems.PlayerSystem(engine.eventManager)
        engine:addSystem(system)
        engine:stopSystem(system.class.name)
        engine.eventManager:addListener(events.KeyPressed.name, system, system.keypressed)
    end

    -- move system
    do
        local system = systems.MoveSystem(engine.eventManager)
        engine:addSystem(system)
        engine:stopSystem(system.class.name)
        engine.eventManager:addListener(events.Move.name, system, system.onMove)
        engine.eventManager:addListener(events.HitCheck.name, system, system.onHitCheck)
    end

    -- map system
    do
        engine:addSystem(systems.MapSystem())
    end
    
    -- pathfinding system
    do
        local system = systems.PathfindingSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(events.Pathfinding.name, system, system.onPathfinding)
    end
    
    -- shadow system
    local shadowSystem = nil
    do
        local system = systems.ShadowSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(events.Flush.name, system, system.flush)
        shadowSystem = system
    end

    -- light system
    do
        local system = systems.LightSystem(
            rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()),
            shadowSystem:PreciseLightPassCallback()
        )
        engine:addSystem(system)
        engine.eventManager:addListener(events.Flush.name, system, system.flush)
        engine.eventManager:addListener(events.Collection.name, system, system.onCollection)
    end

    -- view system
    do
        local system = systems.ViewSystem()
        engine:addSystem(system)
        engine.eventManager:addListener(events.Flush.name, system, system.flush)
    end

    -- display system
    do
        local tileset = assetSystem:get('tileset_simple_mood_ascii')
        tileset:load()
        
        local system = systems.DisplaySystem(engine, Terminal(tileset))
        engine:addSystem(system, 'update')
        engine:addSystem(system, 'draw')
    end

    -- player
    do
        local entity = lovetoys.Entity()

        entity:add(components.Player())
        entity:add(components.Tag { 'player' } )
        entity:add(components.Actor(100))
        entity:add(components.Attribute(assetSystem:get('attribute_core_default')))
        entity:add(components.Position(10, 10))
        entity:add(components.Size())
        entity:add(components.Layer(const.layer.actor))
        entity:add(components.Displayable())
        entity:add(components.Collider())
        entity:add(components.Shadow())
        entity:add(components.Light())
        entity:add(components.View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()), 10))

        local object = assetSystem:get('object_core_player')
        entity:get('Displayable'):setSymbol(object:symbol())
        entity:get('Collider'):setCollision(object:collision())
        entity:get('Shadow'):setShade(object:shade())
        entity:get('Light'):setColor(rot.Color.fromString('goldenrod'))

        engine:addEntity(entity)
    end

    -- other actor
    for i = 1, 1 do
        local entity = lovetoys.Entity()

        entity:add(components.Tag { 'legion' } )
        entity:add(components.Actor(100))
        entity:add(components.Attribute(assetSystem:get('attribute_core_default')))
        entity:add(components.Behavior(engine))
        entity:add(components.Position(math.random(10, 70), math.random(10, 14)))
        entity:add(components.Size())
        entity:add(components.Layer(const.layer.actor))
        entity:add(components.Displayable())
        entity:add(components.Collider())
        entity:add(components.Shadow())
        entity:add(components.Light())
        --entity:add(View(rot.FOV.Precise:new(shadowSystem:PreciseLightPassCallback()), 10))

        local object = assetSystem:get('object_core_player')
        entity:get('Displayable'):setSymbol(object:symbol())
        entity:get('Collider'):setCollision(object:collision())
        entity:get('Shadow'):setShade(object:shade())
        entity:get('Light'):setColor(rot.Color.fromString('purple'))
        --entity:get('Actor'):schedule(function () print('hoge 1') end, 30)
        --entity:get('Actor'):schedule(function () print('hoge 2') end, 20)
        --entity:get('Actor'):schedule(function () print('hoge 3') end, 10)
        entity:get('Behavior'):gotoState('predator')
        --entity:get('Behavior'):gotoState('Wanderer')

        engine:addEntity(entity)
    end
    
    -- map
    do
        local entity = lovetoys.Entity()

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
        entity:add(components.Map(rot.Map.Brogue(w, h), callback))
        entity:add(components.Position())
        entity:add(components.Size(w, h))
        entity:add(components.Layer(const.layer.map))
        entity:add(components.Displayable())
        entity:add(components.Collider())
        entity:add(components.Shadow())
        entity:add(components.Light())
        
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
        engine.eventManager:fireEvent(events.KeyPressed(key, scancode, isrepeat))
    end
end
