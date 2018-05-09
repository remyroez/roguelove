
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Map = lovetoys.Component.create('Map')

function Map:initialize(generator)
    self.generator = generator
    self.dirty = {}
end

function Map:flush()
    util.fill(self.dirty)
end

function Map:create(...)
    self.generator:create(...)
end

return Map
