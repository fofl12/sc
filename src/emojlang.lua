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

local code = [[
📇🧵Hello, world!🧵
]]

sendMessage('Executing code: ', 'SYSTEM')
sendMessage(code, 'SYSTEM')
sendMessage('--------------------------', 'SYSTEM')

