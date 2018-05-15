
local class = require 'middleclass'

local Event = class('Pathfinding')

function Event:initialize(toX, toY, fromX, fromY)
    self.pathfinder = nil
    self.toX = toX or 1
    self.toY = toY or 1
    self.fromX = fromX or 1
    self.fromY = fromY or 1
    self.result = {}
end

return Event
