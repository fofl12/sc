local rows, columns = 25, 40

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

out('` HI\n')
out('` MULTI\nLINE\n')
out('` HJASH#HWTHWQ^Jiw6j3i6j7i3j5i7j5\n')
out('` PART 1')
out('PART 2\n')
for i = 1, 10 do
	task.wait(0.01)
	out('` SCROLLING TEST ' .. i .. '\n')
end
out('Output tests complete\n')
out('-- TESTING COMPLETE ' .. string.rep('-', columns - 20) .. '\n')
out('Welcome to Marcuskernel !\n')
out('Establishing input connection...\n')
local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(400, 20)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)
frame.Parent = ui

local message = Instance.new('TextBox')
message.Text = ''
message.ClearTextOnFocus = false
message.Size = UDim2.fromScale(1, 1)
message.Parent = frame

message.FocusLost:Connect(function(r)
	if r then
		remote:FireServer(message.Text)
		message:CaptureFocus()
		print(#message.Text)
	end
end)

ui.Parent = script
]], remote)
out('Initiating REPL...\n')
local env = {}
env = {
	out = out,
	outconf = function(b, f)
		bg = b
		fg = f
	end,
	Color3 = Color3,
	input = function()
		return select(2, remote.OnServerEvent:Wait())
	end,
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
	ds = function(n)
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
			local i = env.input()
			local m = i:sub(1, 1)
			if m == 'w' then
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
			elseif m == 's' then
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
			elseif m == 'q' then
				running = false
			end
		end
		noline = false
	end,
	edit = function(str)
		local lines = env[str]:split('\n')
		local line = 1
		out('edit - type ? for help\n')
		local running = true
		while running do
			out('> ')
			local i = env.input()
			out(i .. '\n')
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
	end,
}
while true do
	out('] ')
	local message = select(2, remote.OnServerEvent:Wait())
	out(message .. '\n')
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
		out('[EXEC ERROR: ' .. message or 'NOT SPECIFIED' .. ']\n')
		env.outconf(Color3.new(), Color3.new(1, 1, 1))
	end
end
