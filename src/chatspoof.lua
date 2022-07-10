local onNewMessage = game.ReplicatedStorage.DefaultChatSystemChatEvents['1']

local message = ''
local author = ''
onNewMessage:FireAllClients({
	MessageType = 'Message',
	MessageRaw = message,
	Message = message,
	MessageLength = #message,
	SpeakerUserId = 1,
	OriginalChannel = 'SERVER',
	Time = os.time(),
	FromSpeaker = author,
	Id = math.random(6000, 1000000),
	IsFiltered = true,
	IsFilterResult =  false,
	ExtraData = {
		NameColor = Color3.new(0.00392157, 0.635294, 1)
	},
}, 'SERVER')