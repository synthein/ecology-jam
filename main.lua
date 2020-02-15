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
	love.handlers["new rabbit"] = function(...)
		table.insert(world.creatures.rabbits, Rabbit.new(unpack(...)))
	end

	love.handlers["new clover"] = function(...)
		table.insert(world.creatures.clovers, Clover.new(unpack(...)))
	end

	love.handlers["new fox"] = function(...)
		table.insert(world.creatures.foxes, Fox.new(unpack(...)))
	end

	love.event.push("new clover", {400, 300})
	for i = 1, 7 do
		Clover.seed(i, world.maxX, world.maxY)
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
			love.event.push("new fox", {400,300})
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
			world.maxX, world.maxY
		)
	end
end

local drawOrder = {
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
