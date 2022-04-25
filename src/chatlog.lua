-- Compiled with roblox-ts v1.2.9
-- Log the chat to output                                 //
local players = game:GetService("Players")
local function log(player)
	local username = player.Name
	player.Chatted:Connect(function(message)
		print("@" .. username .. ">", message)
	end)
end
local _exp = players:GetPlayers()
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	log(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
players.PlayerAdded:Connect(log)
return nil
