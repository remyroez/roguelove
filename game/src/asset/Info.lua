
local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Asset = require(folderOfThisFile .. 'Asset')

local Info = Asset:addState 'info'

function Info:enteredState()
end

function Info:description()
    return self:properties('description')
end

function Info:version()
    return self:properties('version')
end

function Info:uuid()
    return self:properties('uuid')
end

function Info:authors()
    return self:properties('authors')
end

function Info:dependencies()
    return self:properties('dependencies')
end

function Info:data()
    return self:properties('data')
end
