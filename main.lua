local Clovers = require("clovers")
local Foxes = require("foxes")
local Rabbits = require("rabbits")

local WORLD_WIDTH = 500
local WORLD_HEIGHT = 500

local world = {
	creatureTypes = {Clovers, Foxes, Rabbits}
}

function love.load()
	love.window.setMode(WORLD_WIDTH, WORLD_HEIGHT)
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
