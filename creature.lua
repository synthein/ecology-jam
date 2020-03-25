local Creature = {}

function Creature.new(x, y)
    local self = setmetatable({}, {__index = Creature})

    self.x = x
    self.y = y

    return self
end

function Creature:update()
end

function Creature:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
end

return Creature
