local branchAngle = math.rad(20)
local growspeed = 10
local sizeFactor = 0.8
local maxLayers = 8
local offset = owner.Character.Head.Position - Vector3.new(0, 2)
local baseColor = Color3.fromRGB(114, 60, 30)
local leafColor = BrickColor.Random().Color
local appleColor = BrickColor.Red().Color:Lerp(leafColor, math.random(0.1, 0.5))

local base = Instance.new('SpawnLocation')
base.Enabled = false
base.Color = baseColor
base.Size = Vector3.new(1, 4, 1)
base.Material = 'Wood'
base.Position = offset
base.Anchored = true
base.CanCollide = false
base.Parent = script

local branches = {base}

function recurse(baseCf, baseSiz, layer)
	task.wait(1/60 * layer)
	if layer > maxLayers then
		return
	end
	local branch = base:Clone()
	branch.Color = baseColor:lerp(leafColor, layer / maxLayers)
	branch.Size = Vector3.new(baseSiz.X, baseSiz.Y * sizeFactor, baseSiz.Z * sizeFactor)

	local branch1 = branch:Clone()
	branch1.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, branch.Size.Z) * CFrame.Angles(branchAngle, 0, 0))
	branch1.Parent = script
	table.insert(branches, branch1)
	task.spawn(recurse, branch1.CFrame, branch1.Size, layer + 1)

	local branch2 = branch:Clone()
	branch2.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, -branch.Size.Z) * CFrame.Angles(-branchAngle, 0, 0))
	branch2.Parent = script
	table.insert(branches, branch2)
	recurse(branch2.CFrame, branch2.Size, layer + 1)
end

recurse(base.CFrame, base.Size, 1)

while true do
	task.wait(math.random(30, 60) / growspeed)
	if #branches < 1 then
		break
	end
	local id = math.random(1, #branches)
	local branch = branches[id]
	local food = Instance.new('Part')
	food.Name = 'Food'
	food.BrickColor = BrickColor.Red()
	food.Size = Vector3.one
	food.Position = branch.Position
	food.Anchored = true
	food.Parent = script
	task.delay(math.random(10, 40) / growspeed, function()
		food.Anchored = false
		food:SetAttribute('isFood', true)
		if math.random() < 0.1 then
			table.remove(branches, id)
			branch:Destroy()
		end
	end)
end