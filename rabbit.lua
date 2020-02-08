local Animal = require("animal")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

function Rabbit.new(x, y)
    local r = Animal.new(x, y)

    setmetatable(r, {__index = Rabbit})

    return r
end

function Rabbit:update(dt, world)
    local cloverTarget, cloverX, cloverY, cloverDistanceSq, cloverIndex
    for i, clover in ipairs(world.creatures.clovers) do
        local x, y, distanceSq
        x =  clover.x - self.x
        y =  clover.y - self.y
        distanceSq = x * x + y * y
        if not cloverTarget or cloverDistanceSq > distanceSq then
            cloverTarget = clover
            cloverDistanceSq =distanceSq
            cloverX = x
            cloverY = y
            cloverIndex = i
        end
    end

    if cloverTarget then
        if cloverDistanceSq < 100 then
            table.remove(world.creatures.clovers, cloverIndex)
        else
            local distance = math.sqrt(cloverDistanceSq)
            self.x = self.x + dt * 50 * cloverX / distance
            self.y = self.y + dt * 50 * cloverY / distance
        end
    end
end

function Rabbit:draw()
    love.graphics.setColor(.75, .75, .75)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Rabbit
