local Foxes = {}

function Foxes.draw()
    love.graphics.setColor(1, .5, 0)
    for i, fox in ipairs(world.creatures.foxes) do
        love.graphics.circle("fill", fox[1], fox[2], 15)
    end
end

return Foxes
