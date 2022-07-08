local head = Instance.new'Part'
head.Shape = 'Ball'
head.Size = Vector3.one * 3

local face = owner.Character.Head.face:Clone()
face.Parent = head

head.Parent = script
