-- Compiled with roblox-ts v1.2.9
local char = owner.Character
local hum = char:FindFirstChild("Humanoid")
local torso = (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
local players = game:GetService("Players")
local tool = Instance.new("Tool")
tool.Name = owner.DisplayName
owner.Character.Parent = tool
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Transparency = 1
handle.Parent = tool
local weld = Instance.new("Weld")
weld.Part0 = handle
weld.Part1 = torso
weld.Parent = handle
tool.Equipped:Connect(function()
	hum.Sit = true
end)
handle.Touched:Connect(function(part)
	local _result = part.Parent
	if _result ~= nil then
		_result = _result:FindFirstChild("Humanoid")
	end
	local hum = _result
	if hum then
		local _result_1 = players:GetPlayerFromCharacter(part.Parent)
		if _result_1 ~= nil then
			_result_1 = _result_1:FindFirstChild("Backpack")
		end
		local _condition = _result_1
		if not _condition then
			_condition = tool.Parent
		end
		tool.Parent = _condition
	end
end)
tool.Parent = game:GetService("Workspace")
return nil
