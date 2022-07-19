
local cartgen = Instance.new('Tool', owner.Backpack)
cartgen.Name = 'Cartgen'
local handle = Instance.new('Part', cartgen)
handle.Name = 'Handle'
handle.Material = 'WoodPlanks'
handle.Size = Vector3.one

cartgen.Activated:Connect(function()
	handle.BrickColor = BrickColor.Random()
	local model = Instance.new('Model')

	local base = Instance.new('Part', model)
	base.Size = Vector3.new(6, 1, 6)
	base.Position = Vector3.new()
	base.BrickColor = BrickColor.Random()
	base.Material = 'WoodPlanks'

	local wall1 = Instance.new('Part', model)
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
	roof.CFrame = base.CFrame
	model.Parent = workspace

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
end)