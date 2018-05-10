
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Shadow = lovetoys.Component.create('Shadow')

function Shadow:initialize()
    self:clear()
    self:reset()
end

function Shadow:reset()
    self.map = {}
    self:flush()
end

function Shadow:flush()
    util.fill(self.dirty)
end

function Shadow:clear()
    self.map = {}
    self.dirty = {}
end

function Shadow:setShade(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.map, value, x, y)
    util.fill(self.dirty)
end

function Shadow:getShade(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.map, x, y)
end

return Shadow
