
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local MapSystem = class('MapSystem', lovetoys.System)

function MapSystem:initialize()
    lovetoys.System.initialize(self)
end

function MapSystem:requires()
    return { 'Map', 'Displayable', 'Collider', 'Shadow' }
end

function MapSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local map = entity:get('Map')
        
        if map.dirty then
            entity:get('Displayable'):clear()
            entity:get('Collider'):clear()
            entity:get('Shadow'):clear()
    
            map:create(entity)
            map.dirty = false
        end
    end
end

return MapSystem
