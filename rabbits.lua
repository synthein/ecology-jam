local Rabbits = {}

local rabbits = {{50, 100}}
function Rabbits.draw()
    love.graphics.setColor(.75, .75, .75)
    for i, rabbit in ipairs(rabbits) do
        love.graphics.circle("fill", rabbit[1], rabbit[2], 15)
    end
end

local clovers = {{50, 200}}
function Rabbits.update(dt)
    for i, rabbit in ipairs(rabbits) do
        local cloverTarget, cloverDistanceSq
        for i, clover in ipairs(clovers) do
            local x, y, distanceSq
            x =  clover[1] - rabbit[1]
            y =  clover[1] - rabbit[1]
            distanceSq = x * x + y * y
            if not cloverTarget or cloverDistanceSq > distanceSq then
                cloverTarget = clover
                cloverDistanceSq =distanceSq
            end
        end
        rabbit[1] = rabbit[1] + dt * 5 * cloverTarget[1]
        rabbit[2] = rabbit[2] + dt * 5 * cloverTarget[2]
    end
end

return Rabbits
