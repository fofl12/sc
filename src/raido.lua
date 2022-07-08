local battery = 1
local batteryEnabled = true

local tool = Instance.new('Tool')
tool.Name = 'Raido'

local handle = Instance.new('Part')
handle.Name = 'Handle'
handle.Parent = tool
local mesh = Instance.new('FileMesh')
mesh.MeshId = 'rbxassetid://1323932869'
mesh.TextureId = 'rbxassetid://1323932922'
mesh.Parent = handle
local gui = Instance.new('BillboardGui')
gui.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
gui.Size = UDim2.fromScale(5, 1)
gui.Parent = handle
local statelabel = Instance.new('TextBox')
statelabel.BackgroundTransparency = 1
statelabel.Size = UDim2.fromScale(1, 1)
statelabel.TextColor3 = Color3.new(1, 1, 1)
statelabel.TextScaled = true
statelabel.TextWrap = true
statelabel.Parent = gui

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local uis = game:GetService('UserInputService')
uis.InputBegan:Connect(function(i, g)
	if not g then
		if i.KeyCode == Enum.KeyCode.Q then
			remote:FireServer(1)
		elseif i.KeyCode == Enum.KeyCode.E then
			remote:FireServer(2)
		end
	end
end)
]], remote)

handle.Parent = tool
tool.Parent = owner.Backpack

local sounds = {}
do
	local p1 = Instance.new('Attachment',handle)
	local p2 = Instance.new('Attachment',handle)
	local p3 = Instance.new('Attachment',handle)
	local p4 = Instance.new('Attachment',handle)

	local bass = Instance.new("Sound",p1)
	bass.SoundId = "rbxassetid://12221831"
	bass.Volume = 2
	bass.PlayOnRemove = true
	bass.TimePosition = 0.12
	local ping = Instance.new("Sound",p2)
	ping.SoundId = "rbxassetid://12221990"
	ping.PlayOnRemove = true
	ping.Volume = 2
	ping.TimePosition = 0.12
	local snap = Instance.new("Sound",p3)
	snap.SoundId = "rbxassetid://12222140"
	snap.PlayOnRemove = true
	snap.Volume = 1
	snap.TimePosition = 0.1
	local ping2 = Instance.new("Sound",p4)
	ping2.SoundId = "rbxassetid://12221990"
	ping2.PlayOnRemove = true
	ping2.Volume = 2
	ping2.TimePosition = 0.12
	
	sounds.bass = bass
	sounds.ping = ping
	sounds.snap = snap
	sounds.ping2 = ping2
end

local volume = 1
local function play(name, pitch)
	if battery > 0 or not batteryEnabled then
		sounds[name].PlaybackSpeed = pitch
		sounds[name].Volume = volume * (name == 'snap' and 1 or 2)
		sounds[name].Parent.Parent = nil
		sounds[name].Parent.Parent = handle
		battery -= (sounds[name].Volume / 5000)
	end
end

statelabel.Text = 'Ready'
local channel = 0
local menu = 1
local connectionHandle
remote.OnServerEvent:Connect(function(_, mode)
	if mode == 1 and tool.Parent == owner.Character then
		if menu == 1 then
			if connectionHandle then
				connectionHandle:Disconnect()
			end
			play('ping', 1)
			channel = (channel % 11) + 1
			local oldChannel = channel

			if _G['channel' .. channel] and channel ~= 11 then
				statelabel.Text = 'Channel: ' .. channel .. '\nSearching for signal'

				connectionHandle = _G['channel' .. channel].Event:Connect(function(message)
					if channel == oldChannel and channel ~= 11 then
						for _, sound in next, message do
							local soundname = sound[1]
							local soundpitch = sound[2]
							play(soundname, soundpitch)
							statelabel.Text = ('Channel: %i\nBattery: %i%%'):format(channel, battery * 100)
						end
					end
				end)
			elseif channel ~= 11 then
				statelabel.Text = 'Channel: ' .. channel .. '\nCannot initiate connection'
			else
				statelabel.Text = ('Off\nBattery: %i%%'):format(battery * 100)
			end
		elseif menu == 2 then
			volume += 0.5
			if volume > 3 then
				volume = 0.5
			end
			play('snap', 1)
			statelabel.Text = 'Volume: ' .. volume .. '\nBattery Usage: ' .. volume / 25 .. '%'
		elseif menu == 3 then
			batteryEnabled = not batteryEnabled
			play('snap', 1)
			statelabel.Text = 'Battery enabled: ' .. tostring(batteryEnabled)
		end
	elseif mode == 2 and tool.Parent == owner.Character  then
		menu = (menu % 3) + 1
		play('bass', 1)
		if menu == 1 then
			statelabel.Text = '[Menu: Channels]'
		elseif menu == 2 then
			if connectionHandle then
				connectionHandle:Disconnect()
			end
			statelabel.Text = 'Volume: ' .. volume .. '\nBattery Usage: ' .. volume / 25 .. '%'
		elseif menu == 3 then
			statelabel.Text = 'Battery enabled: ' .. tostring(batteryEnabled)
		end
	end
end)

tool.AncestryChanged:Connect(function()
	if tool.Parent == workspace then
		if battery < 1 then
			if battery < 0 then
				battery = 0
			end
			local i = 0
			while battery < 1 and tool.Parent == workspace do
				battery += 0.015
				i = (i % 3) + 1
				statelabel.Text = ('Recharging%s\n%i%%'):format(('.'):rep(i), battery * 100)
				task.wait(0.1)
			end
			statelabel.Text = 'Recharge complete'
		else
			statelabel.Text = 'Recharge not needed'
		end
	end
end)