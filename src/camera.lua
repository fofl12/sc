local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([==[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local runs = game:GetService('RunService')

local offset = CFrame.Angles(math.rad(-30), 0, 0) + Vector3.new(0, 10, 20)

local cam = workspace.CurrentCamera
cam.CameraType = 'Scriptable'
cam.CFrame = owner.Character.Head.CFrame * offset

local seed = math.random()
runs:BindToRenderStep('RobuxDevice', 1, function(delta)
	local windDir = math.noise(os.clock(), seed, delta) * 360
	local windSpeed = math.noise(os.clock(), delta, seed)
	if os.clock() % 1 < 0.05 then
		remote:FireServer(
			'status',
			([[Wind: %ideg %.2f
FPS: %i
Robux division: True]]):format(windDir, windSpeed, 1 / delta)
		)
	end
end)
]==], remote)
remote.OnServerEvent:Connect(function(plr, mode, data)
	if plr == owner then
		if mode == 'status' then
			owner.Character.Humanoid.DisplayName = data
		end
	end
end)