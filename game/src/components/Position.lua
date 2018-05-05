
local lovetoys = require 'lovetoys.lovetoys'

local Position = lovetoys.Component.create('Position')

function Position:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.dirty = true
end

function Position:reset(x, y)
    self.x = x or 0
    self.y = y or 0
    self.dirty = true
end

return Position
