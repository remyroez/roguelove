
local folderOfThisFile = (...) .. '.'

local Behavior = require(folderOfThisFile ..'Behavior')
require(folderOfThisFile ..'Wanderer')
require(folderOfThisFile ..'Predator')

return Behavior
