
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local System = class('AttributeSystem', lovetoys.System)

function System:initialize(engine)
    lovetoys.System.initialize(self)
    self.engine = engine
end

function System:requires()
    return { 'Attribute' }
end

function System:update(dt)
    for index, entity in pairs(self.targets) do
        local attribute = entity:get('Attribute')
        if attribute:hp() <= 0 then
            print('die', entity.id)
            self.engine:removeEntity(entity)
        end
    end

    self.active = false
end

function System:nextTurn()
    self.active = true
end

return System
