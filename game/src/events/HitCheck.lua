
local class = require 'middleclass'

local HitCheck = class('HitCheck')

function HitCheck:initialize(id, position, size, layer, collider, x, y, check)
    self.id = id
    self.position = position
    self.size = size
    self.layer = layer
    self.collider = collider
    self.x = x or 0
    self.y = y or 0
    self.check = check == nil and true or check
    self.result = false
end

return HitCheck
