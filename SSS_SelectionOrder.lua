-- Choose 6 random locations
-- Store them in array based on order of selection

local screen = game.Workspace.BombStep
local locations = screen.Locations
local selectionOrder = {}
local flashOrder = {}
local choices = {locations.DragonCommand, locations.SupplyDepot, locations.DepartmentStore, locations.TankFactory, locations.Infirmary, locations.Armory}
local parts = screen.Locations:GetChildren()
local initialColor = screen.Locations.Armory.BrickColor
local flashColor = BrickColor.new("Slime green")
local delay1 = 0.3
local delay2 = 0.1
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
local defuseFolder = game.Workspace.Folder
local counter = 1
local completionEvent = game:GetService("ReplicatedStorage"):WaitForChild("CompletionEvent")
local failureEvent = game:GetService("ReplicatedStorage"):WaitForChild("FailureEvent")

local function resetFlash(duration)
	task.wait(duration)
	for i, v in pairs(parts) do
		v.BrickColor = initialColor
	end
	task.wait(duration)
end

local function flash(amount, duration)
	for i = 1, amount do
		for i, v in pairs(parts) do
			v.BrickColor = flashColor
		end
		resetFlash(duration)
	end
end

local function selectionFlash(duration)
	local myCopy = table.clone(choices)
	for i = 1, #choices do
		local site = math.random(1, #myCopy)
		table.insert(selectionOrder, myCopy[site])
		print(myCopy[site])
		table.remove(myCopy, site)
	end
	for i, v in pairs(selectionOrder) do
		v.BrickColor = flashColor
		task.wait(duration)
		v.BrickColor = initialColor
	end
end

local function fastFlash(duration) -- 5 flashes
	local copy = table.clone(choices)
	for i = 1, 5 do
		local site = math.random(1, #copy)
		table.insert(flashOrder, copy[site])
		table.remove(copy, site)
	end
	for i, v in pairs(parts) do -- One flash at a time
		v.BrickColor = flashColor
		task.wait(duration)
		v.BrickColor = initialColor
	end
	task.wait(delay1)
end



local function quadFlash(player)
	flash(4, delay1)
	fastFlash(delay2)
	selectionFlash(0.5)
	flash(4, delay1)
	remoteEvent:FireAllClients()
end

remoteEvent.OnServerEvent:Connect(quadFlash)

local function success()
	counter = 1
	table.clear(selectionOrder)
	completionEvent:FireAllClients()
end

local function failure()
	counter = 1
	table.clear(selectionOrder)
	failureEvent:FireAllClients()
end

local function onInteract(button)
	print("Current selection order: " .. selectionOrder[counter].Name)
	if button == "DragonCommand" and button == selectionOrder[counter].Name then
		defuseFolder.DragonCommandDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	elseif button == "Armory" and button == selectionOrder[counter].Name then
		defuseFolder.ArmoryDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	elseif button == "TankFactory" and button == selectionOrder[counter].Name then
		defuseFolder.TankFactoryDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	elseif button == "Infirmary" and button == selectionOrder[counter].Name then
		defuseFolder.InfirmaryDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	elseif button == "SupplyDepot" and button == selectionOrder[counter].Name then
		defuseFolder.SupplyDepotDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	elseif button == "DepartmentStore" and button == selectionOrder[counter].Name then
		defuseFolder.DepartmentStoreDefuse.DefusePart["Electronic Tinkles Sharp Relay Falling Beeps (SFX)"]:Play()
	else
		failure()
		return
	end
	counter += 1
	print("counter incremented " .. counter)
	if counter == 7 then
		success()
	end
end

defuseFolder.DragonCommandDefuse.DefusePart.DragonCommand.Triggered:Connect(function()
	onInteract("DragonCommand")
end)
defuseFolder.InfirmaryDefuse.DefusePart.Infirmary.Triggered:Connect(function()
	onInteract("Infirmary")
end)
defuseFolder.SupplyDepotDefuse.DefusePart.SupplyDepot.Triggered:Connect(function()
	onInteract("SupplyDepot")
end)
defuseFolder.ArmoryDefuse.DefusePart.Armory.Triggered:Connect(function()
	onInteract("Armory")
end)
defuseFolder.TankFactoryDefuse.DefusePart.TankFactory.Triggered:Connect(function()
	onInteract("TankFactory")
end)
defuseFolder.DepartmentStoreDefuse.DefusePart.DepartmentStore.Triggered:Connect(function()
	onInteract("DepartmentStore")
end)

