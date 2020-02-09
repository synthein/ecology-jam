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
		rabbits = {}
	}
}

function love.load()
	lume.push(world.creatures.clovers,
		Clover.new(50, 50),
		Clover.new(50, 550),
		Clover.new(750, 50),
		Clover.new(750, 550)
	)
	lume.push(world.creatures.rabbits,
		Rabbit.new(50, 100)
	)
	lume.push(world.creatures.foxes,
		Fox.new(200, 300)
	)
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
		--x*1(1-x/100) -> -x^2/100 + x
		--newClovers = - cloverCount * cloverCount / 100 + cloverCount
		newClovers = math.ceil(cloverCount * (1 - cloverCount / 100))
		for i = 1, newClovers do
			clovers[#clovers + 1] = Clover.new(800 * math.random(), 600 * math.random())
		end
	end

	for creatureType, creatures in pairs(world.creatures) do
		for i, creature in ipairs(creatures) do
			creature:update(dt, world, newDay)
		end
	end

	while #world.new.rabbits ~= 0 do
		local list = world.new.rabbits[1]
		table.insert(world.creatures.rabbits, Rabbit.new(list[1], list[2]))
		table.remove(world.new.rabbits, 1)
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
