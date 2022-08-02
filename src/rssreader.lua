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
function newParser()

    XmlParser = {};

    function XmlParser:ToXmlString(value)
        value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
        value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
        value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
        value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
        value = string.gsub(value, "([^%w%&%;%p%\t% ])",
            function(c)
                return string.format("&#x%X;", string.byte(c))
            end);
        return value;
    end

    function XmlParser:FromXmlString(value)
        value = string.gsub(value, "&#x([%x]+)%;",
            function(h)
                return string.char(tonumber(h, 16))
            end);
        value = string.gsub(value, "&#([0-9]+)%;",
            function(h)
                return string.char(tonumber(h, 10))
            end);
        value = string.gsub(value, "&quot;", "\"");
        value = string.gsub(value, "&apos;", "'");
        value = string.gsub(value, "&gt;", ">");
        value = string.gsub(value, "&lt;", "<");
        value = string.gsub(value, "&amp;", "&");
        return value;
    end

    function XmlParser:ParseArgs(node, s)
        string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
            node:addProperty(w, self:FromXmlString(a))
        end)
    end

    function XmlParser:ParseXmlText(xmlText)
        local stack = {}
        local top = newNode()
        table.insert(stack, top)
        local ni, c, label, xarg, empty
        local i, j = 1, 1
        while true do
            ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
            if not ni then break end
            local text = string.sub(xmlText, i, ni - 1);
            if not string.find(text, "^%s*$") then
                local lVal = (top:value() or "") .. self:FromXmlString(text)
                stack[#stack]:setValue(lVal)
            end
            if empty == "/" then -- empty element tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                top:addChild(lNode)
            elseif c == "" then -- start tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                table.insert(stack, lNode)
		top = lNode
            else -- end tag
                local toclose = table.remove(stack) -- remove top

                top = stack[#stack]
                if #stack < 1 then
                    error("XmlParser: nothing to close with " .. label)
                end
                if toclose:name() ~= label then
                    error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
                end
                top:addChild(toclose)
            end
            i = j + 1
        end
        local text = string.sub(xmlText, i);
        if #stack > 1 then
            error("XmlParser: unclosed " .. stack[#stack]:name())
        end
        return top
    end

    function XmlParser:loadFile(xmlFilename, base)
        if not base then
            base = system.ResourceDirectory
        end

        local path = system.pathForFile(xmlFilename, base)
        local hFile, err = io.open(path, "r");

        if hFile and not err then
            local xmlText = hFile:read("*a"); -- read file content
            io.close(hFile);
            return self:ParseXmlText(xmlText), nil;
        else
            print(err)
            return nil
        end
    end

    return XmlParser
end

function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}

    function node:value() return self.___value end
    function node:setValue(val) self.___value = val end
    function node:name() return self.___name end
    function node:setName(name) self.___name = name end
    function node:children() return self.___children end
    function node:numChildren() return #self.___children end
    function node:addChild(child)
        if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
                local tempTable = {}
                table.insert(tempTable, self[child:name()])
                self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
        else
            self[child:name()] = child
        end
        table.insert(self.___children, child)
    end

    function node:properties() return self.___props end
    function node:numProperties() return #self.___props end
    function node:addProperty(name, value)
        local lName = "@" .. name
        if self[lName] ~= nil then
            if type(self[lName]) == "string" then
                local tempTable = {}
                table.insert(tempTable, self[lName])
                self[lName] = tempTable
            end
            table.insert(self[lName], value)
        else
            self[lName] = value
        end
        table.insert(self.___props, { name = name, value = self[name] })
    end

    return node
end

local xml = newParser()

local feeds = {
	'https://raw.githubusercontent.com/fofl12/sc/main/src/feed.rss',
	'https://archlinux.org/feeds/news/',
}
local http = game:GetService('HttpService')
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
	local doc = xml:ParseXmlText(http:GetAsync(feed))
	for _, item in next, doc.rss.channel:children() do
		if item.title then
			print(item.title:value(), '-----')
			local date = item.pubDate:value():split(" ")
			print(item.pubDate:value())
			local day = tonumber(date[2])
			local month = table.find(months, date[3]:sub(1, 3))
			print(month)
			local year = tonumber(date[4])
			local time = date[5]:split(':')
			local realdate = DateTime.fromUniversalTime(
				year, month, day,
				tonumber(time[1]), tonumber(time[2]), tonumber(time[3])
			).UnixTimestamp
			table.insert(items, {
				name = doc.rss.channel.title:value(),
				title = item.title:value(),
				desc = item.description:value(),
				date = realdate
			})
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
	sendMessage('<b>' .. item.title .. '</b><br/>' .. item.desc, item.name)
end
