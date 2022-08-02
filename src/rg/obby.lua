local points = {}
local stage = 0
local sa = rg.hint("Obby - Stage : " .. stage)
local players = game:service'Players'

local function checkpint(platform2)
	local mst = stage
	platform2.raw.Touched:Connect(function(c)
		local p = players:GetPlayerFromCharacter(c.Parent)
		if p and points[p] ~= mst then
			points[p] = mst
			p.CharacterAdded:Connect(function(c)
				task.wait(1)
				if points[p] == mst then
					c.Head.CFrame = platform2.raw.CFrame + Vector3.new(0, 10, 0)
				end
			end)
		end
	end)
end

local function truss()
	local truss = rg.block(Vector3.new(0, 10), Vector3.new(0, 20), 3, 'TrussPart')
	truss.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 20, 0))
end

local function balls(mix)
	local platform1 = rg.block(Vector3.new(0, 0, 5), Vector3.new(10, 2, 10))
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))
	for i = 15, 40, 8 do
		local ball = rg.block(Vector3.new(math.random(-4, 4), mix and 0 or math.random(-2.5, 2.5), i), Vector3.new(2, 2, 2), math.random(1, 8))
		ball.raw.Shape = 'Ball'
	end
	local lava = rg.block(Vector3.new(0, -8, 25), Vector3.new(20, 1, 40), 4)
	lava.Material = 'Neon'
	lava.raw.Touched:Connect(game.Destroy)
	if not mix then
		checkpint(platform2)
	end
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 50))
end

local function paths(mix)
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

	if not mix then 
		checkpint(platform2)
	end
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 50))
	for i, p in ipairs(paths) do
		if i ~= chosenPath then
			p.destroy()
		end
	end
end

local function lava()
	local platform1 = rg.block(Vector3.new(0, 0, 20), Vector3.new(10, 2, 40))
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))

	for i = 1, 8 do
		local lava = rg.block(Vector3.new(0, 1.5, i * 5), Vector3.new(10, 1, 1), 4)
		lava.raw.Material = 'Neon'
		lava.raw.Touched:Connect(game.Destroy)
	end
	
	checkpint(platform2)
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 50))
end

local function slava(mix)
	if not mix then
		local platform1 = rg.block(Vector3.new(0, 0, 20), Vector3.new(10, 2, 40))
		print'nomix'
	end
	local platform2 = rg.block(Vector3.new(0, 0, 45), Vector3.new(10, 2, 10))

	for i = 1, 2 do
		local lava = rg.block(Vector3.new(0, mix and 15 or 12, i * 15 + 5), Vector3.new(25, 2, 2), 4)
		lava.raw.CanCollide = false66
		lava.raw.Material = 'Neon'
		task.spawn(function()
			while true do
				local delta = task.wait()
				lava.raw.CFrame *= CFrame.Angles(0, 0, i * 2 * delta)
			end
		end)
		lava.raw.Touched:Connect(game.Destroy)
	end
	if not mix then
		checkpint(platform2)
		platform2.raw.Touched:Wait()
		rg.offset(Vector3.new(0, 0, 50))
	end
end

--local options = {slava}
local options = {truss, balls, paths, lava, slava}
local mixable1 = {balls, lava, paths}
local mixable2 = {slava}

truss()
while true do
	stage += 1
	sa.set("Obby - Stage : " .. stage)
	if math.random() < 0.05 then
		local mix1 = mixable1[math.random(1, #mixable1)]
		local mix2 = mixable2[math.random(1, #mixable2)]
		task.spawn(mix2, true)
		mix1(true)
	else
		options[math.random(1, #options)]()
	end
end