local Animal = require("animal")
local lume = require("vendor/lume")

local Fox = {}
setmetatable(Fox, {__index = Animal})

function Fox.new(x, y)
    local f = Animal.new(x, y)
    setmetatable(f, {__index = Fox})

    f.speed = 75
    f.spacing = 50

    return f
end

function Fox:update(dt, world, newDay)
    if newDay then
        if self.fill == 4 then
            self.fill = self.fill - 3
            love.event.push("new fox", {self.x + 30, self.y})
        end
        self.fill = self.fill - 1
        if self.fill < 0 then
            lume.remove(world.creatures.foxes, self)
            return
        end
    end

    local food = world.creatures.rabbits


    if self.fill < 4 then
        self:lookForFood(food)
    end

    self:watchForSimilar(world.creatures.foxes)
    self:move(dt, world.maxX, world.maxY)

    if self.target and lume.distance(self.x, self.y, self.target.x, self.target.y, "squared") < 100 then
        self:eat(food)
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
