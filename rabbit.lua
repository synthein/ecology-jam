local Animal = require("animal")
local Clover = require("clover")
local lume = require("vendor/lume")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

Rabbit.speed = 50
Rabbit.spacing = 20
Rabbit.visionDistance = 200
Rabbit.minFoodToReproduce = 3

function Rabbit.new(x, y)
    local r = Animal.new(x, y)
    setmetatable(r, {__index = Rabbit})

    return r
end

function Rabbit:update(dt, world, newDay)
    if newDay then
        self.hidden = false

        if self.fill == self.minFoodToReproduce then
            love.event.push("new rabbit", {self.x + 30, self.y})
            self.fill = self.fill - self.minFoodToReproduce
        else
            self.fill = self.fill - 1
        end

        if self.fill < 0 then
            lume.remove(world.creatures.rabbits, self)
            return
        end
    end

    local food = world.creatures.clovers

    if self.fill < 3 then
        self:lookForFood(food)
    end

    self:lookForShelter(world.creatures.holes)
    self:watchForSimilar(world.creatures.rabbits)
    self:watchForPredators(world.creatures.foxes)

    self:move(dt, world.maxX, world.maxY)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
    if self.hide and lume.distance(self.x, self.y, self.shelter.x, self.shelter.y, "squared") < 100 then
        self.hidden = true
    end
end

function Rabbit:draw()
    if not self.hidden then
        love.graphics.setColor(.75, .75, .75)
        love.graphics.circle("fill", self.x, self.y, 10)
        love.graphics.setColor(0, 0, 0)
        -- text, x, y, r, sx, sy, ox, oy, kx, ky
        if self.gender == "male" then
            love.graphics.print("M", self.x, self.y, 0, 1, 1, 5, 7 )
        else
            love.graphics.print("F", self.x, self.y, 0, 1, 1, 5, 7 )
        end
    end
end

return Rabbit
