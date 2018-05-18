
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Attribute')

function Component:initialize(asset)
    self.asset = asset
    self.stats = {
        hp = self:maxHp()
    }
end

function Component:hp()
    return self.stats and self.stats.hp or 0
end

function Component:maxHp()
    return self.asset and self.asset:maxHp() or 0
end

function Component:triggers()
    return self.asset and self.asset:triggers() or {}
end

function Component:onCollision(me, other, action)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    print('on', action)
    print('me',
        me.id,
        myAttribute:hp(),
        myAttribute:maxHp()
    )
    print('other',
        other.id,
        otherAttribute:hp(),
        otherAttribute:maxHp()
    )
end

return Component
