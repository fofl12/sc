local map = {{}}
local displayed = {{}}
local offset = owner.Character.Head.Position
local width = 300
local height = 200
local scale = 20
for x = 1, width do -- Initial state
	--map[1][x] = math.random() < 0.1
	map[1][x] = x == width / 2
end

local rule = 120
local function alive(x, y)
	local l = map[y - 1][x - 1] or false
	local r = map[y - 1][x + 1] or false
	local c = map[y - 1][x] or false
	local bit = l and 0 or 4
	bit += c and 0 or 2
	bit += r and 0 or 1
	return bit32.extract(rule, bit) == 1
end

for y = 1, height do
	print(y)
	if not map[y] then
		map[y] = {}
		for x = 1, width do
			map[y][x] = alive(x, y)
		end
	end
	if not displayed[y] then
		displayed[y] = {}
	end
	local prev = nil
	for x, val in next, map[y] do
		if val then
			if x % 8 == 0 then
				task.wait()
			end
			if map[y][x - 1] then
				local prevPixel = displayed[y][x - 1]
				prevPixel.Position += Vector3.new(scale / 2)
				prevPixel.Size += Vector3.new(scale)
				displayed[y][x] = prevPixel
				continue
			end
			local pixel = Instance.new('SpawnLocation')
			pixel.Size = Vector3.one * scale
			pixel.Position = Vector3.new(-(scale * width) / 2, scale / 2, -(scale * height) / 2) + Vector3.new(x * scale, 0, (height - y) * scale)
			pixel.Anchored = true
			pixel.BrickColor = BrickColor.Random()
			pixel.Material = 'Wood'
			pixel.Parent = script
			displayed[y][x] = pixel
			prev = val
		end
	end
end
