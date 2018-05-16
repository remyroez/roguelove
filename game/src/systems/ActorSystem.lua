
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local System = class('ActorSystem', lovetoys.System)

function System:initialize(scheduler)
    lovetoys.System.initialize(self)

    self.scheduler = scheduler
    self.lockCount = 1
end

function System:requires()
    return { 'Actor' }
end

function System:update(dt)
    for index, entity in pairs(self.targets) do
        local actor = entity:get('Actor')
        if not actor.added then
            self:add(actor)
            actor.added = true
        end
    end

    self.active = false
end

function System:nextTurn()
    self:start()
    self.active = true
end

function System:start()
    return self:unlock()
end

function System:lock()
    self.lockCount = self.lockCount + 1
    return self
end

function System:unlock()
    assert(self.lockCount > 0, 'Cannot unlock unlocked Engine')
    self.lockCount = self.lockCount - 1
    while self.lockCount < 1 do
        local actor = self.scheduler:next()
        if not actor then return self:lock() end
        if actor:act() then return self:lock() end
    end
    return self
end

function System:add(actor)
    self.scheduler:add(actor, actor:repeating(), actor:delay())
end

function System:remove(actor)
    self.scheduler:remove(actor)
end

function System:componentAdded(event)
    local entity = event.entity
    local component = event.component

    if component == 'Actor' then
        self:add(entity:get(component))
    end
end

function System:componentRemoved(event)
    local entity = event.entity
    local component = event.component

    if component == 'Actor' then
        self:remove(entity:get(component))
    end
end

return System
