owner.Character.Parent = nil
local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
	local remote = script.Parent
	script.Parent = remote.Parent
	remote.Parent = script

	local c = owner.Character
	Instance.new('ForceField', owner.Character)
	c.Parent = workspace
	while true do
		task.wait()
		remote:FireServer(
			c.Head.CFrame, c.Torso.CFrame, c['Left Arm'].CFrame,
			c['Right Arm'].CFrame, c['Left Leg'].CFrame, c['Right Leg'].CFrame
		)
	end
]], remote)

local prevping = os.clock()
local mat = Enum.Material.Water
local terrain = workspace.Terrain
local scale = 20
local parent = script

local function s(cf)
	local p = cf.p
	return (cf - p) + (p * scale)
end

remote.OnServerEvent:Connect(function(player, h, t, la, ra, ll, rl)
	terrain:Clear()
	terrain:FillBall(s(h).p, scale, mat)
	terrain:FillBlock(s(t), Vector3.new(2, 2, 1)*scale, mat)

	terrain:FillBlock(s(la), Vector3.new(1, 2, 1)*scale, mat)
	terrain:FillBlock(s(ra), Vector3.new(1, 2, 1)*scale, mat)
	terrain:FillBlock(s(ll), Vector3.new(1, 2, 1)*scale, mat)
	terrain:FillBlock(s(rl), Vector3.new(1, 2, 1)*scale, mat)
end)
