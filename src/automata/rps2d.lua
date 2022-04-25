local map = {{}}
local workingBuffer = {{}}
local width = 50
local height = 50
for _ = 1, 50 do
  local y = math.random(1, height)
  local x = math.random(1, width)
  local val = math.clamp(math.random(-5, 3), 0, 3)
  if not map[y] then
    map[y] = {}
  end
  map[y][x] = val
end

local function simulate(left, right, up, down)
  if left == right and right == up and up == down then
    return left
  end
  do
    local n = 0
    local ok = true
    for _, x in next, {left, right, up, down} do
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
    for _, x in next, {left, right, up, down} do
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

while true do
  task.wait(1/2)
  for y = 1, height do
    local uplist = map[y + 1] or table.create(width, 0)
    local downList = map[y - 1] or table.create(width, 0)
    local midList = map[y] or table.create(width, 0)
    workingBuffer[y] = {}
    for x = 1, width do
      local left = midList[x - 1] or 0
      local right = midList[x + 1] or 0
      local up = uplist[x] or 0
      local down = downList[x] or 0
      if left == 0 and right == 0 and up == 0 and down == 0 and midList[x] ~= 0 then
        workingBuffer[y][x] = map[y][x]
      else
        workingBuffer[y][x] = simulate(left, right, up, down)
      end
    end
  end
  map = workingBuffer
  workingBuffer = {{}}
  script:ClearAllChildren()
  for y, xlist in ipairs(map) do
    task.wait(1/20)
    for x, val in ipairs(xlist) do
      if val ~= 0 then
        local pixel = Instance.new('WedgePart')
        pixel.Size = Vector3.one
        pixel.Position = Vector3.new(x - height / 2, y, 100)
        pixel.Anchored = true
        pixel.BrickColor = val == 1 and BrickColor.Red() or val == 2 and BrickColor.Green() or val == 3 and BrickColor.Blue() or BrickColor.White()
        pixel.Parent = script
      end
    end
  end
end
