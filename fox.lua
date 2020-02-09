local Animal = require("animal")
local lume = require("vendor/lume")

local Fox = {}
setmetatable(Fox, {__index = Animal})

function Fox.new(x, y)
    local f = Animal.new(x, y)
    setmetatable(f, {__index = Fox})

    f.speed = 60

    return f
end

function Fox:update(dt, world, newDay)
    if newDay then
        if self.fill == 4 then
            table.insert(world.new.foxes, {self.x + 30, self.y})
        elseif self.fill >=2 then
            self.fill = self.fill - 2
        else
            lume.remove(world.creatures.foxes, self)
            return
        end
    end

    local food = world.creatures.rabbits


    if self.fill < 4 then
        self:lookForFood(food)
    end

    self:move(dt, world.maxX, world.maxY)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
    end
end

function Fox:draw()
    love.graphics.setColor(1, .5, 0)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Fox
