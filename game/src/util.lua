
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

function util.fill(t, v)
    for k, _ in pairs(t) do
        t[k] = v or true
    end
end


return util
