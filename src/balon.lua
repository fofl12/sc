local tool = Instance.new('Tool')
tool.Name = 'balon'

local handle = Instance.new('Part')
handle.Size = Vector3.one
handle.Name = 'Handle'
handle.Parent = tool
handle.Position = owner.Character.Head.Position
local a0 = Instance.new('Attachment', handle)

local balloon = Instance.new('Part')
balloon.Size = Vector3.one * 3
balloon.Color = Color3.new(1)
balloon.Shape = 'Ball'
balloon.Position = owner.Character.Head.Position
balloon.Parent = tool
local velocity = Instance.new('BodyVelocity')
velocity.Velocity = Vector3.new(0, 50)
velocity.MaxForce = Vector3.new(0, 4500)
velocity.Parent = balloon
local a1 = Instance.new('Attachment', balloon)

local rope = Instance.new('RopeConstraint')
rope.Attachment0 = a0
rope.Attachment1 = a1
rope.Length = 7.5
rope.Visible = true
rope.Parent = tool

tool.Parent = owner.Backpack