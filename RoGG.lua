-- [[ RoGG Script Hub v0.1 | STABLE VERSION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --

-- Tekrar çalışmayı önleme
if getgenv().RoGG_Loaded then 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RoGG Hub",
        Text = "Script zaten çalışıyor! Menüyü açmak için 'INSERT' tuşuna bas.",
        Duration = 5
    })
    return 
end
getgenv().RoGG_Loaded = true

-- SERVİSLER
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- AYARLAR (CONFIG)
getgenv().Settings = {
    Aimbot = false,
    AimPart = "Head", 
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2, 
    AimFOV = 150,
    ESP = false,
    ESP_TeamCheck = true, -- Varsayılan olarak açık
    WalkSpeed = 16,
    JumpPower = 50,
    MenuKey = Enum.KeyCode.Insert
}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Hub_v0.1"
ScreenGui.ResetOnSpawn = false 

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = CoreGui 
elseif getgenv then 
    ScreenGui.Parent = CoreGui 
else 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

-- ANA ÇERÇEVE
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- MENÜ AÇ/KAPA (INSERT)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == getgenv().Settings.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

-- SOL MENÜ
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "RoGG Hub v0.1"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)

-- SAYFALAR
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -170, 1, -20)
Pages.Position = UDim2.new(0, 170, 0, 10)
Pages.BackgroundTransparency = 1

-- SÜRÜKLEME
local Dragging, DragInput, DragStart, StartPos
Sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true; DragStart = input.Position; StartPos = Main.Position
    end
end)
Sidebar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)

-- [[ UI FONKSİYONLARI ]] --
local tabs = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.85, 0, 0, 40)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            TweenService:Create(t.Btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            t.Page.Visible = false
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        Page.Visible = true
    end)

    table.insert(tabs, {Btn = TabBtn, Page = Page})
    if #tabs == 1 then 
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Page.Visible = true
    end
    return Page
end

local function CreateToggle(parent, text, configName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 44, 0, 24)
    Switch.Position = UDim2.new(1, -54, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        if callback then callback(state) end
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0.95, -10, 0, 38)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 40)}):Play()
        pcall(callback)
    end)
end

-- [[ SAYFALAR & ÖGELER ]] --

local TabCombat = CreateTab("Combat")
local TabVisuals = CreateTab("Visuals")
local TabScripts = CreateTab("Scripts") -- Server Hub
local TabSettings = CreateTab("Settings")

-- COMBAT
CreateToggle(TabCombat, "Aimbot (Sağ Tık)", "Aimbot", nil)
local AimFOVCircle = Drawing.new("Circle") 
AimFOVCircle.Color = Color3.fromRGB(0, 170, 255)
AimFOVCircle.Thickness = 1
AimFOVCircle.NumSides = 60
AimFOVCircle.Radius = getgenv().Settings.AimFOV
AimFOVCircle.Filled = false
AimFOVCircle.Visible = false

-- VISUALS (ESP)
CreateToggle(TabVisuals, "ESP (Wallhack)", "ESP", nil)
CreateToggle(TabVisuals, "Takım Kontrolü (Team Check)", "ESP_TeamCheck", nil)

-- SCRIPTS (HUB)
CreateButton(TabScripts, "Infinite Yield (Admin)", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
CreateButton(TabScripts, "Fly Gui V3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

-- SETTINGS
CreateButton(TabSettings, "Kapat / Unload", function()
    ScreenGui:Destroy()
    AimFOVCircle:Remove()
    getgenv().RoGG_Loaded = false
end)

-- [[ DÖNGÜLER VE MANTIK ]] --

-- AIMBOT MANTIĞI
local function GetClosestPlayer()
    local closestTarget = nil
    local shortestDistance = getgenv().Settings.AimFOV 

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
            if getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local humanoid = v.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude

                if dist < shortestDistance then
                    shortestDistance = dist
                    closestTarget = v.Character[getgenv().Settings.AimPart]
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Position = UserInputService:GetMouseLocation()
    
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local target = GetClosestPlayer()
        if target then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, getgenv().Settings.AimSmoothness)
        end
    end
end)

-- ESP MANTIĞI (DÜZELTİLDİ!)
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                
                local hl = v.Character:FindFirstChild("RoGG_ESP")
                local isTeammate = (v.Team == LocalPlayer.Team)
                local shouldShow = true

                -- Team Check Kontrolü
                if getgenv().Settings.ESP_TeamCheck and isTeammate then
                    shouldShow = false
                end

                if shouldShow then
                    if not hl then
                        hl = Instance.new("Highlight", v.Character)
                        hl.Name = "RoGG_ESP"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0
                    end
                    -- Renk Ayarı
                    if isTeammate then
                        hl.OutlineColor = Color3.fromRGB(0, 255, 0) -- Dost Yeşil
                    else
                        hl.OutlineColor = Color3.fromRGB(255, 40, 40) -- Düşman Kırmızı
                    end
                else
                    -- Gösterilmemesi gerekiyorsa ama varsa SİL
                    if hl then hl:Destroy() end
                end
            end
        end
    else
        -- ESP kapalıysa hepsini temizle
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("RoGG_ESP") then
                v.Character.RoGG_ESP:Destroy()
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG Hub v0.1", Text = "Menü Tuşu: INSERT", Duration = 5})
