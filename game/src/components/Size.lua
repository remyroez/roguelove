
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Size')

function Component:initialize(w, h)
    self.dirty = {}
    self:reset(w, h)
end

function Component:flush()
    util.fill(self.dirty)
end

function Component:reset(w, h)
    self.width = w or 1
    self.height = h or 1
    self:flush()
end

function Component:validatePosition(x, y)
    return util.validatePosition(x, y, self.width, self.height)
end

return Component
