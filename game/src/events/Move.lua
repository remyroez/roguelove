
local class = require 'middleclass'

local Move = class('Move')

function Move:initialize(id, position, size, layer, collider, x, y, check)
    self.id = id
    self.position = position
    self.size = size
    self.layer = layer
    self.collider = collider
    self.x = x or 0
    self.y = y or 0
    self.check = check == nil and true or check
end

return Move
