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
	clovers[#clovers + 1] = Clover.new(600, 500)
	foxes[#foxes + 1] = Fox.new(50, 150)
	rabbits[#rabbits + 1] = Rabbit.new(50, 100)
end

local dayTimer = 0
local dayCount = 0
function love.update(dt)
	dayTimer = dayTimer  + dt
	local newDay = false
	if dayTimer >= 10 then
		newDay = true
		dayTimer = dayTimer - 10
		dayCount = dayCount + 1
	end

	if newDay then
		local clovers = world.creatures.clovers
		cloverCount = #clovers
		--x*10(1-x/20)
		-- n1 = no*r()
		newClovers = - cloverCount * cloverCount / 2 + cloverCount * 10 - cloverCount
		for i = 1, math.floor(newClovers) do
			clovers[#clovers + 1] = Clover.new(50 * i, 50 * dayCount)
		end
	end

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
