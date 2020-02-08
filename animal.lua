local Creature = require("creature")
local lume = require("vendor/lume")

local Animal = {}
setmetatable(Animal, {__index = Creature})

function Animal.new(x, y)
    local a = Creature.new(x, y)
    setmetatable(a, {__index = Animal})

    a.target = nil
    a.targetIndex = nil
    a.targetDistanceSq = nil

    return a
end

function Animal:setTarget(targetPool)
    self.target = nil

    for i, target in ipairs(targetPool) do
        local distanceSq = lume.distance(
            self.x, self.y,
            target.x, target.y,
            "squared"
        )

        if not self.target or self.targetDistanceSq > distanceSq then
            self.target = target
            self.targetIndex = i
            self.targetDistanceSq = distanceSq
        end
    end
end

function Animal:move(dt)
    if self.target then
        local x = self.target.x - self.x
        local y = self.target.y - self.y
        local distance = math.sqrt(x * x + y * y)
        self.x = self.x + dt * 50 * x / distance
        self.y = self.y + dt * 50 * y / distance
    end
end

function Animal:eat(targetPool)
    table.remove(targetPool, self.targetIndex)
    self.target = nil
    self.targetIndex = nil
    self.targetDistanceSq = nil
end

return Animal
