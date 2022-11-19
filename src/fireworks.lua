local cs = game:service'CollectionService'
local debris = game:service'Debris'

local ipad = Instance.new('Tool', owner.Backpack)
ipad.Name = 'Ipad'
ipad.Grip = CFrame.new() * CFrame.Angles(0, math.pi / 2, 0)

local handle = Instance.new('Part', ipad)
handle.Name = 'Handle'
handle.Size = Vector3.new(3, 1, 4)

local gui = Instance.new('SurfaceGui', handle)
gui.Face = 'Top'

local frame = Instance.new('Frame', gui)
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.new()

local warning = Instance.new('TextBox', frame)
warning.Size = UDim2.fromScale(1, 1)
warning.TextScaled = true
warning.BackgroundColor3 = Color3.new(1)
warning.ZIndex = 100
warning.TextColor3 = Color3.new(1, 1)
warning.Text = 'FIRE IN THE HOLE'
warning.Visible = false

local ex = {
	'explosion',
	'expand',
	'ball',
	'doubleball',
	'robux',
	'burst'
}
local eType = 0
local explosionTypeButton = Instance.new('TextButton', frame)
explosionTypeButton.Size = UDim2.fromScale(.5, .3)
explosionTypeButton.Text = 'EType Unset'
explosionTypeButton.TextScaled = true
explosionTypeButton.BackgroundTransparency = 0.9
explosionTypeButton.TextColor3 = Color3.new(1, 1)
explosionTypeButton.MouseButton1Click:Connect(function()
	eType += 1
	eType = ((eType - 1) % #ex) + 1
	explosionTypeButton.Text = ex[eType]
end)

local eSize = 0
local explosionSizeButton = explosionTypeButton:Clone()
explosionSizeButton.Parent = frame
explosionSizeButton.Position = UDim2.fromScale(0, 0.3)
explosionSizeButton.Text = 'ESize Unset'
explosionSizeButton.MouseButton1Click:Connect(function()
	eSize += 1
	eSize %= 7
	explosionSizeButton.Text = 'S' .. ('|'):rep(eSize)
end)

local eShots = 0
local explosionShotsButton = explosionTypeButton:Clone()
explosionShotsButton.Parent = frame
explosionShotsButton.Position = UDim2.fromScale(0.5, 0.3)
explosionShotsButton.Text = 'EShots Unset'
explosionShotsButton.MouseButton1Click:Connect(function()
	eShots += 1
	eShots %= 7
	explosionShotsButton.Text = 'M' .. ('|'):rep(eShots)
end)

local em = {
	'strontium',
	'calcium',
	'sodium',
	'barium',
	'copper',
	'caesium',
	'aluminium'
}
local eMat = 0
local explosionMaterialButton = explosionTypeButton:Clone()
explosionMaterialButton.Parent = frame
explosionMaterialButton.Position = UDim2.fromScale(0, 0.6)
explosionMaterialButton.Text = 'EMat Unset'
explosionMaterialButton.MouseButton1Click:Connect(function()
	eMat += 1
	eMat = ((eMat - 1) % #em) + 1
	explosionMaterialButton.Text = em[eMat]
end)

local spawnButton = explosionSizeButton:Clone()
spawnButton.Parent = frame
spawnButton.Position = UDim2.fromScale(0.5, 0)
spawnButton.Text = 'Spawn'
spawnButton.MouseButton1Click:Connect(function()
	local pack = Instance.new('Part')
	pack.Size = Vector3.new(3, 1, 2)
	pack.Position = owner.Character.Torso.Position
	pack:SetAttribute('type', eType)
	pack:SetAttribute('size', eSize)
	pack:SetAttribute('color', eMat)
	pack:SetAttribute('shots', eShots)
	pack.Parent = workspace
	cs:AddTag(pack, 'firework')
end)

local fireButton = spawnButton:Clone()
fireButton.Parent = frame
fireButton.Position = UDim2.fromScale(0.5, 0.6)
fireButton.Text = 'Fire (Wifi)'
fireButton.MouseButton1Click:Connect(function()
	warning.Visible = true
	for _, pack in next, cs:GetTagged('firework') do
		if (pack.Position - handle.Position).Magnitude < 100 then
			local pos = pack.Position
			local t = pack:GetAttribute('type')
			local s = pack:GetAttribute('size') * 5
			local c = pack:GetAttribute('color')
			local shots = pack:GetAttribute('shots')
			for i = 1, shots do
				task.spawn(function()
					local pos = pos + Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1) * 5
					local s = s + (math.random() * 2 - 1) * 3
					local smoke = Instance.new('Smoke', pack)
					task.wait(5)
					Instance.new('Explosion', workspace).Position = pack.Position
					task.wait(.1)
					pack:Destroy()
					local beam = Instance.new('Part', script)
					beam.Size = Vector3.new(1, 6, 1)
					beam.Material = 'Neon'
					beam.Anchored = true
					beam.CanCollide = false
					beam.Color = Color3.new(1, 1, 1)
					for i = pos.Y, pos.Y + s * 4, 0.5 do
						task.wait()
						beam.Position = pos + Vector3.yAxis * i
					end
					local pos = pos + Vector3.yAxis * (s * 4)
					beam:Destroy()
					local color do
						color = 
							c == 1 and Color3.new(1) or
							c == 2 and Color3.new(0.8, 0.5) or
							c == 3 and Color3.new(0.5, 0.5) or
							c == 4 and Color3.new(0, 1) or
							c == 5 and Color3.new(0, 0, 1) or
							c == 6 and Color3.new(0.5, 0, 0.5) or
							c == 7 and Color3.new(1, 1, 1)
					end
					if t == 1 then
						for i = 1, 20 do
							local p = Instance.new('Part', script)
							p.Position = pos + Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
							p.Size = Vector3.one * 2
							p.Material = 'Neon'
							p.Color = color
							debris:AddItem(p, 1)
							local x = Instance.new('Explosion')
							x.Position = pos
							x.Parent = workspace
							task.wait(0.1)
						end
					elseif t == 2 then
						local ball = Instance.new('Part', script)
						ball.Material = 'Neon'
						ball.Shape = 'Ball'
						ball.Color = color
						ball.CanCollide = false
						ball.Anchored = true
						ball.Position = pos
						for i = 1, s, 0.1 do
							task.wait(.1 / s)
							ball.Size = Vector3.one * i
							if i >= s - 5 then
								ball.Transparency = 1 - (s - i) / 5
							end
						end
						ball:Destroy()
					elseif t == 3 then
						for i = 1, 60 do
							task.spawn(function()
								local r = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector
								local p = Instance.new('Part', script)
								p.Size = Vector3.one * 2
								p.Transparency = math.random() / 2
								p.Material = 'Neon'
								p.Color = color
								p.CanCollide = false
								p.Position = pos
								p:ApplyImpulse((r + Vector3.yAxis * math.random() * 4) * s * 30)
								debris:AddItem(p, 5)
							end)
						end
					elseif t == 4 then
						for i = 1, 30 do
							task.spawn(function()
								local r = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector
								local p = Instance.new('Part', script)
								p.Size = Vector3.one * 2
								p.Transparency = math.random() / 2
								p.Material = 'Neon'
								p.Color = color
								p.CanCollide = false
								p.Position = pos
								p:ApplyImpulse((r + Vector3.yAxis * math.random() * 4) * s * 30)
								task.wait(3)
								local pos = p.Position
								p:Destroy()
								for i = 1, 30 do
									task.spawn(function()
										local r = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector
										local p = Instance.new('Part', script)
										p.Size = Vector3.one * 2
										p.Transparency = math.random() / 2
										p.Material = 'Neon'
										p.Color = color
										p.CanCollide = false
										p.Position = pos
										p:ApplyImpulse((r + Vector3.yAxis * math.random() * 4) * s * 30)
										debris:AddItem(p, 6)
									end)
								end
							end)
						end
					elseif t == 5 then
						local function lerp(a, b, x)
							return a + (b - a) * x
						end
						local function p(x, y)
							local offset = Vector3.new(x, y)
							local r = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector
							local p = Instance.new('Part', script)
							p.Size = Vector3.one * 2
							p.Transparency = math.random() / 2
							p.Material = 'Neon'
							p.Color = color
							p.CanCollide = false
							p.Position = pos + offset
							p:ApplyImpulse(Vector3.new(offset.X, (offset.Y + 2.5), 0) * s * 5)
							debris:AddItem(p, 5)
						end
						for x = 0, 1, 0.2 do
							p(lerp(0, 5, x), lerp(5, 2, x))
						end
						for x = 0, 1, 0.2 do
							p(5, lerp(2, -2, x))
						end
						for x = 0, 1, 0.2 do
							p(lerp(5, 0, x), lerp(-2, -5, x))
						end
						for x = 0, 1, 0.2 do
							p(lerp(0, -5, x), lerp(-5, -2, x))
						end
						for x = 0, 1, 0.2 do
							p(-5, lerp(-2, 2, x))
						end
						for x = 0, 1, 0.2 do
							p(lerp(-5, 0, x), lerp(2, 5, x))
						end

						for x = -0.5, 0.5, 0.25 do
							for y = -0.5, 0.5, 0.25 do
								p(x, y)
							end
						end
					elseif t == 6 then
						for i = 1, 40 do
							task.spawn(function()
								local r = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector
								local p = Instance.new('Part', script)
								p.Size = Vector3.one * 2
								p.Transparency = math.random() / 2
								p.Material = 'Neon'
								p.Color = color
								p.CanCollide = false
								p.Position = pos
								p:ApplyImpulse((r + Vector3.yAxis * math.random() * 30) * s)
								debris:AddItem(p, 5)
							end)
						end
					end
				end)
				task.wait(2)
			end
		end
	end
	warning.Visible = false
end)