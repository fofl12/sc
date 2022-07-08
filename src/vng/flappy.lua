vng.allocateVectors(4)
vng.conf.fps(20)

local ey = 200
local ex = 400
local py = 200
local pd = 0
local over = false
local start = false
local timer = 0

return function()
	timer += 1
	if timer > 40 then
		start = true
	end
	if start and not over then
		pd -= 2
		if vng.input(5) then
			pd = 10
		end
		py -= pd

		ex -= 10
		if ex < 50 then
			ex = 400
			ey = math.random(50, 300)
		end
		if ex < 70 and math.abs(ey - py) > 50 then
			over = true
		end
	end

	vng.clear(true)

	vng.line({0, 350}, {400, 350}, 4)

	vng.line({ex, 0}, {ex, ey - 50}, 3)
	vng.line({ex, 350}, {ex, ey + 50}, 3)

	vng.line({50, py}, {70, py}, over and 6 or 1)
	vng.line({50, py + pd}, {70, py + pd}, 2)
end