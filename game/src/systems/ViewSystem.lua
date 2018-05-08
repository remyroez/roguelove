
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local ViewSystem = class('ViewSystem', lovetoys.System)

function ViewSystem:initialize()
    lovetoys.System.initialize(self)
end

function ViewSystem:requires()
    return { 'Position', 'View' }
end

function ViewSystem:flush()
    self.active = true
end

function ViewSystem:update(dt)
    local position = nil
    local view = nil
    local dirty = true

    for index, entity in pairs(self.targets) do
        position = entity:get('Position')
        view = entity:get('View')
        --dirty = position.dirty[ViewSystem.name] or view.dirty[ViewSystem.name]
        
        if dirty then
            view:compute(position.x, position.y)
            position.dirty[ViewSystem.name] = false
            view.dirty[ViewSystem.name] = false
        end
    end

    self.active = false
end

return ViewSystem
