
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Light = lovetoys.Component.create('Light')

function Light:initialize()
    self:clear()
    self:reset()
end

function Light:reset()
    self.map = {}
    self:flush()
end

function Light:flush()
    util.fill(self.dirty)
end

function Light:clear()
    self.map = {}
    self.dirty = {}
end

function Light:setColor(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.map, value, x, y)
    util.fill(self.dirty)
end

function Light:getColor(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.map, x, y)
end

return Light
