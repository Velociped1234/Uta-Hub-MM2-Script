-- =========================================================
-- Сервисы
-- =========================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- =========================================================
-- Настройки Цветов и Дизайна
-- =========================================================
local THEME = {
	Primary = Color3.fromHex("#d033de"), -- Неоново-фиолетовый
	Background = Color3.fromRGB(30, 30, 30),
	Sidebar = Color3.fromRGB(20, 20, 20),
	ElementBg = Color3.fromRGB(45, 45, 45),
	Text = Color3.fromRGB(255, 255, 255),
	CornerRadius = UDim.new(0, 12)
}

-- =========================================================
-- 1. Создание базового GUI (MainFrame и панели)
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminPanelGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = THEME.CornerRadius
MainUICorner.Parent = MainFrame

-- Левая панель (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarUICorner = Instance.new("UICorner")
SidebarUICorner.CornerRadius = THEME.CornerRadius
SidebarUICorner.Parent = Sidebar

-- Чтобы скрыть закругление справа у сайдбара, добавляем заплатку
local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
SidebarPatch.BackgroundColor3 = THEME.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

-- Контейнер для вкладок
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -130, 1, -20)
ContentContainer.Position = UDim2.new(0, 130, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- =========================================================
-- 2. Оптимизированный Drag-and-Drop (PC & Mobile)
-- =========================================================
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	
	-- Плавное перемещение с помощью TweenService
	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos})
	tween:Play()
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

-- =========================================================
-- 3. Конструктор кнопок-переключателей (Toggles)
-- =========================================================
local function CreateToggle(parent, text, callback)
	local ToggleContainer = Instance.new("Frame")
	ToggleContainer.Size = UDim2.new(1, 0, 0, 40)
	ToggleContainer.BackgroundTransparency = 1
	ToggleContainer.Parent = parent

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = THEME.Text
	Label.TextSize = 16
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleContainer

	local ToggleBg = Instance.new("Frame")
	ToggleBg.Size = UDim2.new(0, 50, 0, 24)
	ToggleBg.Position = UDim2.new(1, -50, 0.5, -12)
	ToggleBg.BackgroundColor3 = THEME.ElementBg
	ToggleBg.Parent = ToggleContainer

	local BgCorner = Instance.new("UICorner")
	BgCorner.CornerRadius = UDim.new(1, 0)
	BgCorner.Parent = ToggleBg

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 3, 0.5, -9)
	Circle.BackgroundColor3 = THEME.Text
	Circle.Parent = ToggleBg

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local isToggled = false

	ToggleBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isToggled = not isToggled
			
			-- Анимация переключателя
			local bgGoal = {BackgroundColor3 = isToggled and THEME.Primary or THEME.ElementBg}
			local circleGoal = {Position = isToggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}
			
			TweenService:Create(ToggleBg, TweenInfo.new(0.2), bgGoal):Play()
			TweenService:Create(Circle, TweenInfo.new(0.2), circleGoal):Play()
			
			if callback then callback(isToggled) end
		end
	end)

	return ToggleContainer
end

-- =========================================================
-- 4. Логика модификации персонажа
-- =========================================================
local function ApplyCustomAvatarMods(state)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	if state then
		-- A. Скрываем правую ногу (поддержка R6 и R15)
		local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg")
		local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
		local rightFoot = character:FindFirstChild("RightFoot")
		
		if rightLeg then rightLeg.Transparency = 1 end
		if rightUpperLeg then rightUpperLeg.Transparency = 1 end
		if rightFoot then rightFoot.Transparency = 1 end

		-- Удаление аксессуаров на правой ноге
		for _, item in pairs(character:GetChildren()) do
			if item:IsA("Accessory") then
				local handle = item:FindFirstChild("Handle")
				if handle then
					for _, attachment in pairs(handle:GetChildren()) do
						if attachment:IsA("Attachment") and string.find(attachment.Name, "Right") and (string.find(attachment.Name, "Leg") or string.find(attachment.Name, "Foot")) then
							item:Destroy()
						end
					end
				end
			end
		end

		-- B. Скрываем голову и удаляем лицо
		local head = character:FindFirstChild("Head")
		if head then
			head.Transparency = 1
			local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
			if face then face:Destroy() end
			
			-- Отключаем отображение Decal/Texture на всякий случай
			for _, v in pairs(head:GetChildren()) do
				if v:IsA("Decal") or v:IsA("Texture") then
					v:Destroy()
				end
			end
		end

		-- C. Подмена ID анимаций
		local animate = character:FindFirstChild("Animate")
		if animate then
			-- ЗАМЕНИТЕ НУЛИ НА ВАШИ CUSTOM ID АНИМАЦИЙ!
			local customAnimations = {
				walk = "rbxassetid://0000000000",
				run = "rbxassetid://0000000000",
				jump = "rbxassetid://0000000000",
				fall = "rbxassetid://0000000000"
			}

			for animName, newId in pairs(customAnimations) do
				local animContainer = animate:FindFirstChild(animName)
				if animContainer then
					for _, animObj in pairs(animContainer:GetChildren()) do
						if animObj:IsA("Animation") then
							animObj.AnimationId = newId
						end
					end
				end
			end
			-- Перезапуск анимаций для применения новых ID
			local currentAnimTrack = humanoid:GetPlayingAnimationTracks()
			for _, track in pairs(currentAnimTrack) do
				track:Stop()
			end
		end
	else
		-- Логика отключения (можно оставить пустой или реализовать перезагрузку персонажа)
		-- Для полного сброса проще всего сделать:
		-- humanoid.Health = 0
	end
end

-- =========================================================
-- 5. Заполнение интерфейса
-- =========================================================
local MainTab = Instance.new("ScrollingFrame")
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.BorderSizePixel = 0
MainTab.ScrollBarThickness = 4
MainTab.Parent = ContentContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = MainTab

-- Добавляем Toggle во вкладку Main
CreateToggle(MainTab, "Enable Custom Avatar Mods", function(toggled)
	ApplyCustomAvatarMods(toggled)
end)

-- (Опционально) Добавление кнопки переключения вкладок на Sidebar
local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(1, 0, 0, 40)
TabButton.BackgroundTransparency = 1
TabButton.Text = "Main"
TabButton.TextColor3 = THEME.Primary -- Подсвечиваем активную вкладку
TabButton.TextSize = 16
TabButton.Font = Enum.Font.GothamBold
TabButton.Parent = Sidebar
