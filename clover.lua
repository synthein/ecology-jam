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

function Clover.seed(cloverCount, clovers, maxX, maxY)
    --x*10(1-x/20)
    -- n1 = no*r()
    --x*1(1-x/100) -> -x^2/100 + x
    --newClovers = - cloverCount * cloverCount / 100 + cloverCount
    newClovers = math.ceil(cloverCount * (1 - cloverCount / 100))
    for i = 1, newClovers do
        table.insert(
            clovers,
            {maxX * math.random(), maxY * math.random()}
        )
    end
end

return Clover
