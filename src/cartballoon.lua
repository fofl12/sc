local function cartballoongen()
local function cartgen()
	local model = Instance.new('Model')

	local hum = Instance.new('Humanoid', model)
	hum.MaxHealth = 400
	hum.DisplayName = 'Taxi'

	local alert = false
	local crashed = false

	local base = Instance.new('SpawnLocation', model)
	base.Enabled = false
	base.Size = Vector3.new(6, 1, 6)
	base.Position = Vector3.new()
	base.BrickColor = BrickColor.Random()
	base.Material = 'WoodPlanks'

	task.spawn(function()
		while task.wait() do
			if alert then
				hum.Health = math.floor(os.clock() * 10) % 2 == 0 and hum.MaxHealth - 1 or 0
			else
				hum.Health = base.Position.Y
			end
	
			
			if base.Velocity.Magnitude < 40 and base.Position.Y < 5 and not crashed then
				alert = false
				hum.DisplayName = 'Taxi'
			elseif base.Velocity.Magnitude > 40 and base.Position.Y < 5 then
				alert = false
				hum.DisplayName = 'Takeoff/Landing'
			elseif base.Velocity.Y > 5 and base.Position.Y < 50 then
				alert = false
				hum.DisplayName = 'Ascending'
			elseif crashed or (base.Velocity.Y < -100 and base.Position.Y < 10) then
				if not crashed then
					local x = Instance.new('Explosion')
					x.Position = base.Position
					x.Parent = base
				end
				alert = true
				hum.DisplayName = 'ALERT\nCrash landing'
				model.Head.Anchored = true
				crashed = true
				model:BreakJoints()
			elseif base.Velocity.Y < -10 and base.Position.Y < math.abs(base.Velocity.Y) * 3 then
				alert = true
				hum.DisplayName = 'ALERT\n!!! Pull Up !!!'
			else
				alert = false
				hum.DisplayName = 'Velocity: ' .. math.floor(base.Velocity.Magnitude)
			end
		end
	end)

	local wall1 = Instance.new('SpawnLocation', model)
	wall1.Enabled = false
	wall1.BrickColor = BrickColor.Random()
	wall1.Material = 'WoodPlanks'
	wall1.Size = Vector3.new(1, 4, 6)
	wall1.Position = Vector3.new(2.5, -2, 0)
	
	local wall2 = wall1:Clone()
	wall2.Position = Vector3.new(-2.5, -2, 0)
	wall2.Parent = model

	local wall3 = wall1:Clone()
	wall3.Size = Vector3.new(6, 4, 1)
	wall3.Position = Vector3.new(0, -2, 2.5)
	wall3.Parent = model

	local wall4 = wall3:Clone()
	wall4.Position = Vector3.new(0, -2, -2.5)
	wall4.Parent = model

	local roof = base:Clone()
	roof.Transparency = 0.9
	roof.CanCollide = false
	roof.Name = 'Head'
	roof.CastShadow = false
	roof.Position = Vector3.new(0, 6, 0)
	roof.Parent = model

	local weld1 = Instance.new('Weld', model)
	weld1.Part0 = base
	weld1.Part1 = wall1
	weld1.C0 = base.CFrame - wall1.Position

	local weld2 = Instance.new('Weld', model)
	weld2.Part0 = base
	weld2.Part1 = wall2
	weld2.C0 = base.CFrame - wall2.Position
	
	local weld3 = Instance.new('Weld', model)
	weld3.Part0 = base
	weld3.Part1 = wall3
	weld3.C0 = base.CFrame - wall3.Position

	local weld4 = Instance.new('Weld', model)
	weld4.Part0 = base
	weld4.Part1 = wall4
	weld4.C0 = base.CFrame - wall4.Position

	local weld5 = Instance.new('Weld', model)
	weld5.Part0 = base
	weld5.Part1 = roof
	weld5.C0 = base.CFrame + roof.Position

	base.CFrame = owner.Character.Head.CFrame
	roof.CFrame = base.CFrame + Vector3.new(0, 0, 0)
	model.Parent = script

	local roofClicker = Instance.new('ClickDetector', roof)
	roofClicker.MouseClick:Connect(function()
		if roof.CanCollide then
			roof.Transparency = 0.9
			roof.CanCollide = false
		else
			roof.Transparency = 0.5
			roof.CanCollide = true
		end
	end)

	return model
end

local cart = cartgen()

for i = 1, _G.bcount or 4 do
	local a0 = Instance.new('Attachment', cart.Head)

	local balloon = Instance.new('Part')
	balloon.Size = Vector3.one * 3
	balloon.Color = Color3.new(1)
	balloon.Shape = 'Ball'
	balloon.Position = cart.Head.Position + Vector3.yAxis
	balloon.Parent = cart
	local velocity = Instance.new('BodyVelocity')
	velocity.Velocity = Vector3.new(0, 50)
	velocity.MaxForce = Vector3.new(0, 4500)
	velocity.Parent = balloon
	local a1 = Instance.new('Attachment', balloon)

	local rope = Instance.new('RopeConstraint')
	rope.Attachment0 = a0
	rope.Attachment1 = a1
	rope.Length = 7.5
	rope.Visible = true
	rope.Parent = cart
end
end

local tool = Instance.new('Tool')
tool.Name = 'Cartballoongen'

local handle = Instance.new('Part', tool)
handle.Size = Vector3.one
handle.Material = 'DiamondPlate'
handle.BrickColor = BrickColor.Random()
handle.Name = 'Handle'

tool.Activated:Connect(cartballoongen)

tool.Parent = owner.Backpack