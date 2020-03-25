local Animal = require("animal")
local Clover = require("clover")
local Timer = require("timer")
local lume = require("vendor/lume")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

Rabbit.speed = 50
Rabbit.spacing = 20
Rabbit.visionDistance = 200
Rabbit.gestationPeriod = 40
Rabbit.color = {.75, .75, .75}
Rabbit.size = 10

function Rabbit.new(x, y, gender)
    local self = Animal.new(x, y, gender)
    setmetatable(self, {__index = Rabbit})

    return self
end

function Rabbit:update(dt, world)
    if self.hunger:ready(dt) then
        if self.pregnant then
            self.fill = self.fill - 2
        else
            self.fill = self.fill - 1
        end

        if self.fill < 0 then
            lume.remove(world.creatures.rabbits, self)
            return
        end
    end

    if self.pregnant and self.pregnant:ready(dt) then
        love.event.push("new rabbit", {self.x + 30, self.y})
        love.event.push("new rabbit", {self.x - 30, self.y})
        love.event.push("new rabbit", {self.x, self.y + 30})
        love.event.push("new rabbit", {self.x, self.y - 30})
        self.pregnant = false
    end

    local food = world.creatures.clovers

    if self.fill < self.full then
        self:lookForFood(food)
    else
        self.netTarget = {0, 0}
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
    if self.hide and self.shelter and lume.distance(self.x, self.y, self.shelter.x, self.shelter.y, "squared") < 100 then
        self.hidden = true
    else
        self.hidden = false
    end
end

function Rabbit:draw()
    if not self.hidden then
        Animal.draw(self)
    end
end

return Rabbit
