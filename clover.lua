local Creature = require("creature")
local lume = require("vendor/lume")

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

-- exponentialRandom is a random function with an exponential distribution.
-- Possible return values are 0 (inclusively) to infinity (exclusively).
-- Learn more: https://en.wikipedia.org/wiki/Exponential_distribution
--
-- Increasing rate increases the probability that the result will be less than
-- one.
local rate = 1
local function exponentialRandom()
    local uniform = math.random()
    return -math.log(uniform) / rate
end

function Clover.seed(cloverPool, maxX, maxY)
    --x*10(1-x/20)
    -- n1 = no*r()
    --x*1(1-x/100) -> -x^2/100 + x
    --newClovers = - cloverCount * cloverCount / 100 + cloverCount
    existingCloverCount = #cloverPool
    newClovers = math.ceil(existingCloverCount * (1 - existingCloverCount / 100))
    for i = 1, newClovers do
        local parent = lume.randomchoice(cloverPool)
        local distance = exponentialRandom() * 50
        local direction = math.random(0, 2*math.pi)
        local x, y = lume.vector(direction, distance)
        x = x + parent.x
        y = y + parent.y
        table.insert(cloverPool, Clover.new(lume.clamp(x, 0, maxX), lume.clamp(y, 0, maxY)))
    end
end

return Clover
