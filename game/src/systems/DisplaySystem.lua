
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
        self:flush(map)
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
                    x + position.x,
                    y + position.y,
                    displayable.layer,
                    displayable:getSymbol(x, y)
                )
            end
        end
        if not position.dirty then
            -- not dirty
        else
            if not dirty then
                dirty = position.dirty
            end
            position.dirty = false
        end
        if not displayable.dirty then
            -- not dirty
        else
            if not dirty then
                dirty = displayable.dirty
            end
            displayable.dirty = false
        end
    end

    return dirty
end

function DisplaySystem:flush(map)
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

function DisplaySystem:draw()
    self.display:draw()
end

function DisplaySystem:displayRect()
    return 1, 1, self.display.widthInChars, self.display.heightInChars
end

return DisplaySystem
