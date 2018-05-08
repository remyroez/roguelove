
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Shadow = lovetoys.Component.create('Shadow')

function Shadow:initialize(layer, w, h)
    self:clear()
    self:reset(layer, w, h)
end

function Shadow:reset(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
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

function Shadow:validatePosition(x, y)
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

function Shadow:setShade(value, x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        util.setMap(self.map, value, x, y)
        util.fill(self.dirty)
    end
end

function Shadow:getShade(x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        return util.getMap(self.map, x, y)
    end
    return nil
end

return Shadow
