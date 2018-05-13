
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local rot = require 'rot'

local Component = lovetoys.Component.create('Actor')

function Component:initialize(speed)
    self.speed = speed or 100
    self.eventQueue = rot.EventQueue()
end

function Component:getSpeed()
    return self.speed
end

function Component:delay()
    return nil
end

function Component:update(entity)
end

function Component:schedule(action, time)
    self.eventQueue:add(action, time or 100)
end

function Component:act()
    local action = self.eventQueue:get()
    if type(action) == 'function' then
        action(self)
    end
end

return Component
