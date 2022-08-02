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
spot1.BrickColor = BrickColor.Black()
spot1.Anchored = true
spot1.Parent = script

local spot2 = spot1:Clone()
spot2.Position = offset + Vector3.new(2, 0, -5)
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

local function claim(zx, zy)
	local function claimed(b)
		return b.BrickColor == spot1.BrickColor
	end
	-- horizontal claim
	for z = 0, 2 do
		if claimed(board[zx][zy + z]) and claimed(board[zx + 1][zy + z]) and claimed(board[zx + 2][zy + z]) then
			return true
		end
	end
	-- vertical claim
	for z = 0, 2 do
		if claimed(board[zx + z][zy]) and claimed(board[zx + z][zy + 1]) and claimed(board[zx + z][zy + 2]) then
			return true
		end
	end
	-- diagonal claim
	if claimed(board[zx][zy]) and claimed(board[zx + 1][zy + 1]) and claimed(board[zx + 2][zy + 2]) then
		return true
	end
	if claimed(board[zx][zy + 2]) and claimed(board[zx + 1][zy + 1]) and claimed(board[zx + 2][zy]) then
		return true
	end
	return false
end
local function superclaim()
	local function claimed(x, y)
		return claim(x * 3, y * 3)
	end
	local boards = 0
	for x = 0, 1 do
		for y = 0, 1 do
			if claimed(x, y) then
				boards += 1
			end
		end
	end
	return boards == 4
end

local defaultcolor = Instance.new('Part').BrickColor
for x = 0, 5 do
	board[x] = {}
	for y = 0, 5 do
		local zx, zy = math.floor(x / 3) * 3, math.floor(y / 3) * 3
		local cell = Instance.new('Part')
		cell.Size = Vector3.new(1.5, 1, 1.5)
		cell.Position = offset + Vector3.new((x * 2) + (zx * 0.25) - 5, 0, (y * 2) + (zy * 0.25))
		cell.Anchored = true
		cell.Parent = script
		local detector = Instance.new('ClickDetector', cell)
		detector.MouseClick:Connect(function(p)
			if cell.BrickColor ~= spot1.BrickColor and cell.BrickColor ~= spot2.BrickColor then
				if p == p1 and turn == 1 then
					cell.BrickColor = spot1.BrickColor
					if claim(zx, zy) then
						for x = zx, zx + 2 do
							for y = zy, zy + 2 do
								board[x][y].BrickColor = spot1.BrickColor
							end
						end
					end
					nextTurn = true
				elseif p == p2 and turn == 2 then
					cell.BrickColor = spot2.BrickColor
					if claim(zx, zy) then
						for x = zx, zx + 2 do
							for y = zy, zy + 2 do
								board[x][y].BrickColor = spot2.BrickColor
							end
						end
					end
					nextTurn = true
				end
			end
		end)
		board[x][y] = cell
	end
end

while true do
	turn = 1
	hum.DisplayName = 'Player1 Turn'
	repeat task.wait(0.1) until nextTurn
	if superclaim() then
		hum.DisplayName = 'Player2 Win!!!'
		return
	end
	nextTurn = false
	turn = 2
	hum.DisplayName = 'Player2 Turn'
	repeat task.wait(0.1) until nextTurn
	if superclaim() then
		hum.DisplayName = 'Player1 Win!!!'
		return
	end
	nextTurn = false
end