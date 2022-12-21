local http = --[[Http or]] game:GetService('HttpService')

local board = Instance.new('Part', script)
board.Position = owner.Character.Head.Position
board.Size = Vector3.new(9, 7, 0)
board.Anchored = true

local gui = Instance.new('SurfaceGui', board)
gui.ClipsDescendants = false

local url = Instance.new('TextBox', gui)
url.Size = UDim2.new(0.9, 0, 0, 50)
url.Name = 'url'
url.TextScaled = true

local goButton = Instance.new('TextButton', gui)
goButton.Size = UDim2.new(0.1, 0, 0, 50)
goButton.AnchorPoint = Vector2.new(1,0)
goButton.Position = UDim2.fromScale(1, 0)
goButton.Name = 'go'
goButton.TextScaled = true
goButton.Text = 'Go'

local cursor = Instance.new("ImageLabel", gui)
cursor.Size = UDim2.fromOffset(50, 50)
cursor.BackgroundTransparency = 1
cursor.AnchorPoint = Vector2.new(0.5, 0.5)
cursor.ZIndex = 10
cursor.Image = "rbxassetid://7767269282"

local rem = Instance.new('RemoteEvent', owner.PlayerGui)
local o = Instance.new('ObjectValue', rem)
o.Name = 'board'
o.Value = board
NLS([[
local rem = script.Parent
script.Parent = rem.Parent
rem.Parent = script
local board = rem:WaitForChild('board').Value
local gui = board:WaitForChild("SurfaceGui")
local urlBar = gui:WaitForChild("url")
local goButton = gui:WaitForChild("go")
local up = gui:WaitForChild("up")
local down = gui:WaitForChild("down")
local u = gui:WaitForChild("u")

goButton.MouseButton1Click:Connect(function()
	rem:FireServer("url", urlBar.Text)
end)
up.MouseButton1Click:Connect(function()
	rem:FireServer("scroll", 100)
end)
down.MouseButton1Click:Connect(function()
	rem:FireServer("scroll", -100)
end)
u.MouseButton1Click:Connect(function()
	rem:FireServer("u")
end)

local g = Instance.new('ScreenGui', script)
local f = Instance.new('Frame', g)
f.Size = UDim2.fromOffset(320, 240)
f.Position = UDim2.fromScale(1, 1)
f.AnchorPoint = Vector2.new(1, 1)
local ofp = f.AbsolutePosition -- f.AbsoluteSize

local moose = owner:GetMouse()
f.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local offset = Vector2.new(moose.X - ofp.X, moose.Y - ofp.Y)
	if offset.X >= 0 and offset.Y >= 0 then
		print('Detection the click')
		rem:FireServer("lmb", offset)
	end
end)
]], rem)
rem.OnServerEvent:Connect(function(_, type, ...)
	if type == "url" then
		local u = ({...})[1]
		url.Text = u
		http:PostAsync("https://wobrowser.snoo8.repl.co/goto", http:JSONEncode({url=u}))
	elseif type == "scroll" then
		local magnitude = ({...})[1]
		http:GetAsync("https://wobrowser.snoo8.repl.co/input?type=scroll&y=" .. tostring(magnitude))
	elseif type == "lmb" then
		local p = ({...})[1]
		cursor.Position = UDim2.new(p.X / 320, 0, p.Y / 240, 50)
		http:GetAsync("https://wobrowser.snoo8.repl.co/input?type=lmb&x=" .. tostring(p.X) .. "&y=" .. tostring(p.Y))
	elseif type == "u" then
		update()
	end
end)

local viewport = Instance.new('Frame')
viewport.Size = UDim2.new(1, -50, 1, -50)
viewport.Position = UDim2.new(0, 0, 0, 50)
local bars = {}
for y = 1, 240 do
	local label = Instance.new('TextBox')
	label.RichText = true
	label.Font = 'Code'
	label.Size = UDim2.fromScale(1, 1/240)
	label.Position = UDim2.fromScale(0, y/240)
	label.TextScaled = true
	label.BackgroundTransparency = 1
	label.Parent = viewport
	bars[y] = label
end
viewport.Parent = gui

local upButton = Instance.new('TextButton', gui)
upButton.Text = '||'
upButton.Name = 'up'
upButton.Size = UDim2.new(0, 50, 0.5, -50)
upButton.TextScaled = true
upButton.Position = UDim2.new(1, -50, 0, 50)
local downButton = upButton:Clone()
downButton.Parent = gui
downButton.Name = 'down'
downButton.Text = '||'
downButton.Position = UDim2.new(1, -50, 0.5, 50)

function update()
	local raw = http.GetAsync(http, 'https://wobrowser.snoo8.repl.co/screenshot')
	local image = http:JSONDecode(raw)
	for i, dat in next, image do
		bars[i].Text = dat
	end
	print('The screenshot has been recognize')
end

local uButton = Instance.new('TextButton', gui)
uButton.Text = 'U'
uButton.Name = 'u'
uButton.Size = UDim2.fromOffset(50, 50)
uButton.Position = UDim2.fromScale(1, 0.5)
uButton.AnchorPoint = Vector2.new(1, 0.5)
uButton.TextScaled = true

--[[
task.spawn(function()
	while task.wait(5) do
		update()
	end
end)
]]