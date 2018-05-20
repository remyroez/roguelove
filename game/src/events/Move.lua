
local class = require 'middleclass'

local Move = class('Move')

function Move:initialize(entity, x, y, check)
    self.entity = entity
    self.id = entity.id
    self.position = entity:get('Position')
    self.size = entity:get('Size')
    self.layer = entity:get('Layer')
    self.collider = entity:get('Collider')
    self.x = x or 0
    self.y = y or 0
    self.check = check == nil and true or check
end

function Move:movedPosition()
    return { x = self.position.x + self.x, y = self.position.y + self.y }
end

return Move
