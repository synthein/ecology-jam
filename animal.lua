local Creature = require("creature")

local Animal = {}
setmetatable(Animal, {__index = Creature})

return Animal
