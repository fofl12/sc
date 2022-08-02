local base = Instance.new('Part')
base.Position = Vector3.new(0, 9999999999999999)
base.Size = Vector3.new(20, 1, 20)
base.Anchored = true
base.Touched:Connect(function(b)
	local hum = b.Parent:FindFirstChild('Humanoid')
	if hum then
		hum.Jumping:Wait()
		hum.PlatformStand = true
	end
end)
base.Parent = script

for _, p in next, game:service'Players':GetChildren() do
	p.Chatted:Connect(function(c)
		if c == ':e skydive' then
			p.Character.Head.CFrame = base.CFrame + Vector3.new(0, 10, 0)
		end
	end)
end

local onNewMessage = game:FindFirstChild('SB_2', true)
local message = 'Say ":e skydive" to skydive'
onNewMessage:FireAllClients({
	MessageType = 'Message',
	MessageRaw = message,
	Message = message,
	MessageLength = #message,
	SpeakerUserId = 1,
	OriginalChannel = 'SERVER',
	Time = os.time(),
	FromSpeaker = 'Alerta',
	Id = math.random(6000, 1000000),
	IsFiltered = true,
	IsFilterResult =  false,
	ExtraData = {
		NameColor = Color3.fromRGB(255, 0, 0)
	},
}, 'SERVER')