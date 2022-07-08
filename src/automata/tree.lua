local branchAngle = math.rad(20)
local sizeFactor = 0.8
local maxLayers = 8
local offset = owner.Character.Head.Position
local baseColor = Color3.fromRGB(114, 60, 30)
local leafColor = Color3.fromRGB(105, 183, 49)

local base = Instance.new('SpawnLocation')
base.Enabled = false
base.Color = baseColor
base.Size = Vector3.new(1, 4, 1)
base.Material = 'Wood'
base.Position = offset
base.Anchored = true
base.CanCollide = false
base.Parent = script

function recurse(baseCf, baseSiz, layer)
	task.wait(1/60 * layer)
	if layer > maxLayers then return end
	local branch = base:Clone()
	branch.Color = baseColor:lerp(leafColor, layer / maxLayers)
	branch.Size = Vector3.new(baseSiz.X, baseSiz.Y * sizeFactor, baseSiz.Z * sizeFactor)

	local branch1 = branch:Clone()
	branch1.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, branch.Size.Z) * CFrame.Angles(branchAngle, 0, 0))
	branch1.Parent = script
	task.spawn(recurse, branch1.CFrame, branch1.Size, layer + 1)

	local branch2 = branch:Clone()
	branch2.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, -branch.Size.Z) * CFrame.Angles(-branchAngle, 0, 0))
	branch2.Parent = script
	recurse(branch2.CFrame, branch2.Size, layer + 1)
end

recurse(base.CFrame, base.Size, 1)