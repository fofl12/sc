local hint = Instance.new('Hint', script)
hint.Text = 'The cash leaderboard is as follows:'

while task.wait(1) do
	local out = 'The cash leaderboard is as follows:\n'
	for _, p in next, game:service'Players':GetPlayers() do
		if p:GetAttribute('cash') then
			out ..= p.Name .. ' : ' .. p:GetAttribute'cash' .. '\n'
		end
	end
	hint.Text = out
end