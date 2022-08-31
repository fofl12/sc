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
local r = math.random(100, 250)
print(r .. ' worms')
for _ = 1, r do
	local pos = Vector3.new(math.random(-50, 50), math.random(0, 100), math.random(-50, 50))
	local ore = "rock"
	print('Choosing material...')
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
		task.wait()
	until ore ~= "rock"
	print("Generating...")
	local dir = CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
	for i = 1, math.random(3, 10) do
		if not (world[pos.X] and world[pos.X][pos.Y] and world[pos.X][pos.Y][pos.Z]) then
			break
		end
		world[pos.X][pos.Y][pos.Z] = ore
		pos += round(dir.LookVector)
		dir *= CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
		task.wait()
	end
	task.wait()
	print(_)
end

print('Pass 2: Caves')
local r = math.random(10, 20)
print(r .. ' worms')
for _ = 1, r do
	local pos = Vector3.new(math.random(-50, 50), math.random(0, 100), math.random(-50, 50))
	print(pos)
	local dir = CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
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
		dir *= CFrame.Angles(math.random() - .5 * 2, math.random() - .5 * 2, 0)
		task.wait()
	end
	task.wait()
	print(_)
end

print('Rendering...')
local real = {}

local function create(x, y, z)
	--print(x, y, z)
	if world[x] and world[x][y] and world[x][y][z] then
		local ore = world[x][y][z]
		if ore == 'air' then
			-- flood fill ripoff
			local q = {{x, y, z}}
			local toLoad = {}
			local filled = {}
			local i = 0
			while #q > 0 do
				i += 1
				if i % 16 == 0 then task.wait() end
				local n = q[1]
				table.remove(q, 1)
				if not (world[n[1]] and world[n[1]][n[2]] and world[n[1]][n[2]][n[3]]) then
					continue
				end
				if world[n[1]][n[2]][n[3]] == 'air' then
					for cx = -1, 1 do
						if not real[cx + n[1]] then
							real[cx + n[1]] = {}
						end
						for cy = -1, 1 do
							if not real[cx + n[1]][cy + n[2]] then
								real[cx + n[1]][cy + n[2]] = {}
							end
							for cz = -1, 1 do
								--task.wait() -- :D!
								if not real[cx + n[1]][cy + n[2]][cz + n[3]] then
									real[cx + n[1]][cy + n[2]][cz + n[3]] = true
									table.insert(q, {cx + n[1], cy + n[2], cz + n[3]})
								end
							end
						end
					end
				else
					table.insert(toLoad, n)
				end
			end
			for _, o in next, toLoad do
				create(o[1], o[2], o[3])
			end
		else
			local part = Instance.new('Part', script)
			part.Anchored = true
			part.Size = Vector3.one * 4
			part.Position = Vector3.new(x, y + 40, z) * 4
			part.Material = 'Grass'
			part.Color = (
				ore == "rock" and Color3.new(.5, .5, .5) or
				ore == "coal" and Color3.new() or
				ore == "iron" and Color3.fromRGB(216, 187, 147) or
				ore == "gold" and Color3.new(1, 1, 0) or
				ore == "copper" and Color3.new(1, .5, 0) or
				ore == "diamond" and Color3.new(0, 0, 1)
			)
			part.Name = ore
			part:SetAttribute('isOre', true)
			part.AncestryChanged:Connect(function()
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
			end)
		end
	end
	real[x][y][z] = true
end

for x, _y in next, world do
	real[x] = {}
	real[x][100] = {}
	for z, ore in next, _y[100] do
		create(x, 100, z)
		if z % 32 == 0 then
			task.wait()
		end
	end
end
print('Done')