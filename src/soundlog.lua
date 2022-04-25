-- Compiled with roblox-ts v1.2.9
-- Log all sound IDs currently being used to the output   //
local workspace = game:GetService("Workspace")
local _exp = workspace:GetDescendants()
local _arg0 = function(object)
	if object:IsA("Sound") then
		local sound = object
		print(">", sound.Name, sound.SoundId)
	end
end
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	_arg0(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
return nil
