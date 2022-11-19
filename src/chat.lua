local mss = game:GetService('MessagingService')
local http = game:GetService('HttpService')
local players = game:GetService('Players')
local blocked = {}
function getChatColor(user)
    local CHAT_COLORS =
    {
        Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
        Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
        Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
        BrickColor.new("Bright violet").Color,
        BrickColor.new("Bright orange").Color,
        BrickColor.new("Bright yellow").Color,
        BrickColor.new("Light reddish violet").Color,
        BrickColor.new("Brick yellow").Color,
    }

        local function GetNameValue(pName)
            local value = 0
            for index = 1, #pName do
                local cValue = string.byte(string.sub(pName, index, index))
                local reverseIndex = #pName - index + 1
                if #pName%2 == 1 then
                    reverseIndex = reverseIndex - 1
                end
                if reverseIndex%4 >= 2 then
                    cValue = -cValue
                end
                value = value + cValue
            end
            return value
        end

    return '#' .. CHAT_COLORS[(GetNameValue(user) % #CHAT_COLORS) + 1]:ToHex()
end
local function filter(text)
	local o = text:gsub(string.char(0), '[NullChar]')
	o = o:gsub('&', '&amp;')
	o = o:gsub('<', '&lt;')
	o = o:gsub('>', '&gt;')
	o = o:gsub('"', '&quot;')
	o = o:gsub("'", '&apos;')
	return o
end
local function generateText(message)
	local authorName = players:GetNameFromUserIdAsync(message.Author)
	local out = ''
	out ..= '<font color="' .. getChatColor(authorName) .. '">[' .. authorName .. '] '
	if message.Nickname then
		out ..= '[' .. filter(message.Nickname) .. '] '
	end
	out ..= '</font>'
	if message.Type == 'text' then
		out ..= filter(message.Content)
	else
		out ..= message.Comment and filter(message.Comment) or '[No comment provided]'
		if message.Type == 'ping' then
			local pingName = players:GetNameFromUserIdAsync(tonumber(message.Content))
			out ..= ' [Pinging ' .. pingName .. ']'
		end
	end
	return out
end

local board = Instance.new('Part')
board.Position = owner.Character.Head.Position + Vector3.new(0, 2)
board.Size = Vector3.new(12, 12, 0)
board.Color = Color3.new()
board.Anchored = true
board.Transparency = 0.6
board.Material = 'Glass'
board.Parent = script

local gui = Instance.new('SurfaceGui', board)
gui.SizingMode = 'PixelsPerStud'

local chat = Instance.new('Frame', gui)
chat.Size = UDim2.fromScale(1, 1)
chat.BackgroundTransparency = 1
local chatListLayout = Instance.new('UIListLayout', chat)
chatListLayout.FillDirection = 'Vertical'
chatListLayout.SortOrder = 'Name'
chatListLayout.HorizontalAlignment = 'Left'
chatListLayout.VerticalAlignment = 'Bottom'

local chatText = Instance.new('TextBox')
chatText.TextXAlignment = 'Left'
chatText.RichText = true
chatText.BackgroundTransparency = 1
chatText.TextColor3 = Color3.new(1, 1, 1)
chatText.Size = UDim2.fromScale(1, 0.01)
chatText.AutomaticSize = 'Y'
chatText.TextYAlignment = 'Top'
chatText.TextWrapped = true
chatText.TextSize = 16

local function sendMessage(text, author, message)
	local vis = chatText:Clone()
	if message then
		vis.Text = generateText(message)
	else
		vis.Text = ('[%s] %s'):format(author, text)
	end
	vis.Name = os.time()
	vis.Parent = chat

	local labels = chat:GetChildren()
	if #labels > 40 then
		local oldest
		for _, label in next, labels do
			if not label:IsA('UIListLayout') then
				if not oldest or tonumber(oldest.Name) > tonumber(label.Name) then
					oldest = label
				end
			end
		end
		if oldest then
			oldest:Destroy()
		end
	end

	return vis
end
sendMessage('chat.lua (comradio2 revision 2.1)', 'SYSTEM')
sendMessage('Please connect to a channel to initiate communications', 'SYSTEM')
sendMessage('Documentation for comradio2 may be found in github.com/fofl12/comradio', 'SYSTEM')

local roster = {}
local channel = nil
local connection = nil
local nickname = nil
local function connect()
	if connection then
		connection:Disconnect()
	end
	connection = mss:SubscribeAsync('comradio:' .. channel, function(recv)
		local data = http:JSONDecode(recv.Data)
		local authorName = players:GetNameFromUserIdAsync(data.Author)
		if data.Type == 'text' then
			sendMessage(data.Content, authorName, data)
		elseif data.Type == 'welcome' then
			sendMessage(authorName .. ' has joined', 'WELCOME')
		elseif data.Type == 'status' then
			sendMessage(authorName .. ' has changed their status to ' .. data.Comment, 'STATUS')
		elseif data.Type == 'rosterRequest' then
			sendMessage(authorName .. ' has requested a roster', 'ROSTER')
			mss:PublishAsync('comradio:' .. channel, http:JSONEncode({
				Type = 'rosterResponse',
				Content = '',
				Author = owner.UserId
			}))
		elseif data.Type == 'rosterResponse' then
			if not table.find(roster, authorName) then
				table.insert(roster, authorName)
			end
		elseif data.Type == 'image' then
			local message = sendMessage(data.Comment, authorName, data)
			local image = Instance.new('ImageLabel', message)
			image.Image = data.Content
			image.Size = UDim2.fromOffset(150, 150)
			image.Position = UDim2.fromOffset(5, 25)
		elseif data.Type == 'sound' then
			local message = sendMessage(data.Comment, authorName, data)
			local sound = Instance.new('TextBox', message)
			sound.Text = 'Sound: ' .. data.Content
			sound.TextScaled = true
			sound.Size = UDim2.fromOffset(150, 150)
			sound.Position = UDim2.fromOffset(5, 25)
		elseif data.Type == 'ping' then
			sendMessage(data.Comment, authorName, data)
			if data.Content == tostring(owner.UserId) then
				for _ = 1, 3 do
					board.Color = Color3.new(1, 1, 0)
					board.Material = 'Plastic'
					board.Transparency = 0
					task.wait(0.2)
					board.Color = Color3.new(0, 0, 0)
					board.Material = 'Glass'
					board.Transparency = 0.6
					task.wait(0.2)
				end
			end
		end
	end)
	sendMessage('Connected to channel', 'SYSTEM')
	mss:PublishAsync('comradio:' .. channel, http:JSONEncode({
		Type = 'welcome',
		Content = '',
		Author = owner.UserId
	}))
end

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(400, 20)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)
frame.Parent = ui

local mode = Instance.new('TextBox')
mode.Text = ''
mode.PlaceholderText = 'Mode'
mode.Size = UDim2.fromScale(0.2, 1)
mode.Parent = frame

local message = Instance.new('TextBox')
message.Text = ''
message.PlaceholderText = 'Message'
message.Size = UDim2.fromScale(0.7, 1)
message.Position = UDim2.fromScale(0.2, 0)
message.Parent = frame

local button = Instance.new('TextButton')
button.Text = 'Send'
button.Size = UDim2.fromScale(0.1, 1)
button.Position = UDim2.fromScale(0.9, 0)
button.Parent = frame

button.MouseButton1Click:Connect(function()
	remote:FireServer(mode.Text, message.Text)
end)

ui.Parent = script
]], remote)
remote.OnServerEvent:Connect(function(plr, mode, dat)
	local command = mode:split(';')
	if mode == 'text' then
		if channel then
			local message = http:JSONEncode({
				Type = 'text',
				Content = dat,
				Author = owner.UserId,
				Nickname = nickname
			})
			mss:PublishAsync('comradio:' .. channel, message)
		else
			sendMessage('Cannot send messages while not connected to any channel!', 'SYSTEM')
		end
	elseif command[1] == 'image' then
		if channel then
			local message = http:JSONEncode({
				Type = 'image',
				Content = dat,
				Comment = command[2],
				Author = owner.UserId,
				Nickname = nickname
			})
			mss:PublishAsync('comradio:' .. channel, message)
		else
			sendMessage('Cannot send messages while not connected to any channel!', 'SYSTEM')
		end
	elseif mode == 'channel' then
		channel = dat
		if channel == '<GENERAL>' then
			channel = ''
		end
		connect()
	elseif mode == 'nickname' then
		nickname = dat
		sendMessage('Set nickname to ' .. nickname, 'ROSTER')
	elseif command[1] == 'ping' then
		if channel then
			local uid = players:GetUserIdFromNameAsync(dat)
			local message = http:JSONEncode({
				Type = 'ping',
				Content = tostring(uid),
				Comment = command[2],
				Author = owner.UserId,
				Nickname = nickname
			})
			mss:PublishAsync('comradio:' .. channel, message)
		else
			sendMessage('Cannot send messages while not connected to any channel!', 'SYSTEM')
		end
	elseif mode == 'roster' then
		roster = {}
		sendMessage('Requesting roster...', 'ROSTER')
		mss:PublishAsync('comradio:' .. channel, http:JSONEncode({
			Type = 'rosterRequest',
			Content = '',
			Author = owner.UserId
		}))
		task.wait(1)
		sendMessage('------ Roster ------', 'ROSTER')
		task.wait()
		for _, name in next, roster do
			sendMessage(name, 'ROSTER')
		end
		sendMessage('-----------------------', 'ROSTER')
	end
end)
