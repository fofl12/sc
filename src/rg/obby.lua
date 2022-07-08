local function truss()
	local truss = rg.block(Vector3.new(0, 10), Vector3.new(0, 20), 3, 'TrussPart')
	truss.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 20, 2))
end

local function balls()
	local platform1 = rg.block(Vector3.new(0, 0, 5), Vector3.new(10, 2, 10))
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))
	for i = 15, 40, 8 do
		local ball = rg.block(Vector3.new(math.random(-5, 5), math.random(-2.5, 2.5), i), Vector3.new(2, 2, 2), math.random(1, 8))
		ball.raw.Shape = 'Ball'
	end
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 50))
end

local function paths()
	local platform1 = rg.block(Vector3.new(0, 0, 5), Vector3.new(10, 2, 10))
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))
	
	local paths = {
		rg.block(Vector3.new(-4, 0, 25), Vector3.new(2, 1, 30), 4),
		rg.block(Vector3.new(0, 0, 25), Vector3.new(2, 1, 30), 5),
		rg.block(Vector3.new(4, 0, 25), Vector3.new(2, 1, 30), 6),
	}
	local chosenPath = math.random(1, #paths)
	for i, p in ipairs(paths) do
		if i ~= chosenPath then
			p.raw.Touched:Connect(game.Destroy)
		end
	end

	platform2.raw.Touched:Wait()
	for i, p in ipairs(paths) do
		if i ~= chosenPath then
			p.destroy()
		end
	end
	rg.offset(Vector3.new(0, 0, 50))
end

local function lava()
	local platform1 = rg.block(Vector3.new(0, 0, 20), Vector3.new(10, 2, 40))
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))

	for i = 1, 8 do
		local lava = rg.block(Vector3.new(0, 1.5, i * 5), Vector3.new(10, 1, 1), 4)
		lava.raw.Material = 'Neon'
		lava.raw.Touched:Connect(game.Destroy)
	end
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 50))
end

local options = {truss, balls, paths, lava}

truss()
while true do
	options[math.random(1, #options)]()
end