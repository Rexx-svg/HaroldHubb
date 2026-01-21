--// Haroldzztop UI MENU (BASE)
--// Solo UI + animaciones + tabs + sonidos

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HaroldzztopUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 260)
mainFrame.Position = UDim2.new(0.5, -210, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(120,120,120)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0,12)

--// HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,40)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Haroldzztop"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,10,0,0)
title.TextXAlignment = Left
title.Parent = header

--// OPEN / CLOSE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Size = UDim2.new(0,40,1,0)
toggleBtn.Position = UDim2.new(1,-40,0,0)
toggleBtn.Parent = header

--// CLICK SOUND
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
clickSound.Parent = gui

--// TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local function createTab(text, x)
	local b = Instance.new("TextButton")
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundTransparency = 1
	b.Size = UDim2.new(0,120,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Parent = tabBar
	return b
end

local mainTabBtn = createTab("Main", 0)
local playerTabBtn = createTab("Player", 140)
local dcTabBtn = createTab("DC", 280)

--// CONTENT
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-20,1,-85)
content.Position = UDim2.new(0,10,0,80)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local function createPage()
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1,0,1,0)
	f.BackgroundTransparency = 1
	f.Visible = false
	f.Parent = content
	return f
end

local mainPage = createPage()
local playerPage = createPage()
local dcPage = createPage()

mainPage.Visible = true

--// PLACEHOLDER TEXTS
local function label(text, parent)
	local l = Instance.new("TextLabel")
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 14
	l.TextColor3 = Color3.fromRGB(255,255,255)
	l.BackgroundTransparency = 1
	l.Size = UDim2.new(1,0,0,30)
	l.Parent = parent
end

label("Contenido MAIN aquí", mainPage)
label("ESP estará aquí (PLAYER / DC luego)", playerPage)
label("Funciones DC aquí", dcPage)

--// TAB SWITCH
local function showPage(page)
	clickSound:Play()
	mainPage.Visible = false
	playerPage.Visible = false
	dcPage.Visible = false
	page.Visible = true
end

mainTabBtn.MouseButton1Click:Connect(function()
	showPage(mainPage)
end)

playerTabBtn.MouseButton1Click:Connect(function()
	showPage(playerPage)
end)

dcTabBtn.MouseButton1Click:Connect(function()
	showPage(dcPage)
end)

--// OPEN / CLOSE ANIMATION
local open = true
local openSize = UDim2.new(0,420,0,260)
local closedSize = UDim2.new(0,420,0,40)

toggleBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	open = not open
	toggleBtn.Text = open and "-" or "+"

	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = open and openSize or closedSize}
	)
	tween:Play()
end)

--// DRAG
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
