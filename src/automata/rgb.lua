local map = {{}}
local width = 500
local height = 1000
for x = 1, width do
  map[1][x] = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

local function simulate(left, right)
  if left == right then
    return left
  end
  do
	local leftPoints = 0
	local rightPoints = 0
	if math.abs(math.floor(left.R * 255) - math.floor(right.R * 255)) % 2 == 0 then
		leftPoints += 1
	else
		rightPoints += 1
	end
	if math.abs(math.floor(left.G * 255) - math.floor(right.G * 255)) % 2 == 0 then
		leftPoints += 1
	else
		rightPoints += 1
	end
	if math.abs(math.floor(left.B * 255) - math.floor(right.B * 255)) % 2 == 0 then
		leftPoints += 1
	else
		rightPoints += 1
	end
	if leftPoints > rightPoints then
		return left
	else
		return right
	end
  end
end

for y = 1, height do
  if not map[y] then
    map[y] = {}
    for x = 1, width do
      local left = map[y - 1][x - 1] or Color3.new()
      local right = map[y - 1][x + 1] or Color3.new()
      map[y][x] = simulate(left, right)
    end
  end
  for x, val in ipairs(map[y]) do
    local pixel = Instance.new('WedgePart')
    pixel.Size = Vector3.one
    pixel.Position = Vector3.new(x - height / 2, y, 100)
    pixel.Anchored = true
    pixel.Color = val
    pixel.Parent = script
    if x % 32 == 0 then
      wait()
    end
  end
end
