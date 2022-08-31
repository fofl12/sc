local rem = Instance.new('RemoteEvent')
rem.Parent = owner.PlayerGui

rem.OnServerEvent:Connect(function(_, pos)
  local x = Instance.new('Explosion')
  x.Position = pos
  x.BlastRadius = 8
  x.ExplosionType = 'Craters'
  x.BlastPressure = 10000000000000000
  x.Visible = false
  x.Parent = workspace
end)

NLS([[
local rem = script.Parent
script.Parent = rem.Parent
rem.Parent = script
local mouse = script.Parent.Parent:GetMouse()

local e = false

mouse.Button1Down:Connect(function()
  e = true
  while e do
    wait(1/20)
    rem:FireServer(mouse.Hit.p)
  end
end)
mouse.Button1Up:Connect(function()
  e = false
end)
]], rem)
