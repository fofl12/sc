function recurse(object, layer)
	for _, object in next, object:GetChildren() do
		print(string.rep('>', layer), object.Name, object.ClassName)
		recurse(object, layer + 1)
	end
end

recurse(game.ReplicatedStorage.DefaultChatSystemChatEvents, 0)