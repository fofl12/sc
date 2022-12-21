local MAXDEPTH = 2

local tnode = Instance.new('SpawnLocation')
tnode.Enabled = false
tnode.Shape = 'Ball'
tnode.Size = Vector3.one * 0.15
tnode.Material = 'Neon'
tnode.Anchored = true
tnode.CanCollide = false

local tcon = Instance.new('Beam')
tcon.Width0 = 0.05
tcon.Width1 = 0.05

local nodes = {}
local cons = {}

local function importFromId(id, idesc, depth)
	if depth > MAXDEPTH + 1 then return end
	local Robux = depth > MAXDEPTH
	print('Indexing from', id, 'layer', depth)
	local friendPage = game.Players:GetFriendsAsync(id)
	local mark = BrickColor.Random()
	local complete = false
	repeat
		task.wait()
		local page = friendPage:GetCurrentPage()
		for i, friend in next, page do
			local desc = {
				name = friend.Username,
				id = friend.Id,
				position = idesc.position + Vector3.new(math.random() * 256 - 128, math.random() * 128 - 64, math.random() * 256 - 128),
				color = mark,
				layer = 1,
				friends = {idesc}
			}
			local orig = table.find(nodes, desc)
			if not orig then
				table.insert(nodes, desc)
				if not Robux then
					importFromId(desc.id, desc, depth + 1)
				end
			else
				table.insert(orig.friends, idesc)
			end
			if i % 512 == 0 then
				task.wait()
			end
		end
		complete, _ = pcall(friendPage.AdvanceToNextPageAsync, friendPage)
		complete = not complete
	until complete
end

print(':: Visualizing supernode')
local snode = tnode:Clone()
snode.Size = Vector3.one
snode.Position = owner.Character.Head.Position
snode.Parent = script

print(':: Indexing nodes')
if not _G.__friendnet then
	importFromId(owner.UserId, {
		position = snode.Position,
		color = snode.BrickColor
	}, 1)
	_G.__friendnet = nodes
else
	print('Found node index cache in _G')
	nodes = _G.__friendnet
end

print(':: Indexing connections')
if not _G.__friendconnet then
	for i, node in next, nodes do
		if node.layer == 1 then
			table.insert(cons, {
				origin = {
					position = snode.position,
					color = snode.BrickColor
				},
				target = node
			})
		end
		for i, friend in next, node.friends do
			local desc = {
				origin = node,
				target = friend,
			}
			if not table.find(cons, desc) then
				table.insert(cons, desc)
			end
		end
	end
	_G.__friendconnet = cons
else
	print('Found node connection index cache in _G')
	cons = _G.__friendconnet
end

local size = #nodes
print(':: Visualizing', size, 'nodes')
for i, node in next, nodes do
	local vnode = tnode:Clone()
	vnode.BrickColor = node.color
	vnode.Position = node.position
	vnode:SetAttribute('Username', node.name)
	vnode:SetAttribute('Id', node.id)
	vnode.Parent = script
	
	if i % 4 == 0 then
		task.wait()
	end
	if i % 64 == 0 then
		print('Visualization Progress: ' .. math.floor(i / size * 100) .. '%')
	end
end

local conSize = #cons
print(':: Visualizing', conSize, 'connections')
for i, con in next, cons do
	local vcon = tcon:Clone()
	local a1 = Instance.new('Attachment', snode)
	a1.WorldPosition = con.origin.position
	local a2 = Instance.new('Attachment', snode)
	a2.WorldPosition = con.target.position
	vcon.Attachment0 = a1
	vcon.Attachment1 = a2
	vcon.Color = ColorSequence.new(con.origin.color.Color, con.target.color.Color)
	vcon.Parent = snode

	if i % 4 == 0 then
		task.wait()
	end
	if i % 64 == 0 then
		print('Visualization Progress: ' .. math.floor(i / conSize * 100) .. '%')
	end
end

print(':: Giving inspection tool')
local tool = Instance.new('Tool')
tool.Name = 'Inspection'
local handle = Instance.new('Part')
handle.Size = Vector3.one * 0.2
handle.Shape = 'Ball'
handle.Anchored = false
handle.CanCollide = false
handle.Name = 'Handle'
handle.Parent = tool
NLS([[
local equipped = false
script.Parent.Equipped:Connect(function(mouse)
	equipped = true
	local hint = Instance.new('Hint', workspace)
	while equipped do
		task.wait(1/5)
		if mouse.Target then
			hint.Text = mouse.Target:GetAttribute('Username') or '?'
		end
	end
	hint:Destroy()
end)
script.Parent.Unequipped:Connect(function()
	equipped = false
end)
]], tool)
tool.Parent = owner.Backpack
