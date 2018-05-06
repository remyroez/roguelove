
local lovetoys = require 'lovetoys.lovetoys'

local Map = lovetoys.Component.create('Map')

function Map:initialize(generator)
    self.generator = generator
    self.dirty = true
end

function Map:flush()
    self.dirty = true
end

function Map:create(...)
    self.generator:create(...)
end

return Map
