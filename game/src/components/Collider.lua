
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Collider = lovetoys.Component.create('Collider')

function Collider:initialize(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
    
    self.collisions = {}
    self.dirty = true
end

function Collider:reset(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
    
    self.collisions = {}
    self.dirty = true
end

function Collider:clear()
    self.collisions = {}
    self.dirty = true
end

function Collider:validatePosition(x, y)
    local validate = false

    if x < 1 then
        -- error
    elseif x > self.width then
        -- error
    elseif y < 1 then
        -- error
    elseif y > self.height then
        -- error
    else
        validate = true
    end

    return validate
end

function Collider:setCollision(collision, x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        util.setMap(self.collisions, collision, x, y)
        self.dirty = true
    end
end

function Collider:getCollision(x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        return util.getMap(self.collisions, x, y)
    end
    return nil
end

return Collider
