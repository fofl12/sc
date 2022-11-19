local base = Instance.new('Part', script)
base.Size = Vector3.new(14, 1, 20)
base.Position = owner.Character.Torso.Position
base.Anchored = true

for i = 0, 3 do
	local seat = Instance.new('VehicleSeat', base)
	seat.Position = base.Position + Vector3.new((i % 2) * 6 - 3, 1, math.floor(i / 2) * 8 - 4)
	local weld = Instance.new('Weld', base)
	weld.C0 =  seat.CFrame - base.Position
	weld.Part0 = base
	weld.Part1 = seat
end