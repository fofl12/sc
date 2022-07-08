local onNewMessage = game.ReplicatedStorage.DefaultChatSystemChatEvents['1']

for _ = 1, 4 do 
	local message = ''
	for i = 1, 80 do
		message ..= string.char(math.random(32, 126))
	end

	onNewMessage:FireClient(game.Players.RaycastRaymond, {
		MessageType = 'Message',
		MessageRaw = message,
		Message = message,
		MessageLength = #message,
		SpeakerUserId = 1,
		OriginalChannel = 'SERVER',
		Time = os.time(),
		FromSpeaker = message:sub(1, math.random(2, 7)),
		Id = math.random(6000, 1000000),
		IsFiltered = true,
		IsFilterResult =  false,
		ExtraData = {
			NameColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		},
	}, 'SERVER')
end