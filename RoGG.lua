-- [[ RoGG Script Hub v0.1 | RED EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Theme: Pavlov Style (Red & Dark) ]] --

-- Tekrar çalışmayı önleme
if getgenv().RoGG_Loaded then 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RoGG Hub",
        Text = "Script zaten aktif! Menü: INSERT",
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
local SelectedPlayer = nil -- Listeden seçilen oyuncu

-- AYARLAR (CONFIG)
getgenv().Settings = {
    Aimbot = false,
    AimPart = "Head", 
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2, 
    AimFOV = 150,
    ESP = false,
    ESP_TeamCheck = true,
    WalkSpeed = 16,
    JumpPower = 50,
    MenuKey = Enum.KeyCode.Insert
}

-- RENK TEMASI (RED & DARK)
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Button = Color3.fromRGB(35, 0, 0), -- Koyu Kırmızı
    ButtonActive = Color3.fromRGB(180, 0, 0), -- Parlak Kırmızı
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(100, 0, 0) -- Kenar Çizgileri
}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Red_UI"
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
Main.Size = UDim2.new(0, 650, 0, 400)
Main.Position = UDim2.new(0.5, -325, 0.5, -200)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- KENAR ÇİZGİSİ (KIRMIZI STROKE)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.ButtonActive
MainStroke.Thickness = 2

-- MENÜ AÇ/KAPA
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == getgenv().Settings.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

-- SOL MENÜ (SIDEBAR)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "PAVLOV HUB - V18" -- Resimdeki gibi
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Theme.ButtonActive
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 10)

-- SAYFALAR ALANI
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -190, 1, -20)
Pages.Position = UDim2.new(0, 190, 0, 10)
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
    TabBtn.BackgroundColor3 = Theme.Background
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    -- Stroke ekle
    local btnStroke = Instance.new("UIStroke", TabBtn)
    btnStroke.Color = Color3.fromRGB(60, 60, 60)
    btnStroke.Thickness = 1

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
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Background, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            t.Btn.UIStroke.Color = Color3.fromRGB(60, 60, 60)
            t.Page.Visible = false
        end
        -- Aktif Tab Rengi (KIRMIZI)
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonActive, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        btnStroke.Color = Theme.ButtonActive
        Page.Visible = true
    end)

    table.insert(tabs, {Btn = TabBtn, Page = Page})
    if #tabs == 1 then 
        TabBtn.BackgroundColor3 = Theme.ButtonActive
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnStroke.Color = Theme.ButtonActive
        Page.Visible = true
    end
    return Page
end

local function CreateRedButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0) -- Koyu Kırmızı Arkaplan
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local s = Instance.new("UIStroke", Btn)
    s.Color = Theme.ButtonActive
    s.Thickness = 1

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonActive}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play()
    end)
    
    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

local function CreateToggle(parent, text, configName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(60, 0, 0)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 20, 0, 20)
    Switch.Position = UDim2.new(1, -30, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 4)

    Switch.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonActive}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end
        if callback then callback(state) end
    end)
end

-- [[ SAYFALAR & ÖGELER ]] --

local TabPlayers = CreateTab("OYUNCULAR") -- Resimdeki Ana Sekme
local TabCombat = CreateTab("SAVAŞ")
local TabVisuals = CreateTab("GÖRSEL")
local TabSettings = CreateTab("AYARLAR")

-- [[ TAB 1: OYUNCULAR (RESİMDEKİ GİBİ) ]] --

local SelectedPlayerLabel = Instance.new("TextLabel", TabPlayers)
SelectedPlayerLabel.Size = UDim2.new(1, 0, 0, 25)
SelectedPlayerLabel.BackgroundTransparency = 1
SelectedPlayerLabel.Text = "Hedef Seç: Yok"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedPlayerLabel.Font = Enum.Font.Gotham

-- Oyuncu Listesi (Scrolling Frame)
local PlayerListFrame = Instance.new("ScrollingFrame", TabPlayers)
PlayerListFrame.Size = UDim2.new(1, -5, 0, 150)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", PlayerListFrame).Color = Color3.fromRGB(60, 60, 60)

local ListLayout = Instance.new("UIListLayout", PlayerListFrame)
ListLayout.SortOrder = Enum.SortOrder.Name

local function RefreshPlayerList()
    -- Eski butonları temizle
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Yeni oyuncuları ekle
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", PlayerListFrame)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.BackgroundTransparency = 0.8
            pBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            pBtn.Text = v.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.Gotham
            pBtn.TextSize = 12
            
            pBtn.MouseButton1Click:Connect(function()
                SelectedPlayer = v
                SelectedPlayerLabel.Text = "Hedef Seç: " .. v.Name
                SelectedPlayerLabel.TextColor3 = Theme.ButtonActive
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

-- Refresh Butonu
CreateRedButton(TabPlayers, "Listeyi Yenile", RefreshPlayerList)

-- Aksiyon Butonları (Resimdeki Gibi)
CreateRedButton(TabPlayers, "Yanına Git (TP)", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    else
        game.StarterGui:SetCore("SendNotification", {Title="Hata", Text="Oyuncu seçilmedi veya karakteri yok!"})
    end
end)

CreateRedButton(TabPlayers, "İzle (Spectate)", function()
    if SelectedPlayer and SelectedPlayer.Character then
        Camera.CameraSubject = SelectedPlayer.Character.Humanoid
    end
end)

CreateRedButton(TabPlayers, "İzlemeyi Bırak", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

-- İlk açılışta listeyi doldur
RefreshPlayerList()

-- [[ TAB 2: SAVAŞ (Combat) ]] --
CreateToggle(TabCombat, "Aimbot (Sağ Tık)", "Aimbot", nil)
CreateToggle(TabCombat, "Kill All (Döngü)", "KillAll", nil) -- Süs olarak duruyor, oyun içi remote gerek

-- [[ TAB 3: GÖRSEL (Visuals) ]] --
CreateToggle(TabVisuals, "ESP (Kutu/Highlight)", "ESP", nil)
CreateToggle(TabVisuals, "Takım Kontrolü", "ESP_TeamCheck", nil)

-- [[ TAB 4: AYARLAR ]] --
CreateRedButton(TabSettings, "Arayüzü Kapat (Destroy)", function()
    ScreenGui:Destroy()
    getgenv().RoGG_Loaded = false
end)

-- [[ DÖNGÜLER (MANTIK) ]] --

-- AIMBOT LOOP
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

-- ESP LOOP
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hl = v.Character:FindFirstChild("RoGG_Red_ESP")
                local isTeam = (v.Team == LocalPlayer.Team and getgenv().Settings.ESP_TeamCheck)
                
                if not isTeam then
                    if not hl then
                        hl = Instance.new("Highlight", v.Character)
                        hl.Name = "RoGG_Red_ESP"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0
                        hl.OutlineColor = Theme.ButtonActive -- Kırmızı Highlight
                    end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("RoGG_Red_ESP") then
                v.Character.RoGG_Red_ESP:Destroy()
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG Red Edition", Text = "Yüklendi!", Duration = 3})
