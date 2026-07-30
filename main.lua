-- =========================================================
-- Сервисы
-- =========================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

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
CornerRadius = UDim.new(0, 12)
}

-- =========================================================
-- 1. Создание базового ScreenGui
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UtaHubAdminGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- =========================================================
-- 2. Вспомогательная функция для перетаскивания (Drag-and-Drop)
-- =========================================================
local function MakeDraggable(frame)
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
	TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

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
		updateInput(input)
	end
end)


end

-- =========================================================
-- 3. Главная Рамка (MainFrame) - Уменьшенный размер 440x300
-- =========================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 300)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- По умолчанию меню скрыто
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = THEME.CornerRadius
MainUICorner.Parent = MainFrame

MakeDraggable(MainFrame)

-- Левая панель (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarUICorner = Instance.new("UICorner")
SidebarUICorner.CornerRadius = THEME.CornerRadius
SidebarUICorner.Parent = Sidebar

-- Заплатка для скрытия правого закругления сайдбара
local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
SidebarPatch.BackgroundColor3 = THEME.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

-- Название проекта: Uta Hub (Цвет #db2cd8)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Uta Hub"
TitleLabel.TextColor3 = THEME.TitleColor
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Sidebar

-- Контейнер для будущего содержимого вкладок (сейчас пустой)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -120, 1, -20)
ContentContainer.Position = UDim2.new(0, 120, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- =========================================================
-- 4. Кнопка "OPEN" с Радужным Переливом
-- =========================================================
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 90, 0, 35)
OpenButton.Position = UDim2.new(0, 20, 0.5, -17)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный цвет кнопки
OpenButton.BorderSizePixel = 0
OpenButton.Text = "OPEN"
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 8)
OpenBtnCorner.Parent = OpenButton

-- Обводка для кнопки (также переливается)
local OpenBtnStroke = Instance.new("UIStroke")
OpenBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenBtnStroke.Thickness = 2
OpenBtnStroke.Parent = OpenButton

MakeDraggable(OpenButton)

-- Логика переливающимися цветами радуги (Rainbow Effect)
RunService.RenderStepped:Connect(function()
local hue = (tick() % 4) / 4 -- Цикл перелива в 4 секунды
local rainbowColor = Color3.fromHSV(hue, 0.85, 1)

OpenButton.TextColor3 = rainbowColor
OpenBtnStroke.Color = rainbowColor


end)

-- Логика открытия / закрытия окна
OpenButton.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)
