
local folderOfThisFile = (...) .. '.'

return {
    ActorSystem = require(folderOfThisFile ..'ActorSystem'),
    BehaviorSystem = require(folderOfThisFile ..'BehaviorSystem'),
    AssetSystem = require(folderOfThisFile ..'AssetSystem'),
    DisplaySystem = require(folderOfThisFile ..'DisplaySystem'),
    LightSystem = require(folderOfThisFile ..'LightSystem'),
    MapSystem = require(folderOfThisFile ..'MapSystem'),
    MoveSystem = require(folderOfThisFile ..'MoveSystem'),
    PlayerSystem = require(folderOfThisFile ..'PlayerSystem'),
    ShadowSystem = require(folderOfThisFile ..'ShadowSystem'),
    TagSystem = require(folderOfThisFile ..'TagSystem'),
    ViewSystem = require(folderOfThisFile ..'ViewSystem'),
}
