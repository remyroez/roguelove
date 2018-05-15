
local class = require 'middleclass'

local Event = class('Pathfinding')

function Event:initialize(toX, toY, fromX, fromY)
    self.pathfinder = nil
    self.toX = toX or 0
    self.toY = toY or 0
    self.fromX = fromX or 0
    self.fromY = fromY or 0
    self.result = {}
end

return Event
