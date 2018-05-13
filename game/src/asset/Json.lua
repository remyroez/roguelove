
local util = require 'util'

local class = require 'middleclass'

local Json = class('Json')

Json.static.default = {}

function Json:initialize(arg)
    self.path = type(arg) == 'string' and arg or ''
    self.json = type(arg) == 'table' and arg or {}
end

function Json:reset(json)
    self.json = setmetatable(type(json) == 'table' and json or {}, { __index = self.default})
end

function Json:serialize(path)
    self.path = path or self.path
    return util.writeJson(self.path, self.json)
end

function Json:deserialize(path)
    self.path = path or self.path

    local json, err = util.readJson(self.path)

    if err then
        self:reset()
    else
        self:reset(json)
    end

    return err == nil, err and ('Json: ' .. err) or nil
end

return Json
