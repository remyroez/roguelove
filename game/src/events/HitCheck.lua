
local class = require 'middleclass'

local HitCheck = class('HitCheck')

function HitCheck:initialize(entity, x, y, check)
    self.entity = entity
    self.id = entity.id
    self.position = entity:get('Position')
    self.size = entity:get('Size')
    self.layer = entity:get('Layer')
    self.collider = entity:get('Collider')
    self.x = x or 0
    self.y = y or 0
    self.check = check == nil and true or check
    self.result = false
end

return HitCheck
