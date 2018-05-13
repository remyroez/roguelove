
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Map = lovetoys.Component.create('Map')

function Map:initialize(generator, callback)
    self.generator = generator
    self.callback = callback
    self.dirty = {}
end

function Map:flush()
    util.fill(self.dirty)
end

function Map:create(...)
    if self.callback then
        self.generator:create(self.callback(...))
    else
        self.generator:create(...)
    end
end

return Map
