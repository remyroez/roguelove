
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local MoveSystem = class('MoveSystem', lovetoys.System)

local function isHit(srcPosition, srcCollider, distX, distY, distCollider)
    local hit = false
    local srcLeft, srcTop = srcPosition.x, srcPosition.y
    local srcRight, srcBottom = (srcLeft + srcCollider.width), (srcTop + srcCollider.height)
    local distLeft, distTop = distX, distY
    local distRight, distBottom = (distLeft + distCollider.width), (distTop + distCollider.height)

    if distCollider.layer < srcCollider.layer then
        -- under layer
        print("distCollider.layer < srcCollider.layer", distCollider.layer, srcCollider.layer)
    elseif distLeft > srcRight then
        -- no hit
        print("distLeft > srcRight", distLeft, srcRight)
    elseif distTop > srcBottom then
        -- no hit
        print("distTop > srcBottom", distTop, srcBottom)
    elseif distRight < srcLeft then
        -- no hit
        print("distRight < srcLeft", distRight, srcLeft)
    elseif distBottom < srcTop then
        -- no hit
        print("distBottom < srcTop", distBottom, srcTop)
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

function MoveSystem:initialize()
    lovetoys.System.initialize(self)
end

function MoveSystem:requires()
    return { 'Position', 'Collider' }
end

function MoveSystem:update(dt)
end

function MoveSystem:onMove(event)
    local hit = false

    if event.check then
        for index, entity in pairs(self.targets) do
            if event.id == entity.id then
                -- equal entity
            elseif isHit(
                entity:get('Position'),
                entity:get('Collider'),
                event.position.x + event.x,
                event.position.y + event.y,
                event.collider
            ) then
                hit = true
                break
            end
        end
    end

    if hit then
        -- can't move
    else
        event.position:translate(event.x, event.y)
    end
end

return MoveSystem
