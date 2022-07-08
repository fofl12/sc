local billboard = Instance.new('BillboardGui', owner.Character.Head)
billboard.StudsOffset = Vector3.new(0, 3, 0)
billboard.Size = UDim2.fromScale(2, 1)

local text = Instance.new('TextBox', billboard)
text.Text = 'Test'
text.TextWrap = true
text.TextScaled = true
text.Size = UDim2.fromScale(1, 1)

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

local scroller = Instance.new('ScrollingFrame')
scroller.Position = UDim2.fromOffset(0, 16)
scroller.Size = UDim2.fromOffset(400, 284)
scroller.Parent = frame

local box = Instance.new('TextBox')
box.Font = 'Code'
box.TextXAlignment = 'Left'
box.TextYAlignment = 'Top'
box.TextWrap = true
box.TextSize = 10
box.MultiLine = true
box.Size = UDim2.fromScale(1, 1)
box.ClearTextOnFocus = false
box.Parent = scroller

button.MouseButton1Click:Connect(function()
	remote:FireServer(box.Text)
end)

frame.Parent = ui
ui.Parent = script
]], remote)
remote.OnServerEvent:Connect(function(plr, mode)
	if plr == owner then
		text.Text = mode
	end
end)