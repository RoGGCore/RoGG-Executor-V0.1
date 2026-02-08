-- [[ RoGG Script Hub v0.2 | VISUALS EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Feature: Advanced ESP & Rectangular Notifs ]] --

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
    -- Combat
    Aimbot = false,
    AimPart = "Head", 
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2, 
    AimFOV = 150,
    -- Visuals
    ESP_Box = false,      -- Kutu
    ESP_Name = false,     -- İsim
    ESP_Distance = false, -- Mesafe
    ESP_Tracers = false,  -- Çizgiler
    ESP_TeamCheck = true,
    ESP_R = 0,   -- Renk Kırmızı
    ESP_G = 170, -- Renk Yeşil
    ESP_B = 255, -- Renk Mavi
    ESP_Color = Color3.fromRGB(0, 170, 255), -- Varsayılan Mavi
    Crosshair = false,
    Fullbright = false,
    -- Character
    Noclip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    -- System
    MenuKey = Enum.KeyCode.Insert
}

-- TRACER ÇİZİM TABLOSU (Performans için)
local Tracers = {}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Visuals_Edit"
ScreenGui.ResetOnSpawn = false 

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = CoreGui 
elseif getgenv then 
    ScreenGui.Parent = CoreGui 
else 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

-- BİLDİRİM ALANI
local NotificationContainer = Instance.new("Frame", ScreenGui)
NotificationContainer.Name = "Notifications"
NotificationContainer.Size = UDim2.new(0, 250, 1, 0)
NotificationContainer.Position = UDim2.new(1, -260, 0, 0) 
NotificationContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotificationContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 5)

-- [[ DİKDÖRTGEN BİLDİRİM SİSTEMİ ]] --
local function SendNotif(text, status)
    local Frame = Instance.new("Frame", NotificationContainer)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    if status == true then
        Stroke.Color = Color3.fromRGB(0, 255, 100) -- Yeşil
    elseif status == false then
        Stroke.Color = Color3.fromRGB(255, 50, 50) -- Kırmızı
    else
        Stroke.Color = Color3.fromRGB(0, 170, 255) -- Mavi
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

    Frame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(2.5, function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- ANA MENÜ
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 550, 0, 400) -- Biraz uzattık
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

-- ÜST BAR
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 4)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | v0.2 Visuals"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TAB ALANI
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
        TabBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
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
            Stroke.Color = Color3.fromRGB(0, 170, 255)
            SendNotif(text .. ": AÇIK", true)
        else
            StatusBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            BoxStroke.Color = Color3.fromRGB(80, 80, 80)
            Stroke.Color = Color3.fromRGB(60, 60, 60)
            SendNotif(text .. ": KAPALI", false)
        end
        if callback then callback(state) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(60, 60, 60)
    Stroke.Thickness = 1.5

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = text .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0.5, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.8, 0, 0, 4)
    Bar.Position = UDim2.new(0.1, 0, 0.75, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
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

-- GÖRSEL (GELİŞMİŞ)
CreateRectToggle(TabVisuals, "Kutu ESP (Box)", "ESP_Box", nil)
CreateRectToggle(TabVisuals, "İsim ESP (Names)", "ESP_Name", nil)
CreateRectToggle(TabVisuals, "Mesafe ESP (Distance)", "ESP_Distance", nil)
CreateRectToggle(TabVisuals, "Çizgiler (Tracers)", "ESP_Tracers", nil)
CreateRectToggle(TabVisuals, "Takım Kontrolü", "ESP_TeamCheck", nil)

-- RENK AYARLAMA (RGB SLIDERS)
local function UpdateColor()
    getgenv().Settings.ESP_Color = Color3.fromRGB(getgenv().Settings.ESP_R, getgenv().Settings.ESP_G, getgenv().Settings.ESP_B)
end

CreateSlider(TabVisuals, "ESP Kırmızı (R)", 0, 255, 0, function(val)
    getgenv().Settings.ESP_R = val; UpdateColor()
end)
CreateSlider(TabVisuals, "ESP Yeşil (G)", 0, 255, 170, function(val)
    getgenv().Settings.ESP_G = val; UpdateColor()
end)
CreateSlider(TabVisuals, "ESP Mavi (B)", 0, 255, 255, function(val)
    getgenv().Settings.ESP_B = val; UpdateColor()
end)

CreateRectToggle(TabVisuals, "Crosshair", "Crosshair", function(state)
    if state then
        local ch = Instance.new("Frame", ScreenGui)
        ch.Name = "RoGG_Crosshair"
        ch.Size = UDim2.new(0, 6, 0, 6)
        ch.Position = UDim2.new(0.5, -3, 0.5, -3)
        ch.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        Instance.new("UICorner", ch).CornerRadius = UDim.new(1,0)
    else
        if ScreenGui:FindFirstChild("RoGG_Crosshair") then ScreenGui.RoGG_Crosshair:Destroy() end
    end
end)

-- OYUNCU
CreateRectToggle(TabPlayer, "Noclip", "Noclip", nil)

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
    -- Tracers temizle
    for _, line in pairs(Tracers) do line:Remove() end
    getgenv().RoGG_Loaded = false
end)

-- [[ DÖNGÜLER ]] --

-- Noclip Loop
RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
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

-- GELİŞMİŞ ESP DÖNGÜSÜ
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            -- Temizlik Kontrolü
            if not Tracers[v.Name] then
                Tracers[v.Name] = Drawing.new("Line")
                Tracers[v.Name].Thickness = 1
                Tracers[v.Name].Transparency = 1
            end
            
            local line = Tracers[v.Name]
            local char = v.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                
                -- Team Check
                local isTeammate = (getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team)

                if not isTeammate then
                    -- 1. KUTU (HIGHLIGHT)
                    if getgenv().Settings.ESP_Box then
                        local hl = char:FindFirstChild("RoGG_Box") or Instance.new("Highlight", char)
                        hl.Name = "RoGG_Box"
                        hl.FillTransparency = 1
                        hl.OutlineColor = getgenv().Settings.ESP_Color
                    else
                        if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
                    end

                    -- 2. İSİM & MESAFE (BILLBOARDGUI)
                    if getgenv().Settings.ESP_Name or getgenv().Settings.ESP_Distance then
                        local bg = char:FindFirstChild("RoGG_Info") or Instance.new("BillboardGui", char)
                        bg.Name = "RoGG_Info"
                        bg.Adornee = char:FindFirstChild("Head")
                        bg.Size = UDim2.new(0, 100, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 2, 0)
                        bg.AlwaysOnTop = true
                        
                        local txt = bg:FindFirstChild("InfoTxt") or Instance.new("TextLabel", bg)
                        txt.Name = "InfoTxt"
                        txt.BackgroundTransparency = 1
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 13
                        txt.TextColor3 = getgenv().Settings.ESP_Color
                        txt.TextStrokeTransparency = 0
                        
                        local infoStr = ""
                        if getgenv().Settings.ESP_Name then infoStr = infoStr .. v.Name .. "\n" end
                        if getgenv().Settings.ESP_Distance then infoStr = infoStr .. "[" .. math.floor(dist) .. "m]" end
                        txt.Text = infoStr
                    else
                        if char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                    end

                    -- 3. TRACERS (ÇİZGİLER)
                    if getgenv().Settings.ESP_Tracers and onScreen then
                        line.Visible = true
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Ekran altı
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Color = getgenv().Settings.ESP_Color
                    else
                        line.Visible = false
                    end
                else
                    -- Takım arkadaşıysa gizle
                    if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
                    if char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                    line.Visible = false
                end
            else
                -- Karakter yoksa gizle
                line.Visible = false
                if char and char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
            end
        else
            -- Oyuncu oyundan çıktıysa tracer'ı sil
            if Tracers[v.Name] then 
                Tracers[v.Name]:Remove()
                Tracers[v.Name] = nil 
            end
        end
    end
end)

-- Oyuncu çıktığında tracer temizle
Players.PlayerRemoving:Connect(function(plr)
    if Tracers[plr.Name] then
        Tracers[plr.Name]:Remove()
        Tracers[plr.Name] = nil
    end
end)

SendNotif("RoGG v0.2 Visuals Yüklendi!", true)
