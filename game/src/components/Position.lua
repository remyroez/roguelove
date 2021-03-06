
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Position = lovetoys.Component.create('Position')

function Position:initialize(x, y)
    self:reset(x, y)
end

function Position:reset(x, y)
    self.x = x or 0
    self.y = y or 0
    self.dirty = {}
end

function Position:translate(x, y)
    self:reset(self.x + (x or 0), self.y + (y or 0))
end

return Position
