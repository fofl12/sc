local offset = owner.Character.Head.Position
local USAFWPTEG = 180 / math.pi

local bg = Instance.new('Part')
bg.Color = Color3.new()
bg.Material = 'Neon'
bg.Size = Vector3.new(4, 4, 0.05)
bg.Position = offset
bg.Anchored = true
bg.CanCollide = false

local baseVector = Instance.new('Part')
baseVector.Material = 'Neon'
baseVector.CanCollide = false
baseVector.Anchored = true

bg.Parent = script

local vectors = {}
local nextVector = 1
local pointsPerStud = 100
local fps = 30
local inputs = {
	[1] = false, -- left
	[2] = false, -- right
	[3] = false, -- up
	[4] = false, -- down
	[5] = false, -- a
	[6] = false  -- b
}

local palette = {
	[0] = Color3.new(), -- black
	[1] = Color3.new(1, 1, 1), -- white
	[2] = Color3.new(0.3, 0.3, 0.3), -- grey
	[3] = Color3.new(1, 0, 0), -- red
	[4] = Color3.new(0, 1, 0), -- green
	[5] = Color3.new(0, 0, 1), -- blue
	[6] = Color3.new(1, 1, 0), -- yellow
	[7] = Color3.new(0, 1, 1) -- cyan
}
local vng = {
	conf = {
		fps = function(new)
			fps = new
		end,
		setPointsPerStud = function(num)
			pointsPerStud = num
		end,
	},
	allocateVectors = function(request)
		for _ = 1, request do
			table.insert(vectors, baseVector:Clone())
		end
	end,
	clear = function(keep)
		if not keep then
			for _, vector in next, vectors do
				vector.Parent = nil
			end
		end
		nextVector = 1
	end,
	input = function(i)
		return inputs[i]
	end,
	line = function(c1, c2, color)
		local color = palette[color] or palette[1]
		local c1 = Vector3.new(
			(c1[1] / pointsPerStud) - (bg.Size.X / 2),
			-((c1[2] / pointsPerStud) - (bg.Size.Y / 2)),
		0.05)
		local c2 = Vector3.new(
			(c2[1] / pointsPerStud) - (bg.Size.X / 2),
			-((c2[2] / pointsPerStud) - (bg.Size.Y / 2)),
		0.05)
		local c = c1 - c2

		assert(vectors[nextVector], 'Insufficient vectors required for `line` operation!')
		local vector = vectors[nextVector]
		nextVector += 1
		vector.Orientation = Vector3.new(0, 0, math.deg(math.atan2(c.Y, c.X)))
		vector.Position = c1:lerp(c2, 0.5) + offset
		vector.Size = Vector3.new(c.Magnitude, 0.05, 0.05)
		vector.Color = color
		vector.Parent = bg
		
		return {
			setPoint1 = function(c1)
				c1 = Vector3.new(
					(c1[1] / pointsPerStud) - (bg.Size.X / 2),
					-((c1[2] / pointsPerStud) - (bg.Size.Y / 2)),
				0.05)
				c = c1 - c2

				vector.Orientation = Vector3.new(0, 0, math.deg(math.atan2(c.Y, c.X)))
				vector.Position = c1:lerp(c2, 0.5) + offset
				vector.Size = Vector3.new(c.Magnitude, 0.05, 0.05)
			end,
			setPoint2 = function(c2)
				c2 = Vector3.new(
					(c2[1] / pointsPerStud) - (bg.Size.X / 2),
					-((c2[2] / pointsPerStud) - (bg.Size.Y / 2)),
				0.05)
				c = c1 - c2
				
				vector.Orientation = Vector3.new(0, 0, math.deg(math.atan2(c.Y, c.X)))
				vector.Position = c1:lerp(c2, 0.5) + offset
				vector.Size = Vector3.new(c.Magnitude, 0.05, 0.05)
			end,
			setColor = function(color)
				vector.Color = palette[color]
			end
		}
	end
}

local loadedHandle = nil
local function run(code)
	if loadedHandle then
		loadedHandle.kill()
	end
	for i, _ in next, vectors do
		table.remove(vectors, i)
	end

	local loaded = loadstring(code)
	setfenv(loaded, {
		vng = vng,
		print = print,
		warn = warn,
		error = error,
		assert = assert,
		math = math,
		os = os,
		wait = task.wait,
		next = next
	})
	local update = loaded()
	if update then
		local active = true
		
		loadedHandle = {
			kill = function()
				active = false
			end
		}
		
		while active do
			task.wait(1 / fps)
			update()
		end
	end
end

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(400, 300)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)

local button = Instance.new('TextButton')
button.Text = 'Push'
button.Size = UDim2.fromOffset(64, 16)
button.Parent = frame

local capture = Instance.new('TextBox')
capture.Text = ''
capture.PlaceholderText = 'Input'
capture.Size = button.Size
capture.Position = UDim2.fromOffset(64, 0)
capture.Parent = frame

local scroller = Instance.new('ScrollingFrame')
scroller.Position = UDim2.fromOffset(0, 16)
scroller.Size = UDim2.fromOffset(400, 284)
scroller.Parent = frame

local box = Instance.new('TextBox')
box.Font = 'Code'
box.TextXAlignment = 'Left'
box.TextYAlignment = 'Top'
box.Text = ''
box.TextWrap = true
box.TextSize = 10
box.MultiLine = true
box.Size = UDim2.fromScale(1, 1)
box.ClearTextOnFocus = false
box.Parent = scroller

local name = Instance.new('TextLabel')
name.TextXAlignment = 'Left'
name.TextYAlignment = 'Top'
name.Text = 'VEngine'
name.TextScaled = true
name.Position = UDim2.fromOffset(128, 0)
name.BackgroundTransparency = 1
name.Size = UDim2.fromOffset(128, 16)
name.Parent = frame

button.MouseButton1Click:Connect(function()
	remote:FireServer('push', box.Text)
end)

frame.Parent = ui
ui.Parent = script

local uis = game:GetService('UserInputService')
local keys = {
	[Enum.KeyCode.Left] = 1, -- left
	[Enum.KeyCode.Right] = 2, -- right
	[Enum.KeyCode.Up] = 3, -- up
	[Enum.KeyCode.Down] = 4, -- down
	[Enum.KeyCode.Z]  = 5, -- a
	[Enum.KeyCode.X]  = 6  -- b
}
uis.InputBegan:Connect(function(input)
	if capture.IsFocused and input.UserInputType == Enum.UserInputType.Keyboard and keys[input.KeyCode] then
		remote:FireServer('keyDown', keys[input.KeyCode])
	end
end)
uis.InputEnded:Connect(function(input)
	if capture.IsFocused and input.UserInputType == Enum.UserInputType.Keyboard and keys[input.KeyCode] then
		remote:FireServer('keyUp', keys[input.KeyCode])
		capture.Text = ''
	end
end)
]], remote)
remote.OnServerEvent:Connect(function(plr, mode, dat)
	--if plr == owner then
		if mode == 'push' then
			run(dat)
		elseif mode == 'keyDown' then
			inputs[dat] = true
		elseif mode == 'keyUp' then
			inputs[dat] = false
		end
	--end
end)

run([[
vng.allocateVectors(9)

-- V
vng.line({50, 50}, {100, 250}, 4)
vng.line({100, 250}, {150, 50}, 4)

-- N
vng.line({150, 250}, {150, 150}, 4)
vng.line({150, 150}, {200, 250}, 4)
vng.line({200, 250}, {200, 150}, 4)

-- G
vng.line({225, 200}, {275, 150}, 4)
vng.line({225, 200}, {275, 250}, 4)
vng.line({275, 250}, {325, 200}, 4)
vng.line({325, 200}, {275, 200}, 4)
wait(1.5)
vng.clear()
]])