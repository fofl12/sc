local size = workspace.Base.Size

local gui = Instance.new('SurfaceGui', workspace.Base)
gui.Face = 'Top'
gui.SizingMode = 1

local label = Instance.new('TextBox', gui)
label.Size = UDim2.fromOffset(500, 500)
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.BackgroundTransparency = 1
label.TextStrokeTransparency = 0
label.Text = 'text'
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true

owner.Chatted:Connect(function(m)
	print'ok'
	label.Text = m
end)

while true do
	task.wait()
	if owner.Character and owner.Character:FindFirstChild('Torso') then
		local target = owner.Character.Torso.Position + size / 2
		label.Position = UDim2.fromScale(
			1 - (target.Z / size.Z),
			target.X / size.X
		)
		label.Rotation = -owner.Character.Torso.Orientation.Y + 90
	end
end
