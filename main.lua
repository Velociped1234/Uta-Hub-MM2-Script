--[[
    ★ UTA HUB PREMIUM EDITION ★
    Цвет: #d033de | Плавные углы | Мобильное перетаскивание | Функции Waguri
--]]

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local LeftPanel = Instance.new("Frame")
local ContentPanel = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UICorner_Toggle = Instance.new("UICorner")
local UIListLayout_Tabs = Instance.new("UIListLayout")

local customColor = Color3.fromHex("#d033de") -- Твой фирменный цвет

ScreenGui.Name = "UtaHub_Gui"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА ТРИГГЕРА (Uta Hub)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.BackgroundColor3 = customColor
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Uta Hub"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
UICorner_Toggle.CornerRadius = UDim.new(0, 8) -- Закругление углов кнопки
UICorner_Toggle.Parent = ToggleButton

-- ГЛАВНОЕ ОКНО
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.Active = true
UICorner_Main.CornerRadius = UDim.new(0, 12) -- Красивые скругленные углы меню
UICorner_Main.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- СКРИПТ ПЛАВНОГО ПЕРЕТАСКИВАНИЯ ПАЛЬЦЕМ ДЛЯ ТЕЛЕФОНОВ
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
		update(input)
	end
end)

-- ЛЕВАЯ ПАНЕЛЬ С ТАБАМИ
LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.Size = UDim2.new(0, 130, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
local UICorner_Left = Instance.new("UICorner")
UICorner_Left.CornerRadius = UDim.new(0, 12)
UICorner_Left.Parent = LeftPanel
UIListLayout_Tabs.Parent = LeftPanel
UIListLayout_Tabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Tabs.Padding = UDim.new(0, 5)

ContentPanel.Name = "ContentPanel"
ContentPanel.Parent = MainFrame
ContentPanel.Position = UDim2.new(0, 135, 0, 5)
ContentPanel.Size = UDim2.new(1, -140, 1, -10)
ContentPanel.BackgroundTransparency = 1

local pageContainers = {}
local tabs = {"Main", "Visuals", "Combat", "Sheriff", "Murder", "Button", "Fling", "Auto Farm", "Setings"}

for _, tabName in ipairs(tabs) do
	local container = Instance.new("ScrollingFrame")
	container.Name = tabName .. "Page"
	container.Parent = ContentPanel
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Visible = false
	container.CanvasSize = UDim2.new(0, 0, 2, 0)
	container.ScrollBarThickness = 4
	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = container
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	pageContainers[tabName] = container
end
pageContainers["Main"].Visible = true

for _, tabName in ipairs(tabs) do
	local TabButton = Instance.new("TextButton")
	TabButton.Name = tabName .. "Tab"
	TabButton.Parent = LeftPanel
	TabButton.Size = UDim2.new(1, 0, 0, 32)
	TabButton.BackgroundColor3 = customColor
	TabButton.BackgroundTransparency = 1
	TabButton.Font = Enum.Font.Gotham
	TabButton.Text = "  " .. tabName
	TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
	TabButton.TextSize = 13
	TabButton.TextXAlignment = Enum.TextXAlignment.Left
	local UICorner_Tab = Instance.new("UICorner")
	UICorner_Tab.CornerRadius = UDim.new(0, 6) -- Закругление вкладок
	UICorner_Tab.Parent = TabButton
	
	TabButton.MouseButton1Click:Connect(function()
		for _, btn in pairs(LeftPanel:GetChildren()) do
			if btn:IsA("TextButton") then btn.BackgroundTransparency = 1 btn.TextColor3 = Color3.fromRGB(180, 180, 180) end
		end
		TabButton.BackgroundTransparency = 0.8
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		for _, page in pairs(pageContainers) do page.Visible = false end
		pageContainers[tabName].Visible = true
	end)
end
if LeftPanel:FindFirstChild("MainTab") then LeftPanel.MainTab.BackgroundTransparency = 0.8 LeftPanel.MainTab.TextColor3 = Color3.fromRGB(255,255,255) end

-- КОНСТРУКТОР ТУМБЛЕРОВ С ЗАКРУГЛЕНИЕМ СТАНДАРТА #d033de
local function createToggle(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.95, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	btn.Font = Enum.Font.Gotham
	btn.Text = text .. ": ВЫКЛ"
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 13
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. (state and ": ВКЛ" or ": ВЫКЛ")
		btn.BackgroundColor3 = state and customColor or Color3.fromRGB(30, 30, 35)
		btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
		callback(state)
	end)
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8) -- Закругление углов у кнопок-переключателей
	return btn
end

local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.95, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.MouseButton1Click:Connect(callback)
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8) -- Закругление обычных кнопок действия
	return btn
end

-- ЛОГИКА ФУНКЦИЙ С ФИЛЬТРАЦИЕЙ ВАГУРИ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local cfg = { Korblox = false, Headless = false, Vampire = false, MurderESP = false, SheriffESP = false, FlickBot = false, AutoBomb = false }

local function applyWaguriVisuals(char)
	if not char then return end
	if cfg.Headless then
		local head = char:WaitForChild("Head", 5)
		if head then
			local face = head:FindFirstChildOfClass("Decal")
			if face then face:Destroy() end
			head.Transparency = 1
			local mesh = head:FindFirstChildOfClass("SpecialMesh")
			if mesh then mesh.Scale = Vector3.new(0,0,0) end
		end
	end
	if cfg.Korblox then
		local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
		if rLeg then
			rLeg.Transparency = 1
			if char:FindFirstChild("RightUpperLeg") then char.RightUpperLeg.Transparency = 1 end
			if char:FindFirstChild("RightFoot") then char.RightFoot.Transparency = 1 end
			for _, part in pairs(char:GetChildren()) do
				if part:IsA("Accessory") and (part.Name:match("RightLeg") or part.Name:match("Foot") or part.Name:match("Pants")) then part:Destroy() end
			end
		end
	end
end

local function applyVampireAnims(char)
	if not cfg.Vampire then return end
	local animate = char:WaitForChild("Animate", 5)
	if animate then
		animate.idle.Animation1.AnimationId = "rbxassetid://1081423413"
		animate.idle.Animation2.AnimationId = "rbxassetid://1081424168"
		animate.walk.WalkAnim.AnimationId = "rbxassetid://1081428230"
		animate.run.RunAnim.AnimationId = "rbxassetid://1081425145"
		animate.jump.JumpAnim.AnimationId = "rbxassetid://1081427504"
		animate.fall.FallAnim.AnimationId = "rbxassetid://1081426462"
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	applyWaguriVisuals(char)
	applyVampireAnims(char)
end)

-- РЕГИСТРАЦИЯ КНОПОК
createToggle(pageContainers["Main"], "Фейк Корблокс (Waguri)", function(val)
	cfg.Korblox = val
	if val and LocalPlayer.Character then applyWaguriVisuals(LocalPlayer.Character) end
end)
createToggle(pageContainers["Main"], "Фейк Хедлесс (Waguri)", function(val)
	cfg.Headless = val
	if val and LocalPlayer.Character then applyWaguriVisuals(LocalPlayer.Character) end
end)
createToggle(pageContainers["Main"], "Анимации Vampire", function(val)
	cfg.Vampire = val
	if val and LocalPlayer.Character then applyVampireAnims(LocalPlayer.Character) end
end)

-- НАПОЛНЕНИЕ ОСТАЛЬНЫХ ВКЛАДОК (ESP, Combat, Reconnect)
local function manageESP(player, color, enableFlag)
	local char = player.Character
	if not char then return end
	local oldESP = char:FindFirstChild("UtaHighlight")
	if enableFlag then
		if not oldESP then
			local hl = Instance.new("Highlight", char)
			hl.Name = "UtaHighlight"
			hl.FillColor = color
			hl.FillTransparency = 0.5
			hl.OutlineColor = Color3.fromRGB(255, 255, 255)
		end
	else
		if oldESP then oldESP:Destroy() end
	end
end

RunService.Heartbeat:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local bp = p:FindFirstChild("Backpack")
			local char = p.Character
local isMurder = (bp and bp:FindFirstChild("Knife")) 
				or char:FindFirstChild("Knife")local isSheriff = 
				(bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
				if isMurder thenmanageESP(p, Color3.fromRGB(255, 0, 50), cfg.MurderESP)if cfg.AutoBomb and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") thenlocal distance = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitudeif distance < 26 thenlocal gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")if gun then gun.Parent = LocalPlayer.Character local remote = gun:FindFirstChild("KnifeServer") or gun:FindFirstChild("ShootGun") if remote then remote:FireServer(char.HumanoidRootPart.Position) end endendendelseif isSheriff thenmanageESP(p, Color3.fromRGB(0, 120, 255), cfg.SheriffESP)elsemanageESP(p, nil, false)endendendend)createToggle(pageContainers["Visuals"], "Подсветка Мардера (Красный)", function(val) cfg.MurderESP = val end)createToggle(pageContainers["Visuals"], "Подсветка Шерифа (Синий)", function(val) cfg.SheriffESP = val end)local function getMurdererHRP()for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then return p.Character.HumanoidRootPart end end endreturn nilendUserInputService.InputBegan:Connect(function(input, processed)if processed then return endif input.UserInputType == Enum.UserInputType.MouseButton1 and cfg.FlickBot thenlocal target = getMurdererHRP()if target then TweenService:Create(Camera, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position)}):Play() endendend)createToggle(pageContainers["Combat"], "Flick Shot Аимбот на Клик", function(val) cfg.FlickBot = val end)createToggle(pageContainers["Combat"], "Авто-Бомба (Анти-Ближний бой)", function(val) cfg.AutoBomb = val end)createButton(pageContainers["Setings"], "Быстрый ПЕРЕЗАХОД (Server Reconnect)", function()local TeleportService = game:GetService("TeleportService")if #Players:GetPlayers() <= 1 then TeleportService:Teleport(game.PlaceId, LocalPlayer) else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) endend)
