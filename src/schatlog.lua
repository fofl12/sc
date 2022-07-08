local onNewMessage = game.ReplicatedStorage.DefaultChatSystemChatEvents['1']

local function recurseLog(tbl, level)
	for k, v in next, tbl do
		if type(v) == 'table' then
			print(('> '):rep(level) .. k .. ': ')
			recurseLog(v, level + 1)
		else
			print(('> '):rep(level) .. k .. ': ' .. tostring(v))
		end
	end
end

onNewMessage.OnClientEvent:Connect(function(data, channel)
	print('Channel: ' .. channel)
	recurseLog(data, 0)
end)