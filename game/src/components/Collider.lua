
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Collider = lovetoys.Component.create('Collider')

function Collider:initialize()
    self:clear()
    self:reset()
end

function Collider:reset()
    self.map = {}
    self:flush()
end

function Collider:flush()
    util.fill(self.dirty)
end

function Collider:clear()
    self.map = {}
    self.dirty = {}
end

function Collider:setCollision(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.map, value, x, y)
    util.fill(self.dirty)
end

function Collider:getCollision(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.map, x, y)
end

return Collider
