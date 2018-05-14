
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local System = class('BehaviorSystem', lovetoys.System)

function System:initialize()
    lovetoys.System.initialize(self)
end

function System:requires()
    return { 'Actor', 'Behavior' }
end

function System:update(dt)
    for index, entity in pairs(self.targets) do
        local action = entity:get('Behavior'):action(entity)
        if action then
            entity:get('Actor'):schedule(action)
        end
    end

    self.active = false
end

function System:nextTurn()
    self.active = true
end

return System
