
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Displayable = lovetoys.Component.create('Displayable')

function Displayable:initialize(layer, w, h)
    self:clear()
    self:reset(layer, w, h)
end

function Displayable:reset(layer, w, h)
    self.width = w or 1
    self.height = h or 1
    self.layer = layer or 1
    self.symbols = {}
    util.fill(self.dirty)
end

function Displayable:clear()
    self.symbols = {}
    self.dirty = {}
end

function Displayable:setSymbol(symbol, x, y)
    x = x or 1
    y = y or 1
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        util.setMap(self.symbols, symbol, x, y)
        util.fill(self.dirty)
    end
end

function Displayable:getSymbol(x, y)
    x = x or 1
    y = y or 1
    if not util.validatePosition(x, y, self.width, self.height) then
        -- error
    else
        return util.getMap(self.symbols, x, y)
    end
    return nil
end

return Displayable
