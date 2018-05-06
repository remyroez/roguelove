
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local MapSystem = class('MapSystem', lovetoys.System)

local function BrogueMapGenerator(displayable)
    return function (x, y, value)
        local symbol = nil
        if value == 0 then
            symbol = '.'
        elseif value == 1 then
            symbol = '#'
        elseif value == 2 then
            symbol = '+'
        end
        displayable:setSymbol(symbol, x, y)
    end
end

function MapSystem:initialize()
    lovetoys.System.initialize(self)
end

function MapSystem:requires()
    return { 'Map', 'Displayable' }
end

function MapSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local map = entity:get('Map')
        
        if map.dirty then
            local displayable = entity:get('Displayable')
            displayable:clear()
    
            map:create(BrogueMapGenerator(displayable))
            map.dirty = false
        end
    end
end

return MapSystem
