local image = {
	'      ',
	' #  # ',
	'      ',
	' #### ',
	'      '
}
local offset = owner.Character.Head.Position

local function line(row, length, horiz)
	local g = Instance.new('Model')
	local h = Instance.new('Humanoid', g)
	h.DisplayName = 's'
	h.Health = length
	local p = Instance.new('Part', g)
	p.Anchored = true
	p.Size = Vector3.one * 0.1
	p.Name = 'Head'
	p.Position = offset + Vector3.new(horiz , row * .1, 0)
	g.Parent = script
end

local rows = {}
for ri, iraw in next, image do
	local filled = false
	local length = 0
	local begin = 0
	rows[ri] = {}
	for i = 1, #iraw do
		local c = iraw:sub(i, i)
		if c == '#' then
			if not filled then
				begin = i
			end
			filled = true
			length += 1
		elseif c == ' ' and filled then
			table.insert(rows[ri], {
				horiz = begin,
				length = length * 10
			})
			length = 0
			begin = 0
			filled = false
		end
	end
end

for i, row in next, rows do
	for _, l in next, row do
		line(i, l.length, l.horiz)
	end
end