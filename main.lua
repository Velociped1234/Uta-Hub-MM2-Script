-- =========================================================
-- UTA HUB - Full Script
-- =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- Проверка и удаление старой версии GUI если она есть
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AdminPanelGui")
if oldGui then
oldGui:Destroy()
end

-- =========================================================
-- Настройки Цветов и Дизайна
-- =========================================================
local THEME = {
TitleColor = Color3.fromHex("#db2cd8"),  -- Цвет названия Uta Hub
Primary = Color3.fromHex("#d033de"),     -- Неоново-фиолетовый акцент
Background = Color3.fromRGB(25, 25, 25), -- Тёмный фоновый цвет
Sidebar = Color3.fromRGB(18, 18, 18),    -- Цвет сайдбара
ElementBg = Color3.fromRGB(40, 40, 40),  -- Цвет элементов
Text = Color3.fromRGB(255, 255, 255),
TextDark = Color3.fromRGB(160, 160, 160), -- Неактивный цвет текста
CornerRadius = UDim.new(0, 12)
}

-- =========================================================
-- 1. Создание главного ScreenGui и Окна
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminPanelGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 320)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = THEME.CornerRadius
MainUICorner.Parent = MainFrame

-- =========================================================
-- 2. Сайдбар и Заголовок
-- =========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarUICorner = Instance.new("UICorner")
SidebarUICorner.CornerRadius = THEME.CornerRadius
SidebarUICorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
SidebarPatch.BackgroundColor3 = THEME.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Uta Hub"
TitleLabel.TextColor3 = THEME.TitleColor
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Sidebar

local TabListContainer = Instance.new("ScrollingFrame")
TabListContainer.Name = "TabListContainer"
TabListContainer.Size = UDim2.new(1, -10, 1, -50)
TabListContainer.Position = UDim2.new(0, 5, 0, 45)
TabListContainer.BackgroundTransparency = 1
TabListContainer.BorderSizePixel = 0
TabListContainer.ScrollBarThickness = 2
TabListContainer.ScrollBarImageColor3 = THEME.Primary
TabListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabListContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabListContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -140, 1, -20)
ContentContainer.Position = UDim2.new(0, 135, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- =========================================================
-- 3. Drag-and-Drop Система (Для окна и кнопки)
-- =========================================================
local function MakeDraggable(frame)
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	end
end)


end

MakeDraggable(MainFrame)

-- =========================================================
-- 4. Радужная Кнопка "UTA HUB"
-- =========================================================
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 105, 0, 35)
OpenButton.Position = UDim2.new(0, 20, 0.5, -17)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "UTA HUB"
OpenButton.TextSize = 14
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 8)
OpenBtnCorner.Parent = OpenButton

local OpenBtnStroke = Instance.new("UIStroke")
OpenBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenBtnStroke.Thickness = 2
OpenBtnStroke.Parent = OpenButton

MakeDraggable(OpenButton)

-- Анимация перелива цветов
local rainbowHue = 0
RunService.RenderStepped:Connect(function(dt)
rainbowHue = (rainbowHue + dt * 0.4) % 1
local rainbowColor = Color3.fromHSV(rainbowHue, 0.8, 1)
OpenButton.TextColor3 = rainbowColor
OpenBtnStroke.Color = rainbowColor
end)

OpenButton.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)

-- =========================================================
-- 5. Конструкторы Компонентов UI (Toggle, Slider, Button, Textbox)
-- =========================================================
local TabButtons = {}
local TabPages = {}
local TabList = {"Main", "Combat", "ESP", "Autofarm", "Fling", "Fun", "Settings"}

local function SwitchTab(tabName)
for name, page in pairs(TabPages) do
page.Visible = (name == tabName)
end
for name, btn in pairs(TabButtons) do
local isActive = (name == tabName)
TweenService:Create(btn, TweenInfo.new(0.15), {
TextColor3 = isActive and THEME.Primary or THEME.TextDark,
BackgroundTransparency = isActive and 0.85 or 1
}):Play()
end
end

for index, tabName in ipairs(TabList) do
local Page = Instance.new("ScrollingFrame")
Page.Name = tabName .. "Page"
Page.Size = UDim2.new(1, 0, 1, 0)
Page.BackgroundTransparency = 1
Page.BorderSizePixel = 0
Page.ScrollBarThickness = 3
Page.ScrollBarImageColor3 = THEME.Primary
Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Visible = false
Page.Parent = ContentContainer

local PageLayout = Instance.new("UIListLayout")
PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageLayout.Padding = UDim.new(0, 8)
PageLayout.Parent = Page

TabPages[tabName] = Page

local TabButton = Instance.new("TextButton")
TabButton.Name = tabName .. "Button"
TabButton.Size = UDim2.new(1, 0, 0, 30)
TabButton.BackgroundColor3 = THEME.Primary
TabButton.BackgroundTransparency = 1
TabButton.Text = tabName
TabButton.TextColor3 = THEME.TextDark
TabButton.TextSize = 13
TabButton.Font = Enum.Font.GothamMedium
TabButton.LayoutOrder = index
TabButton.Parent = TabListContainer

local TabBtnCorner = Instance.new("UICorner")
TabBtnCorner.CornerRadius = UDim.new(0, 6)
TabBtnCorner.Parent = TabButton

TabButton.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
TabButtons[tabName] = TabButton


end

SwitchTab("Main")

-- Функция создания Переключателя (Toggle)
local function CreateToggle(parent, text, default, callback)
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, -6, 0, 36)
ToggleContainer.BackgroundColor3 = THEME.ElementBg
ToggleContainer.Parent = parent

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = ToggleContainer

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -55, 1, 0)
Label.Position = UDim2.new(0, 10, 0, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = ToggleContainer

local ToggleBg = Instance.new("Frame")
ToggleBg.Size = UDim2.new(0, 40, 0, 20)
ToggleBg.Position = UDim2.new(1, -48, 0.5, -10)
ToggleBg.BackgroundColor3 = default and THEME.Primary or Color3.fromRGB(60, 60, 60)
ToggleBg.Parent = ToggleContainer

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(1, 0)
BgCorner.Parent = ToggleBg

local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 14, 0, 14)
Circle.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
Circle.BackgroundColor3 = THEME.Text
Circle.Parent = ToggleBg

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local isToggled = default or false

local function ToggleState()
	isToggled = not isToggled
	local bgGoal = {BackgroundColor3 = isToggled and THEME.Primary or Color3.fromRGB(60, 60, 60)}
	local circleGoal = {Position = isToggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}
	
	TweenService:Create(ToggleBg, TweenInfo.new(0.15), bgGoal):Play()
	TweenService:Create(Circle, TweenInfo.new(0.15), circleGoal):Play()
	
	if callback then callback(isToggled) end
end

ToggleBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleState()
	end
end)

return ToggleContainer


end

-- Функция создания Слайдера (Slider)
local function CreateSlider(parent, text, min, max, default, callback)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, -6, 0, 45)
SliderFrame.BackgroundColor3 = THEME.ElementBg
SliderFrame.Parent = parent

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = SliderFrame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -60, 0, 20)
Label.Position = UDim2.new(0, 10, 0, 4)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = SliderFrame

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Size = UDim2.new(0, 50, 0, 20)
ValueLabel.Position = UDim2.new(1, -55, 0, 4)
ValueLabel.BackgroundTransparency = 1
ValueLabel.Text = tostring(default)
ValueLabel.TextColor3 = THEME.Primary
ValueLabel.TextSize = 13
ValueLabel.Font = Enum.Font.GothamBold
ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
ValueLabel.Parent = SliderFrame

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -20, 0, 6)
SliderTrack.Position = UDim2.new(0, 10, 1, -12)
SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderTrack.Parent = SliderFrame

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
SliderFill.BackgroundColor3 = THEME.Primary
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local dragging = false
local function UpdateSlider(input)
	local posX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
	local value = math.floor(min + (max - min) * posX)
	SliderFill.Size = UDim2.new(posX, 0, 1, 0)
	ValueLabel.Text = tostring(value)
	if callback then callback(value) end
end

SliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		UpdateSlider(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		UpdateSlider(input)
	end
end)


end

-- Функция создания Кнопки (Button)
local function CreateButton(parent, text, callback)
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, -6, 0, 32)
Btn.BackgroundColor3 = THEME.ElementBg
Btn.Text = text
Btn.TextColor3 = THEME.Text
Btn.TextSize = 13
Btn.Font = Enum.Font.GothamMedium
Btn.Parent = parent

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Btn

Btn.MouseButton1Click:Connect(function()
	TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundColor3 = THEME.Primary}):Play()
	task.delay(0.1, function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ElementBg}):Play()
	end)
	if callback then callback() end
end)


end

-- Функция создания Текстового поля (TextBox)
local function CreateTextBox(parent, placeholder, callback)
local BoxContainer = Instance.new("Frame")
BoxContainer.Size = UDim2.new(1, -6, 0, 34)
BoxContainer.BackgroundColor3 = THEME.ElementBg
BoxContainer.Parent = parent

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = BoxContainer

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(1, -16, 1, 0)
Box.Position = UDim2.new(0, 8, 0, 0)
Box.BackgroundTransparency = 1
Box.PlaceholderText = placeholder
Box.Text = ""
Box.TextColor3 = THEME.Text
Box.PlaceholderColor3 = THEME.TextDark
Box.TextSize = 12
Box.Font = Enum.Font.Gotham
Box.TextXAlignment = Enum.TextXAlignment.Left
Box.Parent = BoxContainer

Box.FocusLost:Connect(function(enterPressed)
	if callback then callback(Box.Text, enterPressed) end
end)


end

-- =========================================================
-- 6. Реализация Логики Вкладок
-- =========================================================

-- Вкладка MAIN (Модификации Персонажа)

local mainPage = TabPages["Main"]

-- A. Headless Toggle
CreateToggle(mainPage, "Hide Head (Headless)", false, function(toggled)
local char = LocalPlayer.Character
if not char then return end
local head = char:FindFirstChild("Head")
if head then
head.Transparency = toggled and 1 or 0
for _, item in pairs(head:GetChildren()) do
if item:IsA("Decal") or item:IsA("Texture") then
item.Transparency = toggled and 1 or 0
end
end
end
end)

-- B. Korblox / Hide Right Leg
CreateToggle(mainPage, "Hide Right Leg (Korblox)", false, function(toggled)
local char = LocalPlayer.Character
if not char then return end

local legParts = {"Right Leg", "RightLowerLeg", "RightUpperLeg", "RightFoot"}
for _, partName in ipairs(legParts) do
	local part = char:FindFirstChild(partName)
	if part then
		part.Transparency = toggled and 1 or 0
	end
end

for _, item in pairs(char:GetChildren()) do
	if item:IsA("Accessory") then
		local handle = item:FindFirstChild("Handle")
		if handle then
			for _, att in pairs(handle:GetChildren()) do
				if att:IsA("Attachment") and string.find(att.Name, "Right") and (string.find(att.Name, "Leg") or string.find(att.Name, "Foot")) then
					handle.Transparency = toggled and 1 or 0
				end
			end
		end
	end
end


end)

-- C. Animation Pack Switcher
local customAnimIDs = {walk = "", run = "", jump = "", fall = ""}

CreateTextBox(mainPage, "Walk Animation ID...", function(text) customAnimIDs.walk = text end)
CreateTextBox(mainPage, "Run Animation ID...", function(text) customAnimIDs.run = text end)
CreateTextBox(mainPage, "Jump Animation ID...", function(text) customAnimIDs.jump = text end)
CreateTextBox(mainPage, "Fall Animation ID...", function(text) customAnimIDs.fall = text end)

CreateButton(mainPage, "Apply Custom Animations", function()
local char = LocalPlayer.Character
if not char then return end
local animate = char:FindFirstChild("Animate")
if animate then
if customAnimIDs.walk ~= "" and animate:FindFirstChild("walk") then
animate.walk:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. customAnimIDs.walk
end
if customAnimIDs.run ~= "" and animate:FindFirstChild("run") then
animate.run:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. customAnimIDs.run
end
if customAnimIDs.jump ~= "" and animate:FindFirstChild("jump") then
animate.jump:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. customAnimIDs.jump
end
if customAnimIDs.fall ~= "" and animate:FindFirstChild("fall") then
animate.fall:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. customAnimIDs.fall
end
end
end)

-- Вкладка COMBAT

local combatPage = TabPages["Combat"]

-- WalkSpeed Slider
CreateSlider(combatPage, "WalkSpeed", 16, 250, 16, function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = value
end
end)

-- JumpPower Slider
CreateSlider(combatPage, "JumpPower", 50, 300, 50, function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.JumpPower = value
end
end)

-- Noclip Toggle
local noclipConn
CreateToggle(combatPage, "Noclip (Walk Through Walls)", false, function(toggled)
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

-- Infinite Jump
local infJumpConn
CreateToggle(combatPage, "Infinite Jump", false, function(toggled)
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

-- Вкладка ESP

local espPage = TabPages["ESP"]
local espHighlights = {}
local espConnection

CreateToggle(espPage, "Player ESP (Highlight)", false, function(toggled)
if toggled then
local function addESP(player)
if player ~= LocalPlayer then
local function applyHL(char)
if not char then return end
local hl = Instance.new("Highlight")
hl.Name = "UtaESP"
hl.FillColor = THEME.Primary
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.FillTransparency = 0.5
hl.Parent = char
espHighlights[player] = hl
end
if player.Character then applyHL(player.Character) end
player.CharacterAdded:Connect(applyHL)
end
end

	for _, p in pairs(Players:GetPlayers()) do addESP(p) end
	espConnection = Players.PlayerAdded:Connect(addESP)
else
	if espConnection then espConnection:Disconnect() end
	for _, hl in pairs(espHighlights) do
		if hl then hl:Destroy() end
	end
	espHighlights = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("UtaESP") then
			p.Character.UtaESP:Destroy()
		end
	end
end


end)

-- Вкладка AUTOFARM

local autofarmPage = TabPages["Autofarm"]

local autoClicking = false
CreateToggle(autofarmPage, "Auto Clicker", false, function(toggled)
autoClicking = toggled
task.spawn(function()
while autoClicking do
local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
if tool then tool:Activate() end
task.wait(0.1)
end
end)
end)

CreateButton(autofarmPage, "Teleport to Random Player", function()
local otherPlayers = {}
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
table.insert(otherPlayers, p)
end
end
if #otherPlayers > 0 then
local target = otherPlayers[math.random(1, #otherPlayers)]
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
end
end
end)

-- Вкладка FLING

local flingPage = TabPages["Fling"]
local flingTargetName = ""

CreateTextBox(flingPage, "Enter Target Username...", function(text)
flingTargetName = text
end)

CreateButton(flingPage, "Fling Target Player", function()
if flingTargetName == "" then return end
local targetPlayer
for _, p in pairs(Players:GetPlayers()) do
if string.sub(string.lower(p.Name), 1, #flingTargetName) == string.lower(flingTargetName) or string.sub(string.lower(p.DisplayName), 1, #flingTargetName) == string.lower(flingTargetName) then
targetPlayer = p
break
end
end

if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local root = LocalPlayer.Character.HumanoidRootPart
	local targetRoot = targetPlayer.Character.HumanoidRootPart
	
	local bgv = Instance.new("BodyAngularVelocity")
	bgv.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bgv.AngularVelocity = Vector3.new(0, 99999, 0)
	bgv.Parent = root
	
	for i = 1, 40 do
		root.CFrame = targetRoot.CFrame
		task.wait(0.02)
	end
	bgv:Destroy()
end


end)

-- Вкладка FUN

local funPage = TabPages["Fun"]
local spinBGV

CreateToggle(funPage, "SpinBot", false, function(toggled)
local char = LocalPlayer.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then return end
local root = char.HumanoidRootPart

if toggled then
	spinBGV = Instance.new("BodyAngularVelocity")
	spinBGV.Name = "UtaSpinBot"
	spinBGV.MaxTorque = Vector3.new(0, math.huge, 0)
	spinBGV.AngularVelocity = Vector3.new(0, 50, 0)
	spinBGV.Parent = root
else
	if spinBGV then spinBGV:Destroy() end
	if root:FindFirstChild("UtaSpinBot") then root.UtaSpinBot:Destroy() end
end


end)

CreateToggle(funPage, "Low Gravity", false, function(toggled)
workspace.Gravity = toggled and 35 or 196.2
end)

CreateButton(funPage, "Give Building Tools (BTools)", function()
local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
if backpack then
for i = 1, 4 do
local tool = Instance.new("HopperBin")
tool.BinType = i
tool.Parent = backpack
end
end
end)

-- Вкладка SETTINGS

local settingsPage = TabPages["Settings"]

CreateButton(settingsPage, "Rejoin Game", function()
TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(settingsPage, "Unload UI (Destroy)", function()
ScreenGui:Destroy()
end)
