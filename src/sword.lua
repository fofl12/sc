local color = nil
local threshold = 300
local dmg = 25
local totalDmg = 0
local active = false

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
			selection.Color3 = Color3.fromHSV(math.sin(os.clock() / 6), 1, .3)
		else
			selection.Color3 = color
		end
	end
end)

local bass = Instance.new('Attachment', handle)
local sound = Instance.new('Sound', bass)
sound.PlayOnRemove = true
sound.SoundId = 'rbxasset://sounds/bass.wav'

local ping = Instance.new('Attachment', handle)
local sound = Instance.new('Sound', ping)
sound.PlayOnRemove = true
sound.SoundId = 'rbxasset://sounds/electronicpingshort.wav'

local function play(sound, pitch)
	sound.Sound.PlaybackSpeed = pitch
	sound.Parent = nil
	sound.Parent = handle
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
			tool.Name = 'You have ' .. tostring(math.floor(i * 20) / 20) .. ' seconds left.'
			char.Humanoid:TakeDamage(2)
			task.wait(0.05)
		end
		play(ping, 0.1)
		char.Humanoid:Destroy()
	else
		play(bass, 5)
	end
end)

local ibonk = true
handle.Touched:Connect(function(p)
	if totalDmg > threshold and p ~= workspace.Base then
		play(ping, 2)
		color = Color3.new(1, 0, .5)
		if p == workspace.Terrain then
			p:FillBall(owner.Character.Torso.Position, 6, Enum.Material.Air)
		else
			p:Destroy()
		end
	else
		local hum = p.Parent:FindFirstChild'Humanoid'
		if hum then
			if active and ibonk then
				play(ping, 1)
				hum:TakeDamage(dmg)
				totalDmg += dmg
				print(totalDmg)
				color = Color3.new(1, 0, 0)
				task.delay(5, function()
					totalDmg -= dmg
				end)
			elseif ibonk then
				play(ping, 0.9)
				color = Color3.new(1, .5, 0)
				hum:TakeDamage(dmg / 2)
			end
			ibonk = false
			hum.Sit = true
			task.delay(0.2, function()
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
	owner.Character.Torso['Right Shoulder'].C0 *= CFrame.Angles(0, 0, -math.pi / 4)
	play(bass, 1)
	task.delay(0.2, function()
		active = false
		color = nil
		owner.Character.Torso['Right Shoulder'].C0 *= CFrame.Angles(0, 0, math.pi / 4)
	end)
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
		end
	end
end)