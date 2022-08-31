local assemble = {
	'#REG 1 "Hello, world!"', -- registers can store data of arbitrary size because :D!
	'dev 1 $1',
	'halt'
}

local exec = ""
local registers = {}
for _, i in ipairs(assemble) do
	local com = {}
	local quote = false
	local backslash = false
	local reg = false
	local working = ""
	for h = 1, #i do
		local c = i:sub(h, h)
		local isBack = backslash
		backslash = false
		local isReg = reg
		reg = false
		if c == '\\' then
			backslash = true
		elseif c == '"' and not isBack then
			quote = not quote
		elseif c == ' ' and not (isBack or quote) then
			table.insert(com, working)
			working = ""
		elseif 
		else
			working ..= c
		end
	end

	if com[1] == '#REG' then
		registers[tonumber(com[2])] = com[3]
	elseif com[1] == 'dev' then
		exec ..= 
end