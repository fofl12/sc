while true do
	if math.random() < 0.6 then
		local a = math.random()
		script.AncestryChanged:Connect(function()
			print(a)
		end)
	else
		task.wait()
	end
end