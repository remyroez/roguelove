
local folderOfThisFile = (...) .. '.'

local Asset = require(folderOfThisFile .. 'Asset')
require (folderOfThisFile .. 'Tileset')
require (folderOfThisFile .. 'Info')
require (folderOfThisFile .. 'Object')

return {
    Asset = Asset
}
