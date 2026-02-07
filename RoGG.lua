-- [[ RoGG Script Hub v0.1 | NEON RED EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Theme: Animated Neon Black & Red ]] --

-- Tekrar çalışmayı önleme
if getgenv().RoGG_Loaded then 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RoGG Hub",
        Text = "Script zaten aktif!",
        Duration = 3
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
local Mouse = LocalPlayer:GetMouse()

-- AYARLAR (CONFIG)
getgenv().Settings = {
    -- Combat
    Aimbot = false,
    AimPart = "Head", 
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2, 
    AimFOV = 150,
    -- Visuals
    ESP = false,
    ESP_Health = true, -- Can göstergesi
    ESP_TeamCheck = true,
    ESP_Color = Color3.fromRGB(255, 0, 0), -- Varsayılan Kırmızı
    ESP_R = 255,
    ESP_G = 0,
    ESP_B = 0,
    -- Character
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 50,
    -- System
    MenuKey = Enum.KeyCode.Insert
}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Neon_Red"
ScreenGui.ResetOnSpawn = false 

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = CoreGui 
elseif getgenv then 
    ScreenGui.Parent = CoreGui 
else 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

-- ANA ÇERÇEVE (SİYAH)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 600, 0, 420) -- Biraz uzattık
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- Çok koyu siyah
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- NEON ETKİSİ (HAREKETLİ STROKE)
local NeonStroke = Instance.new("UIStroke", Main)
NeonStroke.Color = Color3.fromRGB(255, 0, 0)
NeonStroke.Thickness = 2
NeonStroke.Transparency = 0

-- NEON ANİMASYONU (PULSE/NEFES ALMA)
task.spawn(function()
    while Main.Parent do
        -- Parlak
        TweenService:Create(NeonStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(255, 0, 0), 
            Thickness = 3,
            Transparency = 0
        }):Play()
        task.wait(1.5)
        -- Sönük
        TweenService:Create(NeonStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(100, 0, 0), 
            Thickness = 1,
            Transparency = 0.5
        }):Play()
        task.wait(1.5)
    end
end)

-- SOL MENÜ
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "RoGG NEON"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 0, 0) -- Kırmızı Başlık
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
-- Başlık Gölgelendirme
local TitleShadow = Instance.new("TextLabel", Title)
TitleShadow.Text = "RoGG NEON"
TitleShadow.Font = Enum.Font.GothamBlack
TitleShadow.TextSize = 22
TitleShadow.TextColor3 = Color3.fromRGB(100, 0, 0)
TitleShadow.Size = UDim2.new(1, 0, 1, 0)
TitleShadow.Position = UDim2.new(0, 2, 0, 2)
TitleShadow.BackgroundTransparency = 1
TitleShadow.ZIndex = -1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)

-- İÇERİK ALANI
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
    TabBtn.Size = UDim2.new(0.85, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local TabStroke = Instance.new("UIStroke", TabBtn)
    TabStroke.Color = Color3.fromRGB(50, 0, 0)
    TabStroke.Thickness = 1

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
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            t.Btn.UIStroke.Color = Color3.fromRGB(50, 0, 0)
            t.Page.Visible = false
        end
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        TabBtn.UIStroke.Color = Color3.fromRGB(255, 0, 0)
        Page.Visible = true
    end)

    table.insert(tabs, {Btn = TabBtn, Page = Page})
    if #tabs == 1 then 
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        TabBtn.UIStroke.Color = Color3.fromRGB(255, 0, 0)
        Page.Visible = true
    end
    return Page
end

local function CreateToggle(parent, text, configName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(60, 0, 0)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    local SwitchStroke = Instance.new("UIStroke", Switch)
    SwitchStroke.Color = Color3.fromRGB(100, 100, 100)

    local Indicator = Instance.new("Frame", Switch)
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
            SwitchStroke.Color = Color3.fromRGB(255, 0, 0)
        else
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            SwitchStroke.Color = Color3.fromRGB(100, 100, 100)
        end
        if callback then callback(state) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(60, 0, 0)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = text .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0.5, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.8, 0, 0, 4)
    Bar.Position = UDim2.new(0.1, 0, 0.75, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Kırmızı Slider
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Trigger = Instance.new("TextButton", Bar)
    Trigger.Size = UDim2.new(1, 0, 1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + ((max - min) * pos))
        Label.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    Trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
end

-- [[ SAYFALAR & ÖGELER ]] --

local TabMain = CreateTab("Ana Sayfa")
local TabCombat = CreateTab("Savaş")
local TabVisuals = CreateTab("Görsel")
local TabSettings = CreateTab("Ayarlar")

-- ANA SAYFA (UÇMA & HIZ)
CreateToggle(TabMain, "Uçma Modu (Fly) [X]", "Fly", function(state)
    if state then
        -- Basit Fly Mantığı
        local bp = Instance.new("BodyVelocity")
        bp.Name = "RoGG_Fly"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Velocity = Vector3.new(0,0,0)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bp.Parent = LocalPlayer.Character.HumanoidRootPart
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("RoGG_Fly") then
            LocalPlayer.Character.HumanoidRootPart.RoGG_Fly:Destroy()
        end
    end
end)

CreateSlider(TabMain, "Uçma Hızı", 10, 200, 50, function(val)
    getgenv().Settings.FlySpeed = val
end)

CreateSlider(TabMain, "Yürüme Hızı", 16, 200, 16, function(val)
    getgenv().Settings.WalkSpeed = val
end)

CreateSlider(TabMain, "Zıplama Gücü", 50, 300, 50, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- SAVAŞ
CreateToggle(TabCombat, "Aimbot", "Aimbot", nil)
CreateSlider(TabCombat, "FOV Alanı", 50, 500, 150, function(val)
    getgenv().Settings.AimFOV = val
end)

-- GÖRSEL (ESP RENK & CAN)
CreateToggle(TabVisuals, "ESP Aktif", "ESP", nil)
CreateToggle(TabVisuals, "Can Göster (Health)", "ESP_Health", nil)

local function UpdateColor()
    getgenv().Settings.ESP_Color = Color3.fromRGB(getgenv().Settings.ESP_R, getgenv().Settings.ESP_G, getgenv().Settings.ESP_B)
end

CreateSlider(TabVisuals, "ESP Kırmızı (R)", 0, 255, 255, function(val)
    getgenv().Settings.ESP_R = val
    UpdateColor()
end)
CreateSlider(TabVisuals, "ESP Yeşil (G)", 0, 255, 0, function(val)
    getgenv().Settings.ESP_G = val
    UpdateColor()
end)
CreateSlider(TabVisuals, "ESP Mavi (B)", 0, 255, 0, function(val)
    getgenv().Settings.ESP_B = val
    UpdateColor()
end)

-- AYARLAR
local CloseBtn = Instance.new("TextButton", TabSettings)
CloseBtn.Size = UDim2.new(1, -5, 0, 40)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
CloseBtn.Text = "Menüyü Gizle (INSERT)"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- [[ DÖNGÜLER ]] --

-- Fly Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local bp = hrp:FindFirstChild("RoGG_Fly")
        if bp then
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            
            bp.Velocity = move * getgenv().Settings.FlySpeed
        end
    end
end)

-- WalkSpeed Loop
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= getgenv().Settings.WalkSpeed then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed
            end
        end
    end
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local closest = nil
        local shortestDist = getgenv().Settings.AimFOV
        local mousePos = UserInputService:GetMouseLocation()

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
                if getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team then continue end
                
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = v.Character[getgenv().Settings.AimPart]
                    end
                end
            end
        end
        
        if closest then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, closest.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, getgenv().Settings.AimSmoothness)
        end
    end
end)

-- ESP Loop (Health + Renk)
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local isTeam = (v.Team == LocalPlayer.Team and getgenv().Settings.ESP_TeamCheck)
                
                if not isTeam then
                    -- 1. Highlight (Kutu)
                    local hl = v.Character:FindFirstChild("RoGG_ESP")
                    if not hl then
                        hl = Instance.new("Highlight", v.Character)
                        hl.Name = "RoGG_ESP"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0
                    end
                    hl.OutlineColor = getgenv().Settings.ESP_Color -- Rengi Slider'dan al

                    -- 2. Health Text (BillboardGui)
                    local bg = v.Character:FindFirstChild("RoGG_Health")
                    if getgenv().Settings.ESP_Health then
                        if not bg and v.Character:FindFirstChild("Head") then
                            bg = Instance.new("BillboardGui", v.Character)
                            bg.Name = "RoGG_Health"
                            bg.Adornee = v.Character.Head
                            bg.Size = UDim2.new(0, 100, 0, 50)
                            bg.StudsOffset = Vector3.new(0, 2, 0)
                            bg.AlwaysOnTop = true
                            
                            local txt = Instance.new("TextLabel", bg)
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Font = Enum.Font.GothamBold
                            txt.TextStrokeTransparency = 0
                            txt.TextSize = 14
                        end
                        
                        if bg then
                            local hum = v.Character:FindFirstChild("Humanoid")
                            if hum then
                                local hp = math.floor(hum.Health)
                                local maxHp = hum.MaxHealth
                                local label = bg:FindFirstChild("TextLabel")
                                if label then
                                    label.Text = "[" .. hp .. "%]"
                                    -- Rengi Cana Göre Değiştir (Yeşil -> Kırmızı)
                                    label.TextColor3 = Color3.fromHSV((hp/maxHp)*0.3, 1, 1) 
                                end
                            end
                        end
                    else
                        if bg then bg:Destroy() end
                    end

                else
                    -- Takım arkadaşı veya ESP kapalıysa sil
                    if v.Character:FindFirstChild("RoGG_ESP") then v.Character.RoGG_ESP:Destroy() end
                    if v.Character:FindFirstChild("RoGG_Health") then v.Character.RoGG_Health:Destroy() end
                end
            end
        end
    else
        -- Her şeyi sil
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                if v.Character:FindFirstChild("RoGG_ESP") then v.Character.RoGG_ESP:Destroy() end
                if v.Character:FindFirstChild("RoGG_Health") then v.Character.RoGG_Health:Destroy() end
            end
        end
    end
end)

-- Menü Aç/Kapa
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == getgenv().Settings.MenuKey then
        Main.Visible = not Main.Visible
    end
    -- Fly Aç/Kapa (X Tuşu)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().Settings.Fly = not getgenv().Settings.Fly
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG NEON", Text = "Yüklendi! Menü: INSERT", Duration = 3})
