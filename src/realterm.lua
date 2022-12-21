local rows, columns = 25, 40
local autoload = true

local uis = game:service'UserInputService'

local board = Instance.new('Part')
board.Position = owner.Character.Head.Position + Vector3.new(0, 2)
board.Size = Vector3.new(12, 12, 0)
board.Color = Color3.new()
board.Anchored = true
board.Transparency = 0.6
board.Material = 'Glass'
board.Parent = script

local gui = Instance.new('SurfaceGui')
gui.SizingMode = 'PixelsPerStud'

local chatText = Instance.new('TextBox')
chatText.Font = 'Code'
chatText.BorderSizePixel = 0
chatText.TextXAlignment = 'Left'
chatText.RichText = true
chatText.BackgroundTransparency = 1
chatText.TextColor3 = Color3.new(1, 1, 1)
chatText.Size = UDim2.fromScale(1 / columns, 1 / rows)
chatText.TextScaled = true
chatText.TextYAlignment = 'Top'

local grid = {}
for x = 0, columns - 1 do
	grid[x] = {}
	for y = 0, rows - 1 do
		local text = chatText:Clone()
		text.Position = UDim2.fromScale(x / columns, y / rows)
		text.Text = ''
		text.Parent = gui
		grid[x][y] = text
		if y % 8 == 0 then
			task.wait()
		end
	end
end
gui.Parent = board

local x, y, noline = 0, 0, false
local bg, fg = Color3.new(), Color3.new(1, 1, 1)
local function clone(t)
	local new = {}
	for k, v in next, t do
		if type(v) == 'table' then
			new[k] = clone(v)
		elseif typeof(v) == 'Instance' then
			new[k] = {
				BackgroundTransparency = v.BackgroundTransparency,
				Text = v.Text,
				BackgroundColor3 = v.BackgroundColor3,
				TextColor3 = v.TextColor3
			}
		else
			new[k] = v
		end
	end
	return new
end
local function compareColor(a, b)
	return a.R == b.R and a.G == b.G and a.B == b.B
end
local function scroll(n)
	local buffer = clone(grid)
	for x = 0, columns - 1 do
		for y = n<0 and 0 or n, n<0 and rows - (-n + 1) or rows - 1 do
			local target = grid[x][y]
			local buffered = buffer[x][y-n]
			target.Text = buffered.Text
			target.BackgroundTransparency = buffered.BackgroundTransparency
			target.BackgroundColor3 = buffered.BackgroundColor3
			target.TextColor3 = buffered.TextColor3
		end
		local target
		if n < 0 then
			target = grid[x][rows - 1]
		elseif n > 0 then
			target = grid[x][0]
		end
		target.Text = ''
		target.BackgroundTransparency = 1
		target.BackgroundColor3 = Color3.new()
		target.TextColor3 = Color3.new(1, 1, 1)
	end
	y += n
end
local function out(str)
	for f, l in utf8.graphemes(str) do
		local c = str:sub(f, l)
		if y >= rows then
			scroll(-1)
		end
		if c == '\n' then
			y += 1
			x = 0
		elseif x < columns then
			grid[x][y].Text = c
			if compareColor(bg, Color3.new()) then
				grid[x][y].BackgroundTransparency = 1
			else
				grid[x][y].BackgroundTransparency = 0
				grid[x][y].BackgroundColor3 = bg
			end
			grid[x][y].TextColor3 = fg
			x += 1
			if x >= columns and not noline then
				y += 1
				x = 0
				print('Wrapping', noline)
			end
		end
	end
end

out('Welcome to Marcuskernel !\n')
out('Establishing input connection...\n')
local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local uis = game:service'UserInputService'
local remote = script.Parent

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(20, 20)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)
frame.Parent = ui

local message = Instance.new('TextBox')
message.Text = ''
message.Size = UDim2.fromScale(1, 1)
message.Parent = frame

message.FocusLost:Connect(function(r)
	if r then
		remote:FireServer(Enum.KeyCode.Return)
		message.Text = ''
	end
end)
uis.InputBegan:Connect(function(i)
	if i.UserInputType.Name == 'Keyboard' and message:IsFocused() then
		remote:FireServer(i.KeyCode)
		message.Text = ''
	end
end)
uis.InputEnded:Connect(function(i)
	if i.KeyCode.Name == 'LeftShift' and message:IsFocused() then
		remote:FireServer(i.KeyCode)
	end
end)

ui.Parent = script
]], remote)
local shiftmap = {
	['1'] = '!',
	['2'] = '@',
	['3'] = '#',
	['4'] = '$',
	['5'] = '%',
	['6'] = '^',
	['7'] = '&',
	['8'] = '*',
	['9'] = '(',
	['0'] = ')',
	['-'] = '_',
	['='] = '+',
	['['] = '{',
	[']'] = '}',
	[';'] = ':',
	["'"] = '"',
	['\\'] = '|',
	[','] = '<',
	['.'] = '>',
	['/'] = '?'
}
local cmap = {
	One = '1',
	Two = '2',
	Three = '3',
	Four = '4',
	Five = '5',
	Six = '6',
	Seven = '7',
	Eight = '8',
	Nine = '9',
	Zero = '0',
	Minus = '-',
	Equals = '=',
	LeftBracket = '[',
	RightBracket = ']',
	Semicolon = ';',
	Quote = "'",
	QuotedDouble = '"',
	BackSlash = '\\',
	Comma = ',',
	Period = '.',
	Slash = '/',
	Space = ' '
}
local function input()
	local message = ''
	local done = false
	local shift = false
	repeat
		local input = select(2, remote.OnServerEvent:Wait())
		local string = uis:GetStringForKeyCode(input)
		if #string > 1 then
			string = cmap[string] or '?'
		end
		if input.Name == 'Return' then
			done = true
		elseif input.Name == 'Backspace' then
			if #message > 0 then
				message = message:sub(1, -2)
				x -= 1
				if x < 0 then
					x = columns - 1
					y -= 1
				end
				grid[x][y].Text = ''
			end
		elseif input.Name == 'Tab' then
			message ..= '    '
		elseif input.Name == 'LeftShift' then
			shift = not shift
			print(shift)
		elseif shiftmap[string] then
			if shift then
				string = shiftmap[string]
			end
			message ..= string
			out(string)
			print'special'
		elseif shift then
			message ..= string:upper()
			out(string:upper())
		else
			message ..= string:lower()
			out(string:lower())
		end
		print(done)
	until done
	return message
end


out('Initializing Lua REPL...\n')
local env = {}
env = {
	ps = "] ",
	out = out,
	grid = function(x, y)
		return grid[x][y]
	end,
	outconf = function(b, f)
		bg = b
		fg = f
	end,
	Color3 = Color3,
	rawinput = function()
		return select(2, remote.OnServerEvent:Wait())
	end,
	input = input,
	table = table,
	tostring = tostring,
	tonumber = tonumber,
	math = math,
	service = function(n)
		return game:GetService(n)
	end,
	owner = owner,
	select = select,
	load = function(text)
		local loaded = loadstring(text)
		setfenv(loaded, env)
		loaded()
	end,
	loadstring = loadstring,
	getfenv = getfenv,
	wait = task.wait,
	nds = function(n)
		local dss = game:GetService('DataStoreService')
		return dss:GetDataStore(n or 'marcuskernel' .. owner.UserId)
	end,
	newline = '\n',
	less = function(str)
		local lines = str:split('\n')
		local line = 0
		local running = true
		noline = true
		for i = line, rows + line do
			if lines[i] then
				out(i .. ' ' .. lines[i] .. '\n')
			else
				out('\n')
			end
		end
		while running do
			local i = env.rawinput()
			if i == Enum.KeyCode.Up then
				scroll(1)
				y = 0
				line -= 1
				if lines[line] then
					out(line .. ' ' .. lines[line] .. '\n')
					print'printed'
				else
					out('\n')
					print(line)
				end
			elseif i == Enum.KeyCode.Down then
				scroll(-1)
				y = rows - 1
				line += 1
				if lines[line + rows - 1] then
					out((line + rows - 1) .. ' ' .. lines[line + rows - 1] .. '\n')
					print'printed'
				else
					out('\n')
					print(line)
				end
			elseif i == Enum.KeyCode.Q then
				running = false
			end
		end
		noline = false
	end,
	eline = function(str)
		local lines = env[str]:split('\n')
		local line = 1
		out('eline - type ? for help\n')
		local running = true
		while running do
			out('> ')
			local i = input()
			out('\n')
			local m = i:sub(1, 1)
			if m == '?' then
				out('?: get help\nw: write to line\ni: insert line\nr: read line\nrl: read with less\ng: go to line\nz: save\nx: exit\n')
			elseif m == 'r' then
				if i:sub(2, 2) == 'l' then
					env.less(table.concat(lines, '\n'))
				else
					out(lines[line] .. '\n')
				end
			elseif m == 'g' then
				line = tonumber(i:sub(2, -1))
			elseif m == 'w' then
				lines[line] = i:sub(2, -1)
			elseif m == 'i' then
				table.insert(lines, line, i:sub(2, -1))
			elseif m == 'z' then
				env[str] = table.concat(lines, '\n')
				out('Wrote to ' .. str .. '\n')
			elseif m == 'x' then
				running = false
			end
		end
		out('Done editing\n')
	end
}
if autoload then
	out('Loading autoload script...\n')
	env.ds = env.nds()
	env.autoload = env.ds:GetAsync('autoload')
	print(env.autoload)
	if not autoload then
		env.outconf(Color3.new(), Color3.new(1, 0, 0))
		out('No autoload script found!\n')
		env.outconf(Color3.new(), Color3.new(1, 1, 1))
	else
		for i, line in next, env.autoload:split('\n') do
			local loaded = loadstring(line)
			if loaded then
				setfenv(loaded, env)
				local success, message = pcall(loaded)
				if not success then
					env.outconf(Color3.new(), Color3.new(1, 0, 0))
					out('Error in autoload script on line ' .. i .. '\n')
					print(message)
					env.outconf(Color3.new(), Color3.new(1, 1, 1))
					break
				end
			else
				env.outconf(Color3.new(), Color3.new(1, 0, 0))
				out('Syntax Error in autoload script on line ' .. i .. '!\n')
				env.outconf(Color3.new(), Color3.new(1, 1, 1))
				break
			end
		end
	end
end
out('Ready\n')
while true do
	out(env.ps)
	local message = input()
	out('\n')
	local loaded = loadstring(message)
	if not loaded then
		env.outconf(Color3.new(), Color3.new(1, 0, 0))
		out('[SYNTAX ERROR]\n')
		env.outconf(Color3.new(), Color3.new(1, 1, 1))
		continue
	end
	setfenv(loaded, env)
	local success, message = pcall(loaded)
	if not success then
		env.outconf(Color3.new(), Color3.new(1, 0, 0))
		out('[EXEC ERROR: ' .. (message or 'NOT SPECIFIED') .. ']\n')
		env.outconf(Color3.new(), Color3.new(1, 1, 1))
	end
end
