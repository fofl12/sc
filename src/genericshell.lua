local part = Instance.new('Part')
part.Anchored = true
part.Size = Vector3.new(6, 4, 1)
part.Position = owner.Character.Head.Position
part.Color = Color3.new()
part.Parent = script

local display = Instance.new('SurfaceGui', part)

local function newText(rawtext)
  local text = Instance.new('TextLabel')
  text.Text = rawtext
  text.TextSize = 30
  text.TextXAlignment = 'Left'
  text.TextYAlignment = 'Top'
  text.AutomaticSize = 'XY'
  text.TextWrapped = true
  text.BackgroundTransparency = 1
  text.TextColor3 = Color3.new(1, 1, 1)
  text.Position = UDim2.fromOffset(0, 200 - text.AbsoluteSize.Y)
  for _, element in next, display:GetChildren() do
    print(element)
    --element.Position = UDim2.fromOffset(0, element.AbsolutePosition.Y - text.AbsoluteSize.Y)
  end
  text.Parent = display
  task.wait()
end

newText('Hi')
newText('Welcome')
