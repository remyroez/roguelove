
local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Behavior = require(folderOfThisFile .. 'Behavior')

local events = require 'events'

local Predator = Behavior:addState 'predator'

function Predator:enteredState()
    self.predator = {
        paths = {},
        pathfinding = events.Pathfinding()
    }
    self.predator.pathfinding.algorithm = events.Pathfinding.dijkstra
end

function Predator:action(entity)
    local retarget = false
    
    do
        local toX, toY, fromX, fromY
        do
            local position = entity:get('Position')
            if position then
                fromX, fromY = position.x + 1, position.y + 1
            end
        end
        local entities = events.fireFindEntitiesWithTag(self.engine, { 'player' })
        for _, entity in ipairs(entities) do
            local position = entity:get('Position')
            if position then
                toX, toY = position.x + 1, position.y + 1
                break
            end
        end
        local pathfinding = self.predator.pathfinding
        if not toX or not toY or not fromX or not fromY then
            -- error
        else
            if pathfinding.toX ~= toX then
                pathfinding.toX = toX
                retarget = true
            end
            if pathfinding.toY ~= toY then
                pathfinding.toY = toY
                retarget = true
            end
            if pathfinding.fromX ~= fromX then
                pathfinding.fromX = fromX
                retarget = true
            end
            if pathfinding.fromY ~= fromY then
                pathfinding.fromY = fromY
                retarget = true
            end
        end
    end

    if retarget then
        local paths = events.fireEvent(self.engine, self.predator.pathfinding)
        table.remove(paths, 1)
        local current = { self.predator.pathfinding.fromX, self.predator.pathfinding.fromY }
        for i, pos in ipairs(paths) do
            paths[i] = { pos[1] - current[1], pos[2] - current[2] }
            current = pos
        end
        self.predator.paths = paths
    end

    return function ()
        if #self.predator.paths > 0 then
            local pos = self.predator.paths[1]
            self:moveEntity(entity, pos[1], pos[2])
            table.remove(self.predator.paths, 1)
        end
    end
end
