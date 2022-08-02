local p = Instance.new('RemoteEvent', owner.PlayerGui)
local players = game:GetService('Players')
NLS([[
local p = script.Parent
script.Parent = p.Parent
p.Parent = script

local event = game:FindFirstChild('SB_10', true)
p.OnClientEvent:Connect(function(m)
	task.wait(0.2)
	event:FireServer('t', 'SERVER')
end)
]], p)
for _, plr in next, players:GetPlayers() do
	plr.Chatted:Connect(function(m)
		if m:find('is quite') then
			p:FireClient(owner)
		end
	end)
end