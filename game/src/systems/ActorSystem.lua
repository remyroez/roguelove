
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local System = class('ActorSystem', lovetoys.System)

function System:initialize(scheduler)
    lovetoys.System.initialize(self)

    self.scheduler = scheduler
    self.engine = rot.Engine(self.scheduler)
end

function System:requires()
    return { 'Actor' }
end

function System:update(dt)
    for index, entity in pairs(self.targets) do
        self:add(entity:get('Actor'))
    end

    self.active = false
end

function System:nextTurn()
    self.engine:start()
    self.active = true
end

function System:add(actor)
    self.scheduler:add(actor, false, actor:delay())
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
