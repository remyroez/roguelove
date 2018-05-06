
local class = require 'middleclass'

local KeyPressed = class('KeyPressed')

function KeyPressed:initialize(key, scancode, isrepeat)
    self.key = key
    self.scancode = scancode
    self.isrepeat = isrepeat
end

return KeyPressed
