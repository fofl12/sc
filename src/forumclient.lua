local board = Instance.new('Part')
board.Position = owner.Character.Position
board.Size = Vector3.new(12, 9, 0)

local gui = Instance.new('SurfaceGui', board)

local bg = Instance.new('ImageLabel', gui)
bg.Size = UDim2.fromScale(1, 1)
bg.Image = 'rbxassetid://113333128'
