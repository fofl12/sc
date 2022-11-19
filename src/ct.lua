local debris = game:GetService('Debris')

local nouns = {
	'cat',
	'dog',
	'sword',
	'house',
	'building',
	'person',
	'zone',
	'doctor',
	'lawyer'
}
local adjectives = {
	'large',
	'small',
	'wide',
	'short',
	'orange',
	'destructive',
	'creative',
	'blue',
	'combusting',
	'liquid'
}

local function dirLayout(callback, root, _recursed)
	if not _recursed then
		callback(root.Name)
	end
	for _, o in next, root:GetChildren() do
		if o.Name:sub(1, 1) ~= '_' then
			callback('> ' .. o.Name .. ' / ' .. o.ClassName)
			dirLayout(function(c)
				callback('> ' .. c)
			end, o, true)
		end
	end
end

-- local capture = false
local buildFolder = Instance.new('Folder', script)
buildFolder.Name = adjectives[math.random(1,#adjectives)] .. nouns[math.random(1,#nouns)]
local rootFolder = buildFolder
local coreFolder = Instance.new('Folder', script)
coreFolder.Name = '_core'

local tool = Instance.new('Tool')
tool.Name = 'ctools'
tool.ToolTip = 'Building Tools'
tool.Grip = CFrame.Angles(0, math.pi, 0) + Vector3.new(0, -0.5, 0)

local handle = Instance.new('Part')
handle.Name = 'Handle'
local mesh = Instance.new('FileMesh', handle)
mesh.Scale = Vector3.new(0.7, 0.7, 0.7)
mesh.MeshId = 'rbxassetid://6768280850'
mesh.TextureId = 'rbxassetid://6772074251'
handle.Parent = tool

do
	local manual = Instance.new('Tool')
	manual.Name = 'CTManual'
	manual.ToolTip = 'Handbook for ctools'
	local manualHandle = Instance.new('Part', manual)
	manualHandle.Size = Vector3.one
	manualHandle.Name = 'Handle'
	NLS([==[
		local gui = Instance.new('ScreenGui')
		local frame = Instance.new('ScrollingFrame', gui)
		frame.Name = 'Manual'
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromOffset(400, 300)
		local text = Instance.new('TextLabel', frame)
		text.Size = UDim2.fromScale(1, 1)
		text.TextWrap = true
		text.TextXAlignment = 'Left'
		text.TextYAlignment = 'Top'
		text.Text = [[
# Keymap
. set mode
, start command
; end command

# Modes
- g: Move
- r: Rotate
- s: Resize
- c: Clone
- x: Remove

# Commands
- oldInputMethod [bool]: set if you want to use the old input method
- color [brickcolor code]: set color of selected
- mat [material code]: set material of selected
- bool [property name] [value]: set bool property of selected
- num [property name] [value]: set number property of selected
- str [propery name] [value]: set string property of selected
- new [classname?] [parentInSelection?]: create a new BasePart in building dir
- tnew [classname] [parentInSelection?]: create a new instance in building dir
- dir: show root directory structure
- hideDir: hide screen from dir
- import: import external selected object to building dir
- export: export contents of the root dir to a folder that won't be deleted when the ct script is deleted. The folder where contents will be exported to will have the same name as the root dir
- lua [script]: spawn a script in the current selection
- cd [name]: change building dir, use .. to go up
- snap [number]: set snap to [number] studs
- rotsnap [number]: set rotation snap to [number] degrees
- cd [name]: set selection to an instance in the selection, .. to go up
- mark [name]: make a reference in _G to selected
]]
		script.Parent.Equipped:Connect(function()
			gui.Parent = owner.PlayerGui
		end)
		script.Parent.Unequipped:Connect(function()
			gui.Parent = nil
		end)
	]==], manual)''
	manual.Parent = owner.Backpack
end

local screen = Instance.new('Part')
screen.Name = 'Screen'
screen.Size = Vector3.new(0, 1, 1.5)
screen.Material = 'SmoothPlastic'
screen.Parent = handle
local gui = Instance.new('SurfaceGui', screen)
gui.Face = 'Left'
local labe = Instance.new('TextBox', gui)
labe.TextScaled = true
labe.Text = 'INDUSTRAIL BUILDING LOGGING DEVICE'
labe.Size = UDim2.fromScale(1, 1)
local weld = Instance.new('Weld')
weld.Part0 = handle
weld.Part1 = screen
weld.C0 = CFrame.Angles(0, math.pi/2 + math.pi/4, 0) + Vector3.new(3, 0, 0)
weld.Parent = tool

local dirScreen = Instance.new('Part')
dirScreen.Transparency = 1
dirScreen.Anchored = true
dirScreen.Size = Vector3.new(6, 6, 0.5)
dirScreen.CanCollide = false
local dirGui = Instance.new('SurfaceGui', dirScreen)
dirGui.Enabled = false
Instance.new('UIListLayout', dirGui)
local dirTemplate = Instance.new('TextButton')
dirTemplate.BackgroundTransparency = 1
dirTemplate.AutomaticSize = 'XY'
dirTemplate.Size = UDim2.fromScale(0, 0)
dirTemplate.Font = 'Code'
dirTemplate.TextWrap = true
dirTemplate.TextSize = 20
dirScreen.Parent = coreFolder

local port = Instance.new('RemoteEvent', tool)
port.Name = 'scPort'

-- local linker = Instance.new('BindableEvent', tool)
-- linker.Name = 'linkerPort'

-- linker.Event:Connect(function(req, meta)
	-- if req == 'buildFolder' then
		-- linker:Fire('callback', buildFolder)
	-- end
-- end)

port.OnServerEvent:Connect(function(player, mode, ...)
	if player ~= owner then return end
	-- if capture then
		-- linker:Fire(mode, ...)
		-- if mode == 'toggleCapture' then
			-- capture = false
			-- print('Capture Off')
		-- end
		-- return
	-- end
	if mode == 'move' then
		local part = ({...})[1]
		local new = ({...})[2]
		part.CFrame = new
	-- elseif mode == 'toggleCapture' then
		-- capture = true
		-- print('Capture On')
	elseif mode == 'create' then
		local position = ({...})[1]
		local type = ({...})[2]
		local parent = ({...})[3]
		local part = Instance.new(type, parent or buildFolder)
		part.Name = adjectives[math.random(1,#adjectives)] .. nouns[math.random(1,#nouns)]
		if position then
			part.Position = position
			part.Anchored = true
		end
	elseif mode == 'resize' then
		local part = ({...})[1]
		local new = ({...})[2]
		part.Size = new
	elseif mode == 'prop' then
		local part = ({...})[1]
		local new = ({...})[2]
		local val = ({...})[3]
		if type(part) == 'string' then
			part = buildFolder:FindFirstChild(part)
		end
		part[val] = new
	elseif mode == 'delete' then
		local part = ({...})[1]
		part:Destroy()
	elseif mode == 'clone' then
		local part = ({...})[1]
		part:Clone().Parent = part.Parent
	elseif mode == 'dir' then
		local opt = ({...})[1]
		if opt then
			dirScreen.Position = owner.Character.Head.Position
			dirScreen.Transparency = 0
			dirGui.Enabled = true
			for _, o in next, dirGui:GetChildren() do
				if not o:IsA('UIListLayout') then
					o:Destroy()
				end
			end
			dirLayout(function(c)
				local label = dirTemplate:Clone()
				label.Text = c
				label.Parent = dirGui
			end, rootFolder)
		else
			dirScreen.Transparency = 1
			dirGui.Enabled = false
		end
	elseif mode == 'import' then
		({...})[1].Parent = buildFolder
	elseif mode == 'export' then
		local export = buildFolder:Clone()
		export:SetAttribute('isCtRoot', true)
		buildFolder:ClearAllChildren()
		export.Parent = workspace
	elseif mode == 'mark' then
		local selected = ({...})[1]
		local name = ({...})[2]
		_G[name] = selected
	elseif mode == 'lua' then
		local selected = ({...})[1]
		local script = ({...})[2]
		NS(script, selected)
	end
end)
NLS([[
	local oldListen = false
	local snap = 1
	local rotsnap = math.rad(45)
	local typing = false
	
	local port = script.Parent
	local tool = port.Parent
	local gui = Instance.new('SurfaceGui', script)
	gui.Adornee = tool:WaitForChild('Handle'):WaitForChild('Screen')
	gui.Face = 'Right'
	local listLayout = Instance.new('UIListLayout')
	listLayout.FillDirection = 'Vertical'
	listLayout.VerticalAlignment = 'Bottom'
	listLayout.Parent = gui
	repeat
		script.Parent = owner.PlayerGui
		task.wait()
	until script.Parent == owner.PlayerGui
	local mouse = owner:GetMouse()
	local mode = 'm'
	local cas = game:GetService('ContextActionService')
	local uis = game:GetService('UserInputService')

	local function output(text)
		local new = Instance.new('TextBox')
		new.Text = text
		new.Font = 'Code'
		new.AutomaticSize = 'XY'
		new.BackgroundTransparency = 1
		new.TextSize = 30
		new.Parent = gui
		return new
	end



	local function lineThickness(obj)
		local average = (obj.Size.X + obj.Size.Y + obj.Size.Z) / 3
		return average / 64
	end

	local move = Instance.new('Handles', script)
	local rotate = Instance.new('ArcHandles', script)
	local highlight = Instance.new('SelectionBox', script)

	local selection = nil
	local origin = nil

	local function handleCommand(command) -- for parity on commands
		if command[1] == 'color' then
			port:FireServer('prop', selection, BrickColor.new(tonumber(command[2])), 'BrickColor')
		elseif command[1] == 'mat' then
			port:FireServer('prop', selection, command[2], 'Material')
		elseif command[1] == 'bool' then
			port:FireServer('prop', command[4] or selection, command[3] == 'true' and true or false, command[2])
		elseif command[1] == 'num' then
			local num, _ = command[3]:gsub("/", ".")
			port:FireServer('prop', command[4] or selection, tonumber(num), command[2])
		elseif command[1] == 'str' then
			port:FireServer('prop', command[4] or selection, command[3], command[2])
		elseif command[1] == 'new' then
			local rp = mouse.Hit.p
			local pos = Vector3.new(math.round(rp.X / snap) * snap, math.round(rp.Y / snap) * snap, math.round(rp.Z / snap) * snap)
			port:FireServer('create', pos, command[2] or 'Part', command[3] and selection or false)
		elseif command[1] == 'tnew' then
			port:FireServer('create', false, command[2], command[3] and selection or false)
		elseif command[1] == 'dir' then
			port:FireServer('dir', true)
		elseif command[1] == 'hideDir' then
			port:FireServer('dir', false)
		elseif command[1] == 'import' then
			port:FireServer('import', selection)
		elseif command[1] == 'export' then
			port:FireServer('export')
		elseif command[1] == 'cd' then
			port:FireServer('cd', command[2])
		elseif command[1] == 'snap' then
			local num, _ = command[2]:gsub("/", ".")
			snap = num
		elseif command[1] == 'rotsnap' then
			local num, _ = command[2]:gsub("/", ".")
			rotsnap = math.rad(num)
		elseif command[1] == 'oldInputMethod' then
			oldInput = command[2] == 'true'
		elseif command[1] == 'mark' then
			port:FireServer('mark', selection, command[2])
		else
			output('? What')
		end
	end

	owner.Chatted:Connect(function(m)
		if not oldInput then
			local vis = output('~ ' .. m)
			if m:sub(1, 1) == '.' then
				oldmode = mode
				mode = m:sub(2, 2)
				if mode == 'g' then
					rotate.Visible = false
					move.Visible = true
				elseif mode == 'r' then
					rotate.Visible = true
					move.Visible = false
				elseif mode == 's' then
					rotate.Visible = false
					move.Visible = true
				elseif mode == 'c' then
					port:FireServer('clone', selection)
					mode = oldmode
				elseif mode == 'x' then
					port:FireServer('delete', selection)
					mode = oldmode
				else
					mode = oldmode
					output('Invalid mode!')
				end
			elseif m:sub(1, 1) == ',' then
				local command = m:sub(2, -2):split(' ')
				handleCommand(command)
			elseif m:sub(1, 1) == '=' then
				port:FireServer('lua', selection, m:sub(2, -1))
			end
		end
	end)

	cas:BindAction('mode', function(_, state)
		if state == Enum.UserInputState.Begin and oldInput and not typing then
			local vis = output('~ .')
			local key
			local connection
			connection = uis.InputBegan:Connect(function(input, processed)
				if input.KeyCode ~= Enum.KeyCode.Period then
					key = input
					connection:Disconnect()
				end
			end)
			repeat wait() until key
			key = uis:GetStringForKeyCode(key.KeyCode):lower()
			local oldmode = mode
			mode = key
			vis.Text = '~ .' .. mode
			if mode == 'g' then
				rotate.Visible = false
				move.Visible = true
			elseif mode == 'r' then
				rotate.Visible = true
				move.Visible = false
			elseif mode == 's' then
				rotate.Visible = false
				move.Visible = true
			elseif mode == 'c' then
				port:FireServer('clone', selection)
				mode = oldmode
			elseif mode == 'x' then
				port:FireServer('delete', selection)
				mode = oldmode
			else
				mode = oldmode
				output('Invalid mode!')
			end
		end
	end, false, Enum.KeyCode.Period)
	cas:BindAction('command', function(_, state)
		if state == Enum.UserInputState.Begin and oldInput then
			local time = os.clock()
			local vis = output('~ ')
			local key = ''
			local connection
			local ready = false
			connection = uis.InputBegan:Connect(function(input, processed)
				if input.KeyCode ~= Enum.KeyCode.Comma and input.KeyCode ~= Enum.KeyCode.Semicolon then
					local text = uis:GetStringForKeyCode(input.KeyCode):lower()
					if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
						text = text:upper()
					end
					key = key .. text
					vis.Text = vis.Text .. text
				elseif input.KeyCode == Enum.KeyCode.Semicolon then
					connection:Disconnect()
					ready = true
				end
			end)
			typing = true
			repeat wait() until ready
			typing = false

			local command = key:split(' ')
			handleCommand(command)
		end
	end, false, Enum.KeyCode.Comma)

	tool.Equipped:Connect(function()
		move.Visible = true
		rotate.Visible = true
		highlight.Visible = true
	end)
	tool.Unequipped:Connect(function()
		move.Visible = false
		rotate.Visible = false
		highlight.Visible = false
	end)

	local time = 0
	local holding = false
	local dragging = false
	mouse.Button1Down:Connect(function()
		if highlight.Visible then
			time = 0
			holding = true
			repeat wait()
				time = time + 1/30
			until time > 0.4 or not holding

			if time < 0.4 then
				selection = mouse.Target
				move.Adornee = selection
				rotate.Adornee = selection
				highlight.Adornee = selection
				highlight.LineThickness = lineThickness(selection)
				output('Selected ' .. selection.Name .. ' (' .. selection.ClassName .. ')')
			else
				origin = selection.CFrame
				mouse.TargetFilter = selection
				dragging = true
			end
			time = 0
		end
	end)
	mouse.Move:Connect(function()
		if dragging and selection then
			local rhp = mouse.Hit.Position
			local hitpos = CFrame.new(math.round(rhp.X / snap) * snap, math.round(rhp.Y / snap) * snap, math.round(rhp.Z / snap) * snap)
			selection.CFrame = hitpos + Vector3.new(selection.Size.X/2, selection.Size.Y/2, selection.Size.Z/2)
		end
	end)
	mouse.Button1Up:Connect(function()
			holding = false
		if dragging then
			mouse.TargetFilter = nil
			dragging = false
			port:FireServer('move', selection, selection.CFrame)
		end
	end)

	move.MouseButton1Down:Connect(function()
		originPos = selection.CFrame
		originSize = selection.Size
	end)
	move.MouseDrag:Connect(function(face, distance)
		if mode == 'g' then
			local pos = Vector3.FromNormalId(face) * (math.round(distance / snap) * snap)
			selection.CFrame = originPos * CFrame.new(pos.X, pos.Y, pos.Z)
		elseif mode == 's' then
			local v = Vector3.FromNormalId(face)
			local pos = v * (math.round(distance / snap) * snap)
			if v.X + v.Y + v.Z < 0 then
				selection.Size = originSize - pos
				selection.CFrame = originPos + (pos * 0.5)
			else
				selection.Size = originSize + pos
				selection.CFrame = originPos + (pos * 0.5)
			end
		end
	end)
	move.MouseButton1Up:Connect(function()
		port:FireServer('resize', selection, selection.Size)
		port:FireServer('move', selection, selection.CFrame)
	end)
	rotate.MouseButton1Down:Connect(function()
		origin = selection.CFrame
	end)
	rotate.MouseDrag:Connect(function(axis, rel, delta)
		local axis = Vector3.FromAxis(axis) * (math.round(rel / rotsnap) * rotsnap)
		selection.CFrame = origin * CFrame.Angles(axis.X, axis.Y, axis.Z)
	end)
	rotate.MouseButton1Up:Connect(function()
		port:FireServer('move', selection, selection.CFrame)
	end)
]], port)

tool.Parent = owner.Backpack
