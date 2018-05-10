
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Light = lovetoys.Component.create('Light')

function Light:initialize(w, h)
    self:clear()
    self:reset(w, h)
end

function Light:reset(w, h)
    self.width = w or 1
    self.height = h or 1
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
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        util.setMap(self.map, value, x, y)
        util.fill(self.dirty)
    end
end

function Light:getColor(x, y)
    x = x or 1
    y = y or 1
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        return util.getMap(self.map, x, y)
    end
    return nil
end

return Light
