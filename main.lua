--// HAROLD TOP 😹
--// RAYFIELD UI (MAIN / PLAYER)

-------------------------
-- SERVICES
-------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-------------------------
-- RAYFIELD
-------------------------
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
))()

-------------------------
-- WINDOW
-------------------------
local Window = Rayfield:CreateWindow({
    Name = "HaroldTop",
    LoadingTitle = "HaroldTop",
    LoadingSubtitle = "Rayfield UI",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-------------------------
-- TABS
-------------------------
local MainTab   = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

-------------------------
-- STATES
-------------------------
local tpSafeOn = false
local tpLobbyOn = false
local wallHopOn = false

local espBartOn = false
local espHomerOn = false

local lobbyPos = nil
local lastPos = nil
local espObjects = {}

-------------------------
-- SAVE LOBBY
-------------------------
local function saveLobby()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		lobbyPos = char.HumanoidRootPart.CFrame
	end
end
saveLobby()
LocalPlayer.CharacterAdded:Connect(saveLobby)

-------------------------
-- TP SAFE (BART)
-------------------------
MainTab:CreateToggle({
	Name = "TP SAFE (Bart)",
	CurrentValue = false,
	Callback = function(Value)
		tpSafeOn = Value
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local hrp = char.HumanoidRootPart

		if tpSafeOn then
			if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
				lastPos = hrp.CFrame
				if lobbyPos then
					hrp.CFrame = lobbyPos
				end
			end
		else
			if lastPos then
				hrp.CFrame = lastPos
				lastPos = nil
			end
		end
	end,
})

-------------------------
-- TP LOBBY
-------------------------
MainTab:CreateToggle({
	Name = "TP LOBBY",
	CurrentValue = false,
	Callback = function(Value)
		tpLobbyOn = Value
		if tpLobbyOn and lobbyPos and LocalPlayer.Character then
			LocalPlayer.Character.HumanoidRootPart.CFrame = lobbyPos
		end
	end,
})

-------------------------
-- WALLHOP
-------------------------
local jumpForce = 50
local clampFallSpeed = 80

PlayerTab:CreateToggle({
	Name = "WALLHOP",
	CurrentValue = false,
	Callback = function(Value)
		wallHopOn = Value
	end,
})

RunService.Heartbeat:Connect(function()
	if not wallHopOn then return end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if wallHopOn then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
		end
	end
end)

-------------------------
-- ESP CORE
-------------------------
local function clearESP(plr)
	if espObjects[plr] then
		espObjects[plr]:Destroy()
		espObjects[plr] = nil
	end
end

local function canUseESP()
	return LocalPlayer.Team ~= nil and LocalPlayer.Team.Name ~= "Muerto"
end

local function addESP(plr, color)
	if plr == LocalPlayer then return end
	if not plr.Team or plr.Team.Name == "Muerto" then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(2.5, 4.5, 2.5)
	box.AlwaysOnTop = true
	box.Transparency = 0.45
	box.Color3 = color
	box.ZIndex = 10
	box.Parent = Workspace

	espObjects[plr] = box
end

local function updateESP()
	for p in pairs(espObjects) do
		clearESP(p)
	end

	if not canUseESP() then return end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Team then
			if espBartOn and plr.Team.Name == "Bart" then
				addESP(plr, Color3.fromRGB(0, 0, 255))
			elseif espHomerOn and plr.Team.Name == "Homer" then
				addESP(plr, Color3.fromRGB(255, 0, 0))
			end
		end
	end
end

-------------------------
-- ESP BART
-------------------------
PlayerTab:CreateToggle({
	Name = "ESP BART",
	CurrentValue = false,
	Callback = function(Value)
		espBartOn = Value
		updateESP()
	end,
})

-------------------------
-- ESP HOMER
-------------------------
PlayerTab:CreateToggle({
	Name = "ESP HOMER",
	CurrentValue = false,
	Callback = function(Value)
		espHomerOn = Value
		updateESP()
	end,
})

RunService.Heartbeat:Connect(updateESP)
Players.PlayerRemoving:Connect(clearESP)
