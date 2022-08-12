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

local http = game:GetService('HttpService')
local xml = loadstring(http:GetAsync(
	'https://raw.githubusercontent.com/github-user123456789/xml2lua-roblox/master/XmlParser.lua'
))()
local handler = loadstring(http:GetAsync(
	'https://raw.githubusercontent.com/github-user123456789/xml2lua-roblox/master/xmlhandler/tree.lua'
))()


local feeds = {
	'https://raw.githubusercontent.com/fofl12/sc/main/src/feed.rss',
	'https://github.com/Anuken/Mindustry/releases.atom',
	'https://github.com/fofl12/sc/commits/main.atom',
	'https://archlinux.org/feeds/news/',
}
local items = {}
local months = {
	'Jan',
	'Feb',
	'Mar',
	'Apr',
	'May',
	'Jun',
	'Jul',
	'Aug',
	'Sep',
	'Oct',
	'Nov',
	'Dec'
}
for _, feed in next, feeds do
	local tree = handler:new()
	local parser = xml.new(tree, {
		stripWS = 1,
		expandEntities = 1,
		errorHandler = error
	})
	local doc =	http:GetAsync(feed)
	parser:parse(doc)
	local isAtom = tree.root.feed
	if isAtom then
		print(tree.root.feed)
		for k, item in pairs(tree.root.feed) do
			print(k, item)
			if k == 'entry' then
				if item.title then
					print(item.title, '-------------atom----')
					local date = DateTime.fromIsoDate(item.updated).UnixTimestamp
					table.insert(items, {
						name = tree.root.feed.title,
						title = item.title,
						desc = type(item.content) == 'string' and item.content or http:JSONEncode(item.content):sub(3, -3):gsub('\\n', '\n'),
						date = date
					})
				else
					for k, item in pairs(item) do
						print(item.title, '-------------atom----')
						local date = DateTime.fromIsoDate(item.updated).UnixTimestamp
						table.insert(items, {
							name = tree.root.feed.title,
							title = item.title,
							desc = type(item.content) == 'string' and item.content or http:JSONEncode(item.content):sub(3, -3):gsub('\\n', '\n'),
							date = date
						})
					end
				end
			end
		end
	else -- RSS
		for k, item in next, tree.root.rss.channel do
			if k == 'item' then
				if item.title then
					print(item.title, '-----')
					local date = item.pubDate:split(" ")
					local day = tonumber(date[2])
					local month = table.find(months, date[3]:sub(1, 3))
					local year = tonumber(date[4])
					local time = date[5]:split(':')
					local realdate = DateTime.fromUniversalTime(
						year, month, day,
						tonumber(time[1]), tonumber(time[2]), tonumber(time[3])
					).UnixTimestamp
					table.insert(items, {
						name = tree.root.rss.channel.title,
						title = item.title,
						desc = item.description,
						date = realdate
					})
				else
					for k, item in next, item do
						print(item.title, '-----')
						local date = item.pubDate:split(" ")
						local day = tonumber(date[2])
						local month = table.find(months, date[3]:sub(1, 3))
						local year = tonumber(date[4])
						local time = date[5]:split(':')
						local realdate = DateTime.fromUniversalTime(
							year, month, day,
							tonumber(time[1]), tonumber(time[2]), tonumber(time[3])
						).UnixTimestamp
						table.insert(items, {
							name = tree.root.rss.channel.title,
							title = item.title,
							desc = item.description,
							date = realdate
						})
					end
				end
			end
		end
	end
end
table.sort(items, function(a, b)
	return a.date > b.date
end)

local board = Instance.new('Part')
board.Position = owner.Character.Head.Position + Vector3.new(0, 2)
board.Size = Vector3.new(24, 12, 0)
board.Color = Color3.new()
board.Anchored = true
board.Transparency = 0.6
board.Material = 'Glass'
board.Parent = script

local gui = Instance.new('SurfaceGui', board)
gui.SizingMode = 'PixelsPerStud'

local chat = Instance.new('ScrollingFrame', gui)
chat.Size = UDim2.fromScale(1, 1)
chat.CanvasSize = UDim2.fromScale(1, 20)
chat.BackgroundTransparency = 1
local chatListLayout = Instance.new('UIListLayout', chat)
chatListLayout.FillDirection = 'Vertical'
chatListLayout.SortOrder = 'Name'
chatListLayout.HorizontalAlignment = 'Left'

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

local function sendMessage(text, author)
	local vis = chatText:Clone()
	vis.Text = ('<font color="%s">[%s]</font> %s'):format(getChatColor(author), author, text)
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

for _, item in ipairs(items) do
	print(item.name, item.title, item.desc)
	sendMessage('<b>' .. item.title .. '</b><br/>' .. item.desc, item.name)
end
