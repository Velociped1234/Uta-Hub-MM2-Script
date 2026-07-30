-- STREAMING_CHUNK:Configuring services and theme settings...
-- =========================================================
-- Сервисы
-- =========================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- =========================================================
-- Настройки Цветов и Дизайна
-- =========================================================
local THEME = {
Primary = Color3.fromHex("#d033de"),      -- Основной фиолетовый
TitleColor = Color3.fromHex("#db2cd8"),   -- Цвет текста "Uta Hub"
Background = Color3.fromRGB(25, 25, 25),
Sidebar = Color3.fromRGB(15, 15, 15),
ElementBg = Color3.fromRGB(40, 40, 40),
Text = Color3.fromRGB(255, 255, 255),
TextDark = Color3.fromRGB(170, 170, 170),
CornerRadius = UDim.new(0, 8)
}

-- STREAMING_CHUNK:Creating the main ScreenGui and Open Button...
-- =========================================================
-- 1. Создание базового GUI
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UtaHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999 -- Поверх всех интерфейсов, магазинов и инвентарей
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- =========================================================
-- 2. Кнопка "UTA HUB" (Радужная, Перетаскиваемая)
-- =========================================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 120, 0, 40)
OpenBtn.Position = UDim2.new(0.5, -60, 0, 20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Text = "UTA HUB"
OpenBtn.Font = Enum.Font.GothamBold -- Сделали шрифт нормальным (не слишком жирным)
OpenBtn.TextSize = 16
OpenBtn.Parent = ScreenGui

local OpenUICorner = Instance.new("UICorner")
OpenUICorner.CornerRadius = UDim.new(0, 8)
OpenUICorner.Parent = OpenBtn

local OpenUIStroke = Instance.new("UIStroke")
OpenUIStroke.Thickness = 2
OpenUIStroke.Parent = OpenBtn

-- Радужная анимация для кнопки
RunService.RenderStepped:Connect(function()
local hue = tick() % 5 / 5
local rainbowColor = Color3.fromHSV(hue, 1, 1)
OpenBtn.TextColor3 = rainbowColor
OpenUIStroke.Color = rainbowColor
end)

-- STREAMING_CHUNK:Building the main frame and sidebar structure...
-- =========================================================
-- 3. Главное Меню
-- =========================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 300) -- Компактный размер
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Изначально скрыто
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = THEME.CornerRadius
MainUICorner.Parent = MainFrame

-- Заголовок Uta Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 120, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Uta Hub"
Title.TextColor3 = THEME.TitleColor
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold -- Убрали слишком толстый шрифт (GothamBlack)
Title.Parent = MainFrame

-- Левая панель (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarUICorner = Instance.new("UICorner")
SidebarUICorner.CornerRadius = THEME.CornerRadius
SidebarUICorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 8, 1, 0)
SidebarPatch.Position = UDim2.new(1, -8, 0, 0)
SidebarPatch.BackgroundColor3 = THEME.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

local SidebarListLayout = Instance.new("UIListLayout")
SidebarListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarListLayout.Parent = Sidebar

-- Контейнер для контента
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -120, 1, -40)
ContentContainer.Position = UDim2.new(0, 120, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- STREAMING_CHUNK:Implementing draggable logic for the interface...
-- =========================================================
-- 4. Перетаскивание (Drag) для окон и кнопок
-- =========================================================
local function MakeDraggable(guiElement)
local dragging, dragInput, dragStart, startPos

guiElement.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = guiElement.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

guiElement.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		guiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


end

MakeDraggable(MainFrame)
MakeDraggable(OpenBtn)

-- Логика кнопки "UTA HUB"
OpenBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)

-- STREAMING_CHUNK:Defining UI constructors (Tabs, Toggles, Sliders)...
-- =========================================================
-- 5. UI Конструкторы (Вкладки, Кнопки, Слайдеры, Переключатели)
-- =========================================================
local Tabs = {}
local TabPages = {}

local function CreateTab(name, isFirst)
local TabBtn = Instance.new("TextButton")
TabBtn.Size = UDim2.new(1, 0, 0, 35)
TabBtn.BackgroundTransparency = 1
TabBtn.Text = name
TabBtn.TextColor3 = isFirst and THEME.Primary or THEME.TextDark
TabBtn.TextSize = 14
TabBtn.Font = Enum.Font.GothamBold
TabBtn.Parent = Sidebar

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1, -20, 1, -20)
Page.Position = UDim2.new(0, 10, 0, 10)
Page.BackgroundTransparency = 1
Page.BorderSizePixel = 0
Page.ScrollBarThickness = 2
Page.Visible = isFirst
Page.Parent = ContentContainer

local PageLayout = Instance.new("UIListLayout")
PageLayout.Padding = UDim.new(0, 8)
PageLayout.Parent = Page

Tabs[name] = TabBtn
TabPages[name] = Page

TabBtn.MouseButton1Click:Connect(function()
	for tName, btn in pairs(Tabs) do
		btn.TextColor3 = (tName == name) and THEME.Primary or THEME.TextDark
	end
	for pName, page in pairs(TabPages) do
		page.Visible = (pName == name)
	end
end)

return Page


end

local function CreateToggle(parent, text, callback)
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, 0, 0, 35)
ToggleContainer.BackgroundColor3 = THEME.ElementBg
ToggleContainer.Parent = parent

Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(0, 6)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -60, 1, 0)
Label.Position = UDim2.new(0, 10, 0, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = ToggleContainer

local ToggleBg = Instance.new("TextButton")
ToggleBg.Size = UDim2.new(0, 40, 0, 20)
ToggleBg.Position = UDim2.new(1, -50, 0.5, -10)
ToggleBg.BackgroundColor3 = THEME.Sidebar
ToggleBg.Text = ""
ToggleBg.Parent = ToggleContainer

Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 16, 0, 16)
Circle.Position = UDim2.new(0, 2, 0.5, -8)
Circle.BackgroundColor3 = THEME.TextDark
Circle.Parent = ToggleBg

Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

local isToggled = false
ToggleBg.MouseButton1Click:Connect(function()
	isToggled = not isToggled
	local goalBg = {BackgroundColor3 = isToggled and THEME.Primary or THEME.Sidebar}
	local goalCirclePos = {Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}
	local goalCircleCol = {BackgroundColor3 = isToggled and THEME.Text or THEME.TextDark}
	
	TweenService:Create(ToggleBg, TweenInfo.new(0.2), goalBg):Play()
	TweenService:Create(Circle, TweenInfo.new(0.2), goalCirclePos):Play()
	TweenService:Create(Circle, TweenInfo.new(0.2), goalCircleCol):Play()
	
	if callback then callback(isToggled) end
end)


end

-- STREAMING_CHUNK:Adding slider and button components...
local function CreateSlider(parent, text, min, max, default, callback)
local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1, 0, 0, 50)
SliderContainer.BackgroundColor3 = THEME.ElementBg
SliderContainer.Parent = parent

Instance.new("UICorner", SliderContainer).CornerRadius = UDim.new(0, 6)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -20, 0, 20)
Label.Position = UDim2.new(0, 10, 0, 5)
Label.BackgroundTransparency = 1
Label.Text = text .. ": " .. tostring(default)
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = SliderContainer

local SliderBg = Instance.new("TextButton")
SliderBg.Size = UDim2.new(1, -20, 0, 6)
SliderBg.Position = UDim2.new(0, 10, 0, 35)
SliderBg.BackgroundColor3 = THEME.Sidebar
SliderBg.Text = ""
SliderBg.AutoButtonColor = false
SliderBg.Parent = SliderContainer

Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
Fill.BackgroundColor3 = THEME.Primary
Fill.BorderSizePixel = 0
Fill.Parent = SliderBg

Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

local dragging = false
local function update(input)
	local x = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
	Fill.Size = UDim2.new(x, 0, 1, 0)
	local val = math.floor(min + (max - min) * x)
	Label.Text = text .. ": " .. tostring(val)
	if callback then callback(val) end
end

SliderBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		update(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)


end

local function CreateButton(parent, text, callback)
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, 0, 0, 35)
Btn.BackgroundColor3 = THEME.ElementBg
Btn.Text = text
Btn.TextColor3 = THEME.Text
Btn.Font = Enum.Font.Gotham
Btn.TextSize = 13
Btn.Parent = parent

Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

Btn.MouseButton1Click:Connect(function()
	if callback then callback() end
end)


end

-- STREAMING_CHUNK:Setting up tabs and Main tab features...
-- =========================================================
-- 6. Наполнение Вкладок и Логика
-- =========================================================
local mainPage = CreateTab("Main", true)
local combatPage = CreateTab("Combat", false)
local espPage = CreateTab("ESP", false)
local autofarmPage = CreateTab("Autofarm", false)
local flingPage = CreateTab("Fling", false)
local funPage = CreateTab("Fun", false)
local settingsPage = CreateTab("Settings", false)

-- Вкладка: MAIN

CreateSlider(mainPage, "WalkSpeed", 16, 250, 16, function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = value
end
end)

CreateSlider(mainPage, "JumpPower", 50, 300, 50, function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.UseJumpPower = true
LocalPlayer.Character.Humanoid.JumpPower = value
end
end)

local noclipConn
CreateToggle(mainPage, "Noclip", false, function(toggled)
if toggled then
noclipConn = RunService.Stepped:Connect(function()
if LocalPlayer.Character then
for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end)
else
if noclipConn then noclipConn:Disconnect() end
end
end)

local infJumpConn
CreateToggle(mainPage, "Infinite Jump", false, function(toggled)
if toggled then
infJumpConn = UserInputService.JumpRequest:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
else
if infJumpConn then infJumpConn:Disconnect() end
end
end)

-- STREAMING_CHUNK:Adding Spin and Fly logic to Main tab...
local spinConn
local spinSpeed = 20
CreateToggle(mainPage, "Spin", false, function(toggled)
if toggled then
spinConn = RunService.RenderStepped:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
end
end)
else
if spinConn then spinConn:Disconnect() end
end
end)

local flying = false
local flySpeed = 50
local flyKeys = {W = false, A = false, S = false, D = false}
local bg, bv

local function StartFly()
local char = LocalPlayer.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then return end
local hrp = char.HumanoidRootPart

bg = Instance.new("BodyGyro", hrp)
bg.P = 9e4
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.cframe = hrp.CFrame

bv = Instance.new("BodyVelocity", hrp)
bv.velocity = Vector3.new(0,0.1,0)
bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

flying = true

char:FindFirstChildOfClass("Humanoid").PlatformStand = true

RunService:BindToRenderStep("FlyLoop", 1, function()
	if not flying or not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local camCF = Camera.CFrame
	local moveDir = Vector3.new(0,0,0)
	
	if flyKeys.W then moveDir = moveDir + camCF.LookVector end
	if flyKeys.S then moveDir = moveDir - camCF.LookVector end
	if flyKeys.D then moveDir = moveDir + camCF.RightVector end
	if flyKeys.A then moveDir = moveDir - camCF.RightVector end
	
	bg.cframe = camCF
	if moveDir.Magnitude > 0 then
		bv.velocity = moveDir.Unit * flySpeed
	else
		bv.velocity = Vector3.new(0,0,0)
	end
end)


end

local function StopFly()
flying = false
RunService:UnbindFromRenderStep("FlyLoop")
if bg then bg:Destroy() end
if bv then bv:Destroy() end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
end
end

CreateToggle(mainPage, "Fly", false, function(toggled)
if toggled then
StartFly()
else
StopFly()
end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true
elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = true
elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = true
elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
if gameProcessed then return end
if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false
elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = false
elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = false
elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
end)

-- STREAMING_CHUNK:Populating remaining tabs (ESP, Autofarm, Fun, Settings)...

-- Вкладка: COMBAT

local combatNote = Instance.new("TextLabel", combatPage)
combatNote.Size = UDim2.new(1, 0, 0, 30)
combatNote.BackgroundTransparency = 1
combatNote.Text = "Доступные функции перенесены в Main."
combatNote.TextColor3 = THEME.TextDark
combatNote.Font = Enum.Font.Gotham

-- Вкладка: ESP

local espEnabled = false
CreateToggle(espPage, "Player ESP", false, function(toggled)
espEnabled = toggled
if not toggled then
for _, v in pairs(Workspace:GetDescendants()) do
if v:IsA("Highlight") and v.Name == "UtaESP" then
v:Destroy()
end
end
end
end)

RunService.RenderStepped:Connect(function()
if espEnabled then
for _, player in pairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character then
if not player.Character:FindFirstChild("UtaESP") then
local highlight = Instance.new("Highlight")
highlight.Name = "UtaESP"
highlight.FillColor = Color3.new(1, 0, 0)
highlight.OutlineColor = Color3.new(1, 1, 1)
highlight.FillTransparency = 0.5
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = player.Character
end
end
end
end
end)

-- Вкладка: AUTOFARM

local autoClickConn
CreateToggle(autofarmPage, "Auto Click", false, function(toggled)
if toggled then
autoClickConn = RunService.RenderStepped:Connect(function()
mouse1click() -- Внимание: mouse1click работает только в мощных экзекьюторах
end)
else
if autoClickConn then autoClickConn:Disconnect() end
end
end)

CreateButton(autofarmPage, "Teleport to Random Player", function()
local allPlayers = Players:GetPlayers()
if #allPlayers > 1 then
local randomPlayer
repeat
randomPlayer = allPlayers[math.random(1, #allPlayers)]
until randomPlayer ~= LocalPlayer

	if randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
	end
end


end)

-- Вкладка: FLING

local flingNote = Instance.new("TextLabel", flingPage)
flingNote.Size = UDim2.new(1, 0, 0, 30)
flingNote.BackgroundTransparency = 1
flingNote.Text = "Функции Fling в разработке."
flingNote.TextColor3 = THEME.TextDark
flingNote.Font = Enum.Font.Gotham

-- Вкладка: FUN

CreateButton(funPage, "Give BTools", function()
local tool1 = Instance.new("HopperBin", LocalPlayer.Backpack)
tool1.BinType = Enum.BinType.Clone
local tool2 = Instance.new("HopperBin", LocalPlayer.Backpack)
tool2.BinType = Enum.BinType.Hammer
local tool3 = Instance.new("HopperBin", LocalPlayer.Backpack)
tool3.BinType = Enum.BinType.Grab
end)

CreateToggle(funPage, "Low Gravity", false, function(toggled)
if toggled then
Workspace.Gravity = 50
else
Workspace.Gravity = 196.2
end
end)

-- Вкладка: SETTINGS

CreateButton(settingsPage, "Rejoin Server", function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

CreateButton(settingsPage, "Unload UI", function()
if ScreenGui then ScreenGui:Destroy() end
if noclipConn then noclipConn:Disconnect() end
if infJumpConn then infJumpConn:Disconnect() end
if spinConn then spinConn:Disconnect() end
StopFly()
end)
