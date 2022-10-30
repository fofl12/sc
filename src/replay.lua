local tracker
local frames = {}
local allocatedParts = {}
local tracking = false
local replaying = false

FRAMERATE = 40
SPEED = 1

local function scale(c, v, i)
	local p = c.p
	if i then
		p /= v
	else
		p *= v
	end
	return c - c.p + p
end

owner.Chatted:Connect(function(m)
	if m:sub(1, 2) == 'r%' then
		local command = m:sub(3, -1):split(' ')
		if command[1] == 'prepare' then
			tracker = Instance.new('Part')
			tracker.Transparency = 0.8
			tracker.BrickColor = BrickColor.Red()
			tracker.CanCollide = false
			tracker.CastShadow = false
			tracker.Anchored = true
			tracker.Position = owner.Character.Head.Position
			tracker.Parent = script
			print('Prepared tracker')
		elseif command[1] == 'reset' then
			tracking = false
			replaying = false
			frames = {}
			tracker:Destroy()
			for _, part in next, allocatedParts do
				part:Destroy()
			end
			allocatedParts = {}
			print('Reset')
		elseif command[1] == 'start' then
			if command[2] == 'track' then
				tracking = true
				print('Starting tracking')
				while tracking do
					task.wait(1 / FRAMERATE)
					local parts = workspace:GetPartsInPart(tracker)
					local frame = {}
					for _, part in next, parts do
						if part:IsA('Part') then
							table.insert(frame, {
								cf = scale(part.CFrame - tracker.Position, tracker.Size, true),
								color = part.Color,
								size = part.Size / tracker.Size,
								transparency = part.Transparency,
								shape = part.Shape
							})
						end
					end
					table.insert(frames, frame)
					if #frames % FRAMERATE == 0 then
						print(#frames / FRAMERATE, 'seconds')
					end
				end
			elseif command[2] == 'replay' then
				replaying = true
				print(frames, #frames)
				local frameI = SPEED > 0 and 0 or #frames + 1
				print('Starting replay')
				while replaying do
					task.wait(1 / FRAMERATE * math.abs(SPEED))
					frameI += SPEED > 0 and 1 or -1
					if frameI % math.floor(FRAMERATE * math.abs(SPEED)) == 0 then
						print(frameI / FRAMERATE, 'seconds')
					end
					if not frames[frameI] then
						replaying = false
						print('Breaking out (no frame)')
						break
					end
					local frame = frames[frameI]
					for i, part in next, frame do
						local realPart = allocatedParts[i]
						if not realPart then
							local newPart = Instance.new('Part')
							newPart.Anchored = true
							newPart.Parent = script
							allocatedParts[i] = newPart
							realPart = newPart
						end
						realPart.CFrame = scale(part.cf, tracker.Size) + tracker.Position
						realPart.Color = part.color
						realPart.Size = part.size * tracker.Size
						realPart.Transparency = part.transparency
						realPart.Shape = part.shape
					end
				end
				print('Finished replay')
			end
		elseif command[1] == 'stop' then
			if command[2] == 'track' then
				print('Stopping tracking')
				tracking = false
			elseif command[2] == 'replay' then
				print('Stopping replay')
				replaying = false
			end
		elseif command[1] == 'save' then
			_G[command[2]] = frames
			print('Saved to _G.', command[2])
		elseif command[1] == 'load' then
			frames = _G[command[2]]
			print('Loaded from _G.', command[2])
		elseif command[1] == 'conf' then
			if tonumber(command[3]) then
				getfenv()[command[2]] = tonumber(command[3])
			elseif command[3] == 'false' or command[3] == 'true' then
				getfenv()[command[2]] = command[3] == 'true'
			else
				getfenv()[command[2]] = command[3]
			end
			print('Set', command[2], 'to', command[3])
		end
	end
end)