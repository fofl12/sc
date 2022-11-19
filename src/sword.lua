local color = nil
local threshold = 300
local dmg = 25
local totalDmg = 0
local active = false
local debris = game:service'Debris'

local tool = Instance.new('Tool')
tool.Name = 'Sword'
tool.Grip = CFrame.new(0, 1.2, -.5) * CFrame.Angles(-math.pi / 4 * 3, 0, 0)

local handle = Instance.new('Part')
handle.Name = 'Handle'
handle.Size = Vector3.new(1, 3, 2)
handle.Transparency = 1
local selection = Instance.new('SelectionBox', handle)
selection.Adornee = handle
selection.LineThickness = 0.1
selection.Transparency = 0
task.spawn(function()
	while true do
		task.wait()
		if not color then
			selection.Color3 = Color3.fromHSV(math.sin(os.clock() / 6) / 2 + 1, 1, .3)
		else
			selection.Color3 = color
		end
	end
end)

local light = Instance.new('PointLight', handle)
light.Range = 30
light.Brightness = 0

local function billthrow(pos, text)
	print(text)
	local ball = Instance.new('Part')
	ball.Shape = 'Ball'
	ball.Transparency = 1
	ball.Position = pos
	ball.Size = Vector3.one
	
	local billboard = Instance.new('BillboardGui', ball)
	billboard.Size = UDim2.fromScale(4, 3)

	local tb = Instance.new('TextBox', billboard)
	tb.TextColor3 = BrickColor.Random().Color
	tb.Text = text
	tb.TextScaled = true
	tb.Size = UDim2.fromScale(1, 1)
	tb.BackgroundTransparency = 1

	ball.Parent = script
	ball:ApplyImpulse(Vector3.new(math.random() * 2 - 1, 1, math.random() * 2 - 1) * 15)
	debris:AddItem(ball, 1)
end

local bass = Instance.new('Sound', handle)
bass.SoundId = 'rbxasset://sounds/bass.wav'

local ping = Instance.new('Sound', ping)
ping.SoundId = 'rbxasset://sounds/electronicpingshort.wav'

local function play(sound, pitch)
	sound.PlaybackSpeed = pitch
	sound:Play()
end

tool.Equipped:Connect(function()
	local char = tool.Parent
	local plr = game:service'Players':GetPlayerFromCharacter(char)
	if plr ~= owner then
		for i = 1, 5 do
			local x = Instance.new('Explosion')
			x.Position = char.Head.Position
			x.Parent = handle
		end
		for i = 5, 0, -0.05 do
			billthrow(handle.Position, 'You have ' .. tostring(math.floor(i * 20) / 20) .. ' seconds left.')
			tool.Name = 'You have ' .. tostring(math.floor(i * 20) / 20) .. ' seconds left.'
			char.Humanoid:TakeDamage(50)
			if tool.Parent ~= char then
				billthrow(handle.Position, 'The disaster has been averted')
				return
			end
			task.wait(0.05)
		end
		char.Humanoid:Destroy()
		for i, p in next, workspace:GetDescendants() do
			if i % 64 == 0 then
				billthrow(handle.Position, 'Kaboom')
			end
			if p:IsA('BasePart') then
				Instance.new('Explosion', p).Position = p.Position
			end
		end
	else
		play(bass, 5)
	end
end)

local maxHp = 0
local ibonk = true
handle.Touched:Connect(function(p)
	if totalDmg > threshold and p ~= workspace.Base then
		play(ping, 2)
		color = Color3.new(1, 0, .5)
		if p == workspace.Terrain then
			p:FillBall(owner.Character.Torso.Position, 6, Enum.Material.Air)
			billthrow(owner.Character.Torso.Position, 'Bye')
		else
			p:Destroy()
			billthrow(p.Position, 'Bye')
		end
	else
		local hum = p.Parent:FindFirstChild'Humanoid'
		if hum then
			if active and ibonk then
				play(ping, 1)
				hum:TakeDamage(dmg)
				billthrow(p.Position, dmg .. 'hp')
				totalDmg += dmg
				light.Brightness = totalDmg / 50
				if totalDmg > threshold then
					billthrow(p.Position, 'Overload!')
				end
				if totalDmg > maxHp then
					maxHp = totalDmg
				end
				print(totalDmg)
				color = Color3.new(1, 0, 0)
				task.delay(10, function()
					if totalDmg <= 0 then return end
					totalDmg -= dmg
					local heal = dmg / 2
					local hum = owner.Character.Humanoid
					billthrow(handle.Position, '-' .. dmg - math.min(hum.MaxHealth, heal + hum.Health) + hum.Health .. 'hp...')
					owner.Character.Humanoid.Health += heal
					light.Brightness = totalDmg / 50
					if totalDmg == 0 then
						billthrow(handle.Position, 'lost ' .. maxHp .. ' hp')
						maxHp = 0
					end
				end)
			elseif ibonk then
				play(ping, 0.9)
				color = Color3.new(1, .5, 0)
				hum:TakeDamage(dmg / 2)
				billthrow(p.Position, dmg / 2 .. 'hp')
				totalDmg += dmg
				light.Brightness = totalDmg / 50
				if totalDmg > threshold then
					billthrow(p.Position, 'Overload!')
				end
				task.delay(10, function()
					if totalDmg <= 0 then return end
					totalDmg -= dmg
					light.Brightness = totalDmg / 50
					billthrow(handle.Position, '-' .. dmg - math.min(hum.MaxHealth, heal + hum.Health) + hum.Health .. 'hp...')
				end)
			end
			ibonk = false
			hum.Sit = true
			task.delay(0.1, function()
				color = nil
				ibonk = true
			end)
			task.delay(3, function()
				hum.Sit = false
			end)
		end
	end
end)

tool.Activated:Connect(function()
	color = Color3.new(0.6)
	active = true
	owner.Character.Torso['Right Shoulder'].C0 *= CFrame.Angles(0, 0, math.pi * .5)
	task.wait(0.2)
	owner.Character.Torso['Right Shoulder'].C0 *= CFrame.Angles(0, 0, -math.pi * .75)
	play(bass, 1)
	task.delay(0.2, function()
		active = false
		color = nil
		owner.Character.Torso['Right Shoulder'].C0 *= CFrame.Angles(0, 0, math.pi * .25)
	end)
end)

local remote = Instance.new('RemoteEvent', tool)
NLS([[
	local debonk = false
	script.Parent.OnClientEvent:Connect(function(mode)
		if debonk then return end
		if mode == 'Q' then
			debonk = true
			local oldWs = owner.Character.Humanoid.WalkSpeed
			local oldGrav = workspace.Gravity
			workspace.Gravity = 100
			owner.Character.Humanoid.WalkSpeed = 100
			owner.Character.Humanoid.Jump = true
			task.wait(0.5)
			owner.Character.Torso:ApplyImpulseAtPosition(Vector3.new(0, 0, -10) * owner.Character.Torso.CFrame.LookVector, Vector3.new(0, 1))
			owner.Character.Humanoid.PlatformStand = true
			task.wait(1)
			owner.Character.Humanoid.PlatformStand = false
			workspace.Gravity = oldGrav
			owner.Character.Humanoid.WalkSpeed = oldWs
			debonk = false
		end
	end)
]], remote)
local lastLaunched = 0
local launchPrompt = Instance.new('ProximityPrompt', handle)
launchPrompt.HoldDuration = 0
launchPrompt.KeyboardKeyCode = 'Q'
launchPrompt.RequiresLineOfSight = false
launchPrompt.Style = 'Custom'
launchPrompt.Triggered:Connect(function(p)
	if os.time() - lastLaunched > 10 and p == owner then
		lastLaunched = os.time()
		remote:FireClient(owner, 'Q')
		billthrow(handle.Position, 'Propulsion')
		task.delay(2, function()
			billthrow(handle.Position, '!! Propulsion Overheat !!')
		end)
	else
		billthrow(handle.Position, 'Wait for propulsion to cool down!')
	end
end)
local recoverPrompt = Instance.new('ProximityPrompt', handle)
recoverPrompt.HoldDuration = 0
recoverPrompt.KeyboardKeyCode = 'E'
recoverPrompt.RequiresLineOfSight = false
recoverPrompt.Style = 'Custom'
recoverPrompt.Triggered:Connect(function(p)
	if totalDmg > 100 and p == owner then
		for _, m in next, workspace:GetChildren() do
			if m:IsA('Model') and m:FindFirstChild('Humanoid') and m:FindFirstChild('Head') then
				local hum = m.Humanoid
				local dist = (m.Head.Position - handle.Position).Magnitude
				if dist < 50 then
					task.delay(10 - dist / 5, function()
						hum.Health += 100 - dist * 2
					end)
				end
			end
		end
		local x = Instance.new('Explosion', handle)
		x.Position = handle.Position
		x.DestroyJointRadiusPercent = 0

		billthrow(handle.Position, 'Recovery')
		billthrow(handle.Position, '-100hp...')
		totalDmg -= 100
	else
		billthrow(handle.Position, 'Not enough HP for recovery .....')
	end
end)

handle.Parent = tool
tool.Parent = owner.Backpack

owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 's%' then
		local command = m:sub(3, -1):split' '
		if command[1] == 'threshold' then
			threshold = tonumber(command[2])
		elseif command[1] == 'dmg' then
			dmg = tonumber(command[2])
		elseif command[1] == 'reset' then
			dmg = 25
			threshold = 300
			totalDmg = 0
			color = nil
			active = false
		elseif command[1] == 'recovery' then
			local billboard = Instance.new('BillboardGui', handle)
			billboard.Size = UDim2.fromScale(10, 10)
			billboard.AlwaysOnTop = true
			local text = Instance.new('TextBox', billboard)
			text.TextScaled = true
			text.Text = 'Sword Recovery'
			text.Size = UDim2.fromScale(1, 1)
			debris:AddItem(billboard, 5)
		end
	end
end)

local oldHp = owner.Character.Humanoid.Health
local usedSave = false
while task.wait(1/10) do
	local newHp = owner.Character.Humanoid.Health
	if newHp < 1 then
		billthrow(handle.Position, '!!! DEAD !!!')
	elseif newHp < 10 and math.random() < .5 and not usedSave then
		usedSave = true
		billthrow(handle.Position, 'Saved by the RNG')
		owner.Character.Humanoid.Health = owner.Character.Humanoid.MaxHealth
	elseif newHp < 15 then
		billthrow(handle.Position, '!! LOW HEALTH !!')
	end
	if newHp < oldHp and math.random() < .5 + (oldHp - newHp) / 200 then
		billthrow(handle.Position, 'Blocked ' .. oldHp - newHp .. ' damage')
		owner.Character.Humanoid.Health = oldHp
		newHp = oldHp
		play(bass, 0.5)
	elseif newHp < oldHp then
		billthrow(handle.Position, 'Ow (-' .. oldHp - newHp .. 'hp)')
		play(ping, 1)
	end
	oldHp = owner.Character.Humanoid.Health
end