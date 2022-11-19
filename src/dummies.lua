local hint = Instance.new('Hint', script)
hint.Text = ('-'):rep(20)
local alive = 0
for _ = 1, 100 do
	hint.Text = ('I'):rep(math.floor(_/5)) .. ('-'):rep(math.floor(100-_)/5)
	alive += 1
	local g = Instance.new('Model', script)
	local hum = Instance.new('Humanoid', g)
	if math.random() < .1 then
		hum.DisplayName = 'Tough Dummy'
		hum.MaxHealth = 1000
		hum.Health = 1000
	else
		hum.DisplayName = 'Dummy'
	end
	local ball = Instance.new('Part', g)
	ball.Name = 'Head'
	ball.Size = Vector3.one * math.random(3, 6)
	ball.Shape = 'Ball'
	ball.BrickColor = BrickColor.Random()
	ball.CFrame = CFrame.new(math.random(-300, 300), 100, math.random(-300, 300))
	task.spawn(function()
		repeat task.wait(1) until not ball or hum.Health < 1
		g:Destroy()
		alive -= 1
		hint.Text = ('I'):rep(math.floor(alive/5)) .. ('-'):rep(math.floor((100-alive)/5))
	end)
	task.wait(.1)
end