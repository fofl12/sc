local display = Instance.new('Part')
display.BrickColor = BrickColor.new('Black')
display.Size = Vector3.new(4, 3, 0.5)
display.Position = owner.Character.Head.Position
display.Anchored = true
display.CanCollide = false
display.Parent = script

local linker = owner.Backpack.ctools.linkerPort
assert(linker, 'lack of Linker Port!?!?!?')

local gui = Instance.new('SurfaceGui', display)

local frame = Instance.new('Frame', gui)
frame.BackgroundTransparency = 1
frame.Size = UDim2.fromScale(1, 1)

local layout = Instance.new('UIListLayout', frame)

function log(text)
	local label = Instance.new('TextBox')
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = 'Code'
	label.TextWrap = true
	label.AutomaticSize = Enum.AutomaticSize.XY
	label.Size = UDim2.fromScale(0,0)
	label.TextSize = 30
	label.Parent = frame
end

log('CogTools Advanced Manipulation Terminal')
log('Please enable Capture in ct to use CTAMT')
log('Today is Piza Day! Head on down to the Cafeteria to get your fresh slice of Piza.')
log('Commands (extension to built in):')
log('- ls')
log('- there are none')

local lastRequest

linker.Event:Connect(function(name, meta)
	if name == 'toggleCapture' then
		log('Warning! Capture has been disabled.')
	elseif name == 'ls' then
		log('Requesting build folder...')
		lastRequest = 'ls'
		linker:Fire('buildFolder')
	elseif name == 'callback' then
		if lastRequest == 'ls' then
			log('Directory:')
			for _, obj in next, meta:GetChildren() do
				log('- ' .. obj.Name .. ' / ' .. obj.ClassName)
			end
		end
	else
		log('Unknown command ' .. name)
	end
end)

display.Parent = script