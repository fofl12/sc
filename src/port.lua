workspace.Base:Destroy()
local base = Instance.new('Part', workspace.Terrain)
base.Anchored = true
base.Size = Vector3.new(100, 1, 100)
base.Position = Vector3.zero
base.Material = 'Glass'
base.Transparency = 0.5
workspace.Terrain:FillBlock(CFrame.new(0, -25, 0), Vector3.new(4000, 50, 4000), Enum.Material.Water)