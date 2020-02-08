local Creature = {}

function Creature.new(x, y)
    local c = setmetatable({}, {__index = Creature})

    c.x = x
    c.y = y

    return c
end

function Creature:update()
end

function Creature:draw()
end

return Creature
