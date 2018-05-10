
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Displayable = lovetoys.Component.create('Displayable')

function Displayable:initialize()
    self:clear()
    self:reset()
end

function Displayable:reset()
    self.map = {}
    self:flush()
end

function Displayable:flush()
    util.fill(self.dirty)
end

function Displayable:clear()
    self.map = {}
    self.dirty = {}
end

function Displayable:setSymbol(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.map, value, x, y)
    util.fill(self.dirty)
end

function Displayable:getSymbol(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.map, x, y)
end

return Displayable
