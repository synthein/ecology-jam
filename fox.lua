local Animal = require("animal")

local Fox = {}
setmetatable(Fox, {__index = Animal})

function Fox.new(x, y)
    local f = Animal.new(x, y)
    setmetatable(f, {__index = Fox})

    return f
end

function Fox:draw()
    love.graphics.setColor(1, .5, 0)
    love.graphics.circle("fill", self.x, self.y, 15)
end

return Fox
