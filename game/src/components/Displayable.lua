
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Displayable = lovetoys.Component.create('Displayable')

function Displayable:initialize(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
    
    self.symbols = {}
    self.dirty = true
end

function Displayable:reset(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
    
    self.symbols = {}
    self.dirty = true
end

function Displayable:clear()
    self.symbols = {}
    self.dirty = true
end

function Displayable:validatePosition(x, y)
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

function Displayable:setSymbol(symbol, x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        util.setMap(self.symbols, symbol, x, y)
        self.dirty = true
    end
end

function Displayable:getSymbol(x, y)
    x = x or 1
    y = y or 1
    if not self:validatePosition(x, y) then
        -- error
    else
        return util.getMap(self.symbols, x, y)
    end
    return nil
end

return Displayable
