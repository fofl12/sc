local tool = Instance.new('Tool', owner.Backpack)
local handle = Instance.new('Part', tool)
handle.Name = 'Handle'
handle.Size = Vector3.new(1, 1, 2)
local light = Instance.new('SpotLight', handle)
light.Range = 60
light.Brightness = 1
tool.Activated:Connect(function()
	light.Enabled = not light.Enabled
end)
owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 'f%' then
		local command = m:sub(3, -1):split(' ')
		if command[1] == 'range' then
			light.Range = tonumber(command[2])
		elseif command[1] == 'brightness' then
			light.Brightness = tonumber(command[2])
		end
	end
end)