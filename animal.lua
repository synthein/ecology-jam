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

    a.predator = nil
    a.targetIndex = nil
    a.targetDistanceSq = nil

    a.fill = 0

    return a
end

function Animal:lookForFood(foodPool)
    self.target = nil

    for i, food in ipairs(foodPool) do
        local distanceSq = lume.distance(
            self.x, self.y,
            food.x, food.y,
            "squared"
        )

        if not self.target or self.targetDistanceSq > distanceSq then
            self.target = food
            self.targetIndex = i
            self.targetDistanceSq = distanceSq
        end
    end
end

function Animal:watchForPredators(predatorPool)
    self.predator = nil

    for i, predator in ipairs(predatorPool) do
        local distanceSq = lume.distance(
            self.x, self.y,
            predator.x, predator.y,
            "squared"
        )

        if not self.predator or self.targetDistanceSq > distanceSq then
            self.predator = predator
            self.predatorIndex = i
            self.targetDistanceSq = distanceSq
        end
    end
end

function Animal:move(dt, maxX, maxY)
    local targetDx, targetDy, targetDistance = 0, 0, math.huge
    local predatorDx, predatorDy, predatorDistance = 0, 0, math.huge

    if self.target then
        targetDx = self.target.x - self.x
        targetDy = self.target.y - self.y
        targetDistance = math.sqrt(targetDx * targetDx + targetDy * targetDy)
    end
    if self.predator then
        predatorDx = self.predator.x - self.x
        predatorDy = self.predator.y - self.y
        predatorDistance = math.sqrt(predatorDx * predatorDx + predatorDy * predatorDy)
    end

    local runDirection = 0
    local dx, dy, distance

    if targetDistance < predatorDistance then
        runDirection = 1
        dx = targetDx
        dy = targetDy
        distance = targetDistance
    else
        runDirection = -1
        dx = predatorDx
        dy = predatorDy
        distance = predatorDistance
    end

    if distance ~= 0 then
        self.x = self.x + runDirection * dt * self.speed * dx / distance
        self.y = self.y + runDirection * dt * self.speed * dy / distance

        self.x = lume.clamp(self.x, 0, maxX)
        self.y = lume.clamp(self.y, 0, maxY)
    end
end

function Animal:eat(foodPool)
    table.remove(foodPool, self.targetIndex)
    self.target = nil
    self.targetIndex = nil
    self.targetDistanceSq = nil

    self.fill = self.fill + 1
end

return Animal
