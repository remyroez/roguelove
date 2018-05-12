
local util = require 'util'

local class = require 'middleclass'

local Asset = class('Asset')

function Asset:initialize(json, path)
    self.json = json or {}
    self.path = path or ''
end

function Asset:id()
    return self.json.id
end

function Asset:title()
    return self.json.name
end

function Asset:type()
    return self.json.type
end

function Asset:isType(type)
    return self:type() == type
end

function Asset:properties(key)
    return key == nil and self.json.properties or self.json.properties[key]
end

return Asset
