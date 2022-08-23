local port = Instance.new('RemoteEvent', owner.PlayerGui)
NLS([[
local port = script.Parent
script.Parent = port.Parent
port.Parent = script

port.OnClientEvent:Connect(function(m)
	game:FindFirstChild('SB_10', true):FireServer(m, 'SERVER')
end)
]],port)

local http = game:service'HttpService'
local key = tostring(math.random(1, 100000000))

local function respond(query)
	local response = http:JSONDecode(http:GetAsync('https://cb.virtualcoffee.tk/?ask=' .. query .. '?ctxkey=' .. key)).message
	print(response, p)
	port:FireClient(owner, owner.Name .. ': ' .. response)
	task.wait(2)
	task.spawn(respond, response)
end

port:FireClient(owner, owner.Name .. ': ' .. 'Hello')
respond('Hello')