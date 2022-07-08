local ppd = 1
local maxdist = 30
local scale = 0.2
local voxelscale = Vector3.one * 0.1

local tool = Instance.new('Tool')
tool.Name = 'LIDAR Device'
tool.TextureId = 'rbxassetid://725416435'
tool.ToolTip = 'beep boop'
local handle
do
	handle = Instance.new('Part')
	handle.Name = 'Handle'
	handle.Size = Vector3.one
	handle.Anchored = false
	handle.CanCollide = false
	handle.Parent = tool
	local mesh = Instance.new('FileMesh')
	mesh.MeshId = 'rbxassetid://515752158'
	mesh.TextureId = 'rbxassetid://515752160'
	mesh.Scale = Vector3.one * 0.02
	mesh.Parent = handle
	tool.Parent = owner.Backpack
end
local remote = Instance.new('RemoteEvent')
remote.Name = 'RemoteLinker'
remote.Parent = tool
NLS([[
local remote = script.Parent:WaitForChild('RemoteLinker')
script.Parent.Activated:Connect(function()
	remote:FireServer()
end)
]], tool)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances = {owner.Character}

local function cast(origin, dir)
	return workspace:Raycast(origin, dir * maxdist, params)
end

remote.OnServerEvent:Connect(function()
	print('Starting')
	handle.Anchored = true
	local offset = owner.Character.Head.Position
	local point = Instance.new('WedgePart')
	point.Size = voxelscale
	point.Anchored = true
	point.CanCollide = true
	
	print('Firing rays')
	local points = {}
	for y = 0, 180, 1 / ppd do
		print('Row ' .. y)
		task.wait()
		for x = -180, 180, 1 / ppd do
			local cf = handle.CFrame * CFrame.Angles(math.rad(y), math.rad(-x), 0)
			local ray = cast(cf.p, cf.LookVector)
			if ray and ray.Distance < maxdist then
				table.insert(points, ray)
			end
			if x % 32 == 0 then
				task.wait()
			end
		end
	end
	handle.Anchored = false
	task.wait()
	print('Rendering')
	for i, ray in ipairs(points) do
		local point = point:Clone()
		point.Position = ((ray.Position - offset) * scale) + offset
		point.Color = ray.Instance.Color
		point.Material = ray.Material
		point.Parent = script
		if i % 32 == 0 then
			task.wait(1/30)
		end
	end
	print('Done')
end)

local prevcommand
owner.Chatted:Connect(function(c)
	if c == '%^' then
		c = prevcommand
	else
		prevcommand = c
	end
	if c == '%discard' then
		script:ClearAllChildren()
	elseif c:sub(1, 5) == '%conf' then
		local command = c:split(' ')
		if command[2] == 'ppd' then
			ppd = tonumber(command[3])
		elseif command[2] == 'maxdist' then
			maxdist = tonumber(command[3])
		elseif command[2] == 'scale' then
			scale = 1 / tonumber(command[3])
		elseif command[2] == 'voxelscale' then
			voxelscale = Vector3.one * (1 / command[3])
		end
	end
end)
