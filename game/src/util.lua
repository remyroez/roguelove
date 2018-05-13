
local lume = require 'lume'
local json = require 'json'

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

function util.readJson(name)
    local contents, sizeOrError = love.filesystem.read(name)
    if contents == nil then
        return {}, sizeOrError
    else
        local succeeded, result = pcall(json.decode, contents)
        return (succeeded and result or {}), (not succeeded and result or nil)
    end
    return {}, 'fatal error.'
end

function util.writeJson(name, data)
    local contents = json.encode(data)
    return love.filesystem.write(name, contents)
end

function util.lastDimension(t, ...)
    local node = t
    local args = {...}
    for _, key in ipairs(args) do
        if type(node[key]) ~= 'table' then
            node[key] = {}
        end
        node = node[key]
    end
    return node
end

function util.fileName(path)
    return path:match("^.+/(.+)$")
end

function util.fileExtension(path)
    return path:match("^.+(%..+)$")
end

function util.fileDirectory(path)
    local dirs = lume.split(path, '/')
    dirs[#dirs] = nil
    return table.concat(dirs, '/')
end

function util.fileFirstDirectory(path)
    local dirs = lume.split(path, '/')
    return dirs[1]
end

function util.isZip(path)
    return util.fileExtension(path) == '.zip'
end

return util
