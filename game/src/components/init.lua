
local folderOfThisFile = (...) .. '.'

return {
    Actor = require(folderOfThisFile ..'Actor'),
    Collider = require(folderOfThisFile ..'Collider'),
    Displayable = require(folderOfThisFile ..'Displayable'),
    Layer = require(folderOfThisFile ..'Layer'),
    Light = require(folderOfThisFile ..'Light'),
    Map = require(folderOfThisFile ..'Map'),
    Player = require(folderOfThisFile ..'Player'),
    Position = require(folderOfThisFile ..'Position'),
    Shadow = require(folderOfThisFile ..'Shadow'),
    Size = require(folderOfThisFile ..'Size'),
    View = require(folderOfThisFile ..'View'),
}
