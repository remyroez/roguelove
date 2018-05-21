
local folderOfThisFile = (...) .. '.'

return {
    ActorSystem = require(folderOfThisFile ..'ActorSystem'),
    AssetSystem = require(folderOfThisFile ..'AssetSystem'),
    AttributeSystem = require(folderOfThisFile ..'AttributeSystem'),
    BehaviorSystem = require(folderOfThisFile ..'BehaviorSystem'),
    DebugSystem = require(folderOfThisFile ..'DebugSystem'),
    DisplaySystem = require(folderOfThisFile ..'DisplaySystem'),
    LightSystem = require(folderOfThisFile ..'LightSystem'),
    MapSystem = require(folderOfThisFile ..'MapSystem'),
    MoveSystem = require(folderOfThisFile ..'MoveSystem'),
    PathfindingSystem = require(folderOfThisFile ..'PathfindingSystem'),
    PlayerSystem = require(folderOfThisFile ..'PlayerSystem'),
    ShadowSystem = require(folderOfThisFile ..'ShadowSystem'),
    TagSystem = require(folderOfThisFile ..'TagSystem'),
    ViewSystem = require(folderOfThisFile ..'ViewSystem'),
}
