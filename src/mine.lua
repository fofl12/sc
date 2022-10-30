local function round(v)
	return Vector3.new(math.round(v.X), math.round(v.Y), math.round(v.Z))
end

local world = {}
print('Generating voxels...')
for x = -50, 50 do
	world[x] = {}
	if x % 4 == 0 then
		task.wait()
	end
	for y = 0, 100 do
		world[x][y] = {}
		for z = -50, 50 do
			world[x][y][z] = "rock"
		end
	end
end
print('Pass 1: Ore veins')
local r = math.random(300, 500)
print(r .. ' worms')
for _ = 1, r do
	local pos = Vector3.new(math.random(-50, 50), math.random(0, 100), math.random(-50, 50))
	local ore = "rock"
	repeat
		if math.random() < .3 then
			ore = "coal"
		elseif pos.Y < 85 and math.random() < .4 then
			ore = "iron"
		elseif pos.Y < 60 and math.random() < .2 then
			ore = "gold"
		elseif pos.Y < 75 and pos.Y > 40 and math.random() < .6 then
			ore = "copper"
		elseif pos.Y < 50 and math.random() < .05 then
			ore = "diamond"
		end
	until ore ~= "rock"
	local dir = CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
	for i = 1, math.random(3, 10) do
		if not (world[pos.X] and world[pos.X][pos.Y] and world[pos.X][pos.Y][pos.Z]) then
			break
		end
		world[pos.X][pos.Y][pos.Z] = ore
		pos += round(dir.LookVector)
		dir *= CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
	end
	if _ % 16 == 0 then
		task.wait()
		print(_)
	end
end

print('Pass 2: Caves')
local r = math.random(20, 50)
local seed = math.random() * 10000
print(r .. ' worms')
for _ = 1, r do
	local pos = Vector3.new(math.random(-50, 50), math.random(0, 100), math.random(-50, 50))
	local dir = CFrame.Angles(math.noise(pos.X + seed, pos.Y, pos.Z), math.noise(pos.X, pos.Y, pos.Z + seed), 0)
	local thickness = math.random(2, 4)
	for i = 1, math.random(6, 20) do
		for x = -thickness/2, thickness/2 do
			for y = -thickness/2, thickness/2 do
				for z = -thickness/2, thickness/2 do
					if world[pos.X + x] and world[pos.X + x][pos.Y + y] then
						world[pos.X + x][pos.Y + y][pos.Z + z] = 'air'
					end
				end
			end
		end
		pos += round(dir.LookVector * thickness)
		dir *= CFrame.Angles(math.noise(pos.X + seed, pos.Y, pos.Z), math.noise(pos.X, pos.Y, pos.Z + seed), 0)
	end
	
	if _ % 16 == 0 then
		task.wait()
		print(_)
	end
end

local function inbound(vec)
	return vec.X > 0 and vec.X <= 7 and vec.Y > 0 and vec.Y <= 7 and vec.Z > 0 and vec.Z <= 7
end

local function inbounds(vec, grid)
	for _, normalId in next, Enum.NormalId:GetEnumItems() do
		local normal = Vector3.fromNormalId(normalId)
		if grid[vec+normal] then
			continue
		end
		if inbound(normal + vec) then
			return true
		end
	end
	return false
end

local function randomPack()
	local pack = {}
	local size = math.random(0, 15)
	for _ = 1, size do
		local a = math.random()
		local ore = 
			a < .04 and 'diamond' or
			a < .08 and 'gold' or
			a < .2 and 'copper' or
			a < .4 and 'iron' or
			'coal'
		table.insert(pack, ore)
	end
	return pack
end

print('Pass 3: Mineshafts')
local r = math.random(2, 5)
print(r, 'trees idk what to name them')
for i = 1, r do
	print('--- Constructing tree', i)
	local msd = math.random(5, 8)
	print('Max stack size:', msd)
	local jumps = math.random(5, 8)
	print('Max jumps:', jumps)
	local stack = {}
	local grid = table.create(7,table.create(7,table.create(7,false))) -- I am profesional programer
	for j = 1, jumps do
		local pos
		if j == 1 then
			pos = Vector3.one*4
			grid[pos.X][pos.Y][pos.Z] = true
		else
			local selection
			local i
			repeat
				i = math.random(1, #stack - 1)
				selection = stack[i]
			until inbounds(selection,grid)
			for j = i + 1, #stack do
				table.remove(stack, j)
			end
			pos = selection
		end
		table.insert(stack, pos)
		for _ = 1, msd do
			if math.random() < .2 and not j == 1 then
				break
			end
			local increment
			repeat
				increment = Enum.NormalId:GetEnumItems()[math.random(1, #Enum.NormalId:GetEnumItems())]
			until inbound(Vector3.fromNormalId(increment) + pos)
			pos += Vector3.fromNormalId(increment)
			grid[pos.X][pos.Y][pos.Z] = true
			table.insert(stack, pos)
		end
	end
	print('Loading into map')
	local offset = Vector3.new(math.random(-50, 0), math.random(30, 60), math.random(-50, 0))
	for x, _y in next, grid do
		for y, _z in next, _y do
			for z, v in next, _z do
				if z then
					-- MY AMASING PROGRAMING
					for tx = 0, 2 do
						for ty = 0, 2 do
							for tz = 0, 2 do
								local x = offset.X+(x*4)+tx
								local y = offset.Y+(y*4)+ty
								local z = offset.Z+(z*4)+tz
								if world[x] and world[x][y] and world[x][y][z] then
									world[x][y][z] = 'air'
								end
							end
						end
					end
					if math.random() < .2 then
						local x = offset.X+(x*4)+1
						local y = offset.Y+(y*4)+1
						local z = offset.Z+(z*4)+1
						if world[x] and world[x][y] and world[x][y][z] then
							world[x][y][z] = randomPack()
						end
					end
				end
			end
		end
	end
end

print('Clear output')
print('Rendering...')
local real = {}
local mineEvent = Instance.new('BindableEvent')
_G.mine = mineEvent

local function ensure(x, y, t)
	if not t[x] then
		t[x] = {}
	end
	if not t[x][y] then
		t[x][y] = {}
	end
end

local function position(x, y, z)
	return Vector3.new(x, y + 40, z) * 4
end

local function create(x, y, z)
	--print(x, y, z)
	if (world[x] and world[x][y] and world[x][y][z]) then
		local ore = world[x][y][z]
		if ore == 'air' then
			print'Startfloodfill'
			-- flood fill ripoff
			local q = {{x, y, z}}
			local toLoad = {}
			local filled = {}
			local i = 0
			print('Detecting')
			local function set(x, y, z)
				ensure(x, y, real)
				if not real[x][y][z] then
					real[x][y][z] = true
					table.insert(q, {x, y, z})
				end
			end
			while #q > 0 do
				i += 1
				if i % 16 == 0 then task.wait() end
				local n = q[1]
				table.remove(q, 1)
				if not (world[n[1]] and world[n[1]][n[2]] and world[n[1]][n[2]][n[3]]) then
					continue
				end
				if world[n[1]][n[2]][n[3]] == 'air' then
					local x = n[1]
					local y = n[2]
					local z = n[3]
					set(x + 1, y, z)
					set(x - 1, y, z)
					set(x, y + 1, z)
					set(x, y - 1, z)
					set(x, y, z + 1)
					set(x, y, z - 1)
				else
					table.insert(toLoad, n)
				end
			end
			print('Rendering')
			for i, o in next, toLoad do
				if i % 16 == 0 then task.wait() end
				if math.random() < .02 then
					local ore = "rock"
					repeat
						if math.random() < .3 then
							ore = "coal"
						elseif o[2] < 85 and math.random() < .4 then
							ore = "iron"
						elseif o[2] < 60 and math.random() < .2 then
							ore = "gold"
						elseif o[2] < 75 and o[2] > 40 and math.random() < .6 then
							ore = "copper"
						elseif o[2] < 50 and math.random() < .05 then
							ore = "diamond"
						end
					until ore ~= "rock"
					world[o[1]][o[2]][o[3]] = ore
				end
				create(o[1], o[2], o[3])
			end
		else
			local function createChecking(x, y, z)
				ensure(x, y, real)
				if not real[x][y][z] then
					create(x, y, z)
				end
			end
			local function renderore(ore)
				local part = Instance.new('Part', script)
				part.Anchored = true
				part.Size = Vector3.one * 4
				part.Position = position(x, y, z)
				part.Material = 'Grass'
				part.Color = (
					ore == "rock" and Color3.new(.5, .5, .5) or
					ore == "coal" and Color3.new() or
					ore == "iron" and Color3.fromRGB(216, 187, 147) or
					ore == "gold" and Color3.new(1, 1, 0) or
					ore == "copper" and Color3.new(1, .5, 0) or
					ore == "diamond" and Color3.fromRGB(45, 177, 229)
				)
				part.Name = ore
				part:SetAttribute('isOre', true)
				part:SetAttribute('cash',
					ore == 'rock' and 1 or
					ore == 'coal' and 2 or
					ore == 'iron' and 5 or
					ore == 'gold' and 20 or
					ore == 'copper' and 15 or
					ore == 'diamond' and 200
				)
				part.AncestryChanged:Connect(function()
					-- I AM AMASING PROGRAMER 2
					createChecking(x + 1, y, z)
					createChecking(x - 1, y, z)
					createChecking(x, y + 1, z)
					createChecking(x, y - 1, z)
					createChecking(x, y, z + 1)
					createChecking(x, y, z - 1)
				end)
			end
			if type(ore) == 'table' then
				local part = Instance.new('Part', script)
				part.Anchored = true
				part.Size = Vector3.one * 3
				part.Position = position(x, y, z)
				part.Material = 'WoodPlanks'
				part.Name = 'iron'
				part:SetAttribute('isOre', true)
				part.AncestryChanged:Connect(function()
					print('I AM UNPACK', x, y, z)
					for _, o in next, ore do
						renderore(o)
					end
				end)
				task.spawn(function()
					while part.Parent == script do
						part.BrickColor = BrickColor.Random()
						task.wait(.1)
					end
				end)
			else
				renderore(ore)
			end
			
			--[[
			workspace.Terrain:FillBlock(CFrame.new(x * 4, y + 40 * 4, z * 4), Vector3.one * 4, (
				ore == "rock" and 'Rock' or
				ore == "coal" and 'Basalt' or
				ore == "iron" and 'Limestone' or
				ore == "gold" and 'Sand' or
				ore == "copper" and 'Sandstone' or
				ore == "diamond" and 'Ice'
			))
			mine.Event:Connect(function(pos)
				if pos.X == x and pos.Y == y and pos.Z == z then
					workspace.Terrain:FillBlock(CFrame.new(x, y + 40, z) * 4, Vector3.one * 4, 'Air')
					for cx = -1, 1 do
						if not real[cx + x] then
							real[cx + x] = {}
						end
						for cy = -1, 1 do
							task.wait()
							if not real[cx + x][cy + y] then
								real[cx + x][cy + y] = {}
							end
							for cz = -1, 1 do
								if not real[cx + x][cy + y][cz + z] then
									create(cx + x, cy + y, cz + z)
								end
							end
						end
					end
				end
			end)
			]]
		end
	end
	ensure(x, y, real)
	real[x][y][z] = true
end

for x, _y in next, world do
	if x < 20 and x > -20 then
		real[x] = {}
		real[x][100] = {}
		for z, ore in next, _y[100] do
			if z < 20 and z > -20 then
				create(x, 100, z)
				if z % 64 == 0 then
					task.wait()
					print(x,z)
				end
			end
		end
	end
end
print('Done')
print('Clear output')