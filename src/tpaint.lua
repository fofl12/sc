local terrain = workspace.Terrain

local material = Enum.Material.Air
local width = 10
local active = true
owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 't%' then
		local command = m:sub(3, -1):split(' ')
		if command[1] == 'mat' then
			material = Enum.Material[command[2]]
		elseif command[2] == 'width' then
			width = tonumber(command[2])
		elseif command[2] == 'active' then
			active = command[3] == 'true'
		end
	end
end)

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local mouse = owner:GetMouse()

mouse.Button1Down:Connect(function()
	remote:FireServer(mouse.Hit.p)
end)
]], remote)
remote.OnServerEvent:Connect(function(_, p)
	if active then
		terrain:FillBall(p, width, material)
	end
end)