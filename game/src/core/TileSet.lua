
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
    self.glyph = setting and setting.glyph or {}
    self.tiles = setting and setting.tiles or {}

    if self:sprite() then
        self:_setupGlyph()
    end
end

function TileSet:_setupGlyph()
    local sprite = self:sprite()

    if not self.glyph.width then
        self.glyph.width = lume.round(sprite:getWidth() / self:numHorizontal())
    elseif not self.glyph.numHorizontal then
        self.glyph.numHorizontal = lume.round(sprite:getWidth() / self:width())
    end

    if not self.glyph.height then
        self.glyph.height = lume.round(sprite:getHeight() / self:numVertical())
    elseif not self.glyph.numVertical then
        self.glyph.numVertical = lume.round(sprite:getHeight() / self:height())
    end
    
    local lg = love.graphics

    if type(self.glyph.quads) ~= 'table' then
        self.glyph.quads = {}
    end

    for i = 0, (self:numGlyphs() - 1) do
        self.glyph.quads[i] = lg.newQuad(
            (i % self:numHorizontal()) * self:width(),
            math.floor(i / self:numHorizontal()) * self:height(),
            self:width(),
            self:height(),
            sprite:getWidth(),
            sprite:getHeight()
        )
    end
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