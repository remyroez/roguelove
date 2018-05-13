
local lume = require 'lume'

local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Asset = require(folderOfThisFile .. 'Asset')

local Tileset = Asset:addState 'tileset'

local defaultWidth = 9
local defaultHeight = 16
local defaultNumHorizontal = 32
local defaultNumVertical = 8
local defaultNumGlyphs = defaultNumHorizontal * defaultNumVertical

function Tileset:enteredState()
    self.tileset = {
        sprite = nil,
        quads = {},
        width = self:properties('width'),
        height = self:properties('height'),
        numHorizontal = self:properties('numHorizontal'),
        numVertical = self:properties('numVertical')
    }
end

function Tileset:load()
    local lg = love.graphics
    local loader = lg.newImage

    if type(self.loaderSet) ~= 'table' then
        -- loaderSet is not table.
    elseif type(self.loaderSet.newImage) ~= 'function' then
        -- loaderSet.newImage is not function.
    else
        loader = self.loaderSet.newImage
    end
    
    self.tileset.sprite = loader(self:file())
    local sprite = self.tileset.sprite

    if not self.tileset.width then
        self.tileset.width = lume.round(sprite:getWidth() / self:numHorizontal())
    elseif not self.tileset.numHorizontal then
        self.tileset.numHorizontal = lume.round(sprite:getWidth() / self:width())
    end

    if not self.tileset.height then
        self.tileset.height = lume.round(sprite:getHeight() / self:numVertical())
    elseif not self.tileset.numVertical then
        self.tileset.numVertical = lume.round(sprite:getHeight() / self:height())
    end
    
    for i = 0, (self:numGlyphs() - 1) do
        self.tileset.quads[i] = lg.newQuad(
            (i % self:numHorizontal()) * self:width(),
            math.floor(i / self:numHorizontal()) * self:height(),
            self:width(),
            self:height(),
            sprite:getWidth(),
            sprite:getHeight()
        )
    end
end

function Tileset:file()
    return self:properties('sprite')
end

function Tileset:width()
    return self.tileset.width or self:properties('width') or defaultWidth
end

function Tileset:height()
    return self.tileset.height or self:properties('height') or defaultHeight
end

function Tileset:numHorizontal()
    return self.tileset.numHorizontal or self:properties('numHorizontal') or defaultNumHorizontal
end

function Tileset:numVertical()
    return self.tileset.numVertical or self:properties('numVertical') or defaultNumVertical
end

function Tileset:numGlyphs()
    return self:numHorizontal() * self:numVertical()
end

function Tileset:sprite()
    return self.tileset.sprite
end

function Tileset:quads()
    return self.tileset.quads
end
