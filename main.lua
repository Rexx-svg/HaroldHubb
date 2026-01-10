local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local tpOn, kickOn = false, false

local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,150,0,125)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,20)
title.Text = "Harold hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1,-8,0,28)
tpBtn.Position = UDim2.new(0,4,0,25)
tpBtn.Text = "Teleport: OFF"
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

local kickBtn = Instance.new("TextButton", frame)
kickBtn.Size = UDim2.new(1,-8,0,28)
kickBtn.Position = UDim2.new(0,4,0,57)
kickBtn.Text = "Auto Kick: OFF"
kickBtn.TextColor3 = Color3.new(1,1,1)
kickBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1,-8,0,28)
closeBtn.Position = UDim2.new(0,4,0,89)
closeBtn.Text = "Close Hub"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0.05,0,0.6,0)
icon.Visible = false
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.Image = ""
icon.Active = true
icon.Draggable = true

local corner = Instance.new("UICorner", icon)
corner.CornerRadius = UDim.new(1,0)

tpBtn.MouseButton1Click:Connect(function()
	tpOn = not tpOn
	tpBtn.Text = "Teleport: "..(tpOn and "ON" or "OFF")
end)

kickBtn.MouseButton1Click:Connect(function()
	kickOn = not kickOn
	kickBtn.Text = "Auto Kick: "..(kickOn and "ON" or "OFF")
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	frame.Visible = true
	icon.Visible = false
end)

-- Obtiene el lugar donde reapareces (SpawnLocation)
local function getSpawn()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("SpawnLocation") then
			return v
		end
	end
end

local function onItemGrab()
	if tpOn then
		local spawn = getSpawn()
		if spawn then
			hrp.CFrame = spawn.CFrame + Vector3.new(0,3,0)
		end
	end
	if kickOn then
		task.wait(0.2)
		plr:Kick("Has robado un brainrot")
	end
end

-- Detecta cualquier cosa que agarres (cualquier Tool)
char.ChildAdded:Connect(function(o)
	if o:IsA("Tool") then
		onItemGrab()
	end
end)

plr.Backpack.ChildAdded:Connect(function(o)
	if o:IsA("Tool") then
		onItemGrab()
	end
end)
