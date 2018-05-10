
local const = require 'const'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Layer')

function Component:initialize(layer)
    self.layer = layer or const.layer.first
end

function Component:get()
    return self.layer
end

function Component:priority()
    return self.layer
end

return Component
