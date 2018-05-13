
local rot = require 'rot'

local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Asset = require(folderOfThisFile .. 'Asset')

local Object = Asset:addState 'object'

function Object:enteredState()
    self.object = {
        symbol = {
            character = nil,
            fgcolor = nil,
            bgcolor = nil
        }
    }
    self:load()
end

function Object:load()
    if type(self:character()) == 'number' then
        self.object.symbol.character = string.char(self:character())
    elseif self:character() == nil then
        self.object.symbol.character = ''
    end
    if type(self:fgcolor()) == 'string' then
        self.object.symbol.fgcolor = rot.Color.fromString(self:fgcolor())
    end
    if type(self:bgcolor()) == 'string' then
        self.object.symbol.bgcolor = rot.Color.fromString(self:bgcolor())
    end
    return self
end

function Object:name()
    return self:properties('name')
end

function Object:collision()
    return self:properties('collision')
end

function Object:shade()
    return self:properties('shade')
end

function Object:symbol()
    return self.object.symbol or self:properties('symbol')
end

function Object:character()
    return self.object.symbol.character or self:properties('symbol').character
end

function Object:fgcolor()
    return self.object.symbol.fgcolor or self:properties('symbol').fgcolor
end

function Object:bgcolor()
    return self.object.symbol.bgcolor or self:properties('symbol').bgcolor
end
