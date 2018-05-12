
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local Json = require 'asset.Json'
local Asset = require 'asset.Asset'

local System = class('AssetSystem', lovetoys.System)

System.static.infoFileName = 'info.json'

function System:initialize()
    System.super.initialize(self)

    self.assets = {}
    self.versions = {}
    self.resourceLoaders = {}
    
    self.active = false
end

function System:requires()
    return { 'Position' }
end

function System:update(dt)
    self.active = false
end

function System:newAsset(basePath)
    local asset
    local path = basePath

    if not love.filesystem.exists(basePath) then
        print(basePath, 'not exists.')
        return
    end
    
    local isDir = love.filesystem.isDirectory(basePath)
    local isZip = util.isZip(basePath)

    if isDir then
        path = path .. "/" .. System.infoFileName
    elseif isZip then
        love.filesystem.mount(basePath, '__temp')
        path = "__temp/" .. System.infoFileName
    end

    if not love.filesystem.exists(path) then
        print(basePath, System.infoFileName .. ' not found.')
    else
        local json = Json(path)
        local succeeded, err = json:deserialize()
    
        if isZip then
            love.filesystem.unmount(basePath)
        end
    
        if not succeeded then
            print(json.path, err)
        elseif type(json.json) ~= 'table' then
            print(json.path, "json is not object type.")
        else
            asset = self:register(json.json, path)
    
            if asset:isType('info') and (isDir or isZip) then
                love.filesystem.mount(basePath, asset:id(), true)
            end
        end
    end

    return asset
end

function System:makeLoaderSet(id)
    return {
        newImage = function (...) return self:newImage(id, ...) end
    }
end

function System:newImage(id, path)
    local image

    local asset = self:get(id)
    if asset then
        if util.fileFirstDirectory(asset.path) == 'assets' then
            image = love.graphics.newImage(util.fileDirectory(asset.path) .. '/' .. path)
        end
    end

    if not image then
        image = love.graphics.newImage(path)
    end

    return image
end

function System:register(json, path)
    local asset = Asset(json, path)
    
    asset.loaderSet = self:resourceLoader(asset:id())
    asset:gotoState(asset:type())

    self.assets[asset:id()] = asset

    if asset:isType('info') then
        self.versions[asset:id()] = asset:properties('version') or '0'
    end

    return asset
end

function System:deregister(id)
    local asset = self:get(id)

    if asset:isType('info') then
        self.versions[id] = nil
    end
    
    self.assets[id] = nil
end

function System:resourceLoader(id)
    if not self.resourceLoaders[id] then
        self.resourceLoaders[id] = self:makeLoaderSet(id)
    end
    return self.resourceLoaders[id]
end

function System:get(id)
    return self.assets[id]
end

return System
