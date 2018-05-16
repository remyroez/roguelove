
local class = require 'middleclass'

local Event = class('Pathfinding')

Event.static.algorithm = {
    astar = 'Astar',
    dijkstra = 'Dijkstra',
}

function Event:initialize(toX, toY, fromX, fromY)
    self.pathfinder = nil
    self.algorithm = 'Astar' or 'Dijkstra'
    self.toX = toX or 1
    self.toY = toY or 1
    self.fromX = fromX or 1
    self.fromY = fromY or 1
    self.result = {}
end

return Event
