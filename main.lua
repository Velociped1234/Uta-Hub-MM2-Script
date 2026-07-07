local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local LeftPanel = Instance.new("Frame")
local ContentPanel = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UICorner_Toggle = Instance.new("UICorner")
local UIListLayout_Tabs = Instance.new("UIListLayout")

ScreenGui.Name = "UtaHub_Gui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА ТРИГГЕРА (Uta Hub)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Uta Hub"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
UICorner_Toggle.CornerRadius = UDim.new(0, 8)
UICorner_Toggle.Parent = ToggleButton

-- ГЛАВНОЕ ОКНО
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.Size = UDim2.new(0, 130, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
local UICorner_Left = Instance.new("UICorner")
UICorner_Left.CornerRadius = UDim.new(0, 10)
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
	container.CanvasSize = UDim2.new(0, 0, 3, 0)
	container.ScrollBarThickness = 4
	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = container
	listLayout.Padding = UDim.new(0, 10)
	pageContainers[tabName] = container
end
pageContainers["Main"].Visible = true

for _, tabName in ipairs(tabs) do
	local TabButton = Instance.new("TextButton")
	TabButton.Name = tabName .. "Tab"
	TabButton.Parent = LeftPanel
	TabButton.Size = UDim2.new(1, 0, 0, 35)
	TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	TabButton.BackgroundTransparency = 1
	TabButton.Font = Enum.Font.Gotham
	TabButton.Text = "  " .. tabName
	TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
	TabButton.TextSize = 13
	TabButton.TextXAlignment = Enum.TextXAlignment.Left
	local UICorner_Tab = Instance.new("UICorner")
	UICorner_Tab.CornerRadius = UDim.new(0, 6)
	UICorner_Tab.Parent = TabButton
	
	TabButton.MouseButton1Click:Connect(function()
		for _, btn in pairs(LeftPanel:GetChildren()) do
			if btn:IsA("TextButton") then btn.BackgroundTransparency = 1 btn.TextColor3 = Color3.fromRGB(180, 180, 180) end
		end
		TabButton.BackgroundTransparency = 0
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		for _, page in pairs(pageContainers) do page.Visible = false end
		pageContainers[tabName].Visible = true
	end)
end

-- ВСПМОГАТЕЛЬНЫЕ ФУНКЦИИ ИНТЕРФЕЙСА
local function createToggle(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	btn.Font = Enum.Font.Gotham
	btn.Text = text .. ": ВЫКЛ"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. (state and ": ВКЛ" or ": ВЫКЛ")
		callback(state)
	end)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local function createSlider(parent, text, min, max, default, callback)
	local label = Instance.new("TextLabel", parent)
	label.Size = UDim2.new(0.9, 0, 0, 20)
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(0.9, 0, 0, 30)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	box.Text = "Введи значение ("..min.." - "..max..")"
	box.TextColor3 = Color3.fromRGB(200, 200, 200)
	box.Font = Enum.Font.Gotham
	box.FocusLost:Connect(function()
		local val = tonumber(box.Text)
		if val then
			val = math.clamp(val, min, max)
			label.Text = text .. ": " .. val
			callback(val)
		end
	end)
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	return label, box
end

local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
	btn.Font = Enum.Font.Gotham
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.MouseButton1Click:Connect(callback)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И НАСТРОЙКИ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки Main
local currentSpeed = 16
local currentJump = 50
local currentFlySpeed = 50
local speedGlitchActive = false
local flyActive = false
local spinActive = false
local currentSpinSpeed = 10
local noclipActive = false

-- Настройки Visuals
local colorInnocent = Color3.fromHex("#32cf21")
local colorSheriff = Color3.fromHex("#2c4dde")
local colorMurderer = Color3.fromHex("#eb0e19")
local colorGun = Color3.fromRGB(255, 215, 0)
local flags = { PlayerESP = false, SheriffESP = false, MurderESP = false, GunESP = false, Tracers = false }

-- Настройки Sheriff & Murder & Buttons
local sheriffFlags = { TriggerBot = false, AutoShoot = false, DistInnocent = false, DistSheriff = false, DistMurder = false, AutoGrab = false, AntiBackstab = false, Wallbang = false }
local murderFlags = { KillAll = false, HideAnim = false, KnifeRangeActive = false }
local currentKnifeRange = 5
local lockCamActive = false

-- Настройки Auto Farm & Settings
local autoFarmActive = false
local farmType = "Teleport" -- Teleport или Slide
local farmSpeed = 15
local autoFlingMurder = false
local autoKillAll = false
local antiFlingActive = false

-- ОПРЕДЕЛЕНИЕ РОЛЕЙ
local function getPlayerRole(player)
	if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
		return "Murder"
	elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
		return "Sheriff"
	else
		return "Innocent"
	end
end

local function getMurderer()
	for _, p in pairs(Players:GetPlayers()) do if getPlayerRole(p) == "Murder" then return p end end
	return nil
end

local function getSheriff()
	for _, p in pairs(Players:GetPlayers()) do if getPlayerRole(p) == "Sheriff" then return p end end
	return nil
end

local function grabDroppedGun()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == "GunDrop" and obj:IsA("BasePart") and hrp then
			local oldCFrame = hrp.CFrame hrp.CFrame = obj.CFrame task.wait(0.2) hrp.CFrame = oldCFrame break
		end
	end
end

local function flingPlayer(targetPlayer)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local targetHrp = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp and targetHrp then
		local oldCFrame = hrp.CFrame
		for i = 1, 20 do
			task.wait()
			hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 1, 0)
			hrp.Velocity = Vector3.new(0, 1000, 0)
		end
		hrp.CFrame = oldCFrame
	end
end

-- ГЛАВНЫЙ СИНХРОНИЗАЦИОННЫЙ ЦИКЛ
task.spawn(function()
	while true do
		task.wait(0.1)
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		
		if hum then
			if not flyActive then hum.WalkSpeed = currentSpeed end
			hum.JumpPower = currentJump
		end
		
		-- Логика Noclip
		if noclipActive and char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
		
		-- Логика Spin
		if spinActive and hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(currentSpinSpeed), 0) end
		
		-- Логика Anti-Fling
		if antiFlingActive and hrp then
			hrp.Velocity = Vector3.new(0, 0, 0)
			hrp.RotVelocity = Vector3.new(0, 0, 0)
		end
		
		if sheriffFlags.AutoGrab then
			for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == "GunDrop" and obj:IsA("BasePart") then grabDroppedGun() end end
		end
		
		if sheriffFlags.AntiBackstab and hrp then
			local mud = getMurderer()
			local mudHrp = mud and mud.Character and mud.Character:FindFirstChild("HumanoidRootPart")
			if mudHrp then
				local _, onScreen = Camera:WorldToViewportPoint(mudHrp.Position)
				if not onScreen then hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(mudHrp.Position.X, hrp.Position.Y, mudHrp.Position.Z)) end
			end
		end
		
		if lockCamActive then
			local mud = getMurderer()
			local mudHrp = mud and mud.Character and mud.Character:FindFirstChild("HumanoidRootPart")
			if mudHrp then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, mudHrp.Position) end
		end
	end
end)

-- ========================================================
-- 1. СЛУЖБЫ И СОБЫТИЯ (UserInputService / RunService)
-- ========================================================

-- Логика Speed Glitch при прыжке
game:GetService("UserInputService").JumpRequest:Connect(function()
    if speedglitchActive then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 5)
        end
    end
end)

-- НАПОЛНЕНИЕ ВКЛАДКИ MAIN
local mp = pageContainers["Main"]
createSlider(mp, "Speed", 16, 150, 16, function(v) currentSpeed = v end)

-- НАПОЛНЕНИЕ ВКЛАДКИ VISUALS
local vp = pageContainers["Visuals"]
createVisualRow(vp, "Player ESP (Innocents)", "Player ESP", colorInnocent)

-- Цикл отрисовки ESP и Линий (Tracers)
local activeLines = {}
game:GetService("RunService").RenderStepped:Connect(function()
    -- Очистка старых линий
    for _, line in pairs(activeLines) do
        line:Destroy()
    end
    table.clear(activeLines)

    -- Перебор игроков для отрисовки трейсеров и подсветки пушки
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local sPos, onScr = Camera:WorldToViewportPoint(hrp.Position)
                if onScr then
                    local startX = Camera.ViewportSize.X / 2
                    local startY = Camera.ViewportSize.Y / 2
                    
                    -- Создание линии трейсера (Твоя оригинальная математика)
                    local line = Instance.new("Frame")
                    line.BorderSizePixel = 0
                    line.AnchorPoint = Vector2.new(0.5, 0.5)
                    line.BackgroundColor3 = colors.Innocent
                    
                    local dist = math.sqrt((sPos.X - startX)^2 + (sPos.Y - startY)^2)
                    line.Size = UDim2.new(0, dist, 0, 2)
                    line.Position = UDim2.new(0, (startX + sPos.X) / 2, 0, (startY + sPos.Y) / 2)
                    line.Rotation = math.deg(math.atan2(sPos.Y - startY, sPos.X - startX))
                    
                    line.Parent = MainGui
                    table.insert(activeLines, line)
                end
            end
        end
    end

    -- Подсветка выпавшего пистолета (GunDrop)
    for _, o in pairs(workspace:GetDescendants()) do
        if o.Name == "GunDrop" and o:IsA("BasePart") then
            if not o:FindFirstChild("UtaHighlight") then
                local h = Instance.new("Highlight", o)
                h.Name = "UtaHighlight"
                h.FillColor = colorGun
            end
        end
    end

    -- Увеличение радиуса ножа в руках Убийцы
    local knife = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")
    if knife and knife:FindFirstChild("Handle") then
        knife.Handle.Size = Vector3.new(currentKnifeRange, currentKnifeRange, currentKnifeRange)
    end
end)

-- НАПОЛНЕНИЕ ВКЛАДКИ SHERIFF
local sp = pageContainers["Sheriff"]
createToggle(sp, "Trigger Bot", function(v) sheriffFlags.TriggerBot = v end)

-- НАПОЛНЕНИЕ ВКЛАДКИ MURDER
local mudPage = pageContainers["Murder"]
local targetInput = Instance.new("TextBox", mudPage)
targetInput.Size = UDim2.new(0.9, 0, 0, 35)

-- НАПОЛНЕНИЕ ВКЛАДКИ BUTTON
local bp = pageContainers["Button"]
createToggle(bp, "1. Lock Cam (Фиксация камеры)", function(v) lockCamActive = v end)

-- НАПОЛНЕНИЕ ВКЛАДКИ FLING
local fp = pageContainers["Fling"]
createButton(fp, "1. Fling Murder", function() flingPlayer(getMurderer()) end)

-- НАПОЛНЕНИЕ ВКЛАДКИ AUTO FARM (НОВАЯ)
local afp = pageContainers["Auto Farm"]
createToggle(afp, "Auto Farm", function(v) autoFarmActive = v end)

-- Выбор типа перемещения фарм-ботом
local typeBtn = Instance.new("TextButton", afp)
typeBtn.Size = UDim2.new(0.9, 0, 0, 35)
typeBtn.BackgroundColor3 = color3
typeBtn.Text = "Выбор типа: Teleport / Slide"

-- Ползунок настройки скорости фарма
createSlider(afp, "Farm Speed", 10, 31, 15, function(v) farmSpeed = v end)

-- Текст предупреждения под ползунком фарма
local warnText = Instance.new("TextLabel", afp)
warnText.Size = UDim2.new(0.9, 0, 0, 20)
warnText.BackgroundTransparency = 1
warnText.TextSize = 12
warnText.TextColor3 = Color3.fromRGB(255, 0, 0)
warnText.Text = "КрасныйТекст"

createToggle(afp, "Auto Fling Murder", function(v) autoFlingMurder = v end)
createToggle(afp, "Auto Kill All", function(v) autoKillAll = v end)

-- Главный цикл логики сбора монет и действий в раунде
-- Главный цикл логики сбора монет и действий в раунде
task.spawn(function()
    while true do
        task.wait(0.5)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if autoFarmActive and hrp then
            -- Твой алгоритм плавного полета (Slide) к монете со скоростью farmSpeed
            -- local dist = (obj.Position - hrp.Position).Magnitude
            
            -- Если монеты в текущем раунде закончились
            if not coinsFound then
                if autoFlingMurder then 
                    flingPlayer(getMurderer()) 
                end
                if autoKillAll then
                    -- Твоя функция уничтожения всех игроков
                end
            end
        end
    end
end)

task.spawn(function()
	
    while true do
        task.wait(0.5)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if autoFarmActive and hrp then
            -- Твой алгоритм плавного полета (Slide) к монете со скоростью farmSpeed
            -- local dist = (obj.Position - hrp.Position).Magnitude
            
            -- Если монеты в текущем раунде закончились
            if not coinsFound then
                if autoFlingMurder then 
                    flingPlayer(getMurderer()) 
                end
                if autoKillAll then
                    -- Твоя функция уничтожения всех игроков
                end
            end
        end
    end
end)

-- НАПОЛНЕНИЕ ВКЛАДКИ SETTINGS (НОВАЯ)
local local_setp = pageContainers["Settings"]
createToggle(local_setp, "Anti Fling", function(v) antiflingActive = v end)

-- ТРИГГЕР ОТКРЫТИЯ ОКНА НА КНОПКУ (Исправленный синтаксис)
toggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local setPage = pageContainers["Setings"]

-- Текст-заголовок для раздела анимаций
local AnimTitle = Instance.new("TextLabel", setPage)
AnimTitle.Size = UDim2.new(0.9, 0, 0, 25)
AnimTitle.BackgroundTransparency = 1
AnimTitle.Font = Enum.Font.GothamBold
AnimTitle.Text = "=== Эмодзи / Анимации ==="
AnimTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
AnimTitle.TextSize = 14

-- Таблица с популярными анимациями Roblox (ID можно менять)
local emotes = {
	{Name = "Приветствие (Wave)", Id = "rbxassetid://507722262"},
	{Name = "Танец 1 (Dance 1)", Id = "rbxassetid://507711087"},
	{Name = "Танец 2 (Dance 2)", Id = "rbxassetid://507711955"},
	{Name = "Поклон (Bow)", Id = "rbxassetid://507713616"},
	{Name = "Смех (Laugh)", Id = "rbxassetid://507711514"},
	{Name = "Указать пальцем (Point)", Id = "rbxassetid://507714856"}
}

local currentTrack = nil

-- Функция для запуска анимации на персонаже
local function playEmote(animationId)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		-- Если уже играет анимация, останавливаем её
		if currentTrack then currentTrack:Stop() end
		
		local anim = Instance.new("Animation")
		anim.AnimationId = animationId
		
		local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
		currentTrack = animator:LoadAnimation(anim)
		currentTrack:Play()
	end
end

-- Создаем кнопки для каждой анимации из таблицы
for _, emote in ipairs(emotes) do
	local btn = Instance.new("TextButton", setPage)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	btn.Font = Enum.Font.Gotham
	btn.Text = "Включить: " .. emote.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	btn.MouseButton1Click:Connect(function()
		playEmote(emote.Id)
	end)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

-- Кнопка остановки всех анимаций
local StopBtn = Instance.new("TextButton", setPage)
StopBtn.Size = UDim2.new(0.9, 0, 0, 35)
StopBtn.BackgroundColor3 = Color3.fromRGB(55, 25, 25) -- Красная кнопка
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Text = "Остановить анимацию"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.MouseButton1Click:Connect(function()
	if currentTrack then currentTrack:Stop() end
end)
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- ПОЛНЫЙ БЛОК ДЛЯ ВКЛАДКИ SETTINGS (НАСТРОЙКИ, ТЕМЫ И ПОГОДА)
-- ==========================================
local setp = pageContainers["Setings"]

-- Заголовок раздела
local SettingsHeader = Instance.new("TextLabel", setp)
SettingsHeader.Size = UDim2.new(0.9, 0, 0, 25)
SettingsHeader.BackgroundTransparency = 1
SettingsHeader.Font = Enum.Font.GothamBold
SettingsHeader.Text = "=== Параметры и Кастомизация ==="
SettingsHeader.TextColor3 = Color3.fromRGB(220, 220, 220)
SettingsHeader.TextSize = 13

-- 1. Кнопки Anti Fling и Anti Touch
createToggle(setp, "Anti Fling", function(v) antiFlingActive = v end)

local antiTouchActive = false
createToggle(setp, "Anti Touch", function(v) antiTouchActive = v end)

-- 2. Переключение тем оформления (Theme)
local themeList = {"Black", "White", "Red", "Purple", "Yellow", "Dark Blue"}
local themeColors = {
	["Black"] = Color3.fromRGB(20, 20, 25),
	["White"] = Color3.fromRGB(240, 240, 245),
	["Red"] = Color3.fromHex("#75061a"),
	["Purple"] = Color3.fromHex("#7424d6"),
	["Yellow"] = Color3.fromHex("#999e0b"),
	["Dark Blue"] = Color3.fromHex("#0b255e") -- Исправлен дубликат желтого на темно-синий
}
local currentThemeIndex = 1

local ThemeBtn = Instance.new("TextButton", setp)
ThemeBtn.Size = UDim2.new(0.9, 0, 0, 35)
ThemeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ThemeBtn.Font = Enum.Font.Gotham
ThemeBtn.Text = "Theme: Black"
ThemeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 6)

ThemeBtn.MouseButton1Click:Connect(function()
	currentThemeIndex = currentThemeIndex + 1
	if currentThemeIndex > #themeList then currentThemeIndex = 1 end
	local activeThemeName = themeList[currentThemeIndex]
	ThemeBtn.Text = "Theme: " .. activeThemeName
	
	-- Меняем цвет фона главного окна меню
	MainFrame.BackgroundColor3 = themeColors[activeThemeName]
	
	-- Корректируем цвет текста кнопок меню для читаемости на белом фоне
	if activeThemeName == "White" then
		ThemeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
		ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	else
		ThemeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end)

-- 3. Настройка прозрачности (Transparency) от 0 до 100
createSlider(setp, "Transparency", 0, 100, 0, function(v)
	if v > 10 then
		-- Превращаем шкалу 0-100 в понятный для Roblox коэффициент прозрачности 0-1
		local transValue = math.clamp(v / 100, 0, 0.9)
		MainFrame.BackgroundTransparency = transValue
		LeftPanel.BackgroundTransparency = transValue
	else
		MainFrame.BackgroundTransparency = 0
		LeftPanel.BackgroundTransparency = 0
	end
end)

-- 4. Выбор погоды / Времени суток (Weather)
local weatherModes = {"День (6:00)", "Ночь (21:00)"}
local weatherTimes = {6, 21}
local currentWeatherIndex = 1

local WeatherBtn = Instance.new("TextButton", setp)
WeatherBtn.Size = UDim2.new(0.9, 0, 0, 35)
WeatherBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
WeatherBtn.Font = Enum.Font.Gotham
WeatherBtn.Text = "Weather: " .. weatherModes[currentWeatherIndex]
WeatherBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", WeatherBtn).CornerRadius = UDim.new(0, 6)

WeatherBtn.MouseButton1Click:Connect(function()
	currentWeatherIndex = currentWeatherIndex + 1
	if currentWeatherIndex > #weatherModes then currentWeatherIndex = 1 end
	WeatherBtn.Text = "Weather: " .. weatherModes[currentWeatherIndex]
	
	-- Принудительно меняем время суток на клиенте через игровой сервис освещения
	game:GetService("Lighting").ClockTime = weatherTimes[currentWeatherIndex]
end)
