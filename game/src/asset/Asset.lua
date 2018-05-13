
local util = require 'util'

local class = require 'middleclass'
local Stateful = require 'stateful'

local Asset = class('Asset')
Asset:include(Stateful)

function Asset:initialize(json, path, parent)
    self.json = json or {}
    self.path = path or ''
    self.parent = parent or nil

    self.loaderSet = {}
end

function Asset:root()
    return (self.parent and self.parent:root() or self:id())
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

function Asset:typeis(type)
    return self:type() == type
end

function Asset:properties(key)
    return key == nil and self.json.properties or self.json.properties[key]
end

function Asset:load()
end

return Asset
