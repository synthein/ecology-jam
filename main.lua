local Clovers = require("clovers")
local Foxes = require("foxes")
local Rabbits = require("rabbits")

world = {
	creatureTypes = {Clovers, Foxes, Rabbits},
	creatures = {
		clovers = {},
		foxes = {},
		rabbits = {},
	},
}

function love.load()
	local clovers = world.creatures.clovers
	local foxes = world.creatures.foxes
	local rabbits = world.creatures.rabbits

	clovers[#clovers + 1] = {50, 50}
	foxes[#foxes + 1] = {50, 150}
	rabbits[#rabbits + 1] = {50, 100}
end

function love.update(dt)
	for i, creatureType in ipairs(world.creatureTypes) do
		if creatureType.update then
			creatureType.update(dt)
		end
	end
end

function love.draw()
	for i, creatureType in ipairs(world.creatureTypes) do
		creatureType.draw()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
