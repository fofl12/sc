local ter = workspace.Terrain
local radius = 100
local noise = 20
local hloblkaj = 100
local center = Vector3.new(500, -100, 0)
local seed = math.random()
print('Seed: ' .. seed)

ter:FillBall(center, hloblkaj, Enum.Material.Water)
for y = 0, math.pi * 2, 0.05 do
  for x = 0, math.pi * 2, 0.05 do
    ter:FillBall(
      Vector3.new(
        math.sin(x) * radius * math.cos(y),
        math.sin(y) * radius,
        math.cos(x) * radius * math.cos(y)
      ) + (Vector3.one * (math.noise(seed * 100, x, y) * noise)) + center,
      4,
      Enum.Material.Grass
    )
  end
end
