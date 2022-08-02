local debris = game:GetService('Debris')
while true do
	local bt = game:FindFirstChild('Building Tools', true)
	if bt and bt.Parent:FindFirstChild'Humanoid' then
		bt.Parent.Humanoid:Destroy()
		print'Abolished'
	end
	task.wait()
end
