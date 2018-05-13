
local util = require 'util'

local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local lume = require 'lume'

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
        
        if isZip then
            love.filesystem.unmount(basePath)
        end
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
    
            if asset:typeis('info') and (isDir or isZip) then
                love.filesystem.mount(basePath, '<' .. asset:id() .. '>', true)
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
        else
            image = love.graphics.newImage('<' .. asset:root() .. '>/' .. path)
        end
    end

    if not image then
        image = love.graphics.newImage(path)
    end

    return image
end

function System:register(json, path, parent)
    local asset = Asset(json, path, parent)

    asset.loaderSet = self:resourceLoader(asset:root())
    asset:gotoState(asset:type())
print('register', asset:id())
    self.assets[asset:id()] = asset

    if asset:typeis('info') then
        self.versions[asset:id()] = asset:properties('version') or '0'
        self:newChildAssets(asset)
    end

    return asset
end

function System:newChildAssets(parentAsset)
    local data = parentAsset:properties('data')

    if type(data) ~= 'table' then
        -- data is not table.
        return
    end

    local dir = parentAsset.path
    if not love.filesystem.isDirectory(dir) then
        dir = util.fileDirectory(dir)
    end

    local asset
    
    for _, name in ipairs(data) do
        local path = dir .. '/' .. name
        if love.filesystem.isDirectory(path) then
            self:newAsset(path)
        else
            local json = Json(path)
            local succeeded, err = json:deserialize()
            
            if not succeeded then
                print(json.path, err)
            elseif type(json.json) ~= 'table' then
                print(json.path, "json is not object type.")
            elseif lume.isarray(json.json) then
                for _, chunk in ipairs(json.json) do
                    asset = self:register(
                        chunk,
                        path,
                        parentAsset
                    )
                end
            else
                asset = self:register(json.json, path, parentAsset)
            end
        end
    end
end

function System:deregister(id)
    local asset = self:get(id)

    if asset:typeis('info') then
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
