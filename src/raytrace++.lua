local TWIST = true -- idk how this works lol
local RES_X = 160
local RES_Y = 120
local PIXEL_SIZE = Vector3.one * 0.1 -- requires RENDER_MODE to be 'Part'
local DIMUL = 3
local LENIENT = false
local DRONE_SHOT = false
local ALBUM = true -- requires RENDER_MODE to be 'Text' to be able to visualize renders
local RENDER_MODE = 'Text'
local MULTI_LIGHT = false -- enable multiple light sources
local SHADOWS = true
local RENDER_PARAMS = {
	rowsplit = 1
}

local http = game:GetService('HttpService')
local Bitmap = loadstring(http:GetAsync('https://raw.githubusercontent.com/max1220/lua-bitmap/5308e9436592238b3d1139d54d0954cb7d045e1d/bitmap.lua'))()
local album = {}

local tool = Instance.new('Tool')
tool.Name = 'Ray Tracer'
tool.TextureId = 'rbxassetid://725416435'
tool.ToolTip = 'Caught in 4K'
local statelabel
local handle
do
	handle = Instance.new('Part')
	handle.Name = 'Handle'
	handle.Size = Vector3.one
	handle.Anchored = false
	handle.CanCollide = false
	local mesh = Instance.new('FileMesh')
	mesh.MeshId = 'rbxassetid://515752158'
	mesh.TextureId = 'rbxassetid://515752160'
	mesh.Scale = Vector3.one * 0.02
	mesh.Parent = handle
	local gui = Instance.new('BillboardGui')
	gui.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
	gui.Size = UDim2.fromScale(5, 1)
	gui.Parent = handle
	statelabel = Instance.new('TextBox')
	statelabel.BackgroundTransparency = 1
	statelabel.Size = UDim2.fromScale(1, 1)
	statelabel.TextColor3 = Color3.new(1, 1, 1)
	statelabel.TextScaled = true
	statelabel.TextWrap = true
	statelabel.Parent = gui
	handle.Parent = tool
	tool.Parent = owner.Backpack
end
statelabel.Text = 'Ready'

local matmap = {
	[Enum.Material.Water] = Enum.Material.Glass,
	[Enum.Material.Grass] = Enum.Material.Grass
}
local lightindex = {}
setmetatable(matmap, {__index=function(t,k)return k end})

local function cast(origin, dir, layer)
	local ray = workspace:Raycast(origin, dir * 500)
	local color, mat, dist
	-- if layer > 8 then
	-- 	ray = nil
	-- end
	if layer % 6 == 0 and not LENIENT then
		task.wait()
	end
	if layer % 100 == 0 then
		warn('Passed 100 layer milestone, the target is unreachable. Skipping...')
		ray = nil
	end
	if ray then
		if ray.Instance == workspace.Terrain then
			if ray.Material == Enum.Material.Water then
				color = workspace.Terrain.WaterColor
				local reflectedNormal = dir - (2 * dir:Dot(ray.Normal) * ray.Normal)
				local reflectedRes = {cast(ray.Position, reflectedNormal, layer + 1)}
				color = color:lerp(reflectedRes[1], workspace.Terrain.WaterReflectance)
				local cutRes = {cast(ray.Position, dir, layer + 1)}
				dist = cutRes[3] + ray.Distance
				color = color:lerp(cutRes[1], workspace.Terrain.WaterTransparency / (dist / 10))
				mat = matmap[Enum.Material.Water]
			else
				color, mat, dist = workspace.Terrain:GetMaterialColor(ray.Material), matmap[ray.Material], ray.Distance
			end
		else
			color, mat, dist = ray.Instance.Color, ray.Material, ray.Distance
			if ray.Instance.Reflectance > 0 then
				local reflectedNormal = dir - (2 * dir:Dot(ray.Normal) * ray.Normal)
				local res = {cast(ray.Position, reflectedNormal, layer + 1)}
				color = color:lerp(res[1], ray.Instance.Reflectance)
				dist += res[3]
			end
			if ray.Instance.Transparency > 0 then
				local res = {cast(ray.Position, dir, layer + 1)}
				color = color:lerp(res[1], ray.Instance.Transparency)
			end
			if MULTI_LIGHT then
				for _, light in next, lightindex do
					local dist = (light.Parent.Position - ray.Position).Magnitude
					if dist < light.Range then
						color = color:lerp(light.Color, math.sqrt(1 - dist / light.Range) * light.Brightness)
					end
				end
			end
		end
		if SHADOWS then
			local dot = (-sunormal):Dot(ray.Normal)
			color = color:lerp(Color3.new(.2,.2,.2), (dot+1)/2)
			if dot < 0 then
				local shadowRay = workspace:Raycast(ray.Position, sunormal * 50)
				if shadowRay and shadowRay.Instance ~= ray.Instance and shadowRay.Instance.CastShadow then
					color = color:lerp(Color3.new(.2,.2,.2), 1 - (shadowRay.Distance / 50))
				end
			end
		end
	else
		color, mat, dist = Color3.fromRGB(70,142,206):lerp(Color3.fromRGB(12,70,206), dir:Dot(Vector3.yAxis)), Enum.Material.Plastic, math.huge
	end
	return color, mat, dist
end

tool.Activated:Connect(function()
	statelabel.Text = 'Initializing'
	sunormal = game.Lighting:GetSunDirection()

	handle.Anchored = true
	local oldcf = handle.CFrame
	tool.Parent = workspace
	if not DRONE_SHOT then
		handle.CFrame = oldcf
	end
	task.wait(3)
	
	if MULTI_LIGHT then
		statelabel.Text = 'Indexing lights'
		lightindex = {}
		for _, light in next, workspace:GetDescendants() do
			if light.Parent:IsA('BasePart') and light:IsA('PointLight') then
				table.insert(lightindex, light)
			end
		end
		print('Light index size: ' .. #lightindex)
	end

	local raymap = {}
	statelabel.Text = 'Firing rays'
	for y = -(RES_Y/2), (RES_Y/2) do
		if not raymap[y+(RES_Y/2)] then
			raymap[y+(RES_Y/2)] = {}
		end
		if LENIENT then
			statelabel.Text = ('Loading row %i'):format(y)
		end
		for x = -(RES_X/2), (RES_X/2) do
			local cf = handle.CFrame * CFrame.Angles(math.rad(y) / DIMUL, math.rad(-x) / DIMUL, TWIST and math.rad(x) / DIMUL or 0)
			local color, mat = cast(cf.p, cf.LookVector, 1)
			if not raymap[y + (RES_Y/2)][x + (RES_X/2)] then
				raymap[y + (RES_Y)/2][x + (RES_X/2)] = color
			end
			if not LENIENT then statelabel.Text = ('Ray %i:%i loaded'):format(x, y) end
			local shouldPause = if LENIENT then x % 2048 == 0 else x % 32 == 0
			if shouldPause then
				task.wait()
			end
		end
	end
	tool.Parent = owner.Character
	handle.Anchored = false
	statelabel.Text = 'Rendering'
	local offset = owner.Character.Head.Position
	if RENDER_MODE == 'Part' then
		for y, xl in next, raymap do
			if LENIENT then statelabel.Text = ('Rendering column %i'):format(x) end
			for x, vp in next, xl do
				local pixel = Instance.new('WedgePart')
				pixel.Size = PIXEL_SIZE
				pixel.Position = offset + (Vector3.new(x, y) * PIXEL_SIZE.X)
				pixel.Color = vp
				--pixel.Material = vp[2]
				pixel.Anchored = true
				pixel.CanCollide = false
				pixel.Parent = script
				if not LENIENT then statelabel.Text = ('Pixel %i:%i rendered'):format(x, y) end
				local shouldPause = if LENIENT then y % 10 == 0 else y % 8 == 0
				if shouldPause then
					task.wait()
				end
			end
		end
		if ALBUM then
			table.insert(album, {rays = raymap})
		end
	elseif RENDER_MODE == 'Text' then
		local outlist = {}
		for y, xl in ipairs(raymap) do
			local prev_color = nil
			local out = ''
			for x, vp in ipairs(xl) do
				if not prev_color then
					prev_color = vp
					out ..= ('<font color="#%s">█'):format(vp:ToHex())
				elseif prev_color.R == vp.R and prev_color.G == vp.G and prev_color.B == vp.B then
					out ..= '█'
				else
					out ..= ('</font><font color="#%s">█'):format(vp:ToHex())
					prev_color = vp
				end
				if x % 32 == 0 then task.wait() end
			end
			out ..= '</font>'
			table.insert(outlist, out)
		end
		local part = Instance.new('Part')
		part.Size = Vector3.new(5, 5, 0.1)
		part.Position = owner.Character.Head.Position
		part.Anchored = true
		part.CanCollide = false
		local gui = Instance.new('SurfaceGui', part)
		local label = Instance.new('TextBox')
		label.RichText = true
		label.Font = 'Code'
		label.Size = UDim2.fromScale(1, 1/#outlist)
		label.TextScaled = true
		label.BackgroundTransparency = 1
		for i, out in next, outlist do
			local b = label:Clone()
			b.Text = out
			b.Position = UDim2.fromScale(0, (1/#outlist) * (#outlist-(i-1)))
			if i % 32 == 0 then task.wait() end
			b.Parent = gui
		end
		part.Parent = script
		if ALBUM then
			table.insert(album, {render = outlist, rays = raymap})
		end
	elseif RENDER_MODE == 'Sound' then
		print('Creating base sound')
		local sound = Instance.new('Sound')
		sound.SoundId = 'rbxassetid://12221967'
		sound.Parent = owner.Character.Head
		if not sound.IsLoaded then sound.Loaded:Wait() end

		for y, xl in ipairs(raymap) do
			for x, vp in ipairs(xl) do
				local h, s, v = vp:ToHSV()
				statelabel.Text = ('Playing pixel %i:%i with pitch %.1f and volume %.1f'):format(x, y, h * 2, v * 1.5)
				sound.PlaybackSpeed = h * 2
				sound.Volume = v * 1.5
				sound:Play()
				task.wait()
			end
		end
		sound:Destroy()

		if ALBUM then
			table.insert(ALBUM, {rays = raymap})
		end
	end
	if ALBUM then
		statelabel.Text = 'Saved at #' .. #album
	else
		statelabel.Text = 'Done!'
	end
end)

local prevcommand
owner.Chatted:Connect(function(c)
	if c == '%^' then
		c = prevcommand
	else
		prevcommand = c
	end
	if c == '%discard' then
		script:ClearAllChildren()
	elseif ALBUM and c == '%clearalbum' then
		table.clear(album)
	elseif ALBUM and c:sub(1, 6) == '%album' then
		local outlist = album[tonumber(c:sub(7, 8))].render

		local part = Instance.new('Part')
		part.Size = Vector3.new(5, 5, 0.1)
		part.Position = owner.Character.Head.Position
		part.Anchored = true
		part.CanCollide = false
		local gui = Instance.new('SurfaceGui', part)
		local label = Instance.new('TextBox')
		label.RichText = true
		label.Font = 'Code'
		label.Size = UDim2.fromScale(1, 1/#outlist)
		label.TextScaled = true
		label.BackgroundTransparency = 1
		for i, out in next, outlist do
			local b = label:Clone()
			b.Text = out
			b.Position = UDim2.fromScale(0, (1/#outlist) * (#outlist-(i-1)))
			if i % 32 == 0 then task.wait() end
			b.Parent = gui
		end
		part.Parent = script
	elseif ALBUM and c:sub(1, 7) == '%upload' then
		local outlist = album[tonumber(c:sub(9, 10))].rays
		local t = string.char
		local length = 52 + (#outlist * #outlist[1] * 3)
		local bmp = Bitmap.empty_bitmap(RES_X, RES_Y)
		for y, row in next, outlist do
			for x, pixel in next, row do
				bmp:set_pixel(x, RES_Y-y, pixel.R * 255, pixel.G * 255, pixel.B * 255)
				if x % 32 == 0 then task.wait() end
			end
		end
		print(http:PostAsync(c:sub(12, -1), bmp:tostring()))
	elseif c:sub(1, 5) == '%conf' then
		local command = c:split(' ')
		if command[2] == 'RES_X' then
			RES_X = tonumber(command[3])
		elseif command[2] == 'RES_Y' then
			RES_Y = tonumber(command[3])
		elseif command[2] == 'DIMUL' then
			DIMUL = tonumber(command[3])
		elseif command[2] == 'RENDER_MODE' then
			RENDER_MODE = command[3]
		elseif command[2] == 'SHADOWS' then
			SHADOWS = command[3] == 'true'
		elseif command[2] == 'MULTI_LIGHT' then
			MULTI_LIGHT = command[3] == 'true'
		elseif command[2] == 'DRONE_SHOT' then
			DRONE_SHOT = command[3] == 'true'
		end
	end
end)
