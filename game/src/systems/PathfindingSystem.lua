
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local System = class('PathfindingSystem', lovetoys.System)

function System:initialize()
    lovetoys.System.initialize(self)
end

function System:requires()
    return { 'Position', 'Collider', 'Size' }
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
                local size = entity:get('Size')
                local left, top = x, y--x - position.x, y - position.y
                if not entity:get('Collider'):getCollision(left, top) then
                    -- skip
                else
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
        local algorithm = event.algorithm or 'AStar'
        event.pathfinder = rot.Path[algorithm](event.toX, event.toY, self:PassableCallback(event.id))
    end
    if event.toX <= 1 then
        -- 
    elseif event.toY <= 1 then
        -- 
    elseif event.fromX <= 1 then
        -- 
    elseif event.fromY <= 1 then
        -- 
    else
        --print(event.toX, event.toY, event.fromX, event.fromY)
        event.pathfinder:compute(event.fromX, event.fromY, function (x, y) table.insert(paths, {x, y}) end)
    end
    event.result = paths
end

return System
