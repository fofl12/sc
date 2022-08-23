local branchAngle = math.rad(20)
local growspeed = 200
local sizeFactor = 0.8
local maxLayers = 6
local baseColor = Color3.fromRGB(114, 60, 30)
local debris = game:GetService('Debris')
local sunormal = game.Lighting:GetSunDirection()

function tree(position, color)
	local leafColor = color and BrickColor.Random().Color:Lerp(color, math.random(0.3, 0.7)) or BrickColor.Random().Color
	local appleColor = BrickColor.Red().Color:Lerp(leafColor, math.random(0.1, 0.5))

	local base = Instance.new('SpawnLocation')
	base.Enabled = false
	base.Color = baseColor
	base.Size = Vector3.new(1, 4, 1)
	base.Material = 'Wood'
	base.Position = position + Vector3.new(0, 2)
	base.Anchored = true
	base.Parent = script

	local branches = {base}

	function recurse(obranch, layer)
		task.wait(layer/60)
		if layer > maxLayers then
			return
		end
		local baseSiz = obranch.Size
		local baseCf = obranch.CFrame

		local branch = base:Clone()
		branch.Color = baseColor:lerp(leafColor, layer / maxLayers)
		branch.Size = Vector3.new(baseSiz.X, baseSiz.Y * sizeFactor, baseSiz.Z * sizeFactor)

		local branch1 = branch:Clone()
		branch1.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, branch.Size.Z) * CFrame.Angles(branchAngle, 0, 0))
		branch1.Parent = script
		table.insert(branches, branch1)
		task.spawn(recurse, branch1, layer + 1)

		local branch2 = branch:Clone()
		branch2.CFrame = baseCf * (CFrame.new(0, branch.Size.Y, -branch.Size.Z) * CFrame.Angles(-branchAngle, 0, 0))
		branch2.Parent = script
		table.insert(branches, branch2)
		recurse(branch2, layer + 1)
	end

	recurse(base, 1)

	while true do
		task.wait(math.random(30, 60) / growspeed)
		if #branches < 1 then
			break
		end
		local id = math.random(1, #branches)
		local branch = branches[id]
		local food = Instance.new('Part')
		food.Name = 'Food'
		food.Color = appleColor
		food.Size = Vector3.one
		food.Position = branch.Position
		food.Anchored = true
		food.Parent = workspace
		task.delay(math.random(10, 40) / growspeed, function()
			food.Anchored = false
			food.Position += Vector3.new(math.random(-25, 25), math.random(-10, 10), math.random(-25, 25))
			food:SetAttribute('isFood', true)
			table.remove(branches, id)
			branch:Destroy()
			for i = 1, 10 do
				if #branches > 0 then
					branches[math.random(1, #branches)]:Destroy()
				end
			end
			if math.random() < 0.04 then
				food.Color = leafColor
				task.delay(math.random(75, 120) / growspeed, function()
					local ray = workspace:Raycast(food.Position, sunormal * 50)
					if (not ray) or (ray and math.random() < 0.1) then
						tree(food.Position, leafColor)
					end
					food:Destroy()
				end)
			end
			debris:AddItem(food, 240 / growspeed)
		end)
	end
end

tree(Vector3.new(owner.Character.Head.Position.X, 0, owner.Character.Head.Position.Z))