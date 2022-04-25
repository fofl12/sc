-- Compiled with roblox-ts v1.2.9
-- Sword that can damage other players                    //
local tweenService = game:GetService("TweenService")
local debris = game:GetService("Debris")
local sword = Instance.new("Tool")
sword.Name = "sword"
sword.Grip = CFrame.new(0, 0, 2)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Color = Color3.fromRGB(102, 0, 102)
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut, -1, true)
local tween = tweenService:Create(handle, tweenInfo, {
	Color = Color3.fromRGB(204, 0, 153),
})
tween:Play()
handle.Size = Vector3.new(1, 1, 3)
handle.Parent = sword
sword.Parent = owner:FindFirstChild("Backpack")
local remote = Instance.new("RemoteEvent", sword)
NLS([[
		local rem = script.Parent;
		local mouse = owner:GetMouse();

		mouse.Button1Down:Connect(function()
			rem:FireServer('down', mouse.UnitRay.Direction, mouse.UnitRay.Origin);
		end)
		mouse.Button1Up:Connect(function()
			rem:FireServer('up');
		end)
	]], remote)
local charging = false
local charge = 0
remote.OnServerEvent:Connect(function(plr, mode, direction, origin)
	if plr ~= owner then
		return nil
	end
	repeat
		local _fallthrough = false
		if mode == "down" then
			charging = true
			while charging do
				wait(1 / 10)
				charge += 1
				local ex = Instance.new("Explosion")
				ex.DestroyJointRadiusPercent = 0
				ex.ExplosionType = Enum.ExplosionType.NoCraters
				ex.Position = handle.Position
				ex.Parent = handle.Parent
				debris:AddItem(ex, 1)
			end
			local ex = Instance.new("Explosion")
			ex.Position = handle.Position
			ex.BlastPressure = charging * 1000
			ex.Parent = handle.Parent
			debris:AddItem(ex, 1)
			_fallthrough = true
		end
		if _fallthrough or mode == "up" then
			charging = false
		end
	until true
end)
return nil
