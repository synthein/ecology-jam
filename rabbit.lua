local Animal = require("animal")
local Clover = require("clover")
local lume = require("vendor/lume")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

Rabbit.speed = 50
Rabbit.spacing = 20
Rabbit.visionDistance = 200
Rabbit.minFoodToReproduce = 2

function Rabbit.new(x, y, gender)
    local r = Animal.new(x, y, gender)
    setmetatable(r, {__index = Rabbit})

    r.full = 3
    if r.gender == "male" then
        r.full = 2
    end
    return r
end

function Rabbit:update(dt, world, newDay)
    if newDay then
        self.hidden = false
        self.fill = self.fill - 1

        if self.gender == "female" and self.fill >= self.minFoodToReproduce and self.pregnant then
            love.event.push("new rabbit", {self.x + 30, self.y})
            love.event.push("new rabbit", {self.x - 30, self.y})
            love.event.push("new rabbit", {self.x, self.y + 30})
            love.event.push("new rabbit", {self.x, self.y - 30})
            self.fill = self.fill - self.minFoodToReproduce
            self.pregnant = false
        end

        if self.fill < 0 then
            lume.remove(world.creatures.rabbits, self)
            return
        end
    end

    local food = world.creatures.clovers

    if self.fill < self.full then
        self:lookForFood(food)
    end

    self:lookForShelter(world.creatures.holes)
    self:lookForMate(world.creatures.rabbits)
    self:watchForSimilar(world.creatures.rabbits)
    self:watchForPredators(world.creatures.foxes)

    self:move(dt, world.maxX, world.maxY)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
    if self.mate and lume.distance(self.x, self.y, self.mate.x, self.mate.y, "squared") < 441 then
        self:reproduce()
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
