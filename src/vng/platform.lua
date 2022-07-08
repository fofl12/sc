vng.allocateVectors(10)
vng.conf.fps(20)

local platforms = {
	{
		x1 = -200,
		x2 = 200,
		y = -100
	},
	{
		x1 = -150,
		x2 = -50,
		y = 0
	},
	{
		x1 = 125,
		x2 = 200,
		y = 100
	}
}

local px, py, dx, dy = 0, 0, 0, 0

local function onPlatform()
	local o
	for _, platform in next, platforms do
		if px > platform.x1 and px < platform.x2 and py <= platform.y and py > platform.y - 20 then
			o = platform
		end
	end
	return o
end

return function()
	dx *= 0.9
	local onPlatform = onPlatform()
	if onPlatform and dy <= 0 then
		dy = 0
	else
		dy -= 0.5
	end
	if onPlatform and onPlatform.y > py then
		py = onPlatform.y
	end
	if vng.input(1) then
		dx -= 2
	end
	if vng.input(2) then
		dx += 2
	end
	if vng.input(5) and onPlatform then
		dy += 12
	end
	if py <= -150 or py >= 200 or px > 200 or px < -200 then
		dy = 0
		py = 0
		table.insert(platforms, {
			x1 = math.random(-200, 200),
			x2 = math.random(-200, 200),
			y = math.random(-200, 100)
		})
	end
	px += dx
	py += dy

	vng.clear(true)
	for _, platform in next, platforms do
		vng.line({platform.x1 + 200, 200 - platform.y}, {platform.x2 + 200, 200 - platform.y}, 2)
	end
	vng.line({px + 200, 200 - py}, {px + 200, 180 - py}, 4) -- player
end