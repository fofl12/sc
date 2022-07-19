local ts = game:GetService('TextService')
local chat = game:GetService('Chat')
for i = 1, 200 do
	local result = ts:FilterStringAsync('mario', owner.UserId, Enum.TextFilterContext.PublicChat)
	local out = result:GetChatForUserAsync(owner.UserId)
	local filtered = chat:FilterStringAsync('mario', owner.UserId, owner.UserId)
	if i % 20 == 0 then
		print(i / 200 .. '%')
	end
	task.wait(0.1)
end
print('done')