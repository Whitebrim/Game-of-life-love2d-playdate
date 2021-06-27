local clearScreen = true
local autoPlay = false
local height = 240
local width = 400
local threshold = 0.5

local function checkCellNeighbours(x, y)
	local left = (x - 1) % width
	local right = (x + 1) % width
	local up = (y - 1) % height
	local down = (y + 1) % height
	local aliveAmount = world[left + up * width] +
						world[x + up * width] +
						world[right + up * width] +
						world[left + y * width] +
						world[right + y * width] +
						world[left + down * width] +
						world[x + down * width] +
						world[right + down * width]

	if aliveAmount == 2 then
		return world[x + y * width]
	end
	if aliveAmount == 3 then
		return 1
	else
		return 0
	end
end

local function nextStep()
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			nextWorld[x + y * width] = checkCellNeighbours(x, y)
		end
	end
	world, nextWorld = nextWorld, world
end

local function drawTable()
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			if (world[x + y * width] == 1) then
				love.graphics.points(x, y)
			end
		end
	end
end

local function newWorld()
	world = {}
	nextWorld = {}
	for x = 0, width - 1 do
		for	y = 0, height - 1 do
			world[x + y * width] = math.random(2) - 1 -- Рандом 0 или 1
		end
	end
end

function loadGame()
	math.randomseed (os.time()) -- Сид для рандома, возможно у playdate sdk есть свой рандом
	newWorld()
end

function updateGame()
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