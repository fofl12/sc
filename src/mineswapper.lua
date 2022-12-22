local board = {}
local reality = {}
local whitelist = {'comsurg'}
local W, H, M = 20, 20, 60
local realmines = 0
owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 'm%' then
		local c = m:sub(3, -1):split(' ')
		if c[1] == 'add' then
			table.insert(whitelist, c[2])
		elseif c[1] == 'rem' then
			table.remove(whitelist, table.find(whitelist, c[2]))
		elseif c[1] == 'check' then
			local correctflags = 0
			local wrongflags = 0
			local explored = 0
			local exploded = 0
			for x = 1, W do
				for y = 1, H do
					local real = reality[x][y]
					local fake = board[x] and board[x][y] or 0
					if real.known() then
						if fake >= 0 then
							explored += 1
							print(x, y)
						else
							exploded += 1
						end
					end
					if real.flagged() then
						if fake >= 0 then
							wrongflags += 1
						else
							correctflags += 1
						end
					end
				end
			end
			reality[1][1].text.Text = 'Corr'
			reality[2][1].text.Text = 'ect '
			reality[3][1].text.Text = 'flags'
			local a = tostring(correctflags)
			for i = 1, #a do
				local c = a:sub(i, i)
				reality[i+3][1].text.Text = c
			end
			reality[#a+4][1].text.Text = '/'
			local b = tostring(realmines)
			for i = 1, #b do
				local c = b:sub(i, i)
				reality[i+4+#a][1].text.Text = c
				reality[i+5+#a][1].text.Text = ''
			end

			reality[1][2].text.Text = 'Wrong'
			reality[2][2].text.Text = 'flags'
			local a = tostring(wrongflags)
			for i = 1, #a do
				local c = a:sub(i, i)
				reality[i+2][2].text.Text = c
				reality[i+3][2].text.Text = ''
			end

			reality[1][3].text.Text = 'Expl'
			reality[2][3].text.Text = 'ored'
			local a = tostring(explored)
			for i = 1, #a do
				local c = a:sub(i, i)
				reality[i+2][3].text.Text = c
			end
			reality[#a+3][3].text.Text = '/'
			local b = tostring((W * H) - realmines)
			for i = 1, #b do
				local c = b:sub(i, i)
				reality[i+3+#a][3].text.Text = c
				reality[i+4+#a][3].text.Text = ''
			end

			reality[1][4].text.Text = 'Expl'
			reality[2][4].text.Text = 'oded'
			local a = tostring(exploded)
			for i = 1, #a do
				local c = a:sub(i, i)
				reality[i+2][4].text.Text = c
				reality[i+3][4].text.Text = ''
			end
		end
	end
end)

--[[
local numbers = {
	[-1] = "rbxassetid://8515641",
	[1] = "rbxassetid://5548832052",
	"rbxassetid://5548834628",
	"rbxassetid://5548835261",
	"rbxassetid://5548835724",
	"rbxassetid://5548836292",
	"rbxassetid://5548836955",
	"rbxassetid://5548839296",
	"rbxassetid://5548869953"
}
]]

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
	realmines += 1
	inc(x-1, y-1)
	inc(x, y-1)
	inc(x+1, y-1)
	inc(x-1, y)
	inc(x+1, y)
	inc(x-1, y+1)
	inc(x, y+1)
	inc(x+1, y+1)
end

local scale = 5
local lives = 3
local playing = true
for x = 1, W do
	reality[x] = {}
	for y = 1, H do
		local height = (math.noise(x * .1, y * .1, hmseed) + 1) * 8
		local button = Instance.new('Part')
		button.Anchored = true
		button.Size = Vector3.new(scale, height, scale)
		button.Position = offset + Vector3.new(x * scale, height / 2, y * scale)
		button.BrickColor = BrickColor.Green()
		button.Material = 'Grass'
		local g = Instance.new('SurfaceGui', button)
		g.Face = 'Top'
		g.CanvasSize = Vector2.new(50, 50)
		g.SizingMode = 'FixedSize'
		local t = Instance.new('TextBox', g)
		--t.Visible = false
		t.Rotation = 90
		t.ClearTextOnFocus = false
		t.TextEditable = false
		t.TextScaled = true
		t.Text = ''
		t.Size = UDim2.fromScale(1, 1)
		t.BackgroundTransparency = 1

		local clicky = Instance.new('Part', button)
		clicky.Size = Vector3.new(scale, 0.2, scale)
		clicky.Transparency = 1
		clicky.Anchored = true
		clicky.Position = offset + Vector3.new(x * scale, height, y * scale)

		local clicker = Instance.new('ClickDetector', clicky)

		local known = false
		local flagged = false
		clicker.RightMouseClick:Connect(function(plr)
			if known then return end
			if not table.find(whitelist, plr.Name) then return end
			flagged = not flagged
			if flagged then
				t.Text = 'F'
				t.TextColor3 = Color3.new(1, 1, 1)
				button.Color = Color3.new(0, 0, 1)
			else
				t.Text = ''
				t.TextColor3 = Color3.new()
				button.BrickColor = BrickColor.Green()
			end
		end)
		local function appear()
			if known then return end
			known = true
			local v = board[x] and board[x][y]
			button.BrickColor = BrickColor.White()
			if v then
				if v < 0 then
					t.Text = 'X'
					button.BrickColor = BrickColor.Red()
					local e = Instance.new('Explosion', script)
					e.Position = offset + Vector3.new(x * 4, height, y * 4)
					lives -= 1
					if playing and lives <= 0 then
						playing = false
						for x = 1, W do
							for y = 1, H do
								reality[x][y].appear()
								task.wait()
							end
						end
					end
				elseif v > 0 then
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

		local function idk(p)
			local allowed = false
			if p:IsA('Player') then
				allowed = table.find(whitelist, p.Name)
			else
				local h = p.Parent:FindFirstChild('Humanoid')
				if h then
					local plr = game:service'Players':GetPlayerFromCharacter(h.Parent)
					if table.find(whitelist, plr.Name) then
						allowed = true
					end
				end
			end
			if playing and allowed and not flagged then
				appear()
			end
		end
		clicky.Touched:Connect(idk)
		clicker.MouseClick:Connect(idk)

		button.Parent = script
		reality[x][y] = {
			appear = appear,
			flagged = function() return flagged end,
			known = function() return known end,
			cell = button,
			text = t
		}
	end
end