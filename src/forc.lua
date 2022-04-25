-- Compiled with roblox-ts v1.2.9
-- [BETA] comradio v3 client                              //
print("forc v1 compliant with comradio Protocol v3")
local NAME_COLORS = { Color3.new(), Color3.new(1 / 255, 162 / 255, 255 / 255), Color3.new(2 / 255, 184 / 255, 87 / 255), BrickColor.new("Bright violet").Color, BrickColor.new("Bright orange").Color, BrickColor.new("Bright yellow").Color, BrickColor.new("Light reddish violet").Color, BrickColor.new("Brick yellow").Color }
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
local function Tags(name, verified, nickname)
	local tag = Format("[" .. ((if verified then "✔️" else "❌") .. ("]" .. ((if nickname ~= "" and nickname then "[" .. nickname .. "]" else "") .. ("[" .. (name .. "]: "))))), ComputeNameColor("[" .. (name .. "]: ")))
	return tag
end
local function PrintToScreen(text)
	print(text)
end
local MessagingService = game:GetService("MessagingService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
print("Please enter your nickname.")
local nick = { owner.Chatted:Wait() }
print("> " .. tostring(nick))
local tokens = {}
local function CheckIfVerified(message)
	local token = tokens[message.author.id]
	if token ~= nil then
		if message.author.token == (bit32.bxor(bit32.bxor(token, message.author.id), message.sentTime)) then
			return true
		end
	end
	return false
end
local channel = "hub"
local connection
local function Connect(name)
	if connection then
		print("Disconnecting...")
		connection:Disconnect()
	end
	print("Connecting to comradio3." .. channel .. "...")
	connection = MessagingService:SubscribeAsync("comradio3." .. channel, function(data, sent)
		local decoded = HttpService:JSONDecode(data)
		if math.abs(os.time() - decoded.sentTime) > 30 then
			return nil
		end
		local authorName = Players:GetNameFromUserIdAsync(decoded.author.id)
		local verified = CheckIfVerified(decoded)
		local _exp = decoded.type
		repeat
			local _fallthrough = false
			if _exp == "verify" then
				if decoded.token ~= nil then
					tokens[decoded.author.id] = decoded.token
				end
				-- eslint-disable-next-line roblox-ts/lua-truthiness
				local _condition = decoded.author.nickname
				if not (_condition ~= "" and _condition) then
					_condition = authorName
				end
				PrintToScreen("(" .. (authorName .. (") " .. (_condition .. " has joined the channel."))))
				break
			end
			if _exp == "text" then
				PrintToScreen(Tags(authorName, verified, decoded.author.nickname))
			end
		until true
	end)
end
return nil
