-- Robux Engine

local offset = Vector3.new(owner.Character.Head.Position.X, 0, owner.Character.Head.Position.Z)
local debris = game:GetService('Debris')

colors = {
	[1] = Color3.new(), -- black
	[2] = Color3.new(1, 1, 1), -- white
	[3] = Color3.new(0.3, 0.3, 0.3), -- grey
	[4] = Color3.new(1, 0, 0), -- red
	[5] = Color3.new(0, 1, 0), -- green
	[6] = Color3.new(0, 0, 1), -- blue
	[7] = Color3.new(1, 1, 0), -- yellow
	[8] = Color3.new(0, 1, 1) -- cyan
}
rg = {
	clear = function()
		script:ClearAllChildren()
	end,
	offset = function(inc)
		offset += inc
	end,
	hint = function(text)
		local hint = Instance.new('Hint', script)
		hint.Text = text or '?'
		local hintApi = {
			set = function(text)
				hint.Text = text
			end,
			get = function()
				return hint.Text
			end,
			raw = hint,
			destroy = function()
				hint:Destroy()
				hintApi = nil
			end
		}
		return hintApi
	end,
	block = function(p, s, c, t)
		local block = Instance.new(t or 'Part', script)
		block.Position = p + offset
		block.Anchored = true
		block.Size = s or Vector3.new(2, 2, 2)
		if type(c) == 'number' then
			block.Color = colors[c]
		else
			block.Color = c or colors[2]
		end

		local blockApi = {
			raw = block,
			destroy = function()
				block:Destroy()
				blockApi = nil
			end
		}
		setmetatable(blockApi, {
			__index = function(_, k)
				if k == 'p' then
					return block.Position
				elseif k == 's' then
					return block.Size
				elseif k == 'c' then
					return block.Color
				end
			end,
			__newindex = function(_, k, v)
				if k == 'p' then
					block.Position = v + offset
				elseif k == 's' then
					block.Size = v
				elseif k == 'c' then
					block.Color = v
				end
			end
		})
		return blockApi
	end,
	timebomb = function(o, t)
		debris:AddItem(o.raw, t)
	end,
}

local remote = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local remote = script.Parent
script.Parent = remote.Parent
remote.Parent = script

local ui = Instance.new('ScreenGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(400, 300)
frame.AnchorPoint = Vector2.one
frame.Position = UDim2.fromScale(1, 1)

local button = Instance.new('TextButton')
button.Text = 'Push'
button.Size = UDim2.fromOffset(64, 16)
button.Parent = frame

local scroller = Instance.new('ScrollingFrame')
scroller.Position = UDim2.fromOffset(0, 16)
scroller.Size = UDim2.fromOffset(400, 284)
scroller.Parent = frame

local box = Instance.new('TextBox')
box.Font = 'Code'
box.TextXAlignment = 'Left'
box.TextYAlignment = 'Top'
box.TextWrap = true
box.TextSize = 10
box.MultiLine = true
box.Size = UDim2.fromScale(1, 1)
box.ClearTextOnFocus = false
box.Parent = scroller

button.MouseButton1Click:Connect(function()
	remote:FireServer('push', box.Text)
end)

frame.Parent = ui
ui.Parent = script
]], remote)
remote.OnServerEvent:Connect(function(plr, mode, dat)
	--if plr == owner then
		print'b'
		if mode == 'push' then
			print'c'
			local loaded = loadstring(dat)
			print(loaded)
			loaded()
		end
	--end
end)