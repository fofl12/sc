local board = Instance.new('Part', script)
board.Size = Vector3.new(6, 6, 0)
board.Position = owner.Character.Head.Position
board.Anchored = true

local gui = Instance.new('SurfaceGui', board)

local file = ''
file ..= "NEM3"