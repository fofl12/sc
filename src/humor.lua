local debris = game:GetService('Debris')
local ts = game:GetService('TweenService')
local images = {
	'rbxassetid://8834989062',
	'rbxassetid://6940140256',
	'rbxassetid://6840297364',
	'rbxassetid://6566147844',
	'rbxassetid://6335920805',
	'rbxassetid://6298045703',
	'rbxassetid://6709911380',
	'rbxassetid://7125224094',
	'rbxthumb://id=212632382&type=Avatar&w=150&h=150',
	'rbxthumb://id=1&type=Avatar&w=150&h=150',
	'rbxthumb://id=2&type=Avatar&w=150&h=150',
	'rbxthumb://id=3&type=Avatar&w=150&h=150',
	'rbxassetid://7514729378',
	'rbxassetid://6072733307',
	'rbxassetid://2994480258',
	'rbxassetid://10713839067',
	'rbxassetid://10713833524',
	'rbxassetid://10713831431',
	'rbxthumb://id=154711494&type=AvatarHeadShot&w=150&h=150',
	'rbxassetid://10714889621',
	'rbxassetid://2108873295',
	'rbxassetid://10265639451'
}

local sounds = {
	'rbxassetid://5058160717',
	'rbxasset://sounds/bass.wav',
}

local board = Instance.new('Part')
board.Size = Vector3.new(10, 10, 1)
board.Position = owner.Character.Head.Position
board.Material = 'Glass'
board.Transparency = 0.6
board.Reflectance = 0.5
board.Anchored = true
board.Parent = script

local gui = Instance.new('SurfaceGui', board)
gui.ClipsDescendants = true

while true do
	task.wait(math.random() / 10)
	gui.Parent = nil
	local label = Instance.new('ImageLabel')
	local sx, sy, px, py = math.random(), math.random(), math.random() / 2, math.random() / 2
	label.Image =  images[math.random(1, #images)]
	label.Position = UDim2.fromScale(px, py)
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(sx, sy)
	label.Parent = gui
	gui.Parent = board
	local sond = Instance.new('Sound')
	sond.SoundId = sounds[math.random(1, #sounds)]
	sond.Parent = board
	sond:Play()
	debris:AddItem(label, 0.5)
	ts:Create(label, TweenInfo.new(1), {
		ImageTransparency = 1
	}):Play()
end