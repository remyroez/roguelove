
local folderOfThisFile = (...) .. '.'

return {
    Collection = require(folderOfThisFile ..'Collection'),
    Flush = require(folderOfThisFile ..'Flush'),
    HitCheck = require(folderOfThisFile ..'HitCheck'),
    KeyPressed = require(folderOfThisFile ..'KeyPressed'),
    Move = require(folderOfThisFile ..'Move'),
    NextTurn = require(folderOfThisFile ..'NextTurn'),
}
