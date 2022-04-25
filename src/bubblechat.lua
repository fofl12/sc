-- Compiled with roblox-ts v1.2.9
-- Add bubblechat                                         //
local chat = game:GetService("Chat")
chat.BubbleChatEnabled = true
local function bubblechat(player)
	player.Chatted:Connect(function(message)
		if player.Character then
			local filtered = chat:FilterStringForBroadcast(message, player)
			if (string.match(message, "/[etw]")) == nil then
				chat:Chat(player.Character, filtered)
			end
		end
	end)
end
local players = game:GetService("Players")
local _exp = players:GetPlayers()
local _arg0 = function(player)
	bubblechat(player)
end
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	_arg0(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
players.PlayerAdded:Connect(bubblechat)
return nil
