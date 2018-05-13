
local util = require 'util'

local class = require 'middleclass'

local jsonschema = require 'jsonschema'

local folderOfThisFile = (...):match("(.-)[^%/%.]+$")
local Json = require(folderOfThisFile .. 'Json')

local Schema = class('Schema', Json)

function Schema:initialize(...)
    Schema.super.initialize(self, ...)
    self.validater = nil
end

function Schema:deserialize(...)
    local succeeded, err = Schema.super.deserialize(self, ...)

    if not succeeded then
        -- error
    else
        self.validater = jsonschema.generate_validator(
            self.json,
            {
                name = 'Schema.lua'
            }
        )
    end

    return succeeded, err
end

function Schema:validate(json)
    local succeeded, err = false, nil

    if type(json) ~= 'table' then
        err = 'json is not table.'
    else
        if json.isInstanceOf and json:isInstanceOf(Json) then
            json = json.json
        end
        succeeded, result, err = pcall(self.validater, json)
        if not succeeded then
            err = result
        elseif not result then
            succeeded = false
        else
            succeeded = result -- true
        end
    end

    return succeeded, err and ('Schema: ' .. err) or nil
end

return Schema
