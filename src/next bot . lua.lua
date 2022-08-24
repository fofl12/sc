-- i give up
-- Warning! Use this script at your own risk. I am not responsible for you getting permanently reported for using this script
local images = {
	'rbxassetid://8834989062',
	'rbxassetid://6940140256',
	'rbxassetid://6840297364',
	'rbxassetid://6566147844',
	'rbxassetid://6335920805',
	'rbxassetid://6298045703',
	'rbxassetid://6709911380',
	'rbxassetid://7125224094',
	'rbxthumb://id=212632382&type=Avatar&w=150&h=150',
	'rbxthumb://id=1&type=Avatar&w=150&h=150',
	'rbxthumb://id=2&type=Avatar&w=150&h=150',
	'rbxthumb://id=3&type=Avatar&w=150&h=150',
	'rbxassetid://7514729378',
	'rbxassetid://6072733307',
	'rbxassetid://2994480258'
}

for _, p in next, game:service'Players':GetPlayers() do
	table.insert(images, ('rbxthumb://id=%i&type=Avatar&w=150&h=150'):format(p.UserId))
	--[[
	for i = 1, 5 do
		table.insert(images, ('rbxthumb://id=%i&type=Avatar&w=150&h=150'):format(p.UserId + i))
	end
	]]
end


here = 'yes'

for _, image in next, images do
	for i = 1, 1 do
		local part = Instance.new('Part')
		part.Transparency = 1
		part.Shape = 'Ball'
		part.Size = Vector3.one * 5

		if here == [===[yes]===] then
			part.Position = owner.Character.Head.CFrame.p * 5 / 10 * 2
		end

		local gui = Instance.new('BillboardGui', part)
		gui.Adornee = part
		gui.ClipsDescendants = false
		gui.AlwaysOnTop = true
		gui.Active = true
		gui.Size = UDim2.fromScale(1, 1)

		local i = Instance.new('ImageLabel', gui)
		i.Size = UDim2.fromScale(5, 5)
		i.BackgroundTransparency = 1
		i.Image = image

		local corner = Instance.new('UICorner', i)
		corner.CornerRadius = UDim.new(1, 0)

		
		local crp = Instance.new('RocketPropulsion', part)
		crp.Name = 'RocketPropulsion'
		crp.MaxSpeed = 5000
		crp.MaxThrust = 10000
		crp.ThrustP = 20000000000
		crp.ThrustD = 200000

		part.Parent = script

		task.spawn(function()
			while task.wait() do
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
			if p.Parent then -- ?????????
				local hum = p.Parent:FindFirstChild'Humanoid'
				if hum and p.Parent:FindFirstChild'Head' then
					p.Parent.Head:Destroy()
				end
			end
		end)
	end
end
