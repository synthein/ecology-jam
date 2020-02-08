local Creature = require("creature")

local Clover = {}
setmetatable(Clover, {__index = Creature})

function Clover.new(x, y)
    local c = Creature.new(x, y)

    setmetatable(c, {__index = Clover})

    return c
end

function Clover:draw()
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.circle("fill", self.x, self.y, 5)
end

return Clover
