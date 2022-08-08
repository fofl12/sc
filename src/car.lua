local origin = owner.Character.Head.Position

local ball = Instance.new('Part')
ball.BrickColor = BrickColor.Blue()
ball.Shape = 'Ball'
ball.Size = Vector3.one * 3
ball.Material = 'Neon'
ball.Position = origin + Vector3.new(0, 2, 10)
ball.Anchored = true
ball.Touched:Connect(game.Destroy)
ball.Parent = script

local coolant = false
local heatant = false

local coolantButton = Instance.new('Part')
coolantButton.Size = Vector3.one
coolantButton.Position = origin + Vector3.new(6, 0, -1)
coolantButton.BrickColor = BrickColor.Blue()
coolantButton.Anchored = true
local coolantClicker = Instance.new('ClickDetector', coolantButton)
local debonk = false
coolantClicker.MouseClick:Connect(function()
	if not debonk then
		debonk = true
		coolant = not coolant
		task.wait(1)
		debonk = false
	end
end)
coolantButton.Parent = script

local heatantButton = coolantButton:Clone()
heatantButton.Position = origin + Vector3.new(6, 0, 1)
heatantButton.BrickColor = BrickColor.Red()
heatantButton.ClickDetector.MouseClick:Connect(function()
	if not debonk then
		debonk = true
		heatant = not heatant
		task.wait(1)
		debonk = false
	end
end)
heatantButton.Parent = script

local heatantSupply = 100
local coolantSupply = 100

local coolantBank = coolantButton:Clone()
coolantBank.Size = Vector3.one * 3
coolantBank.Position = origin + Vector3.new(-4, 0, -12)
coolantBank:ClearAllChildren()
local coolantPrompt = Instance.new('ProximityPrompt', coolantBank)
coolantPrompt.ActionText = 'Refuel coolant'
coolantPrompt.HoldDuration = 3.5
coolantPrompt.Triggered:Connect(function()
	coolantSupply = 100
end)
coolantBank.Parent = script

local heatantBank = coolantBank:Clone()
heatantBank.Position = origin + Vector3.new(4, 0, -12)
heatantBank.BrickColor = BrickColor.Red()
heatantBank.ProximityPrompt.ActionText = 'Refuel heatant'
heatantBank.ProximityPrompt.Triggered:Connect(function()
	heatantSupply = 100
end)
heatantBank.Parent = script

local coolantOverdrive = false
local coolantOverdriveBank = coolantBank:Clone()
coolantOverdriveBank.Position += Vector3.new(-6, 0, 0)
coolantOverdriveBank.ProximityPrompt.ActionText = 'Toggle coolant overdrive'
coolantOverdriveBank.ProximityPrompt.HoldDuration = 5
coolantOverdriveBank.ProximityPrompt.Triggered:Connect(function()
	coolantOverdrive = not coolantOverdrive
	coolantSupply -= 4
end)
coolantOverdriveBank.Parent = script

local temp = 0

local infoLabel
do
	local infoPanel = Instance.new('Part')
	infoPanel.Size = Vector3.new(4, 3, 0.1)
	infoPanel.BrickColor = BrickColor.Black()
	infoPanel.Rotation = Vector3.new(0, -90, 0)
	infoPanel.Anchored = true
	infoPanel.Position = origin + Vector3.new(-6, 0, 0)
	local infoGui = Instance.new('SurfaceGui', infoPanel)
	local infoFrame = Instance.new('Frame', infoGui)
	infoFrame.Size = UDim2.fromScale(0.9, 0.9)
	infoFrame.Position = UDim2.fromScale(0.05, 0.05)
	infoFrame.BackgroundColor3 = Color3.new()
	infoLabel = Instance.new('TextBox', infoFrame)
	infoLabel.Size = UDim2.fromScale(1, 1)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextXAlignment = 'Left'
	infoLabel.TextYAlignment = 'Top'
	infoLabel.TextSize = 40
	infoLabel.TextWrapped = true
	infoLabel.Font = 'Code'
	infoLabel.TextColor3 = Color3.fromRGB(130, 242, 145)
	infoLabel.Text = 'RobuxDevice'
	infoPanel.Parent = script
end

local powerRequest = 500
local totalProfit = 0
local profit = 0

while true do
	task.wait(1)
	if heatantSupply == 0 then
		heatant = false
	elseif heatantSupply < 0 then
		heatantBank:Destroy()
		heatant = false
		heatantSupply = 0
	end
	heatantSupply -= heatant and 5 or 0
	if coolantSupply == 0 then
		coolant = false
	elseif coolantSupply < 0 then
		coolantBank:Destroy()
		coolant = false
		coolantSupply = 0
	end
	coolantSupply -= coolant and (coolantOverdrive and 12 or 5) or 0
	temp += (heatant and 5 or 0) + (coolant and (coolantOverdrive and -12 or -5) or 0)
	local powerGen = temp * 5
	if os.time() % 10 == 0 then
		profit = (powerGen - powerRequest) / 2
		totalProfit += profit
	end
	if os.time() % 50 == 0 then
		powerRequest = math.random(300, 450)
	end
	local state = ''
	if temp > 180 then
		state = '[ MELTDOWN ]'
		temp *= 2
		ball.Size *= 1.5
		local explosion = Instance.new('Explosion')
		explosion.BlastRadius = ball.Size.X * 1.5
		explosion.Position = ball.Position
		explosion.Parent = ball
		ball.BrickColor = BrickColor.Red()
	elseif temp > 150 then
		state = '[ CRITICAL ]'
		temp *= 1.05
	elseif temp > 80 then
		state = '[ OVERHEATING ]'
		temp *= 1.02
		ball.BrickColor = BrickColor.new(106)
	elseif temp > -15 then
		state = '[ OK ]'
		ball.BrickColor = BrickColor.Blue()
	elseif temp > -60 then
		state = '[ ??? ]'
		coolant = true
		temp -= 3
		coolantSupply -= 3
	else
		state = '[ STALLING ]'
		temp *= 3
		coolantSupply = -500
		ball.Size *= 0.6
	end
	infoLabel.Text = ([[----- REACTOROS -------------------
> State: %s
> Temperature: %i
> Coolant: %s ; Heatant: %s
    Supplies
> Coolant supply: %i%%
> Heatant supply: %i%%
    Power generation
> Power gen/request: %i/%i
> Profit: %i robucgks
> Total profit: %i robucgks]]):format(state, temp, coolant and 'ON' or 'OFF', heatant and 'ON' or 'OFF', coolantSupply, heatantSupply, powerGen, powerRequest, profit, totalProfit)
end
