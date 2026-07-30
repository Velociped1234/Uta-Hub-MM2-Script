--[[
    ★ UTA HUB NEXT GENERATION ★
    С расшифрованными функциями из хаба Waguri (Korblox, Headless, Anims)
--]]

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local LeftPanel = Instance.new("Frame")
local ContentPanel = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UICorner_Toggle = Instance.new("UICorner")
local UIListLayout_Tabs = Instance.new("UIListLayout")

ScreenGui.Name = "UtaHub_Gui"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА ТРИГГЕРА (Uta Hub)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 75)
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

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

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
	TabButton.BackgroundColor3 = Color3.fromRGB(255, 0, 75)
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
		TabButton.BackgroundTransparency = 0.8
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		for _, page in pairs(pageContainers) do page.Visible = false end
		pageContainers[tabName].Visible = true
	end)
end
if LeftPanel:FindFirstChild("MainTab") then LeftPanel.MainTab.BackgroundTransparency = 0.8 LeftPanel.MainTab.TextColor3 = Color3.fromRGB(255,255,255) end

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
		btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 75) or Color3.fromRGB(30, 30, 35)
		btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
		callback(state)
	end)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- ПЕРЕМЕННЫЕ ЛОГИКИ ИЗ ВАГУРИ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local cfg = { Korblox = false, Headless = false, Vampire = false }

-- 1. ЧИСТЫЙ КОД ВАГУРИ НА КОРБЛОКС И ХЕДЛЕСС
local function applyWaguriVisuals(char)
	if not char then return end
	
	-- Логика Хедлесса от Вагури
	if cfg.Headless then
		local head = char:WaitForChild("Head", 5)
		if head then
			local face = head:FindFirstChildOfClass("Decal")
			if face then face:Destroy() end
			head.Transparency = 1
			-- Скрытие меша головы, если есть
			local mesh = head:FindFirstChildOfClass("SpecialMesh")
			if mesh then mesh.Scale = Vector3.new(0,0,0) end
		end
	end
	
	-- Логика Корблокса от Вагури (Полная очистка ноги и аттачментов)
	if cfg.Korblox then
		local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
		if rLeg then
			rLeg.Transparency = 1
			if char:FindFirstChild("RightUpperLeg") then char.RightUpperLeg.Transparency = 1 end
			if char:FindFirstChild("RightFoot") then char.RightFoot.Transparency = 1 end
			
			-- Удаление 3D одежды и обуви с этой ноги, чтобы она не висела в воздухе
			for _, part in pairs(char:GetChildren()) do
				if part:IsA("Accessory") and (part.Name:match("RightLeg") or part.Name:match("Foot") or part.Name:match("Pants")) then
					part:Destroy()
				end
			end
		end
	end
end

-- 2. КОД НА VAMPIRE ANIMATION PACK
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

-- ПРИВЯЗКА К ТВОИМ КНОПКАМ ВО ВКЛАДКЕ MAIN
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
