
local lovetoys = require 'lovetoys.lovetoys'
local Stateful = require 'stateful'

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

return Component
