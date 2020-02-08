local Rabbits = {}

local rabbits = {{50, 100}}
function Rabbits.draw()
    love.graphics.setColor(.75, .75, .75)
    for i, rabbit in ipairs(rabbits) do
        love.graphics.circle("fill", rabbit[1], rabbit[2], 15)
    end
end

local clovers = {{50, 50}}
function Rabbits.update(dt)
    for i, rabbit in ipairs(rabbits) do
        local cloverTarget, cloverX, cloverY, cloverDistanceSq
        for i, clover in ipairs(clovers) do
            local x, y, distanceSq
            x =  clover[1] - rabbit[1]
            y =  clover[2] - rabbit[2]
            distanceSq = x * x + y * y
            if not cloverTarget or cloverDistanceSq > distanceSq then
                cloverTarget = clover
                cloverDistanceSq =distanceSq
                cloverX = x
                cloverY = y
            end
        end
        local distance = math.sqrt(cloverDistanceSq)
        rabbit[1] = rabbit[1] + dt * 50 * cloverX / distance
        rabbit[2] = rabbit[2] + dt * 50 * cloverY / distance
    end
end

return Rabbits
