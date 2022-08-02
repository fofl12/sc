owner.Chatted:Connect(function(m)
	local date = DateTime.now():FormatUniversalTime("LLL", "en-us")
	local tool = Instance.new('Tool')
	tool.ToolTip = ("%s\nMessage from %s - %s"):format(m, owner.Name, date)
	tool.TextureId = 'rbxthumb://type=AvatarHeadShot&id=' .. owner.UserId .. '&w=150&h=150'
	local handle = Instance.new('WedgePart')
	handle.Name = 'Handle'
	local decal = Instance.new('Decal', handle)
	decal.Face = 'Top'
	decal.Texture = 'rbxassetid://137708370'
	handle.Parent = tool
	tool.Parent = owner.Backpack
end)
