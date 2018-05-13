
local class = require 'middleclass'

local lume = require 'lume'
local rot = require 'rot'

local TileSet = class('TileSet')

TileSet.static.defaultWidth = 9
TileSet.static.defaultHeight = 16
TileSet.static.defaultNumHorizontal = 32
TileSet.static.defaultNumVertical = 8
TileSet.static.defaultNumGlyphs = TileSet.static.defaultNumHorizontal * TileSet.static.defaultNumVertical

function TileSet:initialize(setting)
    self.tiles = setting and setting.tiles or {}
end

function TileSet:get(name)
    local tile = self.tiles[name] or {}
    if tile.symbol ~= nil then
        if type(tile.symbol.character) == 'number' then
            tile.symbol.character = string.char(tile.symbol.character)
        end
        if type(tile.symbol.fgcolor) == 'string' then
            tile.symbol.fgcolor = rot.Color.fromString(tile.symbol.fgcolor)
        end
        if type(tile.symbol.bgcolor) == 'string' then
            tile.symbol.bgcolor = rot.Color.fromString(tile.symbol.bgcolor)
        end
    end
    return self.tiles[name] or {}
end

function TileSet:width()
    return self.glyph.width or TileSet.defaultWidth
end

function TileSet:height()
    return self.glyph.height or TileSet.defaultHeight
end

function TileSet:numHorizontal()
    return self.glyph.numHorizontal or TileSet.defaultNumHorizontal
end

function TileSet:numVertical()
    return self.glyph.numVertical or TileSet.defaultNumVertical
end

function TileSet:numGlyphs()
    return self:numHorizontal() * self:numVertical()
end

function TileSet:sprite()
    return self.glyph.sprite
end

function TileSet:quads()
    return self.glyph.quads
end


return TileSet