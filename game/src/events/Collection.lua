
local class = require 'middleclass'

local lume = require 'lume'

local Collection = class('Collection')

function Collection:initialize(key)
    self.key = key
    self.result = {}
end

function Collection:push(...)
    lume.push(self.result, ...)
end

return Collection
