local tool = Instance.new('Tool', owner.Backpack)
tool.Name = 'Pickaxe'

local handle = Instance.new('Part', tool)
handle.Name = 'Handle'
handle.Size = Vector3.one

local mesh = Instance.new('FileMesh', handle)
mesh.MeshId = 'rbxassetid://1114777176'
mesh.Scale = Vector3.one / 3
mesh.TextureId = 'rbxassetid://1114777186'

local port = Instance.new('RemoteEvent', tool)

port.OnServerEvent:Connect(function(_, target)
	if typeof(target) == 'Instance' and target:GetAttribute('isOre') then
		if target:GetAttribute('cash') then
			local cash = owner:GetAttribute('cash') or 0
			owner:SetAttribute('cash', cash + target:GetAttribute('cash'))
		end
		target:Destroy()
	elseif typeof(target) == 'Vector3' then
		mine:Fire(Vector3.new(math.round(target.X * 4) / 4, math.round(target.Y * 4) / 4 - 40, math.round(target.Z * 4) / 4) / 4)
	end
end)

NLS([[
local rock, coal, iron, gold, diamond, copper = 0, 0, 0, 0, 0, 0
local hint = Instance.new('Hint', script)

script.Parent.Parent.Activated:Connect(function()
	local target = owner:GetMouse().Target
	if not target then return end
	if target:GetAttribute('isOre') then
		if target.Name == 'rock' then
			rock = rock + 1
		elseif target.Name == 'coal' then
			coal = coal + 1
		elseif target.Name == 'iron' then
			iron = iron + 1
		elseif target.Name == 'gold' then
			gold = gold + 1
		elseif target.Name == 'diamond' then
			diamond = diamond + 1
		elseif target.Name == 'copper' then
			copper = copper + 1
		end
		script.Parent:FireServer(target)
	elseif target == workspace.Terrain then
		script.Parent:FireServer(owner:GetMouse().Position)
	end
end)

while task.wait(1/5) do
	local pos = script.Parent.Parent.Handle.Position / 4 - Vector3.new(0, 40)
	hint.Text = ('Rock: %i / Coal: %i / Iron: %i / Gold: %i / Diamond: %i / Copper: %i\nPosition: %i, %i, %i'):format(rock, coal, iron, gold, diamond, copper, pos.X, pos.Y, pos.Z)
end
]], port)