
local class = require 'middleclass'
local lovetoys = require 'lovetoys.lovetoys'

local events = require 'events'

local PlayerSystem = class('PlayerSystem', lovetoys.System)

function PlayerSystem:initialize(eventManager)
    lovetoys.System.initialize(self)
    self.eventManager = eventManager
end

function PlayerSystem:requires()
    return { 'Player', 'Actor', 'Position', 'Size', 'Layer', 'Collider' }
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
        local hitCheck = false
        local check = not love.keyboard.isDown('lctrl')
        local fire = true
        local fired = false
        for index, entity in pairs(self.targets) do
            fire = true
            if check and hitCheck then
                local event = events.HitCheck(
                    entity,
                    newPos[1],
                    newPos[2]
                )
                self.eventManager:fireEvent(event)
                if event.result then
                    fire = false
                end
            end

            if fire then
                local actor = entity:get('Actor')
                actor:clear()
                actor:schedule(
                    function (entityActor)
                        self.eventManager:fireEvent(
                            events.Move(
                                entity,
                                newPos[1],
                                newPos[2],
                                check
                            )
                        )
                        return true
                    end
                )
                fired = true
            end
        end

        if fired then
            self.eventManager:fireEvent(events.NextTurn())
        end
    end
end

return PlayerSystem
