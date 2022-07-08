Play = function(note, speed)
	out = out .. "p," .. note .. "," .. speed .. ";"
end
W = function(duration)
	out = out .. "w," .. duration .. ";"
end
speed = {Value = 0.15}
bass = 1
snap = 2
ping = 3
ping2 = 4

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