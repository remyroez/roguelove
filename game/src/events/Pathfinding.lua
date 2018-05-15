
local class = require 'middleclass'

local Event = class('Pathfinding')

function Event:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.result = {}
end

return Event
