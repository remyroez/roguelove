
local const = require 'const'
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local rot = require 'rot'
local lume = require 'lume'

local LightSystem = class('LightSystem', lovetoys.System)

LightSystem.static.ReflectivityCallback = function (map, default)
    return function (x, y)
        local reflectivity = 0
        if map then
            reflectivity = util.getMap(map, x, y) or 0
            if type(reflectivity) ~= 'number' then
                reflectivity = default or .3
            end
        end
        return reflectivity
    end
end

function LightSystem:initialize(fov, ...)
    lovetoys.System.initialize(self)

    self.arg = { ... }
    self.fov = fov

    self.lightMap = {}

    self:resetLighting()
end

function LightSystem:requires()
    return { 'Position', 'Light' }
end

function LightSystem:update(dt)
    self:updateLighting()
    self:compute()
    self.active = false
end

function LightSystem:flush()
    self.active = true
end

function LightSystem:resetLighting()
    self.lighting = rot.Lighting:new(unpack(self.arg))
    self.lighting:setFOV(self.fov)
end

function LightSystem:updateLighting()
    local map = {}

    for index, entity in pairs(self.targets) do
        local position = entity:get('Position')
        local light = entity:get('Light')
        
        for x = 1, light.width do
            for y = 1, light.height do
                local left = x + position.x
                local top = y + position.y
                local cell = util.getMap(map, left, top) or {}
                cell[light.layer] = light:getColor(x, y)
                util.setMap(map, cell, left, top)
            end
        end
    end
    
    self:resetLighting()

    for key, value in pairs(map) do
        local x, y = util.splitKey(key)
        local color = nil
        for layer = const.layer.first, const.layer.last do
            if not value[layer] then
                -- no color
            elseif not color then
                color = value[layer]
            else
                color = rot.Color.interpolate(color, value[layer], .5)
            end
        end
        self.lighting:setLight(x, y, color)
    end
end

function LightSystem:compute(callback)
    self.lightMap = {}
    self.lighting:compute(
        function (x, y, color)
            util.setMap(self.lightMap, color, x, y)
            if callback then callback(x, y, color) end
        end
    )
end

function LightSystem:onCollection(event)
    if event.key == 'lightMap' then
        event:push(self.lightMap)
    end
end

return LightSystem
