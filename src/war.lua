local hint = Instance.new('Hint', script)

while true do
hint.Text = 'Starting new war ....'
task.wait(5)

local cat = Instance.new('Part')
cat.Size = Vector3.one * 5
cat.Transparency = 0.2
cat.Shape = 'Ball'

local dog = cat:Clone()

local ic, id = 50, 50
local range = 1
local function update()
	hint.Text = ('CommunicationsRange: %i\n%s\n%s'):format(range, ('cat '):rep(ic), ('dog '):rep(id))
end
update()

dog:SetAttribute('dog', true)
cat:SetAttribute('cat', true)
cat:SetAttribute('hp', 100)
dog:SetAttribute('hp', 100)

local cdecal = Instance.new('Decal', cat)
cdecal.Texture = 'rbxassetid://2994480258'

local ddecal = Instance.new('Decal', dog)
ddecal.Texture = 'rbxassetid://10579536285'

local cats = {}
local dogs = {}
local function annunciate(type, target, pos)
	if type == 'c' then
		for _, cat in next, cats do
			if cat.Parent == script and target.Parent == script and (cat.Position - pos).Magnitude < range then
				cat.RP:Fire()
				cat.RP.Target = target
				cat.B.Attachment1 = target.A
			end
		end
	elseif type == 'd' then
		for _, cat in next, dogs do
			if cat.Parent == script and target.Parent == script and (cat.Position - pos).Magnitude < range then
				cat.RP:Fire()
				cat.RP.Target = target
				cat.B.Attachment1 = target.A
			end
		end
	end
end
for i = 1, ic do -- cats
	local cat = cat:Clone()
	cat.Parent = script
	cat.Name = 'cat'
	cat.Position = owner.Character.Head.Position + Vector3.new((i % 10) * 5 - 50, 0, math.floor(i / 10) * 5)
	cat.Touched:Connect(function(p)
		if cat:GetAttribute('hp') <= 0 then
			cats[i] = nil
			cat:Destroy()
			dog:Destroy()
			ic -= 1
			hint.Text = ('%s\n%s'):format(('cat '):rep(ic), ('dog '):rep(id))
		elseif p:GetAttribute('dog') then
			p:SetAttribute('hp', p:GetAttribute'hp' - math.random(40, 60))
			annunciate('c', p, dog.Position)
		end
	end)
	task.spawn(function()
		while task.wait(.1) do
			annunciate('d', cat, cat.Position)
		end
	end)
	cats[i] = cat
end
for i = 1, id do -- dogs
	local dog = dog:Clone()
	dog.Parent = script
	dog.Name = 'dog'
	dog.Position = owner.Character.Head.Position + Vector3.new((i % 10) *5 + 50, 0, math.floor(i / 10) * 5)
	dog.Touched:Connect(function(p)
		if dog:GetAttribute('hp') <= 0 then
			dogs[i] = nil
			dog:Destroy()
			cat:Destroy()
			id -= 1
			hint.Text = ('%s\n%s'):format(('cat '):rep(ic), ('dog '):rep(id))
		elseif p:GetAttribute('cat') then
			p:SetAttribute('hp', p:GetAttribute'hp' - math.random(40, 70))
			annunciate('d', p, dog.Position)
		end
	end)
	task.spawn(function()
		while task.wait(.1) do
			annunciate('c', dog, dog.Position)
		end
	end)
	dogs[i] = dog
end

for i = 1, ic do
	local cat = cats[i]
	local dog = dogs[i]
	
	local crp = Instance.new('RocketPropulsion', cat)
	crp.Name = 'RP'
	crp.MaxSpeed = 5000
	crp.MaxThrust = 10000
	crp.ThrustP = 20000000000
	crp.ThrustD = 200000
	crp.MaxTorque = Vector3.new()

	local cb = Instance.new('Beam', cat)
	cb.Name = 'B'
	cb.FaceCamera = true
	cb.Width0 = 0.2
	cb.Width1 = 0.2
	cb.Enabled = true
	local ca = Instance.new('Attachment', cat)
	ca.Name = 'A'
	cb.Attachment0 = a

	local drp = crp:Clone()
	drp.Parent = dog

	local db = cb:Clone()
	local da = Instance.new('Attachment', dog)
	da.Name = 'A'
	db.Attachment0 = da
	db.Parent = dog
end
cats[1].RP.Target = dogs[1]
cats[1].B.Attachment1 = dogs[1].A
cats[1].RP:Fire()
dogs[1].RP.Target = cats[1]
dogs[1].B.Attachment1 = cats[1].A
dogs[1].RP:Fire()

for _ = 1, 120 do
	task.wait(1)
	range += 1
	print('ComRange', range)
	print('CatsDogs', ic, id)
end

for _, cat in next, cats do
	cat:Destroy()
end
for _, dog in next, dogs do
	dog:Destroy()
end
if id > ic then
hint.Text = 'Dog Win !!!'
elseif ic > id then
hint.Text = 'Cat Win !!!'
else
hint.Text = 'Tie ......'
end
task.wait(10)
end