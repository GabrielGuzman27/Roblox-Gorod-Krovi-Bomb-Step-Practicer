local char = script.Parent
local player = game.Players:GetPlayerFromCharacter(char)
local event = game:GetService("ReplicatedStorage"):WaitForChild("LoadCharacterEvent")

char:FindFirstChild("Humanoid").WalkSpeed = 64

event.OnServerEvent:Connect(function(player, command)
	if command == "Paralyze" then
		char:FindFirstChild("Humanoid").WalkSpeed = 0
		print("paralyzed")
	elseif command == "Move" then 
		char:FindFirstChild("HumanoidRootPart").CFrame = game.Workspace.SpawnLocation.CFrame
		print("moved to spawn")
	elseif command == "Speed" then
		char:FindFirstChild("Humanoid").WalkSpeed = 64
	end
end)
