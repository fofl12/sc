local adjs = {
	large = function(o)
		o.Size *= 2
	end,
	small = function(o)
		o.Size *= 0.5
	end,
	red = function(o)
		o.BrickColor = BrickColor.Red()
	end,
	green = function(o)
		o.BrickColor = BrickColor.Green()
	end,
	blue = function(o)
		o.BrickColor = BrickColor.Blue()
	end,
	tall = function(o)
		o.Size = o.Size + Vector3.new(0, 3)
	end,
	short = function(o)
		o.Size = o.Size - Vector3.new(0, 3)
	end,
	wide = function(o)
		o.Size = o.Size + Vector3.new(3)
	end,
	sparkle = function(o)
		Instance.new('Sparkles', o)
	end,
	fire = function(o)
		Instance.new('Fire', o)
	end,
}
local nouns = {
	ball = function()
		local new = Instance.new('Part')
		new.Shape = 'Ball'
		return new
	end,
	block = function()
		local new = Instance.new('Part')
		return new
	end,
	cylinder = function()
		local new = Instance.new('Part')
		new.Shape = 'Cylinder'
		return new
	end,
	wedge = function()
		local new = Instance.new('WedgePart')
		return new
	end,
	truss = function()
		local new = Instance.new('TrussPart')
		return new
	end,
	SpawnLocation = function()
		local new = Instance.new('SpawnLocation')
		return new
	end,
}

local function random(g)
	repeat
		for k, v in next, g do
			if math.random() < .2 then
				return {k, v}
			end
		end
		task.wait()
	until false
end

for i = 1, 20 do
	local model = Instance.new('Model')
	local hum = Instance.new('Humanoid', model)
	print('getting noun')
	local noun = random(nouns)
	local adjectives = {}
	print('getting adjectives')
	for i = 1, math.random(1, 3) do
		print(i)
		table.insert(adjectives, random(adjs))
	end
	print('assembling')
	local text = 'me when the '
	local object = noun[2]()
	object:SetAttribute('grab', true)
	for _, adjective in next, adjectives do
		text ..= adjective[1] .. ' '
		adjective[2](object)
	end
	text ..= noun[1]
	
	hum.DisplayName = text
	object.Name = 'Head'
	object.Position = owner.Character.Head.Position
	object.Parent = model
	model.Parent = script
	print(text)
end