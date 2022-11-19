local decter = Instance.new('Part')
local buton = Instance.new('Part')
decter.Position = owner.Character.Head.Position - Vector3.yAxis * 4
decter.Anchored = true
decter.Size = Vector3.new(4, 1, 4)
decter.Parent = script
buton.Position = decter.Position + Vector3.xAxis * 4
buton.Size = Vector3.one * 2
buton.Anchored = true
buton.Parent = script

local sect
do
	local dgui = Instance.new('SurfaceGui', decter)
	dgui.Face = 'Top'
	local dbut =  Instance.new('TextButton', dgui)
	dbut.Text = 'Scan'
	dbut.Size = UDim2.fromScale(1, 1)
	dbut.TextScaled = true
	local bgui = dgui:Clone()
	bgui.TextButton.Text = 'You need to scan'
	bgui.Parent = buton

	dbut.MouseButton1Click:Connect(function()
		local res
		for x = -2, 2 do
			for y = -2, 2 do
				local h = workspace:Raycast(decter.Position + Vector3.new(x, 0, y), Vector3.yAxis)
				if h then
					res = h.Instance
				end
				if res then break end
			end
			if res then break end
		end
		if res.Parent:IsA'Tool' then
			dbut.Text = 'Scanned'
			sect = res.Parent
			bgui.TextButton.Text = sect.Name
		else
			dbut.Text = 'No'
		end
	end)
	bgui.TextButton.MouseButton1Click:Connect(function()
		if sect then
			bgui.TextButton.Text = 'Ok'
			local parnt = sect.Parent
			while task.wait() do
				sect:Clone().Parent = parnt
			end
		else
			bgui.TextButton.Text = 'No'
		end
	end)
end