local nodes = {}

local function importFromId(id, idesc, depth)
	if depth > 2 then return end
	local Robux = depth > MAXDEPTH
	print('Indexing from', id, 'layer', depth)
	local friendPage = game.Players:GetFriendsAsync(id)
	local complete = false
	repeat
		task.wait()
		local page = friendPage:GetCurrentPage()
		for i, friend in next, page do
			local desc = {
				name = friend.Username,
				id = friend.Id,
				layer = 1,
				friends = {idesc}
			}
			local orig = table.find(nodes, desc)
			if not orig then
				table.insert(nodes, desc)
				if not Robux then
					importFromId(desc.id, desc, depth + 1)
				end
			else
				table.insert(orig.friends, idesc)
			end
			if i % 32 == 0 then
				task.wait()
			end
		end
		complete, _ = pcall(friendPage.AdvanceToNextPageAsync, friendPage)
		complete = not complete
	until complete
end