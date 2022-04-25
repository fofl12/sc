local http = game:GetService('HttpService')
local api = 'https://exec.snoo8.repl.co'

local screen = Instance.new('Part')
screen.Size = Vector3.new(5, 3, 1)
screen.Position = owner.Character.Head.Position
screen.Anchored = true
screen.CanCollide = false
screen.BrickColor = BrickColor.new('Black')

local gui = Instance.new('SurfaceGui', screen)
local browser = Instance.new('ScrollingFrame', gui)
browser.Size = UDim2.fromScale(0.2, 0.7)
Instance.new('UIListLayout', browser)
local editor = Instance.new('TextBox', gui)
editor.MultiLine = true
editor.ClearTextOnFocus = false
editor.Size = UDim2.fromScale(0.8, 0.7)
editor.Position = UDim2.fromScale(0.2, 0)
local in = Instance.new('TextBox', gui)
in.Size = UDim2.fromScale(1, 0.1)
in.Position = UDim2.fromScale(0, 0.7)
local out = Instance.new('TextLabel', gui)
out.Size = UDim2.fromScale(1, 0.2)
out.Position = UDim2.fromScale(0, 0.8)
