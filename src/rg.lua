-- Robux Engine

local offset = Vector3.new(owner.Character.Head.Position.X, 0, owner.Character.Head.Position.Z)
local debris = game:GetService('Debris')

colors = {
	[1] = Color3.new(), -- black
	[2] = Color3.new(1, 1, 1), -- white
	[3] = Color3.new(0.3, 0.3, 0.3), -- grey
	[4] = Color3.new(1, 0, 0), -- red
	[5] = Color3.new(0, 1, 0), -- green
	[6] = Color3.new(0, 0, 1), -- blue
	[7] = Color3.new(1, 1, 0), -- yellow
	[8] = Color3.new(0, 1, 1) -- cyan
}
rg = {
	clear = function()
		script:ClearAllChildren()
	end,
	offset = function(inc)
		offset += inc
	end,
	hint = function(text)
		local hint = Instance.new('Hint', script)
		hint.Text = text or '?'
		local hintApi = {
			set = function(text)
				hint.Text = text
			end,
			get = function()
				return hint.Text
			end,
			raw = hint,
			destroy = function()
				hint:Destroy()
				hintApi = nil
			end
		}
		return hintApi
	end,
	block = function(p, s, c, t)
		local block = Instance.new(t or 'Part', script)
		block.Position = p + offset
		block.Anchored = true
		block.Size = s or Vector3.new(2, 2, 2)
		if type(c) == 'number' then
			block.Color = colors[c]
		else
			block.Color = c or colors[2]
		end

		local blockApi = {
			raw = block,
			destroy = function()
				block:Destroy()
				blockApi = nil
			end
		}
		setmetatable(blockApi, {
			__index = function(_, k)
				if k == 'p' then
					return block.Position
				elseif k == 's' then
					return block.Size
				elseif k == 'c' then
					return block.Color
				end
			end,
			__newindex = function(_, k, v)
				if k == 'p' then
					block.Position = v + offset
				elseif k == 's' then
					block.Size = v
				elseif k == 'c' then
					block.Color = v
				end
			end
		})
		return blockApi
	end,
	timebomb = function(o, t)
		debris:AddItem(o.raw, t)
	end,
}

--[==[
local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(400, 300)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)

local button = Instance.new('TextButton')
button.Text = 'Push'
button.Size = UDim2.fromOffset(64, 16)
button.Parent = frame

local scroller = Instance.new('ScrollingFrame')
scroller.Position = UDim2.fromOffset(0, 16)
scroller.Size = UDim2.fromOffset(400, 284)
scroller.Parent = frame

local box = Instance.new('TextBox')
box.Font = 'Code'
box.TextXAlignment = 'Left'
box.TextYAlignment = 'Top'
box.TextWrap = true
box.TextSize = 10
box.MultiLine = true
box.Size = UDim2.fromScale(1, 1)
box.ClearTextOnFocus = false
box.Parent = scroller

button.MouseButton1Click:Connect(function()
	remote:FireServer('push', box.Text)
end)

frame.Parent = ui
ui.Parent = script
]], remote)
remote.OnServerEvent:Connect(function(plr, mode, dat)
	--if plr == owner then
		print'b'
		if mode == 'push' then
			print'c'
			local loaded = loadstring(dat)
			print(loaded)
			loaded()
		end
	--end
end)
]==]

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
		lava.raw.CanCollide = false
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

local function walk()
	local platform1 = rg.block(Vector3.new(0, 0, 5), Vector3.new(20, 2, 10))
	local platform2 = rg.block(Vector3.new(0, 0, 65), Vector3.new(20, 2, 10))

	local color = BrickColor.Random().Color
	local flip = math.random() < .5
	local x1 = math.random((flip and -10 or 0), (flip and 0 or 10))
	local x2 = math.random((flip and 0 or -10), (flip and 10 or 0))
	local path1 = rg.block(Vector3.new(x1, 0, 22.5), Vector3.new(.5, .5, 25), color)
	local path2 = rg.block(Vector3.new((x1 + x2) / 2, 0, 35), Vector3.new(math.abs(x1 - x2), .5, .5), color)
	local path3 = rg.block(Vector3.new(x2, 0, 47.5), Vector3.new(.5, .5, 25), color)

	local lava = rg.block(Vector3.new(0, -8, 35), Vector3.new(25, 1, 65), 4)
	lava.Material = 'Neon'
	lava.raw.Touched:Connect(game.Destroy)

	checkpint(platform2)
	platform2.raw.Touched:Wait()
	rg.offset(Vector3.new(0, 0, 70))
end

--local options = {walk}
local options = {truss, balls, paths, lava, slava, walk}
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