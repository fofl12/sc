-- Compiled with roblox-ts v1.2.9
-- Bloated comradio v2 client                             //
local ms = game:GetService("MessagingService")
local text = game:GetService("TextService")
local players = game:GetService("Players")
local http = game:GetService("HttpService")
local char = owner.Character
local head = char:FindFirstChild("Head")
local channel = ""
local NAME_COLORS = { Color3.new(), Color3.new(1 / 255, 162 / 255, 255 / 255), Color3.new(2 / 255, 184 / 255, 87 / 255), BrickColor.new("Bright violet").Color, BrickColor.new("Bright orange").Color, BrickColor.new("Bright yellow").Color, BrickColor.new("Light reddish violet").Color, BrickColor.new("Brick yellow").Color }
local function encode(input)
	local encoded = {}
	do
		local i = 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i <= #input) then
				break
			end
			local _i = i
			local _i_1 = i
			local c = string.sub(input, _i, _i_1)
			local _arg0 = (string.byte(c))
			-- ▼ Array.push ▼
			encoded[#encoded + 1] = _arg0
			-- ▲ Array.push ▲
		end
	end
	return encoded
end
local function xorEncrypt(input, password)
	local _arg0 = function(byte, index)
		return bit32.bxor(byte, password[index % #password + 1])
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#input)
	for _k, _v in ipairs(input) do
		_newValue[_k] = _arg0(_v, _k - 1, input)
	end
	-- ▲ ReadonlyArray.map ▲
	local encryptedArray = _newValue
	return table.concat(encryptedArray, " ")
end
local function xorDecrypt(input, password)
	local decrypted = ""
	local _exp = string.split(input, ";")
	local _arg0 = function(byte, index)
		local dec = tonumber(byte)
		local unlocked = bit32.bxor(dec, password[index % #password + 1])
		decrypted ..= string.char(unlocked)
	end
	-- ▼ ReadonlyArray.forEach ▼
	for _k, _v in ipairs(_exp) do
		_arg0(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
	return decrypted
end
local function GetNameValue(pName)
	local value = 0
	do
		local index = 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				index += 1
			else
				_shouldIncrement = true
			end
			if not (index < #pName) then
				break
			end
			local cValue = { string.byte(string.sub(pName, index, index)) }
			local reverseIndex = #pName - index + 1
			if #pName % 2 == 1 then
				reverseIndex = reverseIndex - 1
			end
			if reverseIndex % 4 >= 2 then
				cValue[1] = -cValue[1]
			end
			value += cValue[1]
		end
	end
	return value
end
local function ComputeNameColor(pName)
	return NAME_COLORS[GetNameValue(pName) % #NAME_COLORS + 1]
end
local function ExtractRGB(color)
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	return { r, g, b }
end
local function Format(text, color)
	local rgb = ExtractRGB(color)
	return '<font color="rgb(' .. (tostring(rgb[1]) .. (", " .. (tostring(rgb[2]) .. (", " .. (tostring(rgb[3]) .. (')">' .. (text .. "</font>")))))))
end
local function Tags(name)
	local tag = Format("[" .. (name .. "]: "), ComputeNameColor(name))
	return tag
end
local screen = Instance.new("Part", script)
screen.Material = Enum.Material.Glass
screen.BrickColor = BrickColor.new("Black")
screen.Transparency = 0.6
screen.Reflectance = 0.2
screen.Size = Vector3.new(10, 7, 1)
local _cFrame = head.CFrame
local _vector3 = Vector3.new(0, 0, -5)
screen.CFrame = _cFrame + _vector3
screen.Anchored = true
local gui = Instance.new("SurfaceGui", screen)
gui.Face = Enum.NormalId.Back
local scroller = Instance.new("ScrollingFrame", gui)
scroller.BackgroundTransparency = 1
scroller.Size = UDim2.fromScale(1, 1)
scroller.CanvasSize = UDim2.fromScale(1, 6)
local layout = Instance.new("UIListLayout", scroller)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.Name
local function output(text)
	local box = Instance.new("TextBox", scroller)
	box.BackgroundTransparency = 1
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Text = text
	box.Font = Enum.Font.SourceSans
	box.TextSize = 25
	box.RichText = true
	box.TextWrapped = true
	box.AutomaticSize = Enum.AutomaticSize.XY
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Top
	box.Name = tostring(os.clock())
	box.ClipsDescendants = false
	if #scroller:GetChildren() > 25 then
		local oldest
		local _exp = scroller:GetChildren()
		local _arg0 = function(element)
			if element:IsA("TextBox") then
				if not oldest then
					oldest = element
				elseif tonumber(oldest.Name) > tonumber(element.Name) then
					oldest = element
				end
			end
		end
		-- ▼ ReadonlyArray.forEach ▼
		for _k, _v in ipairs(_exp) do
			_arg0(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		oldest:Destroy()
	end
	return box
end
local function send(message, messagetype, author, comment)
	print("sending message as " .. tostring(author))
	local request = {
		Author = author,
		Content = message,
		Type = messagetype,
		Comment = comment,
	}
	ms:PublishAsync("comradio:" .. channel, http:JSONEncode(request))
end
local keys = {}
local exchanges = {}
local privateKey = math.random(1000000, 9999999)
local subscription
local function subscribe(name)
	local _result = subscription
	if _result ~= nil then
		_result:Disconnect()
	end
	subscription = ms:SubscribeAsync("comradio:" .. name, function(message)
		local request = http:JSONDecode(message.Data)
		print("received message from " .. tostring(request.Author))
		print("type: " .. request.Type)
		local author = game:GetService("Players"):GetNameFromUserIdAsync(request.Author)
		local messagetype = request.Type
		local tag = Tags(author)
		print(tag)
		if messagetype == "text" then
			local content = text:FilterStringAsync(request.Content, owner.UserId):GetChatForUserAsync(owner.UserId)
			local box = output(tag .. content)
		elseif messagetype == "welcome" then
			local box = output("Welcome, " .. (author .. '! Say "/rchelp" in the chat for a list of commands.'))
		elseif messagetype == "status" then
			local comment = text:FilterStringAsync(request.Comment, owner.UserId):GetChatForUserAsync(owner.UserId)
			local box = output(author .. ("s new status is " .. comment))
		elseif messagetype == "diffieHellmanExchange" then
			local comment = request.Comment
			local box = output(tag)
			local target = tonumber(string.split(comment, ";")[2])
			print(comment, request.Content)
			if target == owner.UserId then
				local _exp = string.split(comment, ";")[1]
				repeat
					if _exp == "1a" then
						exchanges[request.Author] = {}
						exchanges[request.Author].p = tonumber(string.split(request.Content, ";")[1])
						exchanges[request.Author].g = tonumber(string.split(request.Content, ";")[2])
						box:Destroy()
						local B = (bit32.bxor(exchanges[request.Author].g, privateKey)) % exchanges[request.Author].p
						send(request.Content .. ";" .. tostring(B), "diffieHellmanExchange", owner.UserId, "1b;" .. tostring(request.Author))
						break
					end
					if _exp == "1b" then
						exchanges[request.Author] = {}
						exchanges[request.Author].p = tonumber(string.split(request.Content, ";")[1])
						exchanges[request.Author].g = tonumber(string.split(request.Content, ";")[2])
						exchanges[request.Author].B = tonumber(string.split(request.Content, ";")[3])
						box:Destroy()
						local A = (bit32.bxor(exchanges[request.Author].g, privateKey)) % exchanges[request.Author].p
						send(tostring(A), "diffieHellmanExchange", owner.UserId, "2a;" .. tostring(request.Author))
						break
					end
					if _exp == "2a" then
						exchanges[request.Author].A = tonumber(request.Content)
						exchanges[request.Author].s = (bit32.bxor(exchanges[request.Author].A, privateKey)) % exchanges[request.Author].p
						send("confirmed", "diffieHellmanExchange", owner.UserId, "3;" .. tostring(request.Author))
						box:Destroy()
						break
					end
					if _exp == "2b" then
						exchanges[request.Author].s = (bit32.bxor(exchanges[request.Author].B, privateKey)) % exchanges[request.Author].p
						send("confirmed", "diffieHellmanExchange", owner.UserId, "3;" .. tostring(request.Author))
						box:Destroy()
						break
					end
					if _exp == "3" then
						box.Text ..= "[KEYS CONFIFRMED] You can now send encrypted messages to " .. author
						keys[request.Author] = exchanges[request.Author].s
						break
					end
				until true
			else
				box:Destroy()
			end
		else
			local comment = text:FilterStringAsync(request.Comment, owner.UserId):GetChatForUserAsync(owner.UserId)
			local box = output(tag .. comment)
			repeat
				if messagetype == "image" then
					print("image: " .. request.Content)
					local image = Instance.new("ImageLabel")
					image.Size = UDim2.fromOffset(300, 300)
					image.Position = UDim2.new(0, 5, 0, 25)
					image.ScaleType = Enum.ScaleType.Fit
					image.Image = request.Content
					image.Parent = box
					break
				end
				if messagetype == "sound" then
					print("sound: " .. request.Content)
					local button = Instance.new("TextButton")
					button.Size = UDim2.fromOffset(50, 50)
					button.Position = UDim2.new(0, 5, 0, 25)
					button.TextScaled = true
					button.BackgroundColor3 = Color3.new(0.1, 0.51, 0.98)
					button.Text = "▶"
					button.Parent = box
					local sound = Instance.new("Sound")
					sound.SoundId = request.Content
					sound.Volume = 1
					sound.Looped = true
					sound.Parent = box
					local playing = false
					button.MouseButton1Click:Connect(function()
						playing = not playing
						if playing then
							sound:Play()
							button.Text = "⏸"
						else
							sound:Pause()
							button.Text = "▶"
						end
					end)
					break
				end
				if messagetype == "ping" then
					local pingTarget = players:GetPlayerByUserId(tonumber(request.Content))
					if pingTarget then
						box.BackgroundTransparency = 0.8
						box.BackgroundColor3 = Color3.new(1, 0.8, 0.13)
						box.Text ..= " @" .. pingTarget.Name
					end
					break
				end
				if messagetype == "encrypted" then
					local messageTarget = tonumber(request.Content)
					if messageTarget == owner.UserId then
						-- eslint-disable-next-line roblox-ts/lua-truthiness
						local _value = keys[request.Author]
						if _value ~= 0 and (_value == _value and _value) then
							box.Text = tag .. "[ENCRYPTED] " .. xorDecrypt(comment, encode(tostring(keys[request.Author])))
						else
							box.Text = "[ERROR]: Received private message from " .. author .. ", but no keys are available to decrypt."
						end
					end
					break
				end
				box.Text ..= "[UNKNOWN MESSAGE TYPE]"
			until true
		end
	end)
end
subscribe("")
send("", "welcome", owner.UserId, "")
output("Using rorc v6 compliant with comradio Protocol v2")
local _exp = players:GetPlayers()
local _arg0 = function(player)
	player.Chatted:Connect(function(command)
		if string.sub(command, 1, 6) == "/send " then
			send(string.sub(command, 7, -1), "text", player.UserId, "")
		elseif string.sub(command, 1, 7) == "/image " then
			local split = string.split(string.sub(command, 8, -1), " ")
			local id = split[1]
			table.remove(split, 1)
			local comment = table.concat(split, " ")
			send(id, "image", player.UserId, comment)
		elseif string.sub(command, 1, 7) == "/sound " then
			local split = string.split(string.sub(command, 8, -1), " ")
			local id = split[1]
			table.remove(split, 1)
			local comment = table.concat(split, " ")
			send(id, "sound", player.UserId, comment)
		elseif string.sub(command, 1, 7) == "/rchelp" then
			output("--------------------- help ------------------------")
			output("/send [message] - send a text message")
			output("/image rbxassetid://[id] [comment] - send an image")
			output("/sound rbxassetid://[id] [comment] - send a sound")
			output("/status [status] - change your status")
			output("/ping [name] [comment] - ping someone")
			output("/list - see known channels")
			output("/switch [name] - switch to another channel")
			output("/keys [name] - confirm keys with someone")
			output("/private [name] [msg] - send a private message to someone [requires keys]")
			output("---------------------------------------------------")
		elseif string.sub(command, 1, 8) == "/switch " then
			channel = string.sub(command, 9, -1)
			output("switching to " .. channel)
			subscribe(channel)
			send("", "welcome", owner.UserId, "")
		elseif string.sub(command, 1, 8) == "/status " then
			local status = string.sub(command, 9, -1)
			send("", "status", player.UserId, status)
		elseif string.sub(command, 1, 6) == "/ping " then
			local split = string.split(string.sub(command, 7, -1), " ")
			local name = split[1]
			table.remove(split, 1)
			local comment = table.concat(split, " ")
			local id = players:GetUserIdFromNameAsync(name)
			send(tostring(id), "ping", player.UserId, comment)
		elseif string.sub(command, 1, 5) == "/list" then
			output("------- list -------")
			output("")
			output("coop")
			output("memes")
			output("scripting")
			output("feedback")
			output("questions")
			output("townhall")
			output("news")
			output("--------------------")
		elseif string.sub(command, 1, 6) == "/keys " then
			local split = string.split(string.sub(command, 7, -1), " ")
			local name = split[1]
			table.remove(split, 1)
			local comment = table.concat(split, ";")
			local id = players:GetUserIdFromNameAsync(name)
			send(comment, "diffieHellmanExchange", player.UserId, "1a;" .. tostring(id))
		elseif string.sub(command, 1, 9) == "/private " then
			local split = string.split(string.sub(command, 10, -1), " ")
			local name = split[1]
			table.remove(split, 1)
			local comment = table.concat(split, " ")
			local id = players:GetUserIdFromNameAsync(name)
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _value = keys[id]
			if _value ~= 0 and (_value == _value and _value) then
				local encrypted = xorEncrypt(encode(comment), encode(tostring(keys[id])))
				send(tostring(id), "encrypted", player.UserId, encrypted)
			else
				output("[ERROR]: Attempt to send private message to someone without encryption key")
			end
		end
	end)
end
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	_arg0(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
return nil
