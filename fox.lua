local Animal = require("animal")
local Timer = require("timer")
local lume = require("vendor/lume")

local Fox = {}
setmetatable(Fox, {__index = Animal})

Fox.speed = 100
Fox.spacing = 30
Fox.visionDistance = 300
Fox.gestationPeriod = 15
Fox.color = {1, .5, 0}
Fox.size = 15

function Fox.new(x, y, gender)
    local self = Animal.new(x, y, gender)
    setmetatable(self, {__index = Fox})

    return self
end

function Fox:update(dt, world, newDay)
    if self.hunger:ready(dt) then
        if self.pregnant then
            self.fill = self.fill - 2
        else
            self.fill = self.fill - 1
        end

        if self.fill < 0 then
            lume.remove(world.creatures.foxes, self)
            return
        end
    end

    if self.pregnant and self.pregnant:ready(dt) then
        love.event.push("new fox", {self.x + 30, self.y})
        love.event.push("new fox", {self.x - 30, self.y})
        self.pregnant = nil
    end

    local food = world.creatures.rabbits


    if self.fill < self.full then
        self:lookForFood(food)
    else
        self.netTarget = {0, 0}
    end

    self:watchForSimilar(world.creatures.foxes)
    self:lookForMate(world.creatures.foxes)
    self:move(dt, world.maxX, world.maxY)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
    if self.mate and lume.distance(self.x, self.y, self.mate.x, self.mate.y, "squared") < 961 then
        self:reproduce()
    end
end

return Fox
