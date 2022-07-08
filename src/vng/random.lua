vng.allocateVectors(15)
vng.conf.fps(0.5)

return function()
	vng.clear(true)
	local prev = {200, 200}
	for _ = 1, math.random(2, 14) do
		local new = {math.random(0, 400), math.random(0, 400)}
		vng.line(prev, new)
		prev = new
	end
end