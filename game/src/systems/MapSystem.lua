
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local MapSystem = class('MapSystem', lovetoys.System)

function MapSystem:initialize()
    lovetoys.System.initialize(self)
    self.pathfinder = nil
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

function MapSystem:PassableCallback()
    return function (x, y)
        local passable = true
        for index, entity in pairs(self.targets) do
            if entity:get('Collider'):getCollision(x, y) then
                passable = false
                break
            end
        end
        return passable
    end
end

function MapSystem:onPathfinding(event)
    event.result = self:pathfinding(event.x, event.y)
end

function MapSystem:pathfinding(x, y)
    local paths = {}
    if not self.pathfinder then
        self.pathfinder = rot.Path.AStar(x, y, self:PassableCallback())
    end
    self.pathfinder:compute(x, y, function (x, y) table.insert(paths, {x, y}) end)
    return paths
end

return MapSystem
