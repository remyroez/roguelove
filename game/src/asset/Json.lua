
local util = require 'util'

local class = require 'middleclass'

local Json = class('Json')

function Json:initialize(path)
    self.path = type(path) == 'string' and path or ''
    self.json = {}

    self:reset()
end

function Json:reset()
    self.json = {}
end

function Json:serialize(path)
    self.path = path or self.path
    return util.writeJson(self.path, self.json)
end

function Json:deserialize(path)
    self.path = path or self.path

    local err
    self.json, err = util.readJson(self.path)

    return err == nil, err
end

return Json
