local Animal = require("animal")
local lume = require("vendor/lume")

local Fox = {}
setmetatable(Fox, {__index = Animal})

function Fox.new(x, y)
    local f = Animal.new(x, y)
    setmetatable(f, {__index = Fox})

    return f
end

function Fox:update(dt, world)
    local food = world.creatures.rabbits

    self:lookForFood(food)
    self:move(dt)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
end

function Fox:draw()
    love.graphics.setColor(1, .5, 0)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Fox
