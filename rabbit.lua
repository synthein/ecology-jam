local Animal = require("animal")
local Clover = require("clover")
local lume = require("vendor/lume")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

function Rabbit.new(x, y)
    local r = Animal.new(x, y)
    setmetatable(r, {__index = Rabbit})

    return r
end

function Rabbit:update(dt, world)
    local food = world.creatures.clovers

    self:setTarget(food)
    self:move(dt)

    if lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
end

function Rabbit:draw()
    love.graphics.setColor(.75, .75, .75)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Rabbit
