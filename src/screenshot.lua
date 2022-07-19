local brick = Instance.new('Part')
brick.Position = owner.Character.Torso.Position
brick.Size = Vector3.one * 4
brick.Anchored = true
brick.Parent = script

local i = Instance.new('ProximityPrompt', brick)
i.ActionText = 'SCRENSHOT'
i.ObjectText = 'Imagedevice (accept NLS for it to work)'

local mesh = Instance.new('FileMesh', brick)
mesh.MeshId = 'rbxassetid://515752158'
mesh.TextureId = 'rbxassetid://515752160'
mesh.Scale = Vector3.new(0.03, 0.05, 0.05)

i.Triggered:Connect(function(p)
	NLS([[
		local sh = game:GetService('GuiService'):FindFirstChild('ScreenshotHud')
		assert(sh, 'ScreenshotHud is disabled! Please try again after the flag has been enabled')
		sh.OverlayFont = Enum.Font.SourceSansBold
		sh.ExperienceNameOverlayEnabled = true
		sh.UsernameOverlayEnabled = false
		sh.CloseWhenScreenshotTaken = false
		sh.Visible = true
		print('ScreenshotHud is now visible')
	]], p.PlayerGui)
end)