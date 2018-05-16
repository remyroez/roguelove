
local folderOfThisFile = (...) .. '.'

local events = {
    Collection = require(folderOfThisFile ..'Collection'),
    FindEntitiesWithTag = require(folderOfThisFile ..'FindEntitiesWithTag'),
    Flush = require(folderOfThisFile ..'Flush'),
    HitCheck = require(folderOfThisFile ..'HitCheck'),
    KeyPressed = require(folderOfThisFile ..'KeyPressed'),
    Move = require(folderOfThisFile ..'Move'),
    NextTurn = require(folderOfThisFile ..'NextTurn'),
    Pathfinding = require(folderOfThisFile ..'Pathfinding'),
}

function events.fireEvent(engine, event)
    engine.eventManager:fireEvent(event)
    return event and event.result or nil
end

function events.fireCollection(engine, ...)
    return events.fireEvent(engine, events.Collection(...))
end

function events.fireFindEntitiesWithTag(engine, ...)
    return events.fireEvent(engine, events.FindEntitiesWithTag(...))
end

function events.fireFlush(engine, ...)
    return events.fireEvent(engine, events.Flush(...))
end

function events.fireHitCheck(engine, ...)
    return events.fireEvent(engine, events.HitCheck(...))
end

function events.fireKeyPressed(engine, ...)
    return events.fireEvent(engine, events.KeyPressed(...))
end

function events.fireMove(engine, ...)
    return events.fireEvent(engine, events.Move(...))
end

function events.fireNextTurn(engine, ...)
    return events.fireEvent(engine, events.NextTurn(...))
end

function events.firePathfinding(engine, ...)
    return events.fireEvent(engine, events.Pathfinding(...))
end

return events
