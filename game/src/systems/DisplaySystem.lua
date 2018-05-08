
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local DisplaySystem = class('DisplaySystem', lovetoys.System)

DisplaySystem.static.layer = {
    map = 1,
    item = 2,
    actor = 3
}

DisplaySystem.static.layer.first = DisplaySystem.static.layer.map
DisplaySystem.static.layer.last = DisplaySystem.static.layer.actor

function DisplaySystem:initialize(engine, display)
    lovetoys.System.initialize(self)

    self.engine = engine
    self.display = display

    self.dirty = false
end

function DisplaySystem:requires()
    return { 'Position', 'Displayable' }
end

function DisplaySystem:update(dt)
    local symbolMap = {}
    local visionMap = {}
    local seenMap = {}
    self.dirty = self:updateViewMap(visionMap, seenMap) or self.dirty
    self.dirty = self:updateSymbolMap(symbolMap, visionMap, seenMap) or self.dirty

    if not self.dirty then
        -- not dirty
    else
        self:write(symbolMap, seenMap)
        self.dirty = false
    end
end

function DisplaySystem:updateSymbolMap(map, visionMap, seenMap)
    local dirty = false

    for index, entity in pairs(self.targets) do
        local position = entity:get('Position')
        local displayable = entity:get('Displayable')
        for x = 1, displayable.width do
            for y = 1, displayable.height do
                local left = x + position.x
                local top = y + position.y
                local visible = util.getMap(seenMap, left, top)
                if not visible then
                    -- skip
                else
                    local symbol = displayable:getSymbol(x, y)
                    local vision = util.getMap(visionMap, left, top)
                    if vision then
                        local newSymbol = {}
                        newSymbol.character = symbol.character
                        if symbol.fgcolor then newSymbol.fgcolor = rot.Color.interpolate(symbol.fgcolor, rot.Color.fromString('goldenrod'), vision * .5) end
                        if symbol.bgcolor then newSymbol.bgcolor = rot.Color.interpolate(symbol.bgcolor, rot.Color.fromString('goldenrod'), vision * .5) end
                        symbol = newSymbol
                    end
                    util.setMap(
                        map,
                        symbol,
                        left,
                        top,
                        displayable.layer
                    )
                end
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

function DisplaySystem:updateViewMap(visionMap, seenMap)
    local dirty = false

    for index, entity in pairs(self.engine:getEntitiesWithComponent('View')) do
        local view = entity:get('View')

        for key, value in pairs(view.visionMap) do
            visionMap[key] = (visionMap[key] == nil) and value or math.max(visionMap[key], value)
        end
        for key, value in pairs(view.seenMap) do
            seenMap[key] = (seenMap[key] == nil) and value or math.max(seenMap[key], value)
        end

        if view.dirty['DisplaySystem'] == false then
            -- not dirty
        else
            dirty = true
            view.dirty['DisplaySystem'] = false
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
                local symbol = util.getMap(map, x, y, DisplaySystem.static.layer.last - z + 1)
                if symbol ~= nil then
                    self.display:write(symbol.character, x, y, symbol.fgcolor, symbol.bgcolor)
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
