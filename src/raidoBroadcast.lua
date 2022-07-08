local CHANNEL = 5
_G['channel' .. CHANNEL] = Instance.new('BindableEvent')

local function music(Play, W, ping, bass, snap, ping2, speed)
	Play(({'bass', 'ping', 'ping2', 'snap'})[math.random(1, 4)], math.random(0.5, 2.5))
	W(math.random(0.5, 2.5) * speed.Value)
end

local awaiting = {}
while true do
	music(function(note, speed)
		table.insert(awaiting, {note, speed})
	end, function(i)
		_G['channel' .. CHANNEL]:Fire(awaiting)
		awaiting = {}
		task.wait(i)
	end, 'ping', 'bass', 'snap', 'ping2', {Value = .15})
end