local terrain = workspace.Terrain
task.spawn(function()
	while true do
		task.wait(1)
		local head = owner.Character.Head
		terrain:FillBlock(CFrame.new(head.Position.X, -25, head.Position.Z), Vector3.one * 50, Enum.Material.Water)
	end
end)

local SPEED = 30
local DELTA = Vector3.new()

