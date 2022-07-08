local hint = rg.hint()
local target = math.random(600, 1000)
for i = 20, 1, -1 do
	hint.set('ascent to the ' .. target .. ' th vertical stud\n' .. i)
	task.wait(1)
end
hint.set('go')
local start = os.time()
for height = 0, target, 8 do
	local block = rg.block(Vector3.new(math.random(-4, 4), height, math.random(-4, 4)), Vector3.new(3, 1, 3), 2)
	block.raw.Touched:Wait()
	hint.set('ascent to the ' .. target .. ' th vertical stud\n' .. height .. ' studs')
	block.c = colors[4]
end
task.wait(1)
local time = os.time() - start
hint.set(('Good Job!\nseconds elapsed: %i - studs per second: %i'):format(time, target, target / time))
task.wait(10)
rg.clear()