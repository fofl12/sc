local cs = game:GetService('CollectionService')

local tool = Instance.new('Tool')
tool.Name = 'Cola'
cs:AddTag(tool, 'cola')

local handle = Instance.new('Part', tool)
handle.Name = 'Handle'
handle.Size = Vector3.new(1, 1.2, 1)

local mesh = Instance.new('FileMesh', handle)
mesh.MeshId = 'rbxassetid://10470609'
mesh.TextureId = 'rbxassetid://10470600'
mesh.Scale = Vector3.one * 1.2

tool.Parent = owner.Backpack

local connected = {}
task.spawn(function()
	while task.wait(1) do
		local new = cs:GetTagged('cola')
		for _, n in next, new do
			if not table.find(connected, n) then
				n.Activated:Connect(function()
					Instance.new('Explosion', n.Parent).Position = n.Handle.Position
					n.Parent = workspace
				end)
			end
		end
	end
end)