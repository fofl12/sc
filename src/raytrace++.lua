local TWIST = true
local RES_X = 120
local RES_Y = 90
local PIXEL_SIZE = Vector3.one * 0.1
local DIMUL = 3
local LENIENT = false
local PHOTO_BOOK = true -- Requires RENDER_MODE to be Text
local RENDER_MODE = 'Text'

local tool = Instance.new('Tool')
tool.Name = 'Camera'
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
local remote = Instance.new('RemoteEvent')
remote.Name = 'RemoteLinker'
remote.Parent = tool
NLS([[
local remote = script.Parent:WaitForChild('RemoteLinker')
script.Parent.Activated:Connect(function()
	remote:FireServer()
end)
]], tool)
statelabel.Text = 'Ready'

local matmap = {
	[Enum.Material.Water] = Enum.Material.Glass,
	[Enum.Material.Grass] = Enum.Material.Grass
}
setmetatable(matmap, {__index=function(t,k)return k end})

local function cast(origin, dir, layer, raymap, lx, ly)
	local ray = workspace:Raycast(origin, dir * 500)
	local color, mat, dist
	if layer > 8 then
		ray = nil
	end
	if layer == 6 and not LENIENT then
		task.wait()
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
			local sparkles = ray.Instance:FindFirstChildWhichIsA('Sparkles')
			if sparkles and raymap and sparkles.Enabled and math.random() > 0.7 then
				local nx = lx + math.random(-20, 20)
				local ny = -ly + math.random(-20, 20)
				if not raymap[nx] then
					raymap[nx] = {}
				end
				raymap[nx][ny] = {sparkles.SparkleColor, Enum.Material.Neon}
			end
		end
		local dot = (-sunormal):Dot(ray.Normal)
		color = color:lerp(Color3.new(.2,.2,.2), (dot+1)/2)
		local shadowRay = workspace:Raycast(ray.Position, sunormal * 30)
		if shadowRay and shadowRay.Instance ~= ray.Instance and shadowRay.Instance.CastShadow then
			color = color:lerp(Color3.new(.2,.2,.2), 1 - (shadowRay.Distance / 30))
		end
	else
		color, mat, dist = BrickColor.Blue().Color, Enum.Material.Plastic, math.huge
	end
	return color, mat, dist
end

remote.OnServerEvent:Connect(function()
	statelabel.Text = 'Firing rays'
	sunormal = game.Lighting:GetSunDirection()
	handle.Anchored = true

	local raymap = {}
	for y = -(RES_Y/2), (RES_Y/2) do
		if not raymap[y+(RES_Y/2)] then
			raymap[y+(RES_Y/2)] = {}
		end
		if LENIENT then
			statelabel.Text = ('Loading row %i'):format(x)
		end
		for x = -(RES_X/2), (RES_X/2) do
			local cf = handle.CFrame * CFrame.fromOrientation(math.rad(y) / DIMUL, math.rad(-x) / DIMUL, TWIST and math.rad(x) / DIMUL or 0)
			local color, mat = cast(cf.p, cf.LookVector, 1, raymap, x, y)
			if not raymap[y + (RES_Y/2)][x + (RES_X/2)] then
				raymap[y + (RES_Y)/2][x + (RES_X/2)] = {color, mat}
			end
			if not LENIENT then statelabel.Text = ('Ray %i:%i loaded'):format(x, y) end
			local shouldPause = if LENIENT then x % 2048 == 0 else x % 32 == 0
			if shouldPause then
				task.wait()
			end
		end
	end
	handle.Anchored = false
	statelabel.Text = 'Rendering'
	local offset = owner.Character.Head.Position
	if RENDER_MODE == 'Part' then
		for y, xl in next, raymap do
			if LENIENT then statelabel.Text = ('Rendering column %i'):format(x) end
			for x, vp in next, yl do
				local pixel = Instance.new('WedgePart')
				pixel.Size = PIXEL_SIZE
				pixel.Position = offset + (Vector3.new(x, y) * PIXEL_SIZE.X)
				pixel.Color = vp[1]
				pixel.Material = vp[2]
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
	elseif RENDER_MODE == 'Text' then
		local outlist = {}
		for y, xl in ipairs(raymap) do
			local prev_color = nil
			local out = ''
			for x, vp in ipairs(xl) do
				if not prev_color then
					prev_color = vp[1]
					out ..= ('<font color="#%s">█'):format(vp[1]:ToHex())
				elseif prev_color == vp[1] then
					out ..= '█'
				else
					out ..= ('</font><font color="#%s">█'):format(vp[1]:ToHex())
			
				end
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
			b.Parent = gui
		end
		part.Parent = script
	end
	statelabel.Text = 'Done!'
	task.delay(3, function()
		if statelabel.Text ~= 'Done!' then return end
		statelabel.Text = 'Ready'
	end)
end)

owner.Chatted:Connect(function(c)
	if c == '%discard' then
		script:ClearAllChildren()
	end
end)
