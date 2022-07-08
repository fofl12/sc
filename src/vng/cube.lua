local cube = {
	{{-40, -40, -40}, {40, -40, -40}},
	{{-40, 40, -40}, {40, 40, -40}},
	{{-40, -40, 40}, {40, -40, 40}},
	{{-40, 40, 40}, {40, 40, 40}},

	{{-40, -40, -40}, {-40, -40, 40}},
	{{-40, 40, -40}, {-40, 40, 40}},
	{{40, -40, -40}, {40, -40, 40}},
	{{40, 40, -40}, {40, 40, 40}},

	{{-40, -40, -40}, {-40, 40, -40}},
	{{-40, -40, 40}, {-40, 40, 40}},
	{{40, -40, -40}, {40, 40, -40}},
	{{40, -40, 40}, {40, 40, 40}},
}
local cam = {0, 0, -100}
vng.conf.fps(15)
vng.allocateVectors(#cube)

return function()
	if vng.input(1) then
		cam[1] -= 2
	elseif vng.input(2) then
		cam[1] += 2
	elseif vng.input(3) then
		cam[2] -= 2
	elseif vng.input(4) then
		cam[2] += 2
	elseif vng.input(5) then
		cam[3] -= 2
	elseif vng.input(6) then
		cam[3] += 2
	end
	
	vng.clear(true)
	for _, line in next, cube do
		vng.line(
			{
				((line[1][1] - cam[1]) / (line[1][3] - cam[3]) * 90) + 200,
				((line[1][2] - cam[2]) / (line[1][3] - cam[3]) * 90) + 200,
			},
			{
				((line[2][1] - cam[1]) / (line[2][3] - cam[3]) * 90) + 200,
				((line[2][2] - cam[2]) / (line[2][3] - cam[3]) * 90) + 200,
			},
			4
		)
	end
end