
local class = require 'middleclass'

local rot = require 'rot'

local Terminal = class('Terminal')
Terminal:include(rot.Display)

Terminal.static.default = {
    baseCharWidth = 9,
    baseCharHeight = 16,
    numGlyphsHorizontal = 32,
    numGlyphsTotal = 256,

    widthInChars = 80,
    heightInChars = 24,
    scale = 1,

    defaultForegroundColor = { 235, 235, 235 },
    defaultBackgroundColor = { 15, 15, 15 },
}

local function initDisplay(self, tileSet, w, h, scale, dfg, dbg, fullOrFlags, vsync, fsaa)
    self.baseCharWidth = tileSet and tileSet:width() or Terminal.default.baseCharWidth
    self.baseCharHeight = tileSet and tileSet:height() or Terminal.default.baseCharHeight
    self.numGlyphsHorizontal = tileSet and tileSet:numHorizontal() or Terminal.default.numGlyphsHorizontal
    self.numGlyphsTotal = tileSet and tileSet:numGlyphs() or Terminal.default.numGlyphsTotal

    self.__name = 'Display'
    self.widthInChars = w and w or Terminal.default.widthInChars
    self.heightInChars= h and h or Terminal.default.heightInChars
    self.scale=scale or 1
    self.charWidth = self.baseCharWidth * self.scale
    self.charHeight = self.baseCharHeight * self.scale
    self.glyphs={}
    self.chars={{}}
    self.backgroundColors={{}}
    self.foregroundColors={{}}
    self.oldChars={{}}
    self.oldBackgroundColors={{}}
    self.oldForegroundColors={{}}
    self.graphics=love.graphics

    if love.window then
        love.window.setMode(self.charWidth*self.widthInChars, self.charHeight*self.heightInChars, fullOrFlags)
        self.drawQ = self.graphics.draw
    else
        self.graphics.setMode(self.charWidth*self.widthInChars, self.charHeight*self.heightInChars, fullOrFlags, vsync, fsaa)
        self.drawQ = self.graphics.drawq
    end

    self.defaultForegroundColor = dfg and dfg or Terminal.default.defaultForegroundColor
    self.defaultBackgroundColor = dbg and dbg or Terminal.default.defaultBackgroundColor

    self.graphics.setBackgroundColor(self.defaultBackgroundColor)

    self.canvas = self.graphics.newCanvas(
        self.charWidth * self.widthInChars,
        self.charHeight * self.heightInChars
    )

    self.glyphSprite = tileSet and tileSet:sprite() or self.graphics.newImage('img/cp437.png')
    self.glyphs = tileSet and tileSet:quads() or nil
    
    if self.glyphs == nil then
        for i = 0, (self.numGlyphsTotal - 1) do
            local sx = (i % self.numGlyphsHorizontal) * self.baseCharWidth
            local sy = math.floor(i / self.numGlyphsHorizontal) * self.baseCharHeight
            self.glyphs[i] = self.graphics.newQuad(
                sx, sy,
                self.baseCharWidth, self.baseCharHeight,
                self.glyphSprite:getWidth(), self.glyphSprite:getHeight()
            )
        end
    end

    for i = 1, self.widthInChars do
        self.chars[i]               = {}
        self.backgroundColors[i]    = {}
        self.foregroundColors[i]    = {}
        self.oldChars[i]            = {}
        self.oldBackgroundColors[i] = {}
        self.oldForegroundColors[i] = {}
        for j=1,self.heightInChars do
            self.chars[i][j]               = self.numGlyphsHorizontal
            self.backgroundColors[i][j]    = self.defaultBackgroundColor
            self.foregroundColors[i][j]    = self.defaultForegroundColor
            self.oldChars[i][j]            = nil
            self.oldBackgroundColors[i][j] = nil
            self.oldForegroundColors[i][j] = nil
        end
    end
end

function Terminal:initialize(first, ...)
    if first == nil or type(first) == 'number' then
        rot.Display.init(self, first, ...)
    else
        initDisplay(self, first, ...)
    end
end

return Terminal
