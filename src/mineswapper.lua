local board = {}
local reality = {}

local W, H, M = 20, 20, 60
local hmseed = math.random() * 100
local offset = owner.Character.Head.Position - Vector3.yAxis * 4.5
print(hmseed)

local function inc(x, y)
	if x >= 1 and x <= W and y >= 1 and y <= H then
		if not board[x] then
			board[x] = {}
		end
		if not board[x][y] then
			board[x][y] = 0
		end
		if board[x][y] >= 0 then
			board[x][y] += 1
		end
	end
end

for _ = 1, M do
	local x, y = math.random(1, W), math.random(1, H)
	if not board[x] then board[x] = {} end
	if board[x][y] == -1 then continue end
	if (x == 1 or x == W) and (y == 1 or y == H) then continue end
	board[x][y] = -1
	inc(x-1, y-1)
	inc(x, y-1)
	inc(x+1, y-1)
	inc(x-1, y)
	inc(x+1, y)
	inc(x-1, y+1)
	inc(x, y+1)
	inc(x+1, y+1)
end

local playing = true
for x = 1, W do
	reality[x] = {}
	for y = 1, H do
		local height = (math.noise(x * .1, y * .1, hmseed) + 1) * 6
		local button = Instance.new('Part')
		button.Anchored = true
		button.Size = Vector3.new(4, height, 4)
		button.Position = offset + Vector3.new(x * 4, height / 2, y * 4)
		button.BrickColor = BrickColor.Green()
		button.Material = 'Grass'
		local g = Instance.new('SurfaceGui', button)
		g.Face = 'Top'
		g.CanvasSize = Vector2.new(50, 50)
		g.SizingMode = 'FixedSize'
		local t = Instance.new('TextBox', g)
		t.TextEditable = false
		t.Text = ''
		t.TextScaled = true
		t.Size = UDim2.fromScale(1, 1)
		t.BackgroundTransparency = 1

		local known = false
		local function appear()
			if known then return end
			known = true
			local v = board[x] and board[x][y]
			button.BrickColor = BrickColor.White()
			if v then
				if v < 0 then
					button.BrickColor = BrickColor.Red()
					t.Text = 'X'
					local e = Instance.new('Explosion', script)
					e.Position = offset + Vector3.new(x * 4, height, y * 4)
					if playing then
						playing = false
						for x = 1, W do
							for y = 1, H do
								reality[x][y]()
								task.wait()
							end
						end
					end
				else
					t.Text = v
					t.TextColor3 = 
						v == 1 and Color3.new(0.5, 0, 0) or
						v == 2 and Color3.new(0.5, 0.25, 0) or
						v == 3 and Color3.new(0.5, 0.5, 0) or
						v == 4 and Color3.new(0.25, 0.5, 0) or
						v == 5 and Color3.new(0, 0.5, 0) or
						v == 6 and Color3.new(0, 0.5, 0.25) or
						v == 7 and Color3.new(0, 0.5, 0.5) or
						v == 8 and Color3.new(0, 0.25, 0.5)
				end
			end
		end

		button.Touched:Connect(function(p)
			if playing and (p.Name == 'Left Leg' or p.Name == 'Right Leg') then
				appear()
			end
		end)

		button.Parent = script
		reality[x][y] = appear
	end
end