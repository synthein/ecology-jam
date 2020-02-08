local Creature = require("creature")

local Clover = {}
setmetatable(Clover, {__index = Creature})

function Clover.draw()
    love.graphics.setColor(0, 0.8, 0)
    for i, clover in ipairs(world.creatures.clovers) do
        love.graphics.circle("fill", clover[1], clover[2], 15)
    end
end

return Clover
