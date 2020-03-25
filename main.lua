local Clover = require("clover")
local Fox = require("fox")
local Rabbit = require("rabbit")
local Hole = require("hole")
local lume = require("vendor/lume")

local world = {
	maxX = 800,
	maxY = 600,
	creatures = {
		clovers = {},
		foxes = {},
		rabbits = {},
		holes = {},
	}
}

function love.load()
	love.window.setFullscreen(true)
	world.maxX = love.graphics.getWidth()
	world.maxY = love.graphics.getHeight()
	love.graphics.setBackgroundColor(0.78, 0.68, 0.60)
	local x = world.maxX / 2
	local y = world.maxY / 2

	--table.insert(world.creatures.clovers, Clover.new(x, y))
	table.insert(world.creatures.clovers, Clover.new(300, 200))
	for i = 1, 15 do
		Clover.seed(world.creatures.clovers, world.maxX, world.maxY)
	end

	--love.event.push("new rabbit", {x + 10, y, "male"})
	--love.event.push("new rabbit", {x - 10, y, "female"})
	love.event.push("new rabbit", {0, 20, "male"})
	love.event.push("new rabbit", {20, 0, "female"})

	table.insert(world.creatures.holes, Hole.new(200, 300))
end

local dayTimer = 0
local dayCount = 0
local dayLength = 10
function love.update(dt)
	dayTimer = dayTimer  + dt

	if dayTimer >= dayLength then
		dayTimer = dayTimer - 10
		dayCount = dayCount + 1

		Clover.seed(
			world.creatures.clovers,
			world.maxX, world.maxY
		)
		if dayCount == 13 then
			--love.event.push("new fox", {world.maxX / 2 - 15, world.maxY / 2, "male"})
			--love.event.push("new fox", {world.maxX / 2 + 15, world.maxY / 2, "female"})
			love.event.push("new fox", {0, 30, "male"})
			love.event.push("new fox", {30, 0, "female"})
		end
	end

	for creatureType, creatures in pairs(world.creatures) do
		for i, creature in ipairs(creatures) do
			creature:update(dt, world)
		end
	end
end

local drawOrder = {
	"holes",
	"clovers",
	"rabbits",
	"foxes"
}

function love.draw()
	for _, creatureType in ipairs(drawOrder) do
		for i, creature in ipairs(world.creatures[creatureType]) do
			creature:draw()
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

love.handlers["new rabbit"] = function(...)
	table.insert(world.creatures.rabbits, Rabbit.new(unpack(...)))
end

love.handlers["new clover"] = function(...)
	table.insert(world.creatures.clovers, Clover.new(unpack(...)))
end

love.handlers["new fox"] = function(...)
	table.insert(world.creatures.foxes, Fox.new(unpack(...)))
end
