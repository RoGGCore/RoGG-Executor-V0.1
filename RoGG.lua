-- [[ RoGG Script Hub v0.2 | FIXED EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Features: Working Tracers, ESP, Aimbot ]] --

-- Önceki instance'ları temizle
if getgenv().RoGG_Loaded then
    getgenv().RoGG_Loaded = false
    -- Varsa eski GUI'yi sil
    if game.CoreGui:FindFirstChild("RoGG_Fixed_UI") then
        game.CoreGui.RoGG_Fixed_UI:Destroy()
    end
end
getgenv().RoGG_Loaded = true

-- SERVİSLER
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- AYARLAR
getgenv().Settings = {
    Aimbot = false,
    AimPart = "Head",
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.2,
    AimFOV = 150,
    ESP_Box = false,
    ESP_Name = false,
    ESP_Tracers = false,
    ESP_TeamCheck = true,
    ESP_Color = Color3.fromRGB(0, 170, 255), -- Mavi Tema
    MenuKey = Enum.KeyCode.Insert
}

-- TRACER ÇİZİM TABLOSU (Çizgiler için)
local TracerLines = {}

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Fixed_UI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

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

local function SendNotif(text, status)
    local Frame = Instance.new("Frame", NotificationContainer)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BackgroundTransparency = 0.1
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = status and Color3.fromRGB(0, 255, 100) or (status == false and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 170, 255))

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    task.delay(2.5, function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- ANA MENÜ
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | Fixed"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TABLAR
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 130, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -140, 1, -50)
Pages.Position = UDim2.new(0, 140, 0, 45)
Pages.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    local page = Instance.new("ScrollingFrame", Pages)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            t.Page.Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        page.Visible = true
    end)
    table.insert(tabs, {Btn = btn, Page = page})
    if #tabs == 1 then -- İlkini aç
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        page.Visible = true
    end
    return page
end

local function CreateToggle(parent, text, configName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = ""
    
    local Label = Instance.new("TextLabel", btn)
    Label.Text = text
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Status = Instance.new("Frame", btn)
    Status.Size = UDim2.new(0, 15, 0, 15)
    Status.Position = UDim2.new(1, -25, 0.5, -7.5)
    Status.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UIStroke", Status).Color = Color3.fromRGB(80, 80, 80)

    btn.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            Status.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            SendNotif(text .. ": ON", true)
        else
            Status.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            SendNotif(text .. ": OFF", false)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- TABLAR
local TabCombat = CreateTab("Combat")
local TabVisuals = CreateTab("Visuals")
local TabSettings = CreateTab("Settings")

-- İÇERİK
CreateToggle(TabCombat, "Aimbot", "Aimbot")
CreateToggle(TabVisuals, "Kutu ESP (Box)", "ESP_Box")
CreateToggle(TabVisuals, "İsim ESP (Names)", "ESP_Name")
CreateToggle(TabVisuals, "Çizgiler (Tracers)", "ESP_Tracers")
CreateToggle(TabVisuals, "Takım Kontrolü", "ESP_TeamCheck")

CreateButton(TabSettings, "Hileyi Kapat (Unload)", function()
    ScreenGui:Destroy()
    getgenv().RoGG_Loaded = false
    -- Tracerları temizle
    for _, line in pairs(TracerLines) do line:Remove() end
end)

-- FOV ÇEMBERİ
local AimFOVCircle = Drawing.new("Circle")
AimFOVCircle.Color = Color3.fromRGB(0, 170, 255)
AimFOVCircle.Thickness = 1
AimFOVCircle.NumSides = 60
AimFOVCircle.Radius = getgenv().Settings.AimFOV
AimFOVCircle.Filled = false
AimFOVCircle.Visible = false

-- [[ DÖNGÜLER (MANTIK) ]] --

-- TRACER SİSTEMİ (Çalışan Hali)
RunService.RenderStepped:Connect(function()
    -- FOV
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Position = UserInputService:GetMouseLocation()

    -- Visuals Loop
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            -- Tracer Çizgisi Oluştur/Al
            if not TracerLines[v.Name] then
                local line = Drawing.new("Line")
                line.Thickness = 1
                line.Transparency = 1
                line.Color = getgenv().Settings.ESP_Color
                TracerLines[v.Name] = line
            end
            
            local line = TracerLines[v.Name]
            local char = v.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local isTeammate = (getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team)

                if not isTeammate then
                    -- TRACERS
                    if getgenv().Settings.ESP_Tracers and onScreen then
                        line.Visible = true
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Ekran altı
                        line.To = Vector2.new(pos.X, pos.Y)
                    else
                        line.Visible = false
                    end

                    -- BOX ESP
                    if getgenv().Settings.ESP_Box then
                        local hl = char:FindFirstChild("RoGG_Box") or Instance.new("Highlight", char)
                        hl.Name = "RoGG_Box"
                        hl.FillTransparency = 1
                        hl.OutlineColor = getgenv().Settings.ESP_Color
                    else
                        if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
                    end

                    -- NAME ESP
                    if getgenv().Settings.ESP_Name then
                        local bg = char:FindFirstChild("RoGG_Name") or Instance.new("BillboardGui", char)
                        bg.Name = "RoGG_Name"
                        bg.Adornee = char:FindFirstChild("Head")
                        bg.Size = UDim2.new(0, 100, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 2, 0)
                        bg.AlwaysOnTop = true
                        
                        local txt = bg:FindFirstChild("Txt") or Instance.new("TextLabel", bg)
                        txt.Name = "Txt"
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.Text = v.Name .. " [" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. "m]"
                        txt.TextColor3 = getgenv().Settings.ESP_Color
                        txt.TextStrokeTransparency = 0
                    else
                        if char:FindFirstChild("RoGG_Name") then char.RoGG_Name:Destroy() end
                    end
                else
                    -- Takım arkadaşıysa gizle
                    line.Visible = false
                    if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
                    if char:FindFirstChild("RoGG_Name") then char.RoGG_Name:Destroy() end
                end
            else
                line.Visible = false
            end
        else
             -- Oyuncu çıktıysa sil
            if TracerLines[v.Name] then TracerLines[v.Name]:Remove(); TracerLines[v.Name] = nil end
        end
    end

    -- AIMBOT
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
             local targetPos = CFrame.new(Camera.CFrame.Position, closest.Position)
             Camera.CFrame = Camera.CFrame:Lerp(targetPos, getgenv().Settings.AimSmoothness)
        end
    end
end)

-- Oyuncu çıkınca tracer temizle
Players.PlayerRemoving:Connect(function(plr)
    if TracerLines[plr.Name] then
        TracerLines[plr.Name]:Remove()
        TracerLines[plr.Name] = nil
    end
end)

-- Sürükleme (Drag)
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

-- Toggle Menu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == getgenv().Settings.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

SendNotif("RoGG Hub Fixed Loaded!", true)
