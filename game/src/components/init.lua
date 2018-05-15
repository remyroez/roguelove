
local folderOfThisFile = (...) .. '.'

return {
    Actor = require(folderOfThisFile ..'Actor'),
    Behavior = require(folderOfThisFile ..'Behavior'),
    Collider = require(folderOfThisFile ..'Collider'),
    Displayable = require(folderOfThisFile ..'Displayable'),
    Layer = require(folderOfThisFile ..'Layer'),
    Light = require(folderOfThisFile ..'Light'),
    Map = require(folderOfThisFile ..'Map'),
    Player = require(folderOfThisFile ..'Player'),
    Position = require(folderOfThisFile ..'Position'),
    Shadow = require(folderOfThisFile ..'Shadow'),
    Size = require(folderOfThisFile ..'Size'),
    Tag = require(folderOfThisFile ..'Tag'),
    View = require(folderOfThisFile ..'View'),
}
