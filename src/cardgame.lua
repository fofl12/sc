local screen = Instance.new('Part')
screen.Position = owner.Character.Head.Position + owner.Character.Head.CFrame.LookVector * 6
screen.Size = Vector3.new(6, 6, 0)
screen.Transparency = 0.2
screen.Material = 'Glass'
screen.Anchored = true

local adversary = {'Battle Cat', 'rbxassetid://2994480258'}
local adialog = {'Ok', 'Ok', 'h'}
local me = {owner.DisplayName, 'rbxthumb://type=AvatarHeadShot&w=150&h=150&id=' .. owner.UserId}
local adcards = {}
local mecards = {}

local gui = Instance.new('SurfaceGui', screen)

local announce = Instance.new('TextBox', gui)
announce.AnchorPoint = Vector2.new(0, 1)
announce.Position = UDim2.fromScale(0, 1)
announce.Size = UDim2.fromScale(1, 0.2)
announce.TextSize = 30
announce.TextWrapped = true
announce.TextXAlignment = 'Left'
announce.TextYAlignment = 'Top'

local metab = Instance.new('Frame', gui)
metab.AnchorPoint = Vector2.new(0, 1)
metab.Position = UDim2.fromScale(0, 0.8)
metab.Size = UDim2.fromScale(1, 0.15)
metab.BackgroundColor3 = Color3.new()
local icon = Instance.new('ImageLabel', metab)
icon.Name = 'icon'
icon.Image = me[2]
icon.Size = UDim2.fromScale(0.15, 1)

local adtab = metab:Clone()
adtab.Parent = gui
adtab.Position = UDim2.fromScale(0,0)
adtab.AnchorPoint = Vector2.new(0,0)
local icon = adtab.icon
icon.Image = adversary[2]
icon.AnchorPoint = Vector2.new(1, 0)
icon.Position = UDim2.fromScale(1, 0)
local cardnum = Instance.new('TextBox', adtab)
cardnum.Name = 'cardnum'
cardnum.BackgroundTransparency = 1
cardnum.TextColor3 = Color3.new(1,1,1)
cardnum.Size = UDim2.fromScale(0.85, 1)
cardnum.TextXAlignment = 'Left'
cardnum.Text = 'Cards: 99'
cardnum.TextSize = 40

local play = Instance.new('TextBox', gui)
play.Size = UDim2.fromScale(0.35, 0.35)
play.AnchorPoint = Vector2.new(0.5, 0.5)
play.Position = UDim2.fromScale(0.5, 0.4)
play.TextScaled = true
play.Text = '...'

local deck = Instance.new('TextButton', gui)
deck.Size = UDim2.fromScale(0.2, 0.2)
deck.AnchorPoint = Vector2.new(0.5, 0.5)
deck.Position = UDim2.fromScale(0.15, 0.4)
deck.TextScaled = true
deck.Text = 'This is the deck'

local connection = Instance.new('RemoteFunction', owner.PlayerGui)
NLS([==[
local con = script.Parent
script.Parent = con.Parent
con.Parent = script

con.OnClientInvoke = function(cards, deck)
	local signals = {}
	local done
	for i, card in next, cards do
		signals[i] = card.Focused:Connect(function()
			for _, signal in next, signals do
				signal:Disconnect()
			end
			done = i
		end)
	end
	signals[0] = deck.MouseButton1Click:Connect(function()
		for _, signal in next, signals do
			signal:Disconnect()
		end
		done = 0
	end)
	repeat task.wait(0.5) until done
	return done
end
]==], connection)

screen.Parent = script

local function color(id)
	return id == 0 and Color3.new() or
		id == 1 and Color3.new(1, 0, 0) or
		id == 2 and Color3.new(1, 1, 0) or
		id == 3 and Color3.new(0, 1, 0) or
		Color3.new(0, 0, 1)
end
local function t(num)
	return num == 10 and '#' or tostring(num)
end

local function updateCards(existingRcards)
	cardnum.Text = 'Cards: ' .. #adcards
	if existingRcards then
		for _, card in next, existingRcards do
			card:Destroy()
		end
	end
	local rcards = {}
	for i, card in next, mecards do
		local button = Instance.new('TextBox')
		button.Size = UDim2.fromScale(0.05, 1)
		button.Position = UDim2.fromScale(0.2 + (i - 1) * 0.05)
		button.BackgroundTransparency = 0.2
		button.TextScaled = 1
		button.TextColor3 = color(card[2])
		button.Text = t(card[1])
		button.Parent = metab
		rcards[i] = button
	end
	return rcards
end

local win = false
local turn = false
local firstRound = true

local function legal(card)
	if firstRound then return true end
	if card[1] == 10 and card[2] == 0 then return true end
	if card[1] == 10 and play:GetAttribute'col' == card[2] then return true end
	if card[2] == 0 and play:GetAttribute'num' == card[1] then return true end
	if play:GetAttribute'num' == 10 and play:GetAttribute'col' == 0 then return true end
	if play:GetAttribute'col' == 0 and play:GetAttribute'num' == card[1] then return true end
	if play:GetAttribute'num' == 10 and play:GetAttribute'col' == card[2] then return true end
	if play:GetAttribute'col' == 0 and card[1] == 10 then return true end
	if play:GetAttribute'num' == 10 and card[2] == 0 then return true end
	return card[1] == play:GetAttribute'num' or card[2] == play:GetAttribute'col'
end
local function playcard(card)
	play.Text = t(card[1])
	play.TextColor3 = color(card[2])
	play:SetAttribute('num', card[1])
	play:SetAttribute('col', card[2])
end
local function randomCard()
	local num = math.random(0, 9)
	local col = math.random(1, 4)
	if math.random() < 0.05 then
		num = 0
	end
	if math.random() < 0.05 then
		col = 0
	end
	return {num,col}
end

for i = 1, 15 do
	adcards[i] = randomCard()
	mecards[i] = randomCard()
end
local rcards
repeat 
	announce.Text = (firstRound and (adversary[1] .. ': The adversary may play any card, since this is the first round') or (me[1] .. ': Thinking...'))
	turn = false
	rcards = updateCards(rcards)
	local selection = connection:InvokeClient(owner, rcards, deck)
	if selection == 0 then
		local new = randomCard()
		if legal(new) then
			playcard(new)
		else
			mecards[#mecards + 1] = new
		end
	else
		local card = mecards[selection]
		if not legal(card) then
			announce.Text = adversary[1] .. ': ' .. 'The adversary has utilized illegal cards and must forfeit the game at once'
			win = false
			task.wait(3)
			break
		end
		playcard(card)
		table.remove(mecards, selection)
	end
	if #mecards == 0 then
		win = true
		break
	end
	firstRound = false

	announce.Text = adversary[1] .. ': ' .. adialog[math.random(1, #adialog)]
	turn = true
	task.wait(2)
	local selection
	for i, card in next, adcards do
		if legal(card) then
			playcard(card)
			table.remove(adcards, i)
			selection = i
			break
		end
	end
	if not selection then
		local new = randomCard()
		if legal(new) then
			playcard(new)
		else
			adcards[#adcards + 1] = new
		end
	end
until #adcards == 0 or #mecards == 0
announce.Text = (win and adversary[1] or me[1]) .. ': Congratulations the adversary has won'