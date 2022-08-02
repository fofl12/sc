local generator = Instance.new('Tool')
generator.Name = 'Hjsk'

local players = game:GetService('Players')
local debris = game:GetService('Debris')

local handle = Instance.new('Part', generator)
handle.Name = 'Handle'

local mesh = Instance.new('FileMesh', handle)
mesh.MeshId = 'rbxassetid://430357088'
mesh.TextureId = 'rbxassetid://430357092'
mesh.Scale = Vector3.one * 0.3

local spells = {
	{
		name = 'altitudo',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local force = Instance.new('BodyVelocity', torso)
			force.MaxForce = Vector3.yAxis * 10000
			force.P = 50000000
			force.Velocity = Vector3.yAxis * 300
			task.wait(0.3)
			force:Destroy()
		end
	},
	{
		name = 'crepitus',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local ff = Instance.new('ForceField', p.Character)
			local x = Instance.new('Explosion', p.Character)
			x.Position = torso.Position
			debris:AddItem(x, 5)
			debris:AddItem(ff, 2)
		end
	},
	{
		name = 'ignis',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local result = workspace:Raycast(torso.Position, torso.CFrame.LookVector * 30)
			if result then
				local firebrick = Instance.new('Part', script)
				firebrick.Size = Vector3.one
				firebrick.Transparency = 1
				firebrick.Anchored = true
				local fire = Instance.new('Fire', firebrick)
				for i = 0, 1, 1 / result.Distance do
					firebrick.Position = torso.Position:lerp(result.Instance.Position, i)
					task.wait(0.1)
				end
				fire.Parent = result.Instance
				firebrick:Destroy()
				result.Instance.BrickColor = BrickColor.Black()
				task.wait(5)
				pcall(result.Instance.Destroy, result.Instance)
			end
		end
	},
	{
		name = 'zenus',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local result = workspace:Raycast(torso.Position, torso.CFrame.LookVector * 10)
			if result then
				local hum = result.Instance.Parent:FindFirstChild('Humanoid')
				if hum then
					hum.Health /= 2
				end
			end
		end
	},
	{
		name = 'sodigius',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local result = workspace:Raycast(torso.Position, torso.CFrame.LookVector * 15)
			if result then
				local hum = result.Instance.Parent:FindFirstChild('Humanoid')
				if hum then
					hum.Parent.Archivable = true
					local clone = hum.Parent:Clone()
					clone.Parent = hum.Parent.Parent
					if math.random() < 0.5 then
						hum:Destroy()
					else
						clone.Humanoid:Destroy()
					end
				end
			end
		end
	},
	{
		name = 'lux',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			if not torso:FindFirstChild('PointLight') then
				local light = Instance.new('PointLight', torso)
				debris:AddItem(light, 60)
			end
		end
	},
	{
		name = 'imperium lux',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			if not torso:FindFirstChild('PointLight') then
				local light = Instance.new('PointLight', torso)
				light.Range = 30
				light.Brightness = 3
				debris:AddItem(light, 120)
			end
		end
	},
	{
		name = 'sana',
		run = function(p)
			local torso = p.Character.Torso or p.Character['Upper Torso']
			local field = Instance.new('Part', script)
			field.Material = 'ForceField'
			field.BrickColor = BrickColor.Green()
			field.Position = torso.Position
			field.Shape = 'Ball'
			field.Size = Vector3.one * 20
			field.CastShadow = false
			field.CanQuery = false
			field.CanCollide = false
			field.Anchored = true
			debris:AddItem(field, 30)
			for i = 1, 30 do
				task.wait(1)
				local parts = workspace:GetPartBoundsInRadius(field.Position, 15)
				for _, part in next, parts do
					local hum = part.Parent:FindFirstChild('Humanoid')
					if hum then
						hum.Health += 2
					end
				end
				field.Material = 'Neon'
				task.wait(0.2)
				field.Material = 'ForceField'
			end
		end
	},
	{
		name = 'dolor',
		run = function(p)
			p.Character.Humanoid:TakeDamage(45)
		end
	}
}

local gedebonk = true
generator.Activated:Connect(function()
	if gedebonk then
		gedebonk = false
		local player = players:GetPlayerFromCharacter(generator.Parent)

		local spell = Instance.new('Tool')
		spell.RequiresHandle = false
		local selected = spells[math.random(1, #spells)]
		spell.Name = selected.name
		local debonk = true
		spell.Activated:Connect(function()
			if debonk then
				debonk = false
				pcall(selected.run, player)
				task.wait(5)
				debonk = true
			end
		end)
		spell.Parent = player.Backpack
		task.wait(10)
		gedebonk = true
	end
end)

generator.Parent = owner.Backpack
