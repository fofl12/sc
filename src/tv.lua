local tv = Instance.new('Part', script)
tv.Anchored = true
tv.Position = owner.Character.Head.Position

local gui = Instance.new('SurfaceGui', tv)
gui.SizingMode = 'PixelsPerStud'
gui.PixelsPerStud = 100

local function randomString()
	local o = ''
	for _ = 1, math.random(3, 10) do
		o ..= string.char(math.random(33, 123))
	end
	return o
end

local frames = {
	function() -- calibration
		local textLabel = Instance.new('TextBox')
		textLabel.Text = 'Calibration'
		textLabel.TextScaled = true
		textLabel.Size = UDim2.fromOffset(800, 600)
		textLabel.BackgroundColor3 = Color3.new()
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.Parent = gui
	end,
	function()
		local bg = Instance.new('Frame', gui)
		bg.BackgroundColor3 = Color3.new()
		bg.Size = UDim2.fromScale(1, 1)
		bg.ZIndex = -1
		local frog = Instance.new('TextBox', gui)
		frog.Text = '🐸'
		frog.Size = UDim2.fromScale(0.1, 0.1)
		frog.TextScaled = true
		frog.BackgroundTransparency = 1

		local dx = 0.006
		local dy = 0.004
		while true do
			frog.Position += UDim2.fromScale(dx, dy)
			if frog.Position.X.Scale > 0.9 or frog.Position.X.Scale < 0 then
				dx = -dx
			end
			if frog.Position.Y.Scale > 0.9 or frog.Position.Y.Scale < 0 then
				dy = -dy
			end
			task.wait(1/30)
		end
	end,
	function()
		local bg = Instance.new('Frame', gui)
		bg.BackgroundColor3 = Color3.new()
		bg.Size = UDim2.fromScale(1, 1)
		bg.ZIndex = -1
		local among = Instance.new('ImageLabel', gui)
		among.ImageId = 'rbxassetid://7037955394'
		among.Size = UDim2.fromScale(0.1, 0.1)
		among.BackgroundTransparency = 1

		while true do
			among.Size = UDim2.fromScale(math.random(0.1, 1), math.random(0.1, 1))
			task.wait(1/10)
		end
	end
}

local channel = 1
frames[1]()

local remote = Instance.new('Tool', owner.Backpack)
remote.Name = 'Remote'
do
	local handle = Instance.new('Part')
	handle.Name = 'Handle'
	handle.Size = Vector3.one
	handle.Parent = remote
end
remote.Activated:Connect(function()
	channel = (channel % #frames) + 1
	gui:ClearAllChildren()
	frames[channel]()
end)