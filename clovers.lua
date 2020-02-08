local Clovers = {}

local clovers = {{50, 50}}
function Clovers.draw()
    love.graphics.setColor(0, 0.8, 0)
    for i, clover in ipairs(clovers) do
        love.graphics.circle("fill", clover[1], clover[2], 15)
    end
end

return Clovers
