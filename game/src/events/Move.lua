
local class = require 'middleclass'

local Move = class('Move')

function Move:initialize(id, position, collider, layer, x, y, check)
    self.id = id
    self.position = position
    self.collider = collider
    self.layer = layer
    self.x = x or 0
    self.y = y or 0
    self.check = check == nil and true or check
end

return Move
