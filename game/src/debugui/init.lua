
local folderOfThisFile = (...) .. '.'

local lib = {
    --Collection = require(folderOfThisFile ..'Collection'),
}

local function nilOr(value, default)
    return value == nil and default or value
end

local function nilOrTrue(value)
    return nilOr(value, true)
end

local function nilOrFalse(value)
    return nilOr(value, false)
end

local function callChildren(children)
    if type(children) == 'function' then
        children()
    elseif type(children) == 'table' then
        for _, child in pairs(children) do
            if child then
                child()
            end
        end
    end
end

function lib.MainMenuBar(state)
    return function ()
        if imgui.BeginMainMenuBar() then
            callChildren(state.children)
            imgui.EndMainMenuBar()
        end
    end
end

function lib.Menu(state)
    return function ()
        if imgui.BeginMenu(state.label, nilOrTrue(state.enabled)) then
            callChildren(state.children)
            imgui.EndMenu()
        end
    end
end

function lib.MenuItem(state)
    return function ()
        if imgui.MenuItem(state.label, state.shortcut, nilOrFalse(state.selected), nilOrTrue(state.enabled)) then
            callChildren(state.children)
        end
    end
end

return lib
