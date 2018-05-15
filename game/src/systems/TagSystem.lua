
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'
local lume = require 'lume'

local System = class('TagSystem', lovetoys.System)

function System:initialize()
    lovetoys.System.initialize(self)
end

function System:requires()
    return { 'Tag' }
end

function System:update(dt)
    self.active = false
end

function System:onFindEntitiesWithTag(event)
    event.result = {}
    for index, entity in pairs(self.targets) do
        local tags = entity:get('Tag'):get()
        if lume.all(event.tags, function (tag) return lume.find(tags, tag) end) then
            table.insert(event.result, entity)
        end
    end
end

return System
