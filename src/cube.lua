local color = Color3.fromRGB(54, 179, 247)
local offset = Vector3.new(owner.Character.Head.Position.X, 20, owner.Character.Head.Position.Z)

do
	local fwall = Instance.new('Part')
	fwall.Size = Vector3.new(39, 39, 1)
	fwall.Position = offset + Vector3.new(0, 0, 20)
	fwall.Material = 'Glass'
	fwall.Color = color
	fwall.Transparency = 0.5
	fwall.Anchored = true
	fwall.CastShadow = false
	Instance.new('RemoteEvent', fwall)
	fwall.Parent = script

	local bwall = fwall:Clone()
	bwall.Position -= Vector3.new(0, 0, 40)
	bwall.Parent = script

	local lwall = fwall:Clone()
	lwall.Size = Vector3.new(1, 39, 39)
	lwall.Position = offset - Vector3.new(20, 0, 0)
	lwall.Parent = script

	local rwall = lwall:Clone()
	rwall.Position += Vector3.new(40)
	rwall.Parent = script

	local twall = fwall:Clone()
	twall.Size = Vector3.new(39, 1, 39)
	twall.Position = offset + Vector3.new(0, 20, 0)
	twall.Parent = script

	floor = twall:Clone()
	floor.Position = offset - Vector3.new(0, 20, 0)
	floor.Material = 'Fabric'
	floor.Transparency = 0
	floor.BrickColor = BrickColor.Red()
	floor.Parent = script

	local border = Instance.new('Part')
	border.TopSurface = 'Smooth'
	border.BottomSurface = 'Smooth'
	border.Anchored = true
	Instance.new('RemoteEvent', border)
	for x = 0, 1 do
		for y = 0, 1 do
			local x = (x * 40) - 20
			local y = (y * 40) - 20

			local border = border:Clone()
			border.Position = offset + Vector3.new(x, y)
			border.Size = Vector3.new(1, 1, 41)
			border.Parent = script
		end
	end
	for z = 0, 1 do
		for y = 0, 1 do
			local z = (z * 40) - 20
			local y = (y * 40) - 20

			local border = border:Clone()
			border.Position = offset + Vector3.new(0, y, z)
			border.Size = Vector3.new(41, 1, 1)
			border.Parent = script
		end
	end
	for x = 0, 1 do
		for z = 0, 1 do
			local x = (x * 40) - 20
			local z = (z * 40) - 20

			local border = border:Clone()
			border.Position = offset + Vector3.new(x, 0, z)
			border.Size = Vector3.new(1, 41, 1)
			border.Parent = script
		end
	end
end

do
	local seat = Instance.new('Seat')
	seat.BrickColor = BrickColor.White()
	seat.Size = Vector3.one * 4
	seat.Orientation = Vector3.new(0, 180)
	seat.Anchored = true
	for i = -2, 2 do
		local seat = seat:Clone()
		seat.Position = floor.Position + Vector3.new(i * 4, 0, 5)
		seat.Parent = script
	end
end