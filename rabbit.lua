local Animal = require("animal")
local Clover = require("clover")
local lume = require("vendor/lume")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

function Rabbit.new(x, y)
    local r = Animal.new(x, y)
    setmetatable(r, {__index = Rabbit})

    r.fill = 0

    return r
end

function Rabbit:update(dt, world, newDay)
    if newDay then
        if self.fill == 2 then
            table.insert(world.new.rabbits, {self.x + 30, self.y})
            self.fill = 0
        elseif self.fill == 1 then
            self.fill = 0
        else
            lume.remove(world.creatures.rabbits, self)
            return
        end
    end

    local food = world.creatures.clovers

    if self.fill < 2 then
        self:setTarget(food)
    end

    self:move(dt)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
        self.fill = self.fill + 1
    end
end

function Rabbit:draw()
    love.graphics.setColor(.75, .75, .75)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Rabbit