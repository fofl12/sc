owner.Character.Parent = nil
local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
	local remote = script.Parent
	script.Parent = remote.Parent
	remote.Parent = script

	local explode = Instance.new('Tool', owner.Backpack)
	explode.Name = 'Explode'
	explode.RequiresHandle = false
	explode.Activated:Connect(function()
		remote:FireServer(false, owner:GetMouse().Target)
	end)

	local c = owner.Character
	Instance.new('ForceField', owner.Character)
	c.Parent = workspace
	while true do
		task.wait(1/60)
		remote:FireServer(true,
			c.Head.CFrame, c.Torso.CFrame, c['Left Arm'].CFrame,
			c['Right Arm'].CFrame, c['Left Leg'].CFrame, c['Right Leg'].CFrame
		)
	end
]], remote)

local head
local torso
local leftarm
local rightarm
local leftleg
local rightleg
local prevping = os.clock()
local age = 0
local parent = script

local ts = game:GetService('TweenService')
local function tween(part, cf, delta)
	local oldcf = part.CFrame
	part.CFrame = cf
	
	--[[
	local tweeninfo = TweenInfo.new(delta)
	local tween = ts:Create(part, tweeninfo, {
		CFrame = oldcf:Lerp(cf, 2)
	})
	tween:Play()
	]]
end

remote.OnServerEvent:Connect(function(player, m, h, t, la, ra, ll, rl)
	local delta = os.clock() - prevping
	prevping = os.clock()
	if m then
		age += 1
		if age > 180 then
			age = 0
			delta = 0
			print('Refresh')
			if head then head:Destroy() end
			if torso then torso:Destroy() end
			if leftarm then leftarm:Destroy() end
			if rightarm then rightarm:Destroy() end
			if leftleg then leftleg:Destroy() end
			if rightleg then rightleg:Destroy() end
		end
		if not head or head.Parent ~= parent then
			head = Instance.new('Part', parent)
			head.Shape = 'Ball'
			head.Size = Vector3.one * 2
			head.Color = Color3.new(1, 1, 1)
			local face = Instance.new('Decal', head)
			face.Texture = 'rbxassetid://7132019'
		end
		tween(head, h, delta)
		head.Velocity = Vector3.new()
		head.Anchored = true
		head.CanCollide = false

		if not torso or torso.Parent ~= parent then
			torso = Instance.new('Part', parent)
			torso.Size = Vector3.new(2, 2, 1)
			torso.Color = Color3.new(1, 0, 0)
		end
		tween(torso, t, delta)
		torso.Velocity = Vector3.new()
		torso.Anchored = true
		torso.CanCollide = false

		if not leftarm or leftarm.Parent ~= parent then
			leftarm = Instance.new('Part', parent)
			leftarm.Size = Vector3.new(1, 2, 1)
			leftarm.Color = Color3.new(1, 0, 0)
		end
		tween(leftarm, la, delta)
		leftarm.Velocity = Vector3.new()
		leftarm.Anchored = true
		leftarm.CanCollide = false

		if not rightarm or rightarm.Parent ~= parent then
			rightarm = Instance.new('Part', parent)
			rightarm.Size = Vector3.new(1, 2, 1)
			rightarm.Color = Color3.new(1, 0, 0)
		end
		tween(rightarm, ra, delta)
		rightarm.Velocity = Vector3.new()
		rightarm.Anchored = true
		rightarm.CanCollide = false

		if not leftleg or leftleg.Parent ~= parent then
			leftleg = Instance.new('Part', parent)
			leftleg.Size = Vector3.new(1, 2, 1)
			leftleg.Color = Color3.new(0, 0, 0)
		end
		tween(leftleg, ll, delta)
		leftleg.Velocity = Vector3.new()
		leftleg.Anchored = true
		leftleg.CanCollide = false

		if not rightleg or rightleg.Parent ~= parent then
			rightleg = Instance.new('Part', parent)
			rightleg.Size = Vector3.new(1, 2, 1)
			rightleg.Color = Color3.new(0, 0, 0)
		end
		tween(rightleg, rl, delta)
		rightleg.Velocity = Vector3.new()
		rightleg.Anchored = true
		rightleg.CanCollide = false
	else
		Instance.new('Explosion', h).Position = h.Position
	end
end)