
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local View = lovetoys.Component.create('View')

function View:initialize(fov, radius)
    self.fov = fov
    self.radius = radius or 10
    self:clear()
end

function View:flush()
    util.fill(self.dirty)
end

function View:clear()
    self:clearVision()
    self:clearSeen()
    self.dirty = {}
end

function View:clearVision()
    self.visionMap = {}
end

function View:clearSeen()
    self.seenMap = {}
end

function View:compute(x, y, callback)
    self:clearVision()
    self.fov:compute(x, y, self.radius, self:computer(callback))
end

function View:computer(callback)
    return function (x, y, r, v)
        self:setVision(v, x, y)
        self:setSeen(v > 0, x, y)
        if callback then callback(x, y, r, v) end
    end
end

function View:setVision(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.visionMap, value, x, y)
    self:flush()
end

function View:getVision(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.visionMap, x, y)
end

function View:setSeen(value, x, y)
    x = x or 1
    y = y or 1
    util.setMap(self.seenMap, value, x, y)
    self:flush()
end

function View:getSeen(x, y)
    x = x or 1
    y = y or 1
    return util.getMap(self.seenMap, x, y)
end

return View
