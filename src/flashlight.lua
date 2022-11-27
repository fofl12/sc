local tool = Instance.new('Tool', owner.Backpack)
tool.Name = 'Flashlight'
local handle = Instance.new('Part', tool)
handle.Name = 'Handle'
handle.Size = Vector3.new(1, 1, 2)
handle.Transparency = 1
local selection = Instance.new('SelectionBox', handle)
selection.Adornee = handle
selection.LineThickness = 0.1
selection.Transparency = 0
local light = Instance.new('SpotLight', handle)
light.Range = 60
light.Brightness = 2
task.spawn(function()
	while task.wait() do
		selection.Color3 = Color3.fromHSV(os.clock() % 6 / 6, 1, light.Enabled and 0.9 or 0.3)
	end
end)
tool.Activated:Connect(function()
	light.Enabled = not light.Enabled
end)
local pain = false
owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 'f%' then
		local command = m:sub(3, -1):split(' ')
		if command[1] == 'range' then
			light.Range = tonumber(command[2])
		elseif command[1] == 'brightness' then
			light.Brightness = tonumber(command[2])
		elseif command[1] == 'angle' then
			light.Angle = tonumber(command[2])
		elseif command[1] == 'pain' then
			pain = command[2] == 'true'
			while task.wait(1/10) and pain do
				if not light.Enabled then continue end
				for r = 0, 2, 0.2 do
					for m = 0, 1, 0.1 do
						local dir = (handle.CFrame * CFrame.Angles(
							math.sin(math.rad(r * light.Angle)) * m,
							math.cos(math.rad(r * light.Angle)) * m,
							0
						)).LookVector
						local r = workspace:Raycast(handle.Position, dir * light.Range)
						if r and not r.Instance:IsDescendantOf(owner.Character) then
							local hum = r.Instance.Parent:FindFirstChild'Humanoid'
							if hum then hum:TakeDamage(light.Brightness / 2) end
						end
					end
				end
			end
		end
	end
end)