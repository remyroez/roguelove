
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local rot = require 'rot'

local Component = lovetoys.Component.create('Actor')

function Component:initialize(speed)
    self.speed = speed or 100
    self.eventQueue = rot.EventQueue()
    self.added = false
end

function Component:getSpeed()
    return self.speed
end

function Component:repeating()
    return true
end

function Component:delay()
    return nil
end

function Component:update(entity)
end

function Component:clear()
    self.eventQueue:clear()
end

function Component:schedule(action, time)
    self.eventQueue:add(action, time or 100)
end

function Component:reschedule(action, time)
    if action then
        self.eventQueue:remove(action)
        self:schedule(action, time)
    end
end

function Component:act()
    local result
    local action = self.eventQueue:get()
    if type(action) == 'function' then
        result = action(self)
    end
    return result
end

return Component
