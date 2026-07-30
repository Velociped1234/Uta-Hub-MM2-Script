-- ... existing code ...
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

-- ... existing code ...
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

/* STREAMING_CHUNK:Creating tab list container and switching logic... */
-- Контейнер для списка вкладок в сайдбаре (с прокруткой на случай длинного списка)
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

-- Контейнер для содержимого вкладок
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -130, 1, -20)
ContentContainer.Position = UDim2.new(0, 130, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- =========================================================
-- 3.1 Логика и создание Вкладок
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
-- Создаём отдельную страницу для каждой вкладки
local Page = Instance.new("ScrollingFrame")
Page.Name = tabName .. "Page"
Page.Size = UDim2.new(1, 0, 1, 0)
Page.BackgroundTransparency = 1
Page.BorderSizePixel = 0
Page.ScrollBarThickness = 3
Page.ScrollBarImageColor3 = THEME.Primary
Page.Visible = false
Page.Parent = ContentContainer

TabPages[tabName] = Page

-- Кнопка вкладки в сайдбаре
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

TabButton.MouseButton1Click:Connect(function()
	SwitchTab(tabName)
end)

TabButtons[tabName] = TabButton


end

-- Активируем вкладку "Main" по умолчанию
SwitchTab("Main")

-- =========================================================
-- 4. Кнопка "UTA HUB" с Радужным Переливом
-- =========================================================
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 105, 0, 35)
OpenButton.Position = UDim2.new(0, 20, 0.5, -17)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный цвет кнопки
OpenButton.BorderSizePixel = 0
OpenButton.Text = "UTA HUB"
OpenButton.TextSize = 15
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
-- ... existing code ...
