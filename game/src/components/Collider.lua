
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Collider = lovetoys.Component.create('Collider')

function Collider:initialize(w, h)
    self:clear()
    self:reset(w, h)
end

function Collider:reset(w, h)
    self.width = w or 1
    self.height = h or 1
    self.collisions = {}
    util.fill(self.dirty)
end

function Collider:flush()
    util.fill(self.dirty)
end

function Collider:clear()
    self.collisions = {}
    self.dirty = {}
end

function Collider:setCollision(collision, x, y)
    x = x or 1
    y = y or 1
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        util.setMap(self.collisions, collision, x, y)
        util.fill(self.dirty)
    end
end

function Collider:getCollision(x, y)
    x = x or 1
    y = y or 1
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        return util.getMap(self.collisions, x, y)
    end
    return nil
end

return Collider
