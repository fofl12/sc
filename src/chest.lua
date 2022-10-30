local g = Instance.new('Model')
local h = Instance.new('Humanoid', g)
h.DisplayName = 'Chest\nEmpty'

local box = Instance.new('Part', g)
box.Name = 'Head'
box.Position = owner.Character.Torso.Position
box.Size = Vector3.one * 4
box.Material = 'WoodPlanks'
box.Anchored = true
box.BrickColor = BrickColor.Random()

local clicker = Instance.new('ClickDetector', box)

local inside = nil
local iOwner = nil

box.Touched:Connect(function(p)
	if p.Name == 'Handle' and p.Parent:IsA'Tool' and p.Parent.Parent:FindFirstChild('Humanoid') and not inside then
		iOwner = game:service'Players':GetPlayerFromCharacter(p.Parent.Parent)
		inside = p.Parent
		p.Parent.Parent = nil
		h.DisplayName = 'Chest\nStoring ' .. inside.Name ..'\nOwner: ' .. iOwner.Name
	end
end)

clicker.MouseClick:Connect(function(p)
	if p == iOwner then
		inside.Parent = p.Backpack
		inside = nil
		iOwner = nil
		h.DisplayName = 'Chest\nEmpty'
	end
end)

g.Parent = script