
local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Behavior = require(folderOfThisFile .. 'Behavior')

local events = require 'events'

local Wanderer = Behavior:addState 'Wanderer'

local pos = {
    { 0, 0 },
    { 1, 0 },
    { 0, 1 },
    { 1, 1 },
    { -1, 0 },
    { 0, -1 },
    { -1, -1 },
    { -1, 1 },
    { 1, -1 },
}

function Wanderer:enteredState()
end

function Wanderer:action(entity)
    local newPos = pos[math.random(#pos)]
    return function ()
        self:fireEvent(
            events.Move(
                entity.id,
                entity:get('Position'),
                entity:get('Size'),
                entity:get('Layer'),
                entity:get('Collider'),
                newPos[1],
                newPos[2]
            )
        )
    end
end
