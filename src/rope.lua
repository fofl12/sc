local tool = Instance.new('Tool', owner.Backpack)
tool.Name = 'Rope'

local handle = Instance.new('Part', tool)
handle.Size = Vector3.one
handle.Name = 'Handle'

local p1
local remote = Instance.new('RemoteEvent', tool)
NLS([[
local remote = script.Parent.RemoteEvent
script.Parent.Activated:Connect(function()
	local moose = owner:GetMouse()
	remote:FireServer(moose.Target, moose.Hit.p)
end)
]], tool)

remote.OnServerEvent:Connect(function(_, t, p)
	if p1 then
		local p2 = Instance.new('Attachment', t)
		p2.WorldPosition = p
		local rope = Instance.new('RopeConstraint', t)
		rope.Attachment0 = p1
		rope.Attachment1 = p2
		rope.Visible = true
		rope.Thickness = rope.Length / 10
		rope.Length = (p1.WorldPosition - p2.WorldPosition).Magnitude + 1
		rope.Thickness = rope.Length / 10
		p1 = nil
	else
		p1 = Instance.new('Attachment', t)
		p1.WorldPosition = p
	end
end)