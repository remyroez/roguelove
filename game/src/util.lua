
local util = {}

function util.setMap(map, x, y, z, value)
    if map == nil then
        return
    elseif value == nil then
        return
    end
    x = x or 1
    y = y or 1
    z = z or 1
    if x < 1 then
        return
    elseif y < 1 then
        return
    elseif z < 1 then
        return
    end
    if map[x] == nil then
        map[x] = {}
    end
    if map[x][y] == nil then
        map[x][y] = {}
    end
    map[x][y][z] = value
end

function util.getMap(map, x, y, z)
    if map == nil then
        return
    end
    x = x or 1
    y = y or 1
    z = z or 1
    if x < 1 then
        return
    elseif y < 1 then
        return
    elseif z < 1 then
        return
    end
    if map[x] == nil then
        return nil
    end
    if map[x][y] == nil then
        return nil
    end
    return map[x][y][z]
end


return util
