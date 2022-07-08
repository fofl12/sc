local port = Instance.new('RemoteEvent', owner.PlayerGui)
port.Name = 'qwin'
NLS([[
-- port shuffle
local port = script.Parent
script.Parent = port.Parent
port.Parent = script

local sgui = Instance.new('ScreenGui')
local viewFrame = Instance.new('Frame', sgui)
viewFrame.Size = UDim2.fromOffset(640, 480)
viewFrame.AnchorPoint = Vector2.one * 0.5
viewFrame.Position = UDim2.fromScale(0.5, 0.5)
viewFrame.BackgroundColor3 = BrickColor.new(100).Color

local window = Instance.new('Frame')
window.Size = UDim2.fromOffset(200, 150)
do
	local core = Instance.new('Frame', window)
	core.Size = UDim2.new(1, 0, 0, 16)
	core.Name = 'core'

	local close = Instance.new('TextButton', core)
	close.Text = 'X'
	close.Size = UDim2.fromOffset(16, 16)
	close.BackgroundColor3 = BrickColor.Red().Color
	close.TextColor3 = BrickColor.White().Color
	close.Name = 'close'

	local name = Instance.new('TextLabel', main)
	name.Text = 'Robux Device'
	name.TextXAlignment = 'Left'
	name.TextYAlignment = 'Top'
	name.Size = UDim2.fromOffset(32, 16)
	name.Position = UDim2.fromOffset(0, 16)
	name.TextSize = 16
	name.Parent = core


	local main = Instance.new('Frame', window)
	main.Position = UDim2.fromOffset(0, 16)
	main.BackgroundColor3 = Color3.new(1, 1, 1)
	main.Size = UDim2.new(1, 0, 1, -16)
end
window.Parent = viewFrame
sgui.Parent = script
]], port)