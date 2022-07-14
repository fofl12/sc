local offset = owner.Character.Head.Position
local robucgks = 0
local dropperPrice = 60
local filterPrice = 100
local filterStage = 0

-- Generator conveyer
local conveyer1 = Instance.new('Part')
conveyer1.Position = offset + Vector3.new(5, -3, 0)
conveyer1.Size = Vector3.new(5, 2, 20)
conveyer1.Anchored = true
conveyer1.BrickColor = BrickColor.new(29)
conveyer1.Velocity = Vector3.new(0, 0, -6)
conveyer1.Parent = script

-- Filter conveyer
local conveyer2 = conveyer1:Clone()
conveyer2.Position = offset + Vector3.new(-3, -3, -12)
conveyer2.Size = Vector3.new(20, 2, 5)
conveyer2.Velocity = Vector3.new(-6, 0, 0)
conveyer2.Parent = script

-- Droppers
local droppers = {}
local dropper = Instance.new('Part')
dropper.Position = offset + Vector3.new(8, -2, 8)
dropper.Size = Vector3.new(2, 4, 2)
dropper.Anchored = true
dropper.Parent = script
table.insert(droppers, dropper)
task.spawn(function()
  while true do
    task.wait(5)
    for _, dropper in next, droppers do
      local brik = Instance.new('Part')
      brik.Name = 'Brik'
      brik.Size = Vector3.new(2,2,2)
      brik.Position = dropper.Position - Vector3.new(3, -3)
      brik.Parent = dropper
    end
  end
end)
local function newDropper()
  if robucgks - dropperPrice >= 0 then
    robucgks -= dropperPrice
    local dropper = dropper:Clone()
    dropper.Position -= Vector3.new(0, 0, #droppers * 5)
    dropper.Parent = script
    table.insert(droppers, dropper)
    dropperPrice *= 1.2
  end
end

-- Filters
local filter1 = Instance.new('Part')
filter1.Position = conveyer2.Position + Vector3.new(-2, 1)
filter1.Size = Vector3.new(1, 4, 4)
filter1.Transparency = 1
filter1.CanCollide = false
filter1.Anchored = true
filter1.Parent = script
filter1.Touched:Connect(function(p)
  if p ~= conveyer2 and filterStage >= 1 then
    p.BrickColor = BrickColor.random()
  end
end)
local filter2 = Instance.new('Part')
filter2.Position = conveyer2.Position + Vector3.new(0, 1)
filter2.Size = Vector3.new(1, 4, 4)
filter2.Transparency = 1
filter2.CanCollide = false
filter2.Anchored = true
filter2.Parent = script
filter2.Touched:Connect(function(p)
  if p ~= conveyer2 and filterStage >= 2 then
    if math.random() > 0.35 then
      p.Shape = Enum.PartType.Ball
    end
  end
end)
local filter3 = Instance.new('Part')
filter3.Position = conveyer2.Position + Vector3.new(2, 1)
filter3.Size = Vector3.new(1, 4, 4)
filter3.Transparency = 1
filter3.CanCollide = false
filter3.Anchored = true
filter3.Parent = script
filter3.Touched:Connect(function(p)
  if p ~= conveyer2 and filterStage >= 3 and not p:GetAttribute('sized') then
    p.Size *= math.random() * 3
    p:SetAttribute('sized', true)
  end
end)

-- Salerman
local grup = Instance.new'Model'
local hum = Instance.new('Humanoid', grup)
hum.DisplayName = 'ROBUCGKS!!!!!!!!!'
local saler = Instance.new('Part')
saler.Name = 'Head'
saler.Anchored = true
saler.Transparency = 0.5
saler.Position = conveyer2.Position + Vector3.new(-12, 0, 0)
saler.Size = Vector3.new(5, 1, 5)
saler.Parent = grup
local clicker = Instance.new('ClickDetector', saler)
grup.Parent = script

saler.Touched:Connect(function(p)
  if p ~= convsseyer2 then
    local val = 0
    val += p.Shape ~= Enum.PartType.Block and 3 or 1
    val += (p.BrickColor.r * math.random()) * 2
    val += (p.BrickColor.g * math.random()) * 2
    val += (p.BrickColor.r * math.random()) * 2
    val += (p.Size.Magnitude / 2) * 3
    robucgks += val
    p:Destroy()
    hum.DisplayName = 'ROBUCGKS: ' .. robucgks .. '\nDropper RED pric: ' .. dropperPrice .. '   Filter BLUE pric: ' .. filterPrice
  end
end)

local dropperBuy = Instance.new('Part')
dropperBuy.Anchored = true
dropperBuy.Size = Vector3.one
dropperBuy.BrickColor = BrickColor.Red()
dropperBuy.Position = owner.Character.Head.Position + Vector3.new(0, 0, 10)
local dropperBuyCliker = Instance.new('ClickDetector', dropperBuy)
dropperBuyCliker.MouseClick:Connect(newDropper)
dropperBuy.Parent = script

local filterBuy = Instance.new('Part')
filterBuy.Anchored = true
filterBuy.Size = Vector3.one
filterBuy.BrickColor = BrickColor.Blue()
filterBuy.Position = owner.Character.Head.Position + Vector3.new(-2, 0, 10)
local filterBuyClicker = Instance.new('ClickDetector', filterBuy)
filterBuyClicker.MouseClick:Connect(function()
  if robucgks - filterPrice >= 0 then
    robucgks -= filterPrice
    filterStage += 1
    filterPrice *= 1.5
    if filterStage == 1 then
      filter1.Transparency = 0.5
    elseif filterStage == 2 then
      filter2.Transparency = 0.5
    elseif filterStage == 3 then
      filter3.Transparency = 0.5
    end
  end
end)
filterBuy.Parent = script
