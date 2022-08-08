owner.Character.Archivable = true
local clone = owner.Character:Clone()
clone.Parent = workspace
clone.Name = 'oa'

while true do
	task.wait(math.random(3, 8))
	clone.Humanoid:MoveTo(Vector3.new(math.random(-20, 20), 0, math.random(-20, 20)))
	local tool = clone:FindFirstChildWhichIsA('Tool')
	if tool then
		for i = 1, 5 do
			task.wait()
			tool:Activate()
		end
	end
end