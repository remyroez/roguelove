
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Attribute')

function Component:initialize(asset)
    self.asset = asset
    self.statistics = {
        hp = self:maxHp()
    }
end

function Component:stats(key, value)
    if key ~= nil and value ~= nil and self.statistics[key] ~= nil then
        self.statistics[key] = value
    end
    return key == nil and self.statistics
        or self.statistics[key]
        or self:properties(key)
end

function Component:properties(key)
    return self.asset:properties(key)
end

function Component:hp(...)
    return self:stats('hp', ...) or 0
end

function Component:maxHp()
    return self.asset and self.asset:maxHp() or 0
end

function Component:triggers()
    return self.asset and self.asset:triggers() or {}
end

function Component:onCollision(me, other, action)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    otherAttribute:hp(otherAttribute:hp() - 10)
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
