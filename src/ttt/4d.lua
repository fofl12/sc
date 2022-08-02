local offset = owner.Character.Head.Position - Vector3.new(0, 4)
local players = game:GetService('Players')

local grup = Instance.new('Model', script)
local sign = Instance.new('Part')
sign.Name = 'Head'
sign.Size = Vector3.new(5, 1, 1)
sign.Position = offset + Vector3.new(0, 0, 22)
sign.Parent = grup
local hum = Instance.new('Humanoid', grup)

local spot1 = Instance.new('Part')
spot1.Size = Vector3.new(4, 1, 4)
spot1.Position = offset + Vector3.new(-2, 0, -5)
spot1.BrickColor = BrickColor.Random()
spot1.Anchored = true
spot1.Parent = script

local spot2 = spot1:Clone()
spot2.Position = offset + Vector3.new(2, 0, -5)
do
	local complete = false
	repeat
		spot2.BrickColor = BrickColor.Random()
		complete = spot2.BrickColor ~= spot1.BrickColor
	until complete
end
spot2.Parent = script

local p1 = nil
local p2 = nil

spot1.Touched:Connect(function(p)
	local hum = p.Parent:FindFirstChild('Humanoid')
	if hum then
		local p = players:GetPlayerFromCharacter(p.Parent)
		if p ~= p2 and not p1 then
			p1 = p
		end
	end
end)
spot2.Touched:Connect(function(p)
	local hum = p.Parent:FindFirstChild('Humanoid')
	if hum then
		local p = players:GetPlayerFromCharacter(p.Parent)
		if true and not p2 then
			p2 = p
		end
	end
end)

local turn = 1
local nextTurn = false
local board = {}

local function claim()
	local spot = turn == 1 and spot1 or spot2
	local function claimed(x, y, z, w)
		local cell = board[x][y][z][w]
		return cell.BrickColor == spot.BrickColor
	end
	-- x claim
	for y = 0, 2 do
		for z = 0, 2 do
			for w = 0, 2 do
				if claimed(0, y, z, w) and claimed(1, y, z, w) and claimed(2, y, z, w)  then
					return true
				end
			end
		end
	end
	-- y claim
	for x = 0, 2 do
		for z = 0, 2 do
			for w = 0, 2 do
				if claimed(x, 0, z, w) and claimed(x, 1, z, w) and claimed(x, 2, z, w) then
					return true
				end
			end
		end
	end
	-- z claim
	for x = 0, 2 do
		for y = 0, 2 do
			for w = 0, 2 do
				if claimed(x, y, 0, w) and claimed(x, y, 1, w) and claimed(x, y, 2, w) then
					return true
				end
			end
		end
	end
	-- w claim
	for x = 0, 2 do
		for y = 0, 2 do
			for z = 0, 2 do
				if claimed(x, y, z, 0) and claimed(x, y, z, 1) and claimed(x, y, z, 2) then
					return true
				end
			end
		end
	end
	-- 3d diagonal claim
	for j = 1, 8 do
		local x = bit32.extract(j, 0) == 1
		local y = bit32.extract(j, 1) == 1
		local z = bit32.extract(j, 2) == 1
		for w = 0, 2 do
			local claim = true
			for i = 0, 2 do
				claim = claimed(x and 2-i or i, y and 2-i or i, z and 2-i or i, w)
				if not claim then
					break
				end
			end
			if claim then
				return true
			end
		end
	end
	for w = 0, 2 do
		-- XY diagonal claim
		for z = 0, 2 do
			if claimed(0, 0, z, w) and claimed(1, 1, z, w) and claimed(2, 2, z, w) then
				return true
			end
			if claimed(0, 2, z, w) and claimed(1, 1, z, w) and claimed(2, 0, z, w) then
				return true
			end
		end
		-- XZ diagonal claim
		for y = 0, 2 do
			if claimed(0, y, 0, w) and claimed(1, y, 1, w) and claimed(2, y, 2, w) then
				return true
			end
			if claimed(0, y, 2, w) and claimed(1, y, 1, w) and claimed(2, y, 0, w) then
				return true
			end
		end
		-- YZ diagonal claim
		for x = 0, 2 do
			if claimed(x, 0, 0, w) and claimed(x, 1, 1, w) and claimed(y, 2, 2, w) then
				return true
			end
			if claimed(x, 0, 2, w) and claimed(x, 1, 1, w) and claimed(x, 2, 0, w) then
				return true
			end
		end
	end
	
	return false
end

local defaultcolor = Instance.new('Part').BrickColor
for x = 0, 2 do
	board[x] = {}
	for y = 0, 2 do
		board[x][y] = {}
		for z = 0, 2 do
			board[x][y][z] = {}
			for w = 0, 2 do
				local cell = Instance.new('Part')
				cell.Size = Vector3.new(1, 1, 1)
				cell.Position = offset + Vector3.new((x * 3) - (w * 12) + 9, (y * 3) + 6, (z * 3))
				cell.Anchored = true
				cell.Transparency = 0.3
				cell.Parent = script
				local detector = Instance.new('ClickDetector', cell)
				detector.MouseClick:Connect(function(p)
					if cell.BrickColor ~= spot1.BrickColor and cell.BrickColor ~= spot2.BrickColor then
						if p == p1 and turn == 1 then
							cell.BrickColor = spot1.BrickColor
							cell.Transparency = 0
							nextTurn = true
							for i = 1, 5 do
								cell.Material = 'Neon'
								task.wait(0.2)
								cell.Material = 'Plastic'
								task.wait(0.2)
							end
						elseif p == p2 and turn == 2 then
							cell.BrickColor = spot2.BrickColor
							cell.Transparency = 0
							nextTurn = true
							for i = 1, 5 do
								cell.Material = 'Neon'
								task.wait(0.2)
								cell.Material = 'Plastic'
								task.wait(0.2)
							end
						end
					end
				end)
				board[x][y][z][w] = cell
			end
		end
	end
end

while true do
	turn = 1
	hum.DisplayName = spot1.BrickColor.Name .. ' Turn'
	repeat task.wait(0.1) until nextTurn
	if claim() then
		hum.DisplayName = spot1.BrickColor.Name .. ' Win!!!'
		return
	end
	nextTurn = false
	turn = 2
	hum.DisplayName = spot2.BrickColor.Name .. ' Turn'
	repeat task.wait(0.1) until nextTurn
	if claim() then
		hum.DisplayName = spot2.BrickColor.Name .. ' Win!!!'
		return
	end
	nextTurn = false
end