
local class = require 'middleclass'

local rot = require 'rot'

local TileSet = class('TileSet')

function TileSet:initialize(tiles)
    self.tiles = tiles or {}
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

return TileSet