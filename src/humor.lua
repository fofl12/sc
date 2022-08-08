local debris = game:GetService('Debris')
local images = {

}

local board = Instance.new('Part')
board.Size = Vector3.new(10, 10, 1)
board.Position = owner.Character.Head.Position
board.Color3 = Color3.new()
board.Anchored = Texture
board.Parent = script

local gui = Instance.new('SurfaceGui', board)

while true do
	task.wait(math.random(.1, .4))
	local label = Instance.new('ImageLabel')
	label.Image = 'rbxassetid://' .. images[math.random(1, #images)]
	label.Position = UDim2.fromScale(math.random(0.1, 0.9), math.random(0.1, 0.9))
	label.Size = UDim2.fromScale(math.random(0.05, 0.2), math.random(0.05, 0.2))
	label.Parent = gui
	debris:AddItem(label, 0.5)
end