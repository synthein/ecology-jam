local Clover = require("clover")
local Fox = require("fox")
local Rabbit = require("rabbit")
local lume = require("vendor/lume")

local world = {
	maxX = 800,
	maxY = 600,
	creatures = {
		clovers = {},
		foxes = {},
		rabbits = {},
	},
	new = {
		clovers = {},
		foxes = {},
		rabbits = {}
	}
}

function love.load()
	table.insert(world.new.clovers, {400, 300})
	for i = 0, 6 do
		Clover.seed(
			#world.new.clovers,
			world.new.clovers,
			world.maxX, world.maxY
		)
	end

	love.handlers["new rabbit"] = function(...)
		table.insert(world.creatures.rabbits, Rabbit.new(unpack(...)))
	end

	love.event.push("new rabbit", {400, 300})
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
		if dayCount == 3 then
			table.insert(world.new.foxes, {400,300})
		end
	end

	for creatureType, creatures in pairs(world.creatures) do
		for i, creature in ipairs(creatures) do
			creature:update(dt, world, newDay)
		end
	end

	if newDay then
		Clover.seed(
			#world.creatures.clovers,
			world.new.clovers,
			world.maxX, world.maxY
		)
	end


	while #world.new.clovers ~= 0 do
		local list = world.new.clovers[1]
		table.insert(world.creatures.clovers, Clover.new(list[1], list[2]))
		table.remove(world.new.clovers, 1)
	end

	while #world.new.foxes ~= 0 do
		local list = world.new.foxes[1]
		table.insert(world.creatures.foxes, Fox.new(list[1], list[2]))
		table.remove(world.new.foxes, 1)
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
