local button = script.Parent.Parent.PlayerGui:WaitForChild("ScreenGui").GKBButton
local camera = game.Workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable
camera.CFrame = game.Workspace.BombStepCameraStart.CFrame
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local ColorCorrection = game.Lighting.ColorCorrection
ColorCorrection.Brightness = -1
button.BackgroundTransparency = 1
button.TextTransparency = 1
local typeWrite = script.Parent.Parent.PlayerGui:WaitForChild("TypeWrite").TextLabel
local event = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

local function fixCamera()
	camera.CameraType = Enum.CameraType.Custom
end

local function GKBButtonInit()
	if not button.Visible then
		button.Visible = true
	end
	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0})
	local tween2 = TweenService:Create(button, tweenInfo, {TextTransparency = 0})
	tween:Play()
	tween2:Play()
end

GKBButtonInit()

local function transitionScreen()
	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(ColorCorrection, tweenInfo, {Brightness = -0.1})
	GKBButtonInit()
	tween:Play()
	tween.Completed:Connect(function()
		button.Interactable = true
	end)
end

transitionScreen()

local function setCamera()
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = game.Workspace.BombStepCameraStart.CFrame
	transitionScreen()
end

local function myTypeWrite(text)
	local typeSpeed = 0.025
	local fullText = text
	for i = 1, #fullText do
		typeWrite.Text = string.sub(fullText, 1, i)
		task.wait(typeSpeed)
	end
	task.wait(1.5)
end




button.Activated:Connect(function()
	button.Interactable = false
	local hideInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local goal = {}
	goal.BackgroundTransparency = 1
	goal.TextTransparency = 1
	local tween = TweenService:Create(player.PlayerGui.ScreenGui.GKBButton, hideInfo, goal)
	local camTween = TweenService:Create(camera, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = game.Workspace.BombStepCamera.CFrame})
	tween:Play()
	tween.Completed:Connect(function()
		player.PlayerGui.ScreenGui.GKBButton.Visible = false
		player.PlayerGui.ScreenGui.GKBButton.Interactable = false
		camTween:Play()
		camTween.Completed:Connect(function()
			typeWrite.Visible = true
			event:FireServer()
			myTypeWrite("What?")
			myTypeWrite("What have you done?!")
			myTypeWrite("You have activated the perimeter alarms.")
			myTypeWrite("Disarm them.")
			myTypeWrite("Immediately!")
			typeWrite.Visible = false
			game.ReplicatedStorage.LoadCharacterEvent:FireServer("Speed")
		end)
	end)
end)

game.ReplicatedStorage.FailureEvent.OnClientEvent:Connect(function()
	typeWrite.Visible = true
	camera.CameraType = Enum.CameraType.Scriptable
	game.ReplicatedStorage:WaitForChild("LoadCharacterEvent"):FireServer("Paralyze")
	game.ReplicatedStorage:WaitForChild("LoadCharacterEvent"):FireServer("Move")
	myTypeWrite("You have failed to disarm the alarms.")
	myTypeWrite("Why did I entrust YOU with such a simple task...")
	typeWrite.Visible = false
	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local newTween = TweenService:Create(ColorCorrection, tweenInfo, {Brightness = 1})
	newTween:Play()
	newTween.Completed:Connect(function()
		game.ReplicatedStorage:WaitForChild("LoadCharacterEvent"):FireServer("Move")
		setCamera()
	end)
end)

game.ReplicatedStorage.CompletionEvent.OnClientEvent:Connect(function()
	game.ReplicatedStorage.LoadCharacterEvent:FireServer("Paralyze")
	typeWrite.Visible = true
	myTypeWrite("Thank you for preventing our destruction.")
	typeWrite.Visible = false
	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local newTween = TweenService:Create(ColorCorrection, tweenInfo, {Brightness = 1})
	newTween:Play()
	newTween.Completed:Connect(function()
		game.ReplicatedStorage:WaitForChild("LoadCharacterEvent"):FireServer("Move")
		setCamera()
	end)
end)

event.OnClientEvent:Connect(fixCamera)

