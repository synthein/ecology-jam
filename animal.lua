local Creature = require("creature")
local Timer = require("timer")
local lume = require("vendor/lume")

local Animal = {}
setmetatable(Animal, {__index = Creature})

Animal.visionDistance = math.huge

function Animal.new(x, y, gender)
    local self = Creature.new(x, y)
    setmetatable(self, {__index = Animal})

    self.target = nil
    self.targetIndex = nil
    self.targetDistanceSq = nil

    self.predator = nil
    self.targetIndex = nil
    self.targetDistanceSq = nil

    self.netSimilar = {0, 0}
    self.netTarget = {0, 0}
    self.netPredator = {0, 0}
    self.netMate = {0, 0}
    self.netShelter = {0, 0}

    self.randomDAngle = 0
    self.angle = 0

    self.fill = 0

    if gender then
        self.gender = gender
    else
        self.gender = "female"
        if math.random() >= .5 then
            self.gender = "male"
        end
    end
    if self.gender == female then
        self.pregnant = false
    end

    self.full = 4
    if self.gender == "male" then
        self.full = 2
    end

    self.hunger = Timer.new(10)

    return self
end

function Animal:lookForFood(foodPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.target = nil
    local netTarget = {0, 0}

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
                local dx = food.x - self.x
                local dy = food.y - self.y
                netTarget[1] = netTarget[1] + dx/distanceSq
                netTarget[2] = netTarget[2] + dy/distanceSq
            end
        end
    end
    self.netTarget = netTarget
end

function Animal:lookForShelter(shelterPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.shelter = nil
    local netShelter = {0, 0}

    for i, shelter in ipairs(shelterPool) do
        local distanceSq = lume.distance(
            self.x, self.y,
            shelter.x, shelter.y,
            "squared"
        )

        if distanceSq <= visionSq and (not self.shelter or self.shelterDistanceSq > distanceSq) then
            self.shelter = shelter
            self.shelterDistanceSq = distanceSq
            local dx = shelter.x - self.x
            local dy = shelter.y - self.y
            netShelter[1] = netShelter[1] + dx/distanceSq
            netShelter[2] = netShelter[2] + dy/distanceSq
        end
    end
    self.netShelter = netShelter
end

function Animal:lookForMate(matingPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.mate = nil
    local netMate = {0, 0}

    for i, mate in ipairs(matingPool) do
        if self.gender == "male" and mate.gender == "female" then
            local distanceSq = lume.distance(
                self.x, self.y,
                mate.x, mate.y,
                "squared"
            )

            local ready =  not mate.pregnant and mate.fill == mate.full
            local dx = mate.x - self.x
            local dy = mate.y - self.y
            local m = 1
            if not ready then
                m = 1/4
            end
            netMate[1] = netMate[1] + m*dx/distanceSq
            netMate[2] = netMate[2] + m*dy/distanceSq

            if distanceSq <= visionSq and ready and (not self.mate or self.mateDistanceSq > distanceSq) then
                self.mate = mate
                self.mateDistanceSq = distanceSq
            end
        end
    end
    self.netMate = netMate
end

function Animal:watchForSimilar(similarPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.similar = nil
    local netSimilar = {0, 0}

    for i, similar in ipairs(similarPool) do
        if similar ~= self and not similar.hidden then
            local distanceSq = lume.distance(
            self.x, self.y,
            similar.x, similar.y,
            "squared"
            )

            local spacingSq = self.spacing * self.spacing
            if distanceSq <= spacingSq and (not self.similar or self.similarDistanceSq > distanceSq) then
                self.similar = similar
                self.similarDistanceSq = distanceSq
                local dx = self.x - similar.x
                local dy = self.y - similar.y
                netSimilar[1] = netSimilar[1] + dx/distanceSq
                netSimilar[2] = netSimilar[2] + dy/distanceSq
            end
        end
    end
    self.netSimilar = netSimilar
end

function Animal:watchForPredators(predatorPool)
    local visionSq = self.visionDistance * self.visionDistance
    self.predator = nil
    local netPredator = {0, 0}

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
                local dx = self.x - predator.x
                local dy = self.y - predator.y
                netPredator[1] = netPredator[1] + dx/distanceSq
                netPredator[2] = netPredator[2] + dy/distanceSq
            end
        end
    end
    self.netPredator = netPredator
end

function Animal:move(dt, maxX, maxY)

    local runDirection = 0
    local dx, dy, distance
    self.hide = false

    local survival
    if self.fill >= self.full then
        survival = self.netShelter
        self.hide = true
    else
        survival = self.netTarget
    end

    self.randomDAngle = self.randomDAngle * (1 - dt) + dt * math.random(-25, 25)
    self.angle = self.angle + dt * self.randomDAngle

    dx = survival[1] + self.netMate[1] + self.netSimilar[1] + self.netPredator[1] + math.cos(self.angle)/1000
    dy = survival[2] + self.netMate[2] + self.netSimilar[2] + self.netPredator[2] + math.sin(self.angle)/1000

    distance = math.sqrt(dx * dx + dy * dy)

    if distance ~= 0 then
        self.x = self.x + dt * self.speed * dx / distance
        self.y = self.y + dt * self.speed * dy / distance

        self.x = lume.clamp(self.x, 0, maxX)
        self.y = lume.clamp(self.y, 0, maxY)

        if self.x == 0 or self.x == maxX then
            dx = -dx
        end
        if self.y == 0 or self.y == maxY then
            dy = -dy
        end
        self.angle = math.atan2(dy, dx)
    end

end

function Animal:eat(foodPool)
    table.remove(foodPool, self.targetIndex)
    self.target = nil
    self.targetIndex = nil
    self.targetDistanceSq = nil

    self.fill = self.fill + 1
end

function Animal:reproduce()
    local m = self.mate.gestationPeriod
    self.mate.pregnant = Timer.new(lume.random(m*0.9, m*1.1))
    self.fill = self.fill - 1
end

function Animal:draw()
    Creature.draw(self)
    love.graphics.setColor(0, 0, 0)
    if self.gender == "male" then
        love.graphics.print("M", self.x, self.y, 0, 1, 1, 5, 7 )
    else
        love.graphics.print("F", self.x, self.y, 0, 1, 1, 5, 7 )
    end
end

return Animal
