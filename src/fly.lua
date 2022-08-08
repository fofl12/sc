local plane = Instance.new('Part')
plane.Size = Vector3.new(1, 1, 2)
plane.Position = owner.Character.Head.Position
plane.Parent = owner.Character
plane:SetNetworkOwner(owner)

local velocity = Instance.new('BodyVelocity', plane)
velocity.MaxForce = Vector3.one * 500000000000
velocity.P = 5000000000

local attachment = Instance.new('Attachment', plane)
local angular = Instance.new('AngularVelocity', plane)
angular.MaxTorque = 500000000000
angular.Attachment0 = attachment
angular.RelativeTo = 'Attachment0'

local rope

local face = Instance.new('Decal', plane)
face.Texture = owner.Character.Head.face.Texture

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local throttle = 0
local mouse = owner:GetMouse()
local function removePosition(cf)
	return cf - cf.p
end

remote:FireServer('get')
local plane = remote.OnClientEvent:Wait()
local velocity = plane:WaitForChild('BodyVelocity')
local angular = plane:WaitForChild('AngularVelocity')
local attachment = plane:WaitForChild('Attachment')
angular.AngularVelocity = Vector3.new()

local camera = workspace.CurrentCamera
local rs = game:GetService('RunService')
local uis = game:GetService('UserInputService')
uis.InputBegan:Connect(function(input)
	if input.UserInputState == Enum.UserInputState.Begin then
		if input.KeyCode.Value == 113 then -- Q
			remote:FireServer('x')
		elseif input.KeyCode.Value == 101 then -- E
			remote:FireServer('r', mouse.Target)
		end
	end
end)
rs.RenderStepped:Connect(function(delta)
	local keys = uis:GetKeysPressed()
	local speed = 50
	local aspeed = 2
	local newVelocity = Vector3.new()
	local newAngular = Vector3.new()
	for _, key in next, keys do
		local offset = Vector3.new()
		local angularoffset = Vector3.new()
		if key.KeyCode.Value == 119 then -- W
			angularoffset = Vector3.new(-aspeed, 0, 0)
		elseif key.KeyCode.Value == 115 then -- S
			angularoffset = Vector3.new(aspeed, 0, 0)
		elseif key.KeyCode.Value == 97 then -- A
			angularoffset = Vector3.new(0, aspeed, 0)
		elseif key.KeyCode.Value == 100 then -- D
			angularoffset = Vector3.new(0, -aspeed, 0)
		elseif key.KeyCode.Value == 273 then -- Up
			throttle = throttle + 1
		elseif key.KeyCode.Value == 274 then -- Down
			throttle = throttle - 1
		end
		newVelocity = newVelocity + offset
		newAngular = newAngular + angularoffset
	end
	newVelocity = Vector3.new(0, 0, -throttle)
	velocity.Velocity = plane.CFrame:vectorToWorldSpace(newVelocity)
	angular.AngularVelocity = newAngular

	camera.CameraType = 'Scriptable'
	camera.CFrame = plane.CFrame
end)
]], remote)
remote.OnServerEvent:Connect(function(p, m, dat)
	if m == 'get' then
		remote:FireClient(p, plane)
	elseif m == 'x' then
		Instance.new('Explosion', plane).Position = plane.Position
	elseif m == 'r' then
		if rope then
			rope.Attachment1:Destroy()
			rope:Destroy()
		else
			rope = Instance.new('RopeConstraint', plane)
			rope.Length = 10
			rope.Visible = true
			rope.Thickness = 0.5
			rope.Attachment0 = attachment
			local a1 = Instance.new('Attachment', dat)
			rope.Attachment1 = a1
		end
	end
end)
while true do
	task.wait()
	plane:SetNetworkOwner(owner)
end