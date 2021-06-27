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
	return world[x][y]
end

function checkCellNeighbours(x, y)
	local aliveAmount = 0

	for	i = -1, 1 do
		for j = -1, 1 do
			if not(i == 0 and j == 0) and getCell(x + i, y + j) then
				aliveAmount = aliveAmount + 1
			end
		end
	end

	if (aliveAmount == 2 and world[x][y]) then
		return true
	end
	return aliveAmount == 3
end

function nextStep()
	local nextWorld = {}
	for x = 0, width - 1 do
		nextWorld[x] = {}
		for y = 0, height - 1 do
			nextWorld[x][y] = checkCellNeighbours(x, y)
		end
	end
	world = nextWorld
end

function drawTable()
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			if (world[x][y]) then
				love.graphics.points(x, y)
			end
		end
	end
end

function newWorld()
	world = {}
	for x = 0, width - 1 do
		world[x] = {}
		for	y = 0, height - 1 do
			world[x][y] = love.math.random() > threshold
		end
	end
end

function loadGame()
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
	drawTable()
end