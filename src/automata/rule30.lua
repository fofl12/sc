local map = {{}}
local width = 500
local height = 250
for x = 1, width do
  map[1][x] = x == width / 2
end

function xor(a, b)
  return a ~= b
end

print('Xor Test: ', xor(false, false), xor(false, true), xor(true, false), xor(true, true))

for y = 1, height do
  if not map[y] then
    map[y] = {}
    for x = 1, width do
      map[y][x] = xor(map[y-1][x-1] or false, (map[y-1][x] or false) or (map[y-1][x+1] or false))
    end
  end
  for x, val in ipairs(map[y]) do
    local pixel = Instance.new('WedgePart')
    pixel.Size = Vector3.one
    pixel.Position = Vector3.new(x - height / 2, y, 100)
    pixel.Anchored = true
    pixel.Color = val and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    pixel.Parent = script
    if x % 32 == 0 then
      wait()
    end
  end
end
