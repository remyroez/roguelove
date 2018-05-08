
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local ShadowSystem = class('ShadowSystem', lovetoys.System)

function ShadowSystem:initialize()
    lovetoys.System.initialize(self)
    self.shadowMap = {}
end

function ShadowSystem:requires()
    return { 'Position', 'Shadow' }
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
        local shadow = entity:get('Shadow')
        
        for x = 1, shadow.width do
            for y = 1, shadow.height do
                local left = x + position.x
                local top = y + position.y
                util.setMap(self.shadowMap, shadow:getShade(left, top), left, top, shadow.layer)
            end
        end
    end
end

function ShadowSystem:PreciseLightPassCallback()
    return function (fov, x, y)
        local through = true
        for layer = 1, 3 do
            if util.getMap(self.shadowMap, x, y, layer) then
                through = false
                break
            end
        end
        return through
    end
end

return ShadowSystem