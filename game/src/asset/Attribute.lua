
local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Asset = require(folderOfThisFile .. 'Asset')

local Attribute = Asset:addState 'attribute'

function Attribute:enteredState()
end

function Attribute:maxHp()
    return self:properties('maxHp')
end

function Attribute:triggers()
    return self:properties('triggers')
end
