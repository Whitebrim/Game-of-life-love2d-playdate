local clearScreen = true
local autoPlay = false
local height = 240
local width = 400
local threshold = 0.5

function getCell(x, y)
	if (x == -1) then
		x = width - 1
	end
	if (x == width) then
		x = 0
	end
	if (y == -1) then
		y = height - 1
	end
	if (y == height) then
		y = 0
	end
	return world:getPixel(x,y) == 1
end

function checkCellNeighbours(x, y)
	local aliveAmount = 0

	for	i = -1, 1 do
		for j = -1, 1 do
			if (i ~= 0 or j ~= 0) and getCell(x + i, y + j) then
				aliveAmount = aliveAmount + 1
			end
		end
	end

	if aliveAmount == 2 and world:getPixel(x, y) == 1 then
		return 1, 1, 1, 1
	end
	if aliveAmount == 3 then
		return 1, 1, 1, 1
	else
		return 0, 0, 0, 1
	end
end

function nextStep()
	nextWorld:mapPixel(checkCellNeighbours)
	image:replacePixels(nextWorld)
	world = nextWorld
end

--[[function drawTable()
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			if (world[x][y]) then
				love.graphics.points(x, y)
			end
		end
	end
end--]]

function fill()
	if love.math.random() > threshold then
		return 1, 1, 1, 1
	   end
	   return 0, 0, 0, 1
end

function newWorld()
	world:mapPixel(fill)
	image:replacePixels(world)
end

function loadGame()
	world = love.image.newImageData(width, height, 'r8')
	nextWorld = world:clone()
	image = love.graphics.newImage(world)
	image:setFilter 'nearest'
	currentFrame = 1
	newWorld()
end

function updateGame(dt)
	currentFrame = currentFrame + 1
	if autoPlay then
		nextStep()
	end
end

function keypressed(key, code)
	if key == "a" then
		clearScreen = not clearScreen
	end
	if key == "p" then
		autoPlay = not autoPlay
	end
	if key == "s" then
		nextStep()
	end
	if key == "n" then
		newWorld()
	end
end

function drawGame()
	if clearScreen then
		love.graphics.clear(BLACK)
	end
	love.graphics.draw(image, 0, 0, 0, 2, 2)
  	love.window.setTitle(love.timer.getFPS())
	--drawTable()
end