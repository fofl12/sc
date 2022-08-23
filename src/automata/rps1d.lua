local map = {{}}
local width = 300
local height = 100
for x = 1, width do
  if x == 1 then
    map[1][x] = 1
  elseif x == width then
    map[1][x] = 3
  elseif x == width / 2 then
    map[1][x] = 2
  end
  map[1][x] = math.random(0, 3)
end

local function simulate(left, right, middle)
  if left == right and right == midle then
    return left
  end
  do
    local n = 0
    local ok = true
    for _, x in next, {left, right, middle} do
      if x ~= 0 then
        if n ~= x and n ~= 0 then
          ok = false
          break
        else
          n = x
        end
      end
    end
    if ok then
      return n
    end
  end
  do
    local a = 0
    local b = 0
    for _, x in next, {left, right, middle} do
      if x ~= 0 then
        if a == 0 or a == x then
          a = x
        elseif b == 0 or b == x then
          b = x
        else
          return 0
        end
      end
    end
    if a == 1 and b == 2 then
      return b
    elseif a == 2 and b == 3 then
      return b
    elseif a == 3 and b == 1 then
      return b
    else
      return a
    end
  end
end

for y = 1, height do
  if not map[y] then
    map[y] = {}
    for x = 1, width do
      local left = map[y - 1][x - 1] or 0
      local right = map[y - 1][x + 1] or 0
      local middle = map[y - 1][x] or 0
      map[y][x] = simulate(left, right, middle)
    end
  end
  for x, val in ipairs(map[y]) do
    local pixel = Instance.new('WedgePart')
    pixel.Size = Vector3.one
    pixel.Position = Vector3.new(x - height / 2, y, 100)
    pixel.Anchored = true
    pixel.BrickColor = val == 1 and BrickColor.Red() or val == 2 and BrickColor.Green() or val == 3 and BrickColor.Blue() or BrickColor.White()
    pixel.Parent = script
    if x % 32 == 0 then
      wait()
    end
  end
end
