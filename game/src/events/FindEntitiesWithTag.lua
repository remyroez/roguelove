
local class = require 'middleclass'

local Event = class('FindEntitiesWithTag')

function Event:initialize(tags)
    self.tags = tags or {}
    self.result = {}
end

return Event
