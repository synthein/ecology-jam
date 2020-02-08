local Animal = require("animal")

local Rabbit = {}
setmetatable(Rabbit, {__index = Animal})

function Rabbit.draw()
    love.graphics.setColor(.75, .75, .75)
    for i, rabbit in ipairs(world.creatures.rabbits) do
        love.graphics.circle("fill", rabbit[1], rabbit[2], 15)
    end
end

function Rabbit.update(dt)
    for i, rabbit in ipairs(world.creatures.rabbits) do
        local cloverTarget, cloverX, cloverY, cloverDistanceSq, cloverIndex
        for i, clover in ipairs(world.creatures.clovers) do
            local x, y, distanceSq
            x =  clover[1] - rabbit[1]
            y =  clover[2] - rabbit[2]
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
                rabbit[1] = rabbit[1] + dt * 50 * cloverX / distance
                rabbit[2] = rabbit[2] + dt * 50 * cloverY / distance
            end
        end
    end
end

return Rabbit
