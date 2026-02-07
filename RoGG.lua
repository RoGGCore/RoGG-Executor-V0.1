-- [[ RoGG Script Hub v0.1 | REMASTERED ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Feature: Rectangular Notifications ]] --

-- Tekrar çalışmayı önleme
if getgenv().RoGG_Loaded then 
    return 
end
getgenv().RoGG_Loaded = true

-- SERVİSLER
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- AYARLAR (CONFIG)
getgenv().Settings = {
    Aimbot = false,
    AimPart = "Head", 
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2, 
    AimFOV = 150,
    ESP = false,
    ESP_TeamCheck = true,
    Noclip = false,
    Crosshair = false,
    Fullbright = false,
    WalkSpeed = 16,
    JumpPower = 50,
    MenuKey = Enum.KeyCode.Insert
}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Remastered"
ScreenGui.ResetOnSpawn = false 

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = CoreGui 
elseif getgenv then 
    ScreenGui.Parent = CoreGui 
else 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

-- BİLDİRİM ALANI (SAĞ ALT KÖŞE)
local NotificationContainer = Instance.new("Frame", ScreenGui)
NotificationContainer.Name = "Notifications"
NotificationContainer.Size = UDim2.new(0, 250, 1, 0)
NotificationContainer.Position = UDim2.new(1, -260, 0, 0) -- Sağ taraf
NotificationContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotificationContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 5)

-- [[ ÖZEL BİLDİRİM FONKSİYONU (DİKDÖRTGEN KUTUCUK) ]] --
local function SendNotif(text, status)
    local Frame = Instance.new("Frame", NotificationContainer)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    
    -- Dikdörtgen kenar çizgisi (Status rengine göre)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    if status == true then
        Stroke.Color = Color3.fromRGB(0, 255, 100) -- Yeşil (Açık)
    elseif status == false then
        Stroke.Color = Color3.fromRGB(255, 50, 50) -- Kırmızı (Kapalı)
    else
        Stroke.Color = Color3.fromRGB(0, 170, 255) -- Mavi (Bilgi)
    end

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Animasyon (Giriş)
    Frame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    -- Kaybolma
    task.delay(2.5, function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- ANA MENÜ ÇERÇEVESİ
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
-- Dikdörtgen tasarım için Corner Radius'u kaldırdım veya çok azalttım
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

-- ÜST BAR (Sürükleme için)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 4)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | V0.1"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TAB BUTONLARI ALANI
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 130, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabHolder.BorderSizePixel = 0

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- İÇERİK ALANI
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -140, 1, -50)
Pages.Position = UDim2.new(0, 140, 0, 45)
Pages.BackgroundTransparency = 1

-- SÜRÜKLEME
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true; DragStart = input.Position; StartPos = Main.Position
    end
end)
TopBar.InputChanged:Connect(function(input)
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
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.BorderSizePixel = 0

    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            t.Page.Visible = false
        end
        TabBtn.TextColor3 = Color3.fromRGB(0, 170, 255) -- Aktif Mavi
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Page.Visible = true
    end)

    table.insert(tabs, {Btn = TabBtn, Page = Page})
    if #tabs == 1 then 
        TabBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Page.Visible = true
    end
    return Page
end

local function CreateRectToggle(parent, text, configName, callback)
    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Size = UDim2.new(1, -10, 0, 40)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ToggleBtn.Text = ""
    ToggleBtn.AutoButtonColor = false
    
    -- Dikdörtgen Stroke
    local Stroke = Instance.new("UIStroke", ToggleBtn)
    Stroke.Color = Color3.fromRGB(60, 60, 60)
    Stroke.Thickness = 1.5

    local Label = Instance.new("TextLabel", ToggleBtn)
    Label.Text = text
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local StatusBox = Instance.new("Frame", ToggleBtn)
    StatusBox.Size = UDim2.new(0, 15, 0, 15)
    StatusBox.Position = UDim2.new(1, -25, 0.5, -7.5)
    StatusBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    StatusBox.BorderSizePixel = 0
    local BoxStroke = Instance.new("UIStroke", StatusBox)
    BoxStroke.Color = Color3.fromRGB(80, 80, 80)
    BoxStroke.Thickness = 1

    ToggleBtn.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        
        if state then
            StatusBox.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            BoxStroke.Color = Color3.fromRGB(0, 170, 255)
            Stroke.Color = Color3.fromRGB(0, 170, 255) -- Kenar parlar
            -- DİKDÖRTGEN BİLDİRİM GÖNDER
            SendNotif(text .. ": AÇIK", true)
        else
            StatusBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            BoxStroke.Color = Color3.fromRGB(80, 80, 80)
            Stroke.Color = Color3.fromRGB(60, 60, 60)
            -- DİKDÖRTGEN BİLDİRİM GÖNDER
            SendNotif(text .. ": KAPALI", false)
        end
        if callback then callback(state) end
    end)
end

-- [[ SAYFALAR & ÖGELER ]] --

local TabCombat = CreateTab("Savaş")
local TabVisuals = CreateTab("Görsel")
local TabPlayer = CreateTab("Oyuncu")
local TabSettings = CreateTab("Ayarlar")

-- SAVAŞ
CreateRectToggle(TabCombat, "Aimbot", "Aimbot", nil)
local AimFOVCircle = Drawing.new("Circle") 
AimFOVCircle.Color = Color3.fromRGB(0, 170, 255)
AimFOVCircle.Thickness = 1
AimFOVCircle.NumSides = 60
AimFOVCircle.Radius = getgenv().Settings.AimFOV
AimFOVCircle.Filled = false
AimFOVCircle.Visible = false

-- GÖRSEL (YENİ ÖZELLİKLER)
CreateRectToggle(TabVisuals, "ESP (Kutu/Line)", "ESP", nil)
CreateRectToggle(TabVisuals, "Takım Kontrolü", "ESP_TeamCheck", nil)

CreateRectToggle(TabVisuals, "Crosshair (Nişangah)", "Crosshair", function(state)
    if state then
        -- Basit GUI Crosshair
        local ch = Instance.new("Frame", ScreenGui)
        ch.Name = "RoGG_Crosshair"
        ch.Size = UDim2.new(0, 6, 0, 6)
        ch.Position = UDim2.new(0.5, -3, 0.5, -3)
        ch.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        Instance.new("UICorner", ch).CornerRadius = UDim.new(1,0)
    else
        if ScreenGui:FindFirstChild("RoGG_Crosshair") then
            ScreenGui.RoGG_Crosshair:Destroy()
        end
    end
end)

CreateRectToggle(TabVisuals, "Fullbright (Işık)", "Fullbright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.ClockTime = 14 -- Resetler ama tam eski haline döndürmek zor
    end
end)

-- OYUNCU (YENİ ÖZELLİKLER)
CreateRectToggle(TabPlayer, "Noclip (Duvardan Geç)", "Noclip", nil)

-- AYARLAR
local CloseBtn = Instance.new("TextButton", TabSettings)
CloseBtn.Size = UDim2.new(1, -10, 0, 40)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "Hileyi Kapat (UNLOAD)"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UIStroke", CloseBtn).Color = Color3.fromRGB(255, 0, 0)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    AimFOVCircle:Remove()
    getgenv().RoGG_Loaded = false
end)

-- [[ DÖNGÜLER ]] --

-- Noclip Loop
RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Position = UserInputService:GetMouseLocation()
    
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

-- ESP Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hl = v.Character:FindFirstChild("RoGG_ESP")
                local isTeam = (v.Team == LocalPlayer.Team and getgenv().Settings.ESP_TeamCheck)
                
                if not isTeam then
                    if not hl then
                        hl = Instance.new("Highlight", v.Character)
                        hl.Name = "RoGG_ESP"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0
                        hl.OutlineColor = Color3.fromRGB(0, 170, 255) -- Mavi Highlight
                    end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("RoGG_ESP") then
                v.Character.RoGG_ESP:Destroy()
            end
        end
    end
end)

-- İlk Açılış Bildirimi
SendNotif("RoGG Hub Yüklendi!", true)
