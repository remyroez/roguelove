
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Attribute')

function Component:initialize(stats)
    self.stats = stats or {}
end

function Component:onCollision(me, other, action)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    print('on', action)
    print('me', me.id, myAttribute and myAttribute.stats.hp or nil)
    print('other', other.id, otherAttribute and otherAttribute.stats.hp or nil)
end

return Component
