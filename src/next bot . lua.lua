-- i give up
local images = {
	'rbxassetid://8834989062',
	'rbxassetid://6940140256',
	'rbxassetid://6840297364',
	'rbxassetid://6566147844',
	'rbxassetid://6335920805'
}

for _, image in next, images do
	for i = 1, 1 do
		local part = Instance.new('Part')
		part.Transparency = 1
		part.Shape = 'Ball'
		part.Size = Vector3.one * 5

		local gui = Instance.new('BillboardGui', part)
		gui.Adornee = part
		gui.ClipsDescendants = false
		gui.AlwaysOnTop = true
		gui.Active = true
		gui.Size = UDim2.fromScale(1, 1)

		local i = Instance.new('ImageLabel', gui)
		i.Size = UDim2.fromScale(5, 5)
		i.Image = image

		
		local crp = Instance.new('RocketPropulsion', part)
		crp.Name = 'RocketPropulsion'
		crp.MaxSpeed = 5000
		crp.MaxThrust = 10000
		crp.ThrustP = 20000000000
		crp.ThrustD = 200000

		part.Parent = script

		task.spawn(function()
			while task.wait(1) do
				local min, target = math.huge
				for _, p in next, game:service'Players':GetPlayers() do
					if p.Character and p.Character:FindFirstChild'Head' then
						local dist = (part.Position - p.Character.Head.Position).Magnitude
						if dist <= min then
							min = dist
							target = p.Character.Head
						end
					end
				end
				crp.Target = target
				crp:Fire()
			end
		end)

		part.Touched:Connect(function(p)
			local hum = p.Parent:FindFirstChild'Humanoid'
			if hum and p.Parent:FindFirstChild'Head' then
				p.Parent.Head:Destroy()
			end
		end)
	end
end
