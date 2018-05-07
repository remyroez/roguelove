
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


return util
