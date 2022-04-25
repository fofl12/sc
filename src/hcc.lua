local ms = game:GetService('MessagingService')

local screen = Instance.new("Part", script)
screen.Material = Enum.Material.Glass
screen.BrickColor = BrickColor.new("Black")
screen.Transparency = 0.6
screen.Reflectance = 0.2
screen.Size = Vector3.new(10, 7, 1)
screen.CFrame = owner.Character.Head.CFrame + Vector3.new(0, 0, 5)
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
		for _, element in next, scroller:GetChildren() do
			if element:IsA("TextBox") then
				if not oldest then
					oldest = element
				elseif tonumber(oldest.Name) > tonumber(element.Name) then
					oldest = element
				end
			end
		end
		oldest:Destroy()
	end
	return box
end

local hostname = 'hcc-' .. owner.Name
local subscription
local channel
local function subscribe()
	if subscription then subscription:Disconnect() end
	output(('Connecting to %s...'):format(channel))
	subscription = ms:SubscribeAsync(channel, function(message)
		local sc = message.Data:split(' ')
		if sc[1] == 'INFO' and sc[2] ~= hostname then
			
		elseif sc[1] == 'SEND' then
			output(('[%s] [%s]: %s'):format(sc[2], sc[3], sc[5]))
		end
	end)
end

output('Hcc v1 for cogradio protocol v4')
output('Say /chelp for a list of commands')
for _, player in next, game.Players:GetPlayers() do
	player.Chatted:Connect(function(c)
		if c:sub(1, 6) == '/chelp' then
			output('------ help ------')
			output('/csay %s - send message')
			output('/connect %s - connect to channel')
			output('------------------')
		elseif c:sub(1, 5) == '/csay' then
			local message = c:sub(7, -1)
			print(message)
			ms:PublishAsync(channel, ('SEND %s %s ? %s'):format(hostname, player.Name, message))
		elseif c:sub(1, 8) == '/connect' and player == owner then
			channel = c:sub(10, -1)
			subscribe()
		end
	end)
end
