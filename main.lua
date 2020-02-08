local Clover = require("clover")
local Fox = require("fox")
local Rabbit = require("rabbit")

local world = {
	creatureTypes = {
		Clover,
		Fox,
		Rabbit,
	},
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

	clovers[#clovers + 1] = Clover.new(50, 50)
	foxes[#foxes + 1] = Fox.new(50, 150)
	rabbits[#rabbits + 1] = Rabbit.new(50, 100)
end

function love.update(dt)
	for creatureType, creatures in pairs(world.creatures) do
		for i, creature in ipairs(creatures) do
			creature:update(dt, world)
		end
	end
end

function love.draw()
	for creatureType, creatures in pairs(world.creatures) do
		for i, creature in ipairs(creatures) do
			creature:draw()
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
