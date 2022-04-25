-- Compiled with roblox-ts v1.2.9
-- Ray tracer                                             //
local camera = Instance.new("Part")
camera.CFrame = CFrame.new(20, 10, 15)
camera.Size = Vector3.new(0.5, 0.5, 0.5)
camera.Anchored = true
camera.Parent = script
local pointlights = {}
local _exp = game.Workspace:GetDescendants()
local _arg0 = function(light)
	if light:IsA("PointLight") then
		-- ▼ Array.push ▼
		pointlights[#pointlights + 1] = light
		-- ▲ Array.push ▲
	end
end
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	_arg0(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
local distFromPoint
local function raycast(origin, normal)
	local result = game.Workspace:Raycast(origin, normal)
	if result then
		if result.Instance ~= game.Workspace.Terrain then
			local color = result.Instance.Color
			if result.Instance.Reflectance > 0 then
				local _normal = result.Normal
				local _arg0_1 = normal:Dot(result.Normal) * 2
				local reflectedNormal = (normal - (_normal * _arg0_1)) * 100
				color = color:Lerp(raycast(result.Position, reflectedNormal), result.Instance.Reflectance)
			end
			if result.Instance.Transparency > 0 then
				local _fn = color
				local _position = result.Position
				local _arg0_1 = normal.Unit * 0.05
				color = _fn:Lerp(raycast(_position + _arg0_1, normal), result.Instance.Transparency)
			end
			--[[
				was very ugly
				if (game.Workspace.Raycast(result.Position, new Vector3(0.5, 0.1, 0).mul(100))) {
				color = color.Lerp(new Color3(0, 0, 0), 1 - result.Instance.Transparency);
				}
			]]
			local _arg0_1 = function(light)
				local Brightness = distFromPoint((light.Parent).Position, result.Position) / light.Range
				Brightness = 1 - Brightness
				Brightness = math.clamp(Brightness, 0, 1)
				color = color:Lerp(light.Color, math.clamp((light.Brightness / 30) * Brightness, 0, 0.9))
			end
			-- ▼ ReadonlyArray.forEach ▼
			for _k, _v in ipairs(pointlights) do
				_arg0_1(_v, _k - 1, pointlights)
			end
			-- ▲ ReadonlyArray.forEach ▲
			return color
		else
			return game.Workspace.Terrain:GetMaterialColor(result.Material)
		end
	end
	return Color3.fromRGB(69, 217, 255)
end
local function eqColor(a, b)
	local diffr = math.abs(a.R - b.R)
	local diffg = math.abs(a.G - b.G)
	local diffb = math.abs(a.B - b.B)
	return diffr < 0.02 and (diffg < 0.02 and diffb < 0.02)
end
function distFromPoint(center, point)
	return (point - center).Magnitude
end
local pixels = {}
do
	local x = -100
	local _shouldIncrement = false
	while true do
		if _shouldIncrement then
			x += 1
		else
			_shouldIncrement = true
		end
		if not (x < 100) then
			break
		end
		pixels[x + 1] = {}
		do
			local y = -100
			local _shouldIncrement_1 = false
			while true do
				if _shouldIncrement_1 then
					y += 1
				else
					_shouldIncrement_1 = true
				end
				if not (y < 100) then
					break
				end
				if y % 16 == 0 then
					wait(1 / 40)
				end
				local pixel = Instance.new("WedgePart")
				pixel.Size = Vector3.new(1, 1, 1) * 0.05
				pixel.Anchored = true
				pixel.Position = Vector3.new(x / 20 + 20, y / 20 + 10, 20)
				pixels[x + 1][y + 1] = pixel
				local _cFrame = CFrame.new(20, 10, 15)
				local _arg0_1 = CFrame.Angles(y / 200, x / 200, 0)
				local cf = _cFrame * _arg0_1
				local normal = cf.LookVector * 100
				local origin = cf.Position
				local color = raycast(origin, normal)
				if x > -100 then
					local prevPixel = pixels[x - 1 + 1][y + 1]
					if eqColor(prevPixel.Color, color) then
						pixels[x + 1][y + 1] = prevPixel
						local _position = prevPixel.Position
						local _vector3 = Vector3.new(0.025, 0, 0)
						prevPixel.Position = _position + _vector3
						local _size = prevPixel.Size
						local _vector3_1 = Vector3.new(0.05, 0, 0)
						prevPixel.Size = _size + _vector3_1
						pixel:Destroy()
						continue
					end
				end
				pixel.Color = color
				pixel.Parent = script
			end
		end
	end
end
return nil
