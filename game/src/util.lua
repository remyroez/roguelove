
local lume = require 'lume'

local util = {}

function util.setMap(map, value, ...)
    if map == nil then
        return
    elseif value == nil then
        return
    end
    map[table.concat({...}, ',')] = value
end

function util.getMap(map, ...)
    if map == nil then
        return
    end
    return map[table.concat({...}, ',')]
end

function util.splitKey(key)
    return unpack(lume.split(key, ','))
end

function util.fill(t, v)
    for k, _ in pairs(t) do
        t[k] = v or true
    end
end

function util.validatePosition(x, y, w, h)
    local validate = false

    if x < 1 then
        -- error
    elseif x > w then
        -- error
    elseif y < 1 then
        -- error
    elseif y > h then
        -- error
    else
        validate = true
    end

    return validate
end

return util
