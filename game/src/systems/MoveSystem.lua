
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local Flush = require 'events.Flush'

local MoveSystem = class('MoveSystem', lovetoys.System)

MoveSystem.static.isHit = function (
    srcPosition, srcSize, srclayer, srcCollider,
    distPosition, distSize, distLayer, distCollider
)
    local hit = false

    local srcLeft, srcTop = srcPosition.x, srcPosition.y
    local srcRight, srcBottom = (srcLeft + srcSize.width), (srcTop + srcSize.height)
    local distLeft, distTop = distPosition.x, distPosition.y
    local distRight, distBottom = (distLeft + srcSize.width), (distTop + srcSize.height)

    if distLayer:priority() < srclayer:priority() then
        -- under layer
        --print("distLayer:priority() < srclayer:priority()", distLayer:priority(), srclayer:priority())
    elseif distLeft > srcRight then
        -- no hit
        --print("distLeft > srcRight", distLeft, srcRight)
    elseif distTop > srcBottom then
        -- no hit
        --print("distTop > srcBottom", distTop, srcBottom)
    elseif distRight < srcLeft then
        -- no hit
        --print("distRight < srcLeft", distRight, srcLeft)
    elseif distBottom < srcTop then
        -- no hit
        --print("distBottom < srcTop", distBottom, srcTop)
    else
        local left = math.min(srcLeft, distLeft)
        local top = math.min(srcTop, distTop)
        local right = math.max(srcRight, distRight)
        local bottom = math.max(srcBottom, distBottom)
        local width = (right - left)
        local height = (bottom - top)
        for x = 1, width do
            for y = 1, height do
                local srcCollision = srcCollider:getCollision(left - srcLeft + x, top - srcTop + y)
                local distCollision = distCollider:getCollision(left - distLeft + x, top - distTop + y)
                
                if srcCollision == nil or distCollision == nil then
                    -- nil
                elseif not srcCollision or not distCollision then
                    -- not
                elseif srcCollision ~= distCollision then
                    -- not
                else
                    hit = true
                    break
                end
            end
        end
    end

    return hit
end

function MoveSystem:initialize(eventManager)
    lovetoys.System.initialize(self)
    self.eventManager = eventManager
end

function MoveSystem:requires()
    return { 'Position', 'Size', 'Layer', 'Collider' }
end

function MoveSystem:update(dt)
    self.active = false
end

function MoveSystem:onMove(event)
    local hit = false
    local other = nil

    if event.check then
        hit, other = self:onHitCheck(event)
    end

    if not hit then
        event.position:translate(event.x, event.y)
        
        if self.eventManager then
            self.eventManager:fireEvent(Flush())
        end
    elseif not other then
        -- hit with unknown
    elseif not other:get('Attribute') then
        -- no attribute
    else
        -- can't move
        local attribute = event.entity:get('Attribute')
        if attribute then
            attribute:onCollisionTo(event.entity, other, 'move')
        end
    end
end

function MoveSystem:onHitCheck(event)
    local hit = false
    local other = nil

    for index, entity in pairs(self.targets) do
        if event.id == entity.id then
            -- equal entity
        elseif MoveSystem.isHit(
            entity:get('Position'),
            entity:get('Size'),
            entity:get('Layer'),
            entity:get('Collider'),
            event:movedPosition(),
            event.size,
            event.layer,
            event.collider
        ) then
            hit = true
            other = entity
            break
        end
    end

    event.result = hit

    return hit, other
end

return MoveSystem
