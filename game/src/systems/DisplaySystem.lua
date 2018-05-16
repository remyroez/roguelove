
local const = require 'const'
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'

local Collection = require 'events.Collection'

local DisplaySystem = class('DisplaySystem', lovetoys.System)

function DisplaySystem:initialize(engine, display)
    lovetoys.System.initialize(self)

    self.engine = engine
    self.display = display

    self.dirty = false
end

function DisplaySystem:requires()
    return { 'Position', 'Size', 'Layer', 'Displayable' }
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
        self:write(symbolMap)
        self.dirty = false
    end
end

function DisplaySystem:updateSymbolMap(map, visionMap, seenMap)
    local dirty = false

    local lightMap = self:getLightMap()
    local darkColor = rot.Color.fromString('black')

    for index, entity in pairs(self.targets) do
        local position = entity:get('Position')
        local size = entity:get('Size')
        local layer = entity:get('Layer')
        local displayable = entity:get('Displayable')
        for x = 1, size.width do
            for y = 1, size.height do
                local left = x + position.x
                local top = y + position.y
                local visible = util.getMap(seenMap, left, top)
                if not visible then
                    -- skip
                else
                    local symbol = displayable:getSymbol(x, y)
                    local vision = util.getMap(visionMap, left, top)
                    local light = util.getMap(lightMap, left, top)
                    local newSymbol
                    if vision then
                        newSymbol = {
                            character = symbol.character,
                            fgcolor = (symbol.fgcolor and rot.Color.interpolateHSL(symbol.fgcolor, darkColor, (1 - vision) * .5) or nil),
                            bgcolor = (symbol.bgcolor and rot.Color.interpolate(symbol.bgcolor, darkColor, (1 - vision) * .5) or nil)
                        }
                        if layer:get() ~= const.layer.map then
                            -- skip light
                        elseif not light then
                            -- no light
                        else
                            if newSymbol.fgcolor then
                                newSymbol.fgcolor = rot.Color.add(newSymbol.fgcolor, light)
                            end
                            if newSymbol.bgcolor then
                                newSymbol.bgcolor = rot.Color.add(newSymbol.bgcolor, light)
                            end
                        end
                    elseif layer:get() ~= const.layer.map then
                        -- no display
                    else
                        newSymbol = {
                            character = symbol.character,
                            fgcolor = (symbol.fgcolor and rot.Color.interpolateHSL(symbol.fgcolor, darkColor, .5) or nil),
                            bgcolor = (symbol.bgcolor and rot.Color.interpolate(symbol.bgcolor, darkColor, .5) or nil)
                        }
                    end
                    if newSymbol then
                        util.setMap(map, newSymbol, left, top, layer:priority())
                    end
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
            visionMap[key] = math.max(visionMap[key] or 0, value)
        end
        for key, value in pairs(view.seenMap) do
            seenMap[key] = seenMap[key] or value
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

function DisplaySystem:getLightMap()
    local event = Collection('lightMap')
    self.engine.eventManager:fireEvent(event)
    return event.result[1] or {}
end

function DisplaySystem:write(map)
    self.display:clear()
    local left, top, right, bottom = self:displayRect()
    for x = left, right do
        for y = top, bottom do
            local character = nil
            local fgcolor = nil
            local bgcolor = nil
            for z = const.layer.first, const.layer.last do
                local symbol = util.getMap(map, x, y, z)
                if symbol ~= nil then
                    character = symbol.character or character
                    fgcolor = symbol.fgcolor or fgcolor
                    bgcolor = symbol.bgcolor or bgcolor
                end
            end
            if character == nil then character = '' end
            self.display:write(character, x, y, fgcolor, bgcolor)
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
