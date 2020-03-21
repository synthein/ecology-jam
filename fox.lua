local Animal = require("animal")
local Timer = require("timer")
local lume = require("vendor/lume")

local Fox = {}
setmetatable(Fox, {__index = Animal})

Fox.speed = 75
Fox.spacing = 30
Fox.visionDistance = 300

function Fox.new(x, y)
    local self = Animal.new(x, y)
    setmetatable(self, {__index = Fox})

    self.full = 4
    if self.gender == "male" then
        self.full = 2
    end

    self.hunger = Timer.new(10)

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
        love.event.push("new fox", {self.x, self.y + 30})
        love.event.push("new fox", {self.x, self.y - 30})
        self.pregnant = nil
    end

    local food = world.creatures.rabbits


    if self.fill < self.full then
        self:lookForFood(food)
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

function Fox:draw()
    love.graphics.setColor(1, .5, 0)
    love.graphics.circle("fill", self.x, self.y, 15)
    love.graphics.setColor(0, 0, 0)
    -- text, x, y, r, sx, sy, ox, oy, kx, ky
    if self.gender == "male" then
        love.graphics.print("M", self.x, self.y, 0, 1, 1, 5, 7 )
    else
        love.graphics.print("F", self.x, self.y, 0, 1, 1, 5, 7 )
    end
end

return Fox
