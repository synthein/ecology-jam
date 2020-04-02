local Creature = require("creature")
local lume = require("vendor/lume")

local Clover = {}
setmetatable(Clover, {__index = Creature})

Clover.color = {0, 0.8, 0}
Clover.size = 5

function Clover.new(x, y)
    local c = Creature.new(x, y)
    setmetatable(c, {__index = Clover})

    return c
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

    newClovers = math.ceil(existingCloverCount * (1 - existingCloverCount * 4 / (maxX + maxY)))
    for i = 1, newClovers do
        local parent = lume.randomchoice(cloverPool)

        local distance, direction
        local x, y = -1, -1

        while x < 0 or x > maxX or y < 0 or y > maxY do
            distance = exponentialRandom() * 150
            direction = math.random(0, 2*math.pi)
            x, y = lume.vector(direction, distance)
            x = x + parent.x
            y = y + parent.y
        end

        table.insert(cloverPool, Clover.new(x, y))
    end
end

return Clover
