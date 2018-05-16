
local lovetoys = require 'lovetoys.lovetoys'
local Stateful = require 'stateful'

local events = require 'events'

local Component = lovetoys.Component.create('Behavior')
Component:include(Stateful)

function Component:initialize(engine)
    self.engine = engine
end

function Component:action(entity)
    return function () end
end

function Component:fireEvent(...)
    return self.engine.eventManager:fireEvent(...)
end

function Component:moveEntity(entity, x, y)
    events.fireMove(
        self.engine,
        entity.id,
        entity:get('Position'),
        entity:get('Size'),
        entity:get('Layer'),
        entity:get('Collider'),
        x,
        y
    )
end

return Component
