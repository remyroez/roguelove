
local util = require 'util'

local lovetoys = require 'lovetoys.lovetoys'

local Component = lovetoys.Component.create('Statistic')

function Component:initialize(stats)
    self.stats = stats or {}
end

function Component:onCollision(other)
    if self.stats.hp then
        self.stats.hp = self.stats.hp - 10
    end
    print('hp', self.stats.hp)
end

return Component
