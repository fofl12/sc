local CHANNEL = 7
if not _G['channel' .. CHANNEL] then
	_G['channel' .. CHANNEL] = Instance.new('BindableEvent')
end

local function music(Play, W, ping, bass, snap, ping2, speed)
	bp = 1.6
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
			Play(snap,0.7)
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
		end
		bp = 1.2
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
			Play(snap,0.7)
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
		end
		bp = 1.02
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
			Play(snap,0.7)
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
		end
		bp = 1.15
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
			Play(snap,0.7)
			for i = 1,2 do
				Play(bass,bp)
				W(speed.Value)
			end
		end
		bp = 1.6
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				Play(snap,0.7)
				W(speed.Value)
			end
			Play(bass,bp)
			Play(snap,1)
			W(speed.Value)
			Play(bass,bp)
			Play(snap,0.7)
			W(speed.Value)
		end
		bp = 1.2
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				Play(snap,0.7)
				W(speed.Value)
			end
			Play(bass,bp)
			Play(snap,1)
			W(speed.Value)
			Play(bass,bp)
			Play(snap,0.7)
			W(speed.Value)
		end
		bp = 1.02
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				Play(snap,0.7)
				W(speed.Value)
			end
			Play(bass,bp)
			Play(snap,1)
			W(speed.Value)
			Play(bass,bp)
			Play(snap,0.7)
			W(speed.Value)
		end
		bp = 1.15
		for i = 1,4 do
			for i = 1,2 do
				Play(bass,bp)
				Play(snap,0.7)
				W(speed.Value)
			end
			Play(bass,bp)
			Play(snap,1)
			W(speed.Value)
			Play(bass,bp)
			Play(snap,0.7)
			W(speed.Value)
		end
end

local awaiting = {}
while true do
	music(function(note, speed)
		table.insert(awaiting, {note, speed})
	end, function(i)
		_G['channel' .. CHANNEL]:Fire(awaiting)
		awaiting = {}
		task.wait(i)
	end, 'ping', 'bass', 'snap', 'ping2', {Value = .1})
end