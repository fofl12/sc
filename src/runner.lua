-- Compiled with roblox-ts v1.2.9
-- Loader that lets you quickly run scripts from this repo
local workspace = game:GetService("Workspace")
local API = "https://raw.githubusercontent.com/snoo8/scriptsoup/main"
local defaultHeaders = {
	["Cache-Control"] = "no-cache",
}
local http = game:GetService("HttpService")
local commands = {
	size = function(args)
		local char = owner.Character
		if not char then
			warn("no character")
			return nil
		end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then
			warn("no humanoid")
			return nil
		end
		if hum.RigType ~= Enum.HumanoidRigType.R15 then
			warn("not r15")
			return nil
		end
		local width = hum:FindFirstChild("BodyWidthScale")
		local heigth = hum:FindFirstChild("BodyHeightScale")
		local depth = hum:FindFirstChild("BodyDepthScale")
		local head = hum:FindFirstChild("HeadScale")
		local scale = tonumber(args[2])
		width.Value = scale
		heigth.Value = scale
		depth.Value = scale
		head.Value = scale
		return nil
	end,
	ws = function(args)
		local char = owner.Character
		if not char then
			warn("no character")
			return nil
		end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then
			warn("no humanoid")
			return nil
		end
		hum.WalkSpeed = tonumber(args[2])
		return nil
	end,
	jp = function(args)
		local char = owner.Character
		if not char then
			warn("no character")
			return nil
		end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then
			warn("no humanoid")
			return nil
		end
		hum.JumpPower = tonumber(args[2])
		return nil
	end,
	dn = function(args)
		local char = owner.Character
		if not char then
			warn("no character")
			return nil
		end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then
			warn("no humanoid")
			return nil
		end
		hum.DisplayName = args[2]
		return nil
	end,
}
local function get(endpoint)
	local url = API .. endpoint
	local response = http:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = defaultHeaders,
	})
	if not response.Success then
		warn("HTTP GET request failure:", url, response.StatusCode, response.StatusMessage)
	end
	return response.Body
end
local function show(text)
	if owner.Character then
		local char = owner.Character
		local head = char:FindFirstChild("Head")
		if not head then
			return nil
		end
		local screen = Instance.new("Part", script)
		screen.Material = Enum.Material.Glass
		screen.BrickColor = BrickColor.new("Black")
		screen.Transparency = 0.6
		screen.Reflectance = 0.2
		screen.Size = Vector3.new(10, 7, 1)
		local _cFrame = head.CFrame
		local _vector3 = Vector3.new(0, 0, 5)
		screen.CFrame = _cFrame + _vector3
		screen.Anchored = true
		local gui = Instance.new("SurfaceGui", screen)
		gui.Face = Enum.NormalId.Back
		local scroller = Instance.new("ScrollingFrame", gui)
		scroller.BackgroundTransparency = 1
		scroller.Size = UDim2.fromScale(1, 1)
		scroller.CanvasSize = UDim2.fromScale(1, 6)
		local box = Instance.new("TextBox", scroller)
		box.BackgroundTransparency = 1
		box.TextColor3 = Color3.new(1, 1, 1)
		box.Text = text
		box.TextSize = 15
		box.TextWrapped = true
		box.Size = UDim2.fromScale(1, 1)
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.TextYAlignment = Enum.TextYAlignment.Top
	else
		print(text)
	end
end
local forceField = Instance.new("Part")
forceField.Shape = Enum.PartType.Ball
forceField.Size = Vector3.new(8, 8, 8)
forceField.Material = Enum.Material.ForceField
forceField.BrickColor = BrickColor.Black()
-- forceField.CanCollide = false;
forceField.Massless = true
local forceFieldWeld = Instance.new("Weld")
forceFieldWeld.Part0 = owner.Character:FindFirstChild("HumanoidRootPart")
forceFieldWeld.Part1 = forceField
forceFieldWeld.Parent = forceField
local forceFieldEnabled = false
local forceFieldMode = "d"
forceField.Touched:Connect(function(part)
	if not part:IsDescendantOf(owner.Character) then
		print(forceFieldMode)
		repeat
			if forceFieldMode == "d" then
				if not part.Anchored then
					part:Destroy()
				end
				break
			end
			if forceFieldMode == "r" then
				local _fn = part
				local _position = part.Position
				local _position_1 = forceField.Position
				_fn:ApplyImpulse((_position - _position_1) * 50)
				break
			end
			if forceFieldMode == "x" then
				Instance.new("ForceField", owner.Character)
				Instance.new("Explosion", part).Position = part.Position
				break
			end
		until true
	end
end)
owner.Chatted:Connect(function(message)
	if string.sub(message, 2, 2) == "'" then
		local command = { string.sub(message, 1, 1), string.sub(message, 3, -1) }
		local split = string.split(command[2], "'")
		local _exp = command[1]
		repeat
			local _fallthrough = false
			if _exp == "r" then
				local requested = get("/out/" .. command[2] .. ".lua")
				if typeof(requested) == "string" and requested ~= "" then
					NS(requested, script)
				else
					warn("Invalid script name!")
				end
				break
			end
			if _exp == "q" then
				NS(command[2], script)
				break
			end
			if _exp == "v" then
				local source = get(command[2])
				show(source)
				break
			end
			if _exp == "h" then
				local got = http:GetAsync(command[2])
				show(got)
				break
			end
			if _exp == "c" then
				script:ClearAllChildren()
				break
			end
			if _exp == "a" then
				local targetCommand = commands[split[1]]
				if targetCommand == nil then
					warn("invalid command")
					return nil
				end
				targetCommand(split)
				break
			end
			if _exp == "e" then
				print((loadstring("return " .. command[2])()))
				_fallthrough = true
			end
			if _fallthrough or _exp == "f" then
				local params = string.split(command[2], "'")
				local _exp_1 = params[1]
				repeat
					if _exp_1 == "t" then
						forceFieldEnabled = not forceFieldEnabled
						if forceFieldEnabled then
							forceField.Parent = script
						else
							forceField.Parent = nil
						end
						break
					end
					if _exp_1 == "m" then
						print("set", params[2])
						forceFieldMode = params[2]
						repeat
							if forceFieldMode == "d" then
								forceField.BrickColor = BrickColor.Black()
								break
							end
							if forceFieldMode == "r" then
								forceField.BrickColor = BrickColor.Blue()
								break
							end
							if forceFieldMode == "x" then
								forceField.BrickColor = BrickColor.Red()
								break
							end
						until true
						break
					end
					if _exp_1 == "fw" then
						forceFieldWeld = Instance.new("Weld")
						forceFieldWeld.Part0 = owner.Character:FindFirstChild("HumanoidRootPart")
						forceFieldWeld.Part1 = forceField
						forceFieldWeld.Parent = forceField
						break
					end
				until true
				break
			end
		until true
	end
end)
return nil
