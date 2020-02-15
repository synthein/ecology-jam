local Creature = require("creature")
local lume = require("vendor/lume")

local Animal = {}
setmetatable(Animal, {__index = Creature})

Animal.visionDistance = math.huge

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

    a.gender = "male"
    if math.random() >= .5 then
        a.gender = "female"
    end

    return a
end

function Animal:lookForFood(foodPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.target = nil

    for i, food in ipairs(foodPool) do
        if not food.hidden then
            local distanceSq = lume.distance(
                self.x, self.y,
                food.x, food.y,
                "squared"
            )

            if distanceSq <= visionSq and (not self.target or self.targetDistanceSq > distanceSq) then
                self.target = food
                self.targetIndex = i
                self.targetDistanceSq = distanceSq
            end
        end
    end
end

function Animal:lookForShelter(shelterPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.shelter = nil

    for i, shelter in ipairs(shelterPool) do
        local distanceSq = lume.distance(
            self.x, self.y,
            shelter.x, shelter.y,
            "squared"
        )

        if distanceSq <= visionSq and (not self.shelter or self.shelterDistanceSq > distanceSq) then
            self.shelter = shelter
            self.shelterDistanceSq = distanceSq
        end
    end
end

function Animal:watchForSimilar(similarPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.similar = nil

    for i, similar in ipairs(similarPool) do
        if similar ~= self and not similar.hidden then
            local distanceSq = lume.distance(
            self.x, self.y,
            similar.x, similar.y,
            "squared"
            )

            if distanceSq <= visionSq and (not self.similar or self.similarDistanceSq > distanceSq) then
                self.similar = similar
                self.similarDistanceSq = distanceSq
            end
        end
    end
end

function Animal:watchForPredators(predatorPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.predator = nil

    for i, predator in ipairs(predatorPool) do
        if not predator.hidden then
            local distanceSq = lume.distance(
                self.x, self.y,
                predator.x, predator.y,
                "squared"
            )

            if distanceSq <= visionSq and (not self.predator or self.targetDistanceSq > distanceSq) then
                self.predator = predator
                self.predatorIndex = i
                self.targetDistanceSq = distanceSq
            end
        end
    end
end

function Animal:move(dt, maxX, maxY)
    local targetDx, targetDy, targetDistance = 0, 0, math.huge
    local shelterDx, shelterDy, shelterDistance = 0, 0, math.huge
    local similarDx, similarDy, similarDistance = 0, 0, math.huge
    local predatorDx, predatorDy, predatorDistance = 0, 0, math.huge

    if self.target then
        targetDx = self.target.x - self.x
        targetDy = self.target.y - self.y
        targetDistance = math.sqrt(targetDx * targetDx + targetDy * targetDy)
    end
    if self.shelter then
        shelterDx = self.shelter.x - self.x
        shelterDy = self.shelter.y - self.y
        shelterDistance = math.sqrt(shelterDx * shelterDx + shelterDy * shelterDy)
    end
    if self.similar then
        similarDx = self.similar.x - self.x
        similarDy = self.similar.y - self.y
        similarDistance = math.sqrt(similarDx * similarDx + similarDy * similarDy)
    end
    if self.predator then
        predatorDx = self.predator.x - self.x
        predatorDy = self.predator.y - self.y
        predatorDistance = math.sqrt(predatorDx * predatorDx + predatorDy * predatorDy)
    end

    local runDirection = 0
    local dx, dy, distance
    self.hide = false
    if similarDistance < self.spacing then
        runDirection = -1
        dx = similarDx
        dy = similarDy
        distance = similarDistance
    elseif targetDistance < predatorDistance then
        runDirection = 1
        dx = targetDx
        dy = targetDy
        distance = targetDistance
    elseif shelterDistance < predatorDistance then
        runDirection = 1
        dx = shelterDx
        dy = shelterDy
        distance = shelterDistance
        self.hide = true
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
