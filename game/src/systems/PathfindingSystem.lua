
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local System = class('PathfindingSystem', lovetoys.System)

function System:initialize()
    lovetoys.System.initialize(self)
end

function System:requires()
    return { 'Position', 'Collider' }
end

function System:update(dt)
    self.active = false
end

function System:PassableCallback(id)
    return function (x, y)
        local passable = true
        for index, entity in pairs(self.targets) do
            if entity.id == id then
                -- skip
            else
                local position = entity:get('Position')
                if entity:get('Collider'):getCollision(x, y) then
                    passable = false
                    break
                end
            end
        end
        return passable
    end
end

function System:onPathfinding(event)
    local paths = {}
    if not event.pathfinder or (event.pathfinder._toX ~= event.toX) or (event.pathfinder._toY ~= event.toY) then
        event.pathfinder = rot.Path.AStar(event.toX, event.toY, self:PassableCallback(event.id))
    end
    event.pathfinder:compute(event.fromX, event.fromY, function (x, y) table.insert(paths, {x, y}) end)
    event.result = paths
end

return System
