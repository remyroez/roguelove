
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local DisplaySystem = class('DisplaySystem', lovetoys.System)

DisplaySystem.static.layer = {
    map = 1,
    item = 2,
    actor = 3
}

DisplaySystem.static.layer.first = DisplaySystem.static.layer.map
DisplaySystem.static.layer.last = DisplaySystem.static.layer.actor

function DisplaySystem:initialize(display)
    lovetoys.System.initialize(self)

    self.dirty = false
    self.display = display
end

function DisplaySystem:requires()
    return { 'Position', 'Displayable' }
end

function DisplaySystem:update(dt)
    local map = {}
    self.dirty = self:updateMap(map) or self.dirty

    if not self.dirty then
        -- not dirty
    else
        self:write(map)
        self.dirty = false
    end
end

function DisplaySystem:updateMap(map)
    local dirty = false

    for index, entity in pairs(self.targets) do
        local position = entity:get('Position')
        local displayable = entity:get('Displayable')
        for x = 1, displayable.width do
            for y = 1, displayable.height do
                util.setMap(
                    map,
                    displayable:getSymbol(x, y),
                    x + position.x,
                    y + position.y,
                    displayable.layer
                )
            end
        end
        if position.dirty['DisplaySystem'] == false then
            -- not dirty
        else
            dirty = true
            position.dirty['DisplaySystem'] = false
        end
        if displayable.dirty['DisplaySystem'] == false then
            -- not dirty
        else
            dirty = true
            displayable.dirty['DisplaySystem'] = false
        end
    end

    return dirty
end

function DisplaySystem:write(map)
    self.display:clear()
    local left, top, right, bottom = self:displayRect()
    for x = left, right do
        for y = top, bottom do
            for z = DisplaySystem.static.layer.first, DisplaySystem.static.layer.last do
                local tile = util.getMap(map, x, y, DisplaySystem.static.layer.last - z + 1)
                if tile ~= nil then
                    self.display:write(tile, x, y)
                    break
                end
            end
        end
    end
end

function DisplaySystem:flush()
    self.dirty = true
end

function DisplaySystem:draw()
    self.display:draw()
end

function DisplaySystem:displayRect()
    return 1, 1, self.display.widthInChars, self.display.heightInChars
end

return DisplaySystem
