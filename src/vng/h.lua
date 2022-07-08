vng.conf.fps(15)
vng.conf.setPointsPerStud(4)
vng.allocateVectors(4)
vng.line({4, 4}, {4, 12})
vng.line({12, 4}, {12, 12})
local mid = vng.line({4, 8}, {12, 8})
local under = vng.line({2, 14}, {14, 14}, 3)

return function()
	mid.setPoint1({4, math.sin(os.clock() * 4) + 8})
	mid.setPoint2({12, math.cos(os.clock() * 2) + 8})
	under.setColor(os.time() % 8)
end