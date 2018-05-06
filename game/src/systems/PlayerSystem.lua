
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local PlayerSystem = class('PlayerSystem', lovetoys.System)

function PlayerSystem:initialize()
    lovetoys.System.initialize(self)
end

function PlayerSystem:requires()
    return { 'Position', 'Player' }
end

function PlayerSystem:update(dt)
    
end

function PlayerSystem:keypressed(event)
    local key = event.key

    local update = true

    local newPos={0,0}
    if     key=='kp1' then newPos={-1, 1}
    elseif key=='kp2' or key=='j' then newPos={ 0, 1}
    elseif key=='kp3' then newPos={ 1, 1}
    elseif key=='kp4' or key=='h' then newPos={-1, 0}
    elseif key=='kp5' then newPos={ 0, 0}
    elseif key=='kp6' or key=='l' then newPos={ 1, 0}
    elseif key=='kp7' then newPos={-1,-1}
    elseif key=='kp8' or key=='k' then newPos={ 0,-1}
    elseif key=='kp9' then newPos={ 1,-1}
    else
        update = false
    end
    
    if update then
        for index, entity in pairs(self.targets) do
            entity:get('Position'):translate(unpack(newPos))
        end
    end
end

return PlayerSystem
