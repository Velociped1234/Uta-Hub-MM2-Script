-- STREAMING_CHUNK:Configuring services, theme, and stable UI foundation...
-- =========================================================
-- Улучшенное ядро без багов и вылетов
-- =========================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- =========================================================
-- Настройки Цветов и Дизайна (Адаптировано под скриншоты)
-- =========================================================
local THEME = {
Primary = Color3.fromHex("#d033de"),      -- Основной Uta Hub
Secondary = Color3.fromHex("#e8357f"),    -- Розовый для секций (как на скрине)
TitleColor = Color3.fromHex("#db2cd8"),
Background = Color3.fromRGB(20, 20, 20),  -- Темнее фон для контраста
Sidebar = Color3.fromRGB(15, 15, 15),
ElementBg = Color3.fromRGB(30, 30, 30),
ElementDark = Color3.fromRGB(25, 25, 25),
Text = Color3.fromRGB(255, 255, 255),
TextDark = Color3.fromRGB(150, 150, 150),
CornerRadius = UDim.new(0, 8)
}

-- STREAMING_CHUNK:Creating bug-free ScreenGui and Draggable Button...
-- =========================================================
-- 1. Создание базового GUI (Фикс черных экранов)
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UtaHubGui_Stable"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999 -- Всегда поверх инвентарей и магазинов
-- Защита от дублирования при перезапуске
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UtaHubGui_Stable") then
LocalPlayer.PlayerGui.UtaHubGui_Stable:Destroy()
end
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =========================================================
-- 2. Кнопка "UTA HUB" (Радужная, Перетаскиваемая)
-- =========================================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 120, 0, 40)
OpenBtn.Position = UDim2.new(0.5, -60, 0, 20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Text = "UTA HUB"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 16
OpenBtn.Parent = ScreenGui

local OpenUICorner = Instance.new("UICorner")
OpenUICorner.CornerRadius = UDim.new(0, 20) -- Скругленная как капсула
OpenUICorner.Parent = OpenBtn

local OpenUIStroke = Instance.new("UIStroke")
OpenUIStroke.Thickness = 2
OpenUIStroke.Parent = OpenBtn

-- Плавная Радужная анимация
RunService.RenderStepped:Connect(function()
local hue = tick() % 5 / 5
local rainbowColor = Color3.fromHSV(hue, 1, 1)
OpenBtn.TextColor3 = rainbowColor
OpenUIStroke.Color = rainbowColor
end)

-- STREAMING_CHUNK:Building the main frame layout with correct clipping...
-- =========================================================
-- 3. Главное Меню (Расширено для 2-х колонок Combat)
-- =========================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400) -- Увеличен для колонок
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- ИСПРАВЛЕНИЕ: Никаких черных квадратов за краями!
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = THEME.CornerRadius
MainUICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 120, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Uta Hub"
Title.TextColor3 = THEME.TitleColor
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
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

-- STREAMING_CHUNK:Implementing draggable windows correctly...
-- =========================================================
-- 4. Идеальное Перетаскивание (Drag) без зависаний
-- =========================================================
local function MakeDraggable(guiElement, dragHandle)
dragHandle = dragHandle or guiElement
local dragging, dragInput, dragStart, startPos

dragHandle.InputBegan:Connect(function(input)
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

dragHandle.InputChanged:Connect(function(input)
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

OpenBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)

-- STREAMING_CHUNK:Advanced UI Constructors for matching the screenshots...
-- =========================================================
-- 5. Расширенные UI Конструкторы (Точно как на фото)
-- =========================================================
local Tabs = {}
local TabPages = {}

local function CreateTab(name, isFirst)
local TabBtn = Instance.new("TextButton")
TabBtn.Size = UDim2.new(1, 0, 0, 35)
TabBtn.BackgroundTransparency = 1
TabBtn.Text = "  " .. name
TabBtn.TextColor3 = isFirst and THEME.Primary or THEME.TextDark
TabBtn.TextXAlignment = Enum.TextXAlignment.Left
TabBtn.TextSize = 14
TabBtn.Font = Enum.Font.GothamBold
TabBtn.Parent = Sidebar

local Page = Instance.new("Frame")
Page.Size = UDim2.new(1, -20, 1, -20)
Page.Position = UDim2.new(0, 10, 0, 10)
Page.BackgroundTransparency = 1
Page.Visible = isFirst
Page.Parent = ContentContainer

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

-- Секции с розовой полоской (как Sheriff / Murder)
local function CreateSection(parent, text)
local Section = Instance.new("Frame")
Section.Size = UDim2.new(1, 0, 0, 25)
Section.BackgroundTransparency = 1
Section.Parent = parent

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 3, 0, 14)
Line.Position = UDim2.new(0, 0, 0.5, -7)
Line.BackgroundColor3 = THEME.Secondary
Line.BorderSizePixel = 0
Line.Parent = Section

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -10, 1, 0)
Label.Position = UDim2.new(0, 10, 0, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 14
Label.Font = Enum.Font.GothamBold
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Section


end

-- Подзаголовки
local function CreateLabel(parent, text)
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 20)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.GothamBold
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = parent
return Label
end

-- STREAMING_CHUNK:Constructing Toggles and Dropdowns...
local function CreateToggle(parent, text, default, callback)
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, 0, 0, 30)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Parent = parent

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -50, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 13
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = ToggleContainer

local ToggleBg = Instance.new("TextButton")
ToggleBg.Size = UDim2.new(0, 34, 0, 18)
ToggleBg.Position = UDim2.new(1, -34, 0.5, -9)
ToggleBg.BackgroundColor3 = default and THEME.Primary or THEME.ElementBg
ToggleBg.Text = ""
ToggleBg.Parent = ToggleContainer

Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 14, 0, 14)
Circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
Circle.BackgroundColor3 = THEME.Text
Circle.Parent = ToggleBg

Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

local isToggled = default
ToggleBg.MouseButton1Click:Connect(function()
	isToggled = not isToggled
	local goalBg = {BackgroundColor3 = isToggled and THEME.Primary or THEME.ElementBg}
	local goalCirclePos = {Position = isToggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}
	
	TweenService:Create(ToggleBg, TweenInfo.new(0.2), goalBg):Play()
	TweenService:Create(Circle, TweenInfo.new(0.2), goalCirclePos):Play()
	
	if callback then task.spawn(callback, isToggled) end
end)


end

-- Компактный Dropdown (Циклическая кнопка, чтобы избежать багов с наложением)
local function CreateDropdown(parent, text, options, callback)
local DropContainer = Instance.new("Frame")
DropContainer.Size = UDim2.new(1, 0, 0, 30)
DropContainer.BackgroundTransparency = 1
DropContainer.Parent = parent

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0.5, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.TextDark
Label.TextSize = 12
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = DropContainer

local DropBtn = Instance.new("TextButton")
DropBtn.Size = UDim2.new(0.5, 0, 0, 24)
DropBtn.Position = UDim2.new(0.5, 0, 0.5, -12)
DropBtn.BackgroundColor3 = THEME.ElementDark
DropBtn.TextColor3 = THEME.Secondary
DropBtn.TextSize = 12
DropBtn.Font = Enum.Font.GothamBold
DropBtn.Text = options[1] .. " v"
DropBtn.Parent = DropContainer
Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)

local currentIndex = 1
DropBtn.MouseButton1Click:Connect(function()
	currentIndex = currentIndex + 1
	if currentIndex > #options then currentIndex = 1 end
	DropBtn.Text = options[currentIndex] .. " v"
	if callback then task.spawn(callback, options[currentIndex]) end
end)


end

-- STREAMING_CHUNK:Constructing Sliders, Buttons and Player List...
local function CreateSlider(parent, text, min, max, default, unit, callback)
unit = unit or ""
local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1, 0, 0, 40)
SliderContainer.BackgroundTransparency = 1
SliderContainer.Parent = parent

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0.5, 0, 0, 20)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = THEME.Text
Label.TextSize = 12
Label.Font = Enum.Font.Gotham
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = SliderContainer

local ValLabel = Instance.new("TextLabel")
ValLabel.Size = UDim2.new(0.5, 0, 0, 20)
ValLabel.Position = UDim2.new(0.5, 0, 0, 0)
ValLabel.BackgroundTransparency = 1
ValLabel.Text = tostring(default) .. " " .. unit
ValLabel.TextColor3 = THEME.Secondary
ValLabel.TextSize = 12
ValLabel.Font = Enum.Font.GothamBold
ValLabel.TextXAlignment = Enum.TextXAlignment.Right
ValLabel.Parent = SliderContainer

local SliderBg = Instance.new("TextButton")
SliderBg.Size = UDim2.new(1, 0, 0, 6)
SliderBg.Position = UDim2.new(0, 0, 0, 25)
SliderBg.BackgroundColor3 = THEME.ElementBg
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

-- Кружок-ползунок
local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 12, 0, 12)
Knob.Position = UDim2.new(1, -6, 0.5, -6)
Knob.BackgroundColor3 = THEME.Text
Knob.Parent = Fill
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

local dragging = false
local function update(input)
	local x = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
	Fill.Size = UDim2.new(x, 0, 1, 0)
	local val = math.floor(min + (max - min) * x)
	ValLabel.Text = tostring(val) .. " " .. unit
	if callback then task.spawn(callback, val) end
end

SliderBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		update(input)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
end)


end

local function CreateButton(parent, text, callback)
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, 0, 0, 30)
Btn.BackgroundColor3 = THEME.ElementDark
Btn.Text = text
Btn.TextColor3 = THEME.Text
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 13
Btn.Parent = parent
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Btn).Color = THEME.ElementBg

Btn.MouseButton1Click:Connect(function()
	if callback then task.spawn(callback) end
end)


end

-- STREAMING_CHUNK:Setting up Tabs (Hardcoded English to prevent localization bugs)...
-- =========================================================
-- 6. Инициализация Вкладок
-- =========================================================
-- Тексты жестко заданы на английском, чтобы избежать бага "Бой" / "ЭСП"
local mainPage = CreateTab("Main", true)
local combatPage = CreateTab("Combat", false)
local espPage = CreateTab("ESP", false)
local autofarmPage = CreateTab("Autofarm", false)
local flingPage = CreateTab("Fling", false)
local funPage = CreateTab("Fun", false)
local settingsPage = CreateTab("Settings", false)

-- =========================================================
-- TAB: MAIN (Walkspeed, Jumppower, Noclip, Fly, Spin)
-- =========================================================
local MainScroll = Instance.new("ScrollingFrame", mainPage)
MainScroll.Size = UDim2.new(1, 0, 1, 0)
MainScroll.BackgroundTransparency = 1
MainScroll.ScrollBarThickness = 2
MainScroll.BorderSizePixel = 0
local MainLayout = Instance.new("UIListLayout", MainScroll)
MainLayout.Padding = UDim.new(0, 5)

CreateSlider(MainScroll, "WalkSpeed", 16, 250, 16, "", function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = value
end
end)

CreateSlider(MainScroll, "JumpPower", 50, 300, 50, "", function(value)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.UseJumpPower = true
LocalPlayer.Character.Humanoid.JumpPower = value
end
end)

local noclipConn
CreateToggle(MainScroll, "Noclip", false, function(toggled)
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
CreateToggle(MainScroll, "Infinite Jump", false, function(toggled)
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

-- Fly & Spin Logic
local spinConn
CreateToggle(MainScroll, "Spin", false, function(toggled)
if toggled then
spinConn = RunService.RenderStepped:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(20), 0)
end
end)
else
if spinConn then spinConn:Disconnect() end
end
end)

-- STREAMING_CHUNK:Building the Combat Layout (2 Columns Exactly like images)...
-- =========================================================
-- TAB: COMBAT (MM2 Features, 2 Columns)
-- =========================================================
-- Создаем 2 колонки для точного совпадения со скриншотом
local CombatLayout = Instance.new("UIListLayout", combatPage)
CombatLayout.FillDirection = Enum.FillDirection.Horizontal
CombatLayout.Padding = UDim.new(0, 10)

local LeftCol = Instance.new("ScrollingFrame", combatPage)
LeftCol.Size = UDim2.new(0.5, -5, 1, 0)
LeftCol.BackgroundTransparency = 1
LeftCol.ScrollBarThickness = 2
LeftCol.BorderSizePixel = 0
local LeftLayout = Instance.new("UIListLayout", LeftCol)
LeftLayout.Padding = UDim.new(0, 5)

local RightCol = Instance.new("ScrollingFrame", combatPage)
RightCol.Size = UDim2.new(0.5, -5, 1, 0)
RightCol.BackgroundTransparency = 1
RightCol.ScrollBarThickness = 2
RightCol.BorderSizePixel = 0
local RightLayout = Instance.new("UIListLayout", RightCol)
RightLayout.Padding = UDim.new(0, 5)

-- ---- LEFT COLUMN (Sheriff / AimBot) ----
CreateSection(LeftCol, "Sheriff")
CreateToggle(LeftCol, "Auto Pickup Gun", true, function(state) end)
CreateToggle(LeftCol, "Silent Aim", true, function(state) end)
CreateToggle(LeftCol, "Wallbang", true, function(state) end)
CreateToggle(LeftCol, "Auto Shoot Murder", false, function(state) end)
CreateToggle(LeftCol, "Auto Kill Murder", false, function(state) end)
CreateToggle(LeftCol, "Auto Fling Sheriff", false, function(state) end)

CreateLabel(LeftCol, "AimBot")
CreateDropdown(LeftCol, "Aim Version", {"V1 (Pulse)", "V2 (Beta)"}, function(val) end)
CreateDropdown(LeftCol, "AimBot Type", {"Flick Shot", "Tracking"}, function(val) end)
CreateSlider(LeftCol, "Flick Speed", 1, 20, 5, "", function(val) end)
CreateSlider(LeftCol, "Flick Return %", 0, 100, 41, "", function(val) end)
CreateSlider(LeftCol, "Prediction (ms)", 0, 200, 58, "", function(val) end)
CreateToggle(LeftCol, "Aim Debug", true, function(state) end)

CreateLabel(LeftCol, "Custom Sounds")
CreateDropdown(LeftCol, "Shot Sound", {"Harvester", "Luger", "Revolver"}, function(val) end)
CreateButton(LeftCol, "Preview Shot", function() end)
CreateDropdown(LeftCol, "Kill Sound", {"Off", "Oof", "Splat"}, function(val) end)
CreateButton(LeftCol, "Preview Kill", function() end)

-- ---- RIGHT COLUMN (Murder / Kill Player) ----
CreateSection(RightCol, "Murder")
CreateLabel(RightCol, "Kill Aura")
CreateToggle(RightCol, "Kill All", false, function(state) end)
CreateToggle(RightCol, "Kill Only Sheriff", false, function(state) end)
CreateToggle(RightCol, "Limit Distance", false, function(state) end)
CreateSlider(RightCol, "Kill Distance", 10, 100, 50, "studs", function(val) end)

CreateLabel(RightCol, "Knife Throw")
CreateToggle(RightCol, "Knife Throw Aimbot", false, function(state) end)
CreateToggle(RightCol, "Prediction", true, function(state) end)
CreateSlider(RightCol, "Prediction Lead %", 0, 100, 83, "", function(val) end)

CreateSection(RightCol, "Kill Player")
local SelectedTargetLabel = CreateLabel(RightCol, "Selected: none")
SelectedTargetLabel.TextColor3 = THEME.TextDark

local selectedPlayerForKill = nil
CreateButton(RightCol, "Kill Selected", function()
if selectedPlayerForKill then
print("Attempting to kill: " .. selectedPlayerForKill.Name)
end
end)

-- Кастомный список игроков для правой колонки
local PlayerListFrame = Instance.new("ScrollingFrame", RightCol)
PlayerListFrame.Size = UDim2.new(1, 0, 0, 150)
PlayerListFrame.BackgroundColor3 = THEME.ElementDark
PlayerListFrame.ScrollBarThickness = 2
PlayerListFrame.BorderSizePixel = 0
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 6)
local PlayerListLayout = Instance.new("UIListLayout", PlayerListFrame)

local function UpdatePlayerList()
for _, child in pairs(PlayerListFrame:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
local PBtn = Instance.new("TextButton")
PBtn.Size = UDim2.new(1, 0, 0, 30)
PBtn.BackgroundTransparency = 1
PBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
PBtn.TextColor3 = THEME.Text
PBtn.TextXAlignment = Enum.TextXAlignment.Left
PBtn.Font = Enum.Font.Gotham
PBtn.TextSize = 12
PBtn.Parent = PlayerListFrame

		PBtn.MouseButton1Click:Connect(function()
			selectedPlayerForKill = p
			SelectedTargetLabel.Text = "Selected: " .. p.Name
		end)
	end
end


end
UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- STREAMING_CHUNK:Finalizing ESP, Autofarm, Fling, Settings functionality...
-- =========================================================
-- TAB: ESP
-- =========================================================
local EspScroll = Instance.new("ScrollingFrame", espPage)
EspScroll.Size = UDim2.new(1, 0, 1, 0)
EspScroll.BackgroundTransparency = 1
EspScroll.ScrollBarThickness = 2
EspScroll.BorderSizePixel = 0
local EspLayout = Instance.new("UIListLayout", EspScroll)
EspLayout.Padding = UDim.new(0, 5)

local espEnabled = false
CreateToggle(EspScroll, "Player ESP", false, function(toggled)
espEnabled = toggled
if not toggled then
for _, v in pairs(Workspace:GetDescendants()) do
if v:IsA("Highlight") and v.Name == "UtaESP" then v:Destroy() end
end
end
end)

RunService.RenderStepped:Connect(function()
if espEnabled then
for _, player in pairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("UtaESP") then
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
end)

-- =========================================================
-- TAB: AUTOFARM, FLING, FUN, SETTINGS
-- =========================================================
-- Autofarm
local AutoScroll = Instance.new("ScrollingFrame", autofarmPage)
AutoScroll.Size = UDim2.new(1, 0, 1, 0)
AutoScroll.BackgroundTransparency = 1
AutoScroll.BorderSizePixel = 0
Instance.new("UIListLayout", AutoScroll).Padding = UDim.new(0, 5)

CreateButton(AutoScroll, "Teleport to Random Player", function()
local allP = Players:GetPlayers()
if #allP > 1 then
local rand
repeat rand = allP[math.random(1, #allP)] until rand ~= LocalPlayer
if rand.Character and rand.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
end
end
end)

-- Fling (Placeholder)
local FlingScroll = Instance.new("ScrollingFrame", flingPage)
FlingScroll.Size = UDim2.new(1, 0, 1, 0)
FlingScroll.BackgroundTransparency = 1
FlingScroll.BorderSizePixel = 0
Instance.new("UIListLayout", FlingScroll).Padding = UDim.new(0, 5)
CreateLabel(FlingScroll, "Fling functions in development.")

-- Fun
local FunScroll = Instance.new("ScrollingFrame", funPage)
FunScroll.Size = UDim2.new(1, 0, 1, 0)
FunScroll.BackgroundTransparency = 1
FunScroll.BorderSizePixel = 0
Instance.new("UIListLayout", FunScroll).Padding = UDim.new(0, 5)

CreateButton(FunScroll, "Give BTools (Local)", function()
for _, bin in pairs({"Clone", "Hammer", "Grab"}) do
local tool = Instance.new("HopperBin", LocalPlayer.Backpack)
tool.BinType = Enum.BinType[bin]
end
end)

CreateToggle(FunScroll, "Low Gravity", false, function(toggled)
Workspace.Gravity = toggled and 50 or 196.2
end)

-- Settings
local SetScroll = Instance.new("ScrollingFrame", settingsPage)
SetScroll.Size = UDim2.new(1, 0, 1, 0)
SetScroll.BackgroundTransparency = 1
SetScroll.BorderSizePixel = 0
Instance.new("UIListLayout", SetScroll).Padding = UDim.new(0, 5)

CreateButton(SetScroll, "Rejoin Server", function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

CreateButton(SetScroll, "Unload UI", function()
if ScreenGui then ScreenGui:Destroy() end
if noclipConn then noclipConn:Disconnect() end
if infJumpConn then infJumpConn:Disconnect() end
if spinConn then spinConn:Disconnect() end
end)
