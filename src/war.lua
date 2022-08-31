local cat = Instance.new('Part')
cat.Size = Vector3.one * 5
cat.Transparency = 0.2
cat.Shape = 'Ball'

local dog = cat:Clone()

local ic, id = 500, 500
local hint = Instance.new('Hint', script)
hint.Text = ('Dog %i\nCat %i'):format(ic, id)

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
for i = 1, ic do -- cats
	local cat = cat:Clone()
	cat.Parent = script
	cat.Position = owner.Character.Head.Position + Vector3.new((i % 10) * 5 - 50, 0, math.floor(i / 10) * 5)
	cat.Touched:Connect(function(p)
		if cat:GetAttribute('hp') <= 0 then
			cats[i] = nil
			cat:Destroy()
			dog:Destroy()
			ic -= 1
		elseif p:GetAttribute('dog') then
			p:SetAttribute('hp', p:GetAttribute'hp' - math.random(40, 60))
		end
		hint.Text = ('Dog %s\nCat %s'):format(id, ic)
	end)
	cats[i] = cat
end
for i = 1, id do -- dogs
	local dog = dog:Clone()
	dog.Parent = script
	dog.Position = owner.Character.Head.Position + Vector3.new((i % 10) *5 + 50, 0, math.floor(i / 10) * 5)
	dog.Touched:Connect(function(p)
		if dog:GetAttribute('hp') <= -20 then
			dogs[i] = nil
			dog:Destroy()
			cat:Destroy()
			id -= 1
		elseif p:GetAttribute('cat') then
			p:SetAttribute('hp', p:GetAttribute'hp' - math.random(40, 70))
		end
		hint.Text = ('Dog %s\nCat %s'):format(id, ic)
	end)
	dogs[i] = dog
end

for i = 1, ic do
	local cat = cats[i]
	local dog = dogs[i]
	
	local crp = Instance.new('RocketPropulsion', cat)
	crp.Name = 'RocketPropulsion'
	crp.MaxSpeed = 5000
	crp.MaxThrust = 10000
	crp.ThrustP = 20000000000
	crp.ThrustD = 200000
	crp.MaxTorque = Vector3.new()
	crp.Target = dog
	crp:Fire()

	local drp = crp:Clone()
	drp.Parent = dog
	drp.Target = cat
	drp:Fire()
end

local function clone(t)
	local n = {}
	for k, v in next, t do
		n[k] = v
	end
	return n
end