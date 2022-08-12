local output
local con
con = owner.DescendantAdded:Connect(function(i)
	print(i.Name)
	if true then
		print('spoofing')
		output = i:Clone()
		output.Parent = owner
		con:Disconnect()
	end
end)