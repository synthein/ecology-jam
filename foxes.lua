local Foxes = {}

local foxes = {{50, 150}}
function Foxes.draw()
    love.graphics.setColor(1, .5, 0)
    for i, fox in ipairs(foxes) do
        love.graphics.circle("fill", fox[1], fox[2], 15)
    end
end

return Foxes
