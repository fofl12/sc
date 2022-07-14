local offset = owner.Character.Head.Position
local mps = game:GetService('MarketplaceService')
local power = 0
local powerstage = 1
local generation = 30
local robucgks = 100
local filterPrice = 100
local powerPrice = 120
local filterStage = 0
local conveyerSpeed = 6

-- Master conveyer
local mconveyer = Instance.new('Part')
mconveyer.Position = offset + Vector3.new(512, -3, -17)
mconveyer.Size = Vector3.new(1024, 2, 10)
mconveyer.Velocity = Vector3.new(-conveyerSpeed, 0, 0)
mconveyer.Anchored = true
mconveyer.BrickColor = BrickColor.new(29)
mconveyer.Parent = script

local debris = game:GetService('Debris')
-- Conveyers
for i = 1, math.floor(mconveyer.Size.X / 10) do
	local grup = Instance.new('Model', script)
	local conveyer = mconveyer:Clone()
	conveyer.Name = 'Head'
	conveyer.Position = offset + Vector3.new((i * 10), -2.9, -4)
	conveyer.Size = Vector3.new(3, 2, 20)
	conveyer.Transparency = 0.5
	conveyer.CanCollide = false
	conveyer.Velocity = Vector3.new(0, 0, -6)
	conveyer.Parent = grup
	local dropperStage = 0
	local price = i * 60
	local dropperPrice = i * 40
	local clicker = Instance.new('ClickDetector', conveyer)

	local hum = Instance.new('Humanoid', grup)
	hum.DisplayName = 'Conveyer ' .. i ..'\nConveyer price: ' .. price .. '\nDropper price: ' .. dropperPrice

	clicker.MouseClick:Connect(function()
		if conveyer.Transparency == 0.5 then
			if robucgks >= price and power + (i * 5) <= generation * powerstage then
				print('Buy Conveyer')
				robucgks -= price
				conveyer.Transparency = 0
				conveyer.CanCollide = true
				power += i * 5
				while true do
					task.wait(2)
					if power <= powerstage * generation then
						conveyer.Velocity = Vector3.new(0, 0, -6)
					else
						conveyer.Velocity = Vector3.new()
					end
				end
			end
		else
			if robucgks >= dropperPrice and dropperStage < 4 and power + (i * 5) <= generation * powerstage then
				robucgks -= dropperPrice
				dropperStage += 1
				dropperPrice += i * 10
				hum.DisplayName = 'Conveyer ' .. i ..'\nConveyer price: ' .. price .. '\nDropper price: ' .. dropperPrice
				local x = conveyer.Position.X + (dropperStage % 2 == 0 and 3 or -3)
				local y = conveyer.Position.Z + (dropperStage < 3 and 2 or -2)
				power += i * 5
				local dropper = Instance.new('Part')
				dropper.Size = Vector3.new(2, 4, 2)
				dropper.Anchored = true
				dropper.Position = Vector3.new(x, 2, y)
				dropper.Parent = script
				print('New Dropper')
				while true do
					task.wait(2)
					if power <= powerstage * generation then
						local block = Instance.new('Part')
						block.Size = Vector3.one
						block.Color = Color3.new(0.2, 0.2, 0.2)
						block.Position = Vector3.new(conveyer.Position.X, 4, y)
						block.Parent = dropper
						block.Name = 'Food'
						block:SetAttribute('worth', 2)
						block:SetAttribute('isFood', true)
						debris:AddItem(block, i * 30)
					end
				end
			end
		end
	end)
end

-- Filters
local filter1 = Instance.new('Part')
filter1.Anchored = true
filter1.CanCollide = false
filter1.Transparency = 1
filter1.Size = Vector3.new(1, 4, 10)
filter1.Position = mconveyer.Position + Vector3.new(-490, 2, 0)
filter1.Touched:Connect(function(o)
	if filter1.Transparency == 0.5 then
		o.BrickColor = BrickColor.Random()
		o:SetAttribute('worth', o:GetAttribute('worth') + math.random(1, 2))
	end
end)
filter1.Parent = script
local filter2 = filter1:Clone()
filter2.Position = mconveyer.Position + Vector3.new(-450, 2, 0)
filter2.Touched:Connect(function(o)
	if filter2.Transparency == 0.5 then
		o.Size = Vector3.new(math.random(1, 2), math.random(1, 2), math.random(1, 2))
		o:SetAttribute('worth', o:GetAttribute('worth') + math.random(1, 3))
	end
end)
filter2.Parent = script
local filter3 = filter1:Clone()
filter3.Position = mconveyer.Position + Vector3.new(-300, 2, 0)
filter3.Touched:Connect(function(o)
	if filter3.Transparency == 0.5 and math.random() < 0.6 then
		o.Shape = math.random() < 0.5 and Enum.PartType.Ball or Enum.PartType.Cylinder
		o:SetAttribute('worth', o:GetAttribute('worth') + math.random(3, 5))
	end
end)
filter3.Parent = script

-- Salerman
local grup = Instance.new'Model'
local hum = Instance.new('Humanoid', grup)
hum.DisplayName = 'ROBUCGKS!!!!!!!!!'
local saler = Instance.new('Part')
saler.Name = 'Head'
saler.Anchored = true
saler.Transparency = 0.5
saler.Position = mconveyer.Position + Vector3.new(-517, 0, 0)
saler.Size = Vector3.new(10, 1, 10)
saler.Parent = grup
grup.Parent = script
local music = Instance.new('Sound', saler)
music.SoundId = 'rbxassetid://7023598688'
music.Looped = true
music:Play()

saler.Touched:Connect(function(p)
	if p:IsA('BasePart') then
		local val = p:GetAttribute('worth') or 1
		robucgks += val
		pcall(p.Destroy, p)
	end
end)
task.spawn(function()
	while true do
		task.wait(1)
		hum.DisplayName = ('ROBUCGKS: %i\nPowerGen GREEN pric: %i     Filter BLUE pric: %i\nPower (consumption/generation): %i/%i\nConveyer speed boost YELLOW: %s  Power generation boost RED: %s'):format(robucgks, powerPrice, filterPrice, power, generation * powerstage, tostring(conveyerSpeed > 7), tostring(generation > 31))
	end
end)

local visualPower = Instance.new('Part')
visualPower.Position = mconveyer.Position + Vector3.new(0, 5, -8)
visualPower.Size = Vector3.new(5, 10, 10)
visualPower.Anchored = true
visualPower.Parent = script
visualPower.Touched:Connect(function(p)
	local hum = p.Parent:FindFirstChild('Humanoid')
	if hum then
		hum:TakeDamage(40)
	end
end)
local powerDecal = Instance.new('Decal', visualPower)
powerDecal.Texture = 'rbxassetid://67728428'
powerDecal.Face = 'Back'

local powergenBuy = Instance.new('Part')
powergenBuy.Anchored = true
powergenBuy.Size = Vector3.one
powergenBuy.BrickColor = BrickColor.Green()
powergenBuy.Position = saler.Position + Vector3.new(-2, 0, 6)
local powerGenBuyClicker = Instance.new('ClickDetector', powergenBuy)
powerGenBuyClicker.MouseClick:Connect(function()
	if robucgks >= powerPrice then
		robucgks -= powerPrice
		powerstage *= 2
		powerPrice += 120
		visualPower.Size += Vector3.new(5, 0, 0)
	end
end)
powergenBuy.Parent = script

local filterBuy = Instance.new('Part')
filterBuy.Anchored = true
filterBuy.Size = Vector3.one
filterBuy.BrickColor = BrickColor.Blue()
filterBuy.Position = saler.Position + Vector3.new(2, 0, 6)
local filterBuyClicker = Instance.new('ClickDetector', filterBuy)
filterBuyClicker.MouseClick:Connect(function()
	if robucgks - filterPrice >= 0 and power + 10 <= generation * powerstage and filterStage < 3 then
		robucgks -= filterPrice
		filterStage += 1
		filterPrice += 100
		power += 10
		if filterStage == 1 then
			filter1.Transparency = 0.5
		elseif filterStage == 2 then
			filter2.Transparency = 0.5
		elseif filterStage == 3 then
			filter3.Transparency = 0.5
		end
	end
end)
filterBuy.Parent = script

local conveyerSpeedBuy = Instance.new('Part')
conveyerSpeedBuy.Anchored = true
conveyerSpeedBuy.Size = Vector3.one
conveyerSpeedBuy.BrickColor = BrickColor.Yellow()
conveyerSpeedBuy.Position = saler.Position + Vector3.new(1, 0, 6)
local conveyerSpeedClicker = Instance.new('ClickDetector', conveyerSpeedBuy)
conveyerSpeedClicker.MouseClick:Connect(function(p)
	if mps:UserOwnsGamePassAsync(p.UserId, 60776802) then
		conveyerSpeed = 60
		mconveyer.Velocity = Vector3.new(-conveyerSpeed, 0, 0)
	elseif conveyerSpeed < 60 then
		mps:PromptGamePassPurchase(p, 60776802)
	end
end)
conveyerSpeedBuy.Parent = script

local betterButton = conveyerSpeedBuy:Clone()
betterButton.Position = saler.Position + Vector3.new(0, 0, 6)
betterButton.BrickColor = BrickColor.Red()
betterButton.ClickDetector.MouseClick:Connect(function(p)
	if not debonk then
		debonk = true
		if mps:UserOwnsGamePassAsync(p.UserId, 60736939) then
			generation = 60
		elseif generation < 60 then
			mps:PromptGamePassPurchase(p, 60736939)
		end
		task.wait(1)
		debonk = false
	end
end)
betterButton.Parent = script
