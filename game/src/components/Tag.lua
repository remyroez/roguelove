
local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Tag')

function Component:initialize(tags)
    self.tags = tags or {}
end

function Component:get()
    return self.tags
end

return Component
