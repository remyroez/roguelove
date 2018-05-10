
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local Move = require 'events.Move'

local PlayerSystem = class('PlayerSystem', lovetoys.System)

function PlayerSystem:initialize(eventManager)
    lovetoys.System.initialize(self)
    self.eventManager = eventManager
end

function PlayerSystem:requires()
    return { 'Position', 'Size', 'Layer', 'Collider', 'Player' }
end

function PlayerSystem:update(dt)
    
end

function PlayerSystem:keypressed(event)
    local key = event.key

    local update = true

    local newPos={0,0}
    if     key=='kp1' then newPos={-1, 1}
    elseif key=='kp2' or key=='j' or key=='down' then newPos={ 0, 1}
    elseif key=='kp3' then newPos={ 1, 1}
    elseif key=='kp4' or key=='h' or key=='left' then newPos={-1, 0}
    elseif key=='kp5' then newPos={ 0, 0}
    elseif key=='kp6' or key=='l' or key=='right' then newPos={ 1, 0}
    elseif key=='kp7' then newPos={-1,-1}
    elseif key=='kp8' or key=='k' or key=='up' then newPos={ 0,-1}
    elseif key=='kp9' then newPos={ 1,-1}
    else
        update = false
    end
    
    if update then
        for index, entity in pairs(self.targets) do
            self.eventManager:fireEvent(
                Move(
                    entity.id,
                    entity:get('Position'),
                    entity:get('Size'),
                    entity:get('Layer'),
                    entity:get('Collider'),
                    newPos[1],
                    newPos[2],
                    not love.keyboard.isDown('lctrl')
                )
            )
        end
    end
end

return PlayerSystem
