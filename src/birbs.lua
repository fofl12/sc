local offset = owner.Character.Head.Position - Vector3.new(0, 4)
local birds = {}

local tree = Instance.new('Part')
tree.Anchored = true
tree.Position = offset + Vector3.new(5, 5, 5)
tree.BrickColor = BrickColor.Brow()
tree.Size = Vector3.new(2, 10, 2)
tree.Parent = script

local lake = Instance.new('Part')
lake.Anchored = true
lake.Position = offset + Vector3.new(-5, 0, 2)
lake.BrickColor = BrickColor.Blue()
lake.Size = Vector3.new(8, 1, 7)
lake.Parent = script

local prey = Instance.new('Part')
prey.Anchored = true
prey.Shape = 'Ball'
prey.Position = offset + Vector3.new(5, 0, 5)
prey.BrickColor = BrickColor.Red()
prey.Size = Vector3.new(2, 2, 2)
prey.Parent = script