
local cartgen = Instance.new('Tool', owner.Backpack)
cartgen.Name = 'Cartgen'
local handle = Instance.new('Part', cartgen)
handle.Name = 'Handle'
handle.Material = 'WoodPlanks'
handle.Size = Vector3.one

cartgen.Activated:Connect(function()
	

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