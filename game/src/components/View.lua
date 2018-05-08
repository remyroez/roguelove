
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local View = lovetoys.Component.create('View')

function View:initialize(fov, radius)
    self.fov = fov
    self.radius = radius or 10
end

function View:compute(first, ...)
    if type(first) ~= 'string' then
        self.fov:compute(first, ...)
    elseif self.fov[first] ~= nil then
        self.fov[first](self, ...)
    end
end

return View
