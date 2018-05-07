
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local MapSystem = class('MapSystem', lovetoys.System)

local function BrogueMapGenerator(tileSet, entity)
    return function (x, y, value)
        local tile = nil
        if value == 0 then
            tile = tileSet:get('floor')
        elseif value == 1 then
            tile = tileSet:get('wall')
            collision = true
        elseif value == 2 then
            tile = tileSet:get('door')
        else
            tile = tileSet:get('error')
        end
        entity:get('Displayable'):setSymbol(tile.symbol, x, y)
        entity:get('Collider'):setCollision(tile.collision, x, y)
    end
end

function MapSystem:initialize(tileSet)
    lovetoys.System.initialize(self)
    self.tileSet = tileSet
end

function MapSystem:requires()
    return { 'Map', 'Displayable', 'Collider' }
end

function MapSystem:update(dt)
    if self.tileSet == nil then return end

    for index, entity in pairs(self.targets) do
        local map = entity:get('Map')
        
        if map.dirty then
            entity:get('Displayable'):clear()
            entity:get('Collider'):clear()
    
            map:create(BrogueMapGenerator(self.tileSet, entity))
            map.dirty = false
        end
    end
end

return MapSystem
