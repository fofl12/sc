local cx, cy, cz = 0, 0, .1
local debris = game:GetService'Debris'

local function project(x, y, z)
	-- Isometric
	x -= cx
	y -= cy
	x /= cz
	y /= cz
	return x, y
	--[[
	-- Perspective
	x -= cx
	y -= cy
	z -= cz
	x /= z
	y /= z
	return x, y
	]]
end

local object = {}
for x = -1, 1, 2 do
	for y = -1, 1, 2 do
		for z = -1, 1, 2 do
			table.insert(object, {x, y, z})
		end
	end
end

while true do
	task.wait()
	cx = math.sin(os.clock())
	cy = math.cos(os.clock())
	for _, point in next, object do
		local px, py = project(unpack(point))
		local pickle = Instance.new('Part')
		pickle.Position = owner.Character.Head.Position + Vector3.new(px, py + 10)
		pickle.Anchored = true
		pickle.Size = Vector3.one * .1
		pickle.Parent = script
		debris:AddItem(pickle, 1/30)
	end
end