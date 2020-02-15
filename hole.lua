local Creature = require("creature")

local Hole = {}
setmetatable(Hole, {__index = Creature})

function Hole.new(x, y)
    local h = Creature.new(x, y)
    setmetatable(h, {__index = Hole})

    return h
end

function Hole:draw()
    love.graphics.setColor(.5, .25, 0)
    love.graphics.circle("fill", self.x, self.y, 40)
end

return Hole
