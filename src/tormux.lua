-- Compiled with roblox-ts v1.2.9
-- Bad, ugly, stupid and terrible console (how original)  //
local http = game:GetService("HttpService")
local screen = loadstring(http:GetAsync("https://raw.githubusercontent.com/snoo8/scriptsoup/main/models/tormuxUI.lua"))()
screen.Parent = script
local _cFrame = (owner.Character:FindFirstChild("Head")).CFrame
local _cFrame_1 = CFrame.new(0, 0, -5)
screen.CFrame = _cFrame * _cFrame_1
local UI = screen:FindFirstChild("SurfaceGui"):FindFirstChild("Frame")
local out = UI:FindFirstChild("output")
local widgets = UI:FindFirstChild("widgets")
local remote = Instance.new("RemoteEvent", owner:FindFirstChild("PlayerGui"))
local ref = Instance.new("ObjectValue", remote)
ref.Name = "ref"
ref.Value = screen
NLS([[
		local rem = script.Parent
		local ref = rem:WaitForChild("ref")
		local screen = ref.Value
		script.Parent = rem.Parent
		rem.Parent = script
		ref.Parent = script

		local gui = screen:WaitForChild("SurfaceGui")
		gui.Parent = script
		gui.Adornee = screen

		local UI = gui:WaitForChild("Frame")
		local box = UI:WaitForChild("input")
		local go = box:WaitForChild("go")
		local out = UI:WaitForChild("output")
		print('out')
		table.foreach(out:GetChildren(), print)
		local log = out:WaitForChild("help")
		print('hel')
		out:WaitForChild("welcome"):Destroy()
		print('des')
		log.Parent = nil
		print('go')

		go.MouseButton1Click:Connect(function()
			local text = box.Text
			print(text)
			box.Text = ""
			rem:FireServer("exec", text)
		end)
		rem:FireServer("init")
	]], remote)
local logTemplate = out:FindFirstChild("help")
local widgetTemplate = widgets:FindFirstChild("1")
local availableWidgets = {
	time = function()
		local widget = widgetTemplate:Clone()
		coroutine.wrap(function()
			while true do
				widget.Text = os.date("%H:%M")
				wait(60)
			end
		end)()
		return widget
	end,
	quote = function()
		local widget = widgetTemplate:Clone()
		coroutine.wrap(function()
			while true do
				local quote = http:JSONDecode(http:GetAsync("http://api.quotable.io/random"))
				widget.Text = quote.content
				wait(35)
			end
		end)()
		return widget
	end,
	joke = function()
		local widget = widgetTemplate:Clone()
		coroutine.wrap(function()
			while true do
				local joke = http:GetAsync("https://v2.jokeapi.dev/joke/Any?format=txt&safe-mode")
				widget.Text = joke
				wait(35)
			end
		end)()
		return widget
	end,
}
local function log(text)
	local box = logTemplate:Clone()
	box.Name = tostring(os.clock())
	box.Text = text
	box.Parent = out
	if #out:GetChildren() > 11 then
		local oldest
		local _exp = out:GetChildren()
		local _arg0 = function(box)
			if box:IsA("TextBox") then
				if oldest == nil then
					oldest = box
				elseif tonumber(oldest.Name) < tonumber(box.Name) then
					oldest = box
				end
			end
		end
		-- ▼ ReadonlyArray.forEach ▼
		for _k, _v in ipairs(_exp) do
			_arg0(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		oldest:Destroy()
	end
end
local env = getfenv(0)
local terminalLib = {
	log = log,
	help = function()
		log("terminal.log ( text: string ) -> void / log to output")
		log("terminal.help () -> void / show help")
		log("terminal.setWidget ( num: string, widget: Widget ) -> void / set widget")
		log("terminal.widgets -> Widget[] / list of widgets")
	end,
	widgets = availableWidgets,
	setWidget = function(num, widget)
		local _result = widgets:FindFirstChild(num)
		if _result ~= nil then
			_result:Destroy()
		end
		local newWidget = widget()
		newWidget.Name = num
		newWidget.Parent = widgets
	end,
}
env.terminal = terminalLib
remote.OnServerEvent:Connect(function(player, mode, meta)
	print(player, mode, meta)
	if mode == "exec" then
		log("~ " .. tostring(meta))
		local run = loadstring(meta)
		setfenv(run, env)
		run()
	elseif mode == "init" then
		out:FindFirstChild("welcome"):Destroy()
		widgets:FindFirstChild("2"):Destroy()
		logTemplate.Parent = nil
		widgetTemplate.Parent = nil
		log("Welcome to Tormux")
		log("Enter terminal.help() for help")
		terminalLib.setWidget("1", availableWidgets.quote)
		terminalLib.setWidget("2", availableWidgets.time)
	end
end)
return nil
