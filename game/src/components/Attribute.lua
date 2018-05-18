
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

function Component:onCollisionTo(me, other, action)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    print('onCollisionTo', action, me.id .. ' -> ' .. other.id)
    otherAttribute:onCollisionFrom(other, me)
end

function Component:onCollisionFrom(me, other, action)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    print('onCollisionFrom', action, me.id .. ' -> ' .. other.id)
    otherAttribute:onDamage(me, other)
end

function Component:onDamage(me, other)
    local myAttribute, otherAttribute = util.gets('Attribute', me, other)
    myAttribute:hp(myAttribute:hp() - 10)
    print('onDamage', me.id .. ' -> ' .. other.id)
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
