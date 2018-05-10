
local const = require 'const'
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local ShadowSystem = class('ShadowSystem', lovetoys.System)

function ShadowSystem:initialize()
    lovetoys.System.initialize(self)
    self.shadowMap = {}
end

function ShadowSystem:requires()
    return { 'Position', 'Size', 'Layer', 'Shadow' }
end

function ShadowSystem:update(dt)
    self:updateShadowMap()
    self.active = false
end

function ShadowSystem:flush()
    self.active = true
end

function ShadowSystem:updateShadowMap()
    self.shadowMap = {}

    for index, entity in pairs(self.targets) do
        local position = entity:get('Position')
        local size = entity:get('Size')
        local layer = entity:get('Layer')
        local shadow = entity:get('Shadow')
        
        for x = 1, size.width do
            for y = 1, size.height do
                local left = x + position.x
                local top = y + position.y
                util.setMap(self.shadowMap, shadow:getShade(left, top), left, top, layer:priority())
            end
        end
    end
end

function ShadowSystem:PreciseLightPassCallback()
    return function (fov, x, y)
        local through = true
        local found = false
        local shade = false
        for priority = const.layer.first, const.layer.last do
            shade = util.getMap(self.shadowMap, x, y, priority)
            if shade == nil then
                -- nil
            else
                found = true
                if shade then
                    through = false
                    found = true
                    break
                end
            end
        end
        if not found then
            --through = false
        end
        return through
    end
end

return ShadowSystem
