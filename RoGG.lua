-- [[ RoGG Script Hub v0.4 | SKIN & FIX EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Features: Skin Changer, Fixed Team Check ]] --

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
    AimSmoothness = 0.1, 
    AimFOV = 150,
    NoRecoil = false,
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Tracers = false,
    ESP_TeamCheck = true,
    ESP_Color = Color3.fromRGB(0, 170, 255),
    Crosshair = false,
    Fullbright = false,
    -- Skins (YENİ)
    Skin_Rainbow = false,
    Skin_Custom = false,
    Skin_Color = Color3.fromRGB(255, 215, 0), -- Altın Sarısı
    -- Movement
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfJump = false,
    WalkSpeed = 16,
    JumpPower = 50,
    -- System
    MenuKey = Enum.KeyCode.Insert
}

-- YARDIMCI FONKSİYON: GELİŞMİŞ TEAM CHECK
local function IsTeammate(player)
    if not getgenv().Settings.ESP_TeamCheck then return false end
    if player == LocalPlayer then return true end
    
    -- Yöntem 1: Takım Objeleri
    if player.Team and LocalPlayer.Team then
        if player.Team == LocalPlayer.Team then return true end
    end
    
    -- Yöntem 2: Takım Renkleri (Bazı oyunlar bunu kullanır)
    if player.TeamColor and LocalPlayer.TeamColor then
        if player.TeamColor == LocalPlayer.TeamColor then return true end
    end
    
    return false
end

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Ultimate_v04"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

-- BİLDİRİM SİSTEMİ
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
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | v0.4 Skins & Fixes"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TABLAR
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -50)
Pages.Position = UDim2.new(0, 150, 0, 45)
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
    if #tabs == 1 then btn.TextColor3 = Color3.fromRGB(0, 170, 255); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); page.Visible = true end
    return page
end

local function CreateRectToggle(parent, text, configName, callback)
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
        if callback then callback(state) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

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

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

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

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
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
local TabSkins = CreateTab("Skins") -- YENİ TAB
local TabMovement = CreateTab("Movement")
local TabSettings = CreateTab("Settings")

-- COMBAT
CreateRectToggle(TabCombat, "Aimbot", "Aimbot")
CreateRectToggle(TabCombat, "No Recoil", "NoRecoil")
CreateSlider(TabCombat, "FOV Size", 50, 500, 150, function(val) getgenv().Settings.AimFOV = val end)
CreateSlider(TabCombat, "Smoothness", 1, 20, 2, function(val) getgenv().Settings.AimSmoothness = val / 10 end)

-- VISUALS
CreateRectToggle(TabVisuals, "Box ESP", "ESP_Box")
CreateRectToggle(TabVisuals, "Name ESP", "ESP_Name")
CreateRectToggle(TabVisuals, "Tracers", "ESP_Tracers")
CreateRectToggle(TabVisuals, "Team Check", "ESP_TeamCheck")
CreateRectToggle(TabVisuals, "Crosshair", "Crosshair", function(state)
    if state then
        local ch = Instance.new("Frame", ScreenGui); ch.Name = "Crosshair"; ch.Size = UDim2.new(0, 6, 0, 6); ch.Position = UDim2.new(0.5, -3, 0.5, -3); ch.BackgroundColor3 = Color3.fromRGB(0, 255, 0); Instance.new("UICorner", ch).CornerRadius = UDim.new(1,0)
    else if ScreenGui:FindFirstChild("Crosshair") then ScreenGui.Crosshair:Destroy() end end
end)

-- SKINS (YENİ ÖZELLİK)
CreateRectToggle(TabSkins, "Rainbow Gun (RGB)", "Skin_Rainbow")
CreateRectToggle(TabSkins, "Custom Color Gun", "Skin_Custom")
-- Renk Seçici (Basit Sliderlar ile)
CreateSlider(TabSkins, "Red (R)", 0, 255, 255, function(val) getgenv().Settings.Skin_Color = Color3.fromRGB(val, getgenv().Settings.Skin_Color.G*255, getgenv().Settings.Skin_Color.B*255) end)
CreateSlider(TabSkins, "Green (G)", 0, 255, 215, function(val) getgenv().Settings.Skin_Color = Color3.fromRGB(getgenv().Settings.Skin_Color.R*255, val, getgenv().Settings.Skin_Color.B*255) end)
CreateSlider(TabSkins, "Blue (B)", 0, 255, 0, function(val) getgenv().Settings.Skin_Color = Color3.fromRGB(getgenv().Settings.Skin_Color.R*255, getgenv().Settings.Skin_Color.G*255, val) end)

-- MOVEMENT
CreateRectToggle(TabMovement, "Fly", "Fly")
CreateRectToggle(TabMovement, "Noclip", "Noclip")
CreateRectToggle(TabMovement, "Infinite Jump", "InfJump")
CreateSlider(TabMovement, "Fly Speed", 10, 200, 50, function(val) getgenv().Settings.FlySpeed = val end)
CreateSlider(TabMovement, "WalkSpeed", 16, 200, 16, function(val) getgenv().Settings.WalkSpeed = val end)

-- SETTINGS
CreateButton(TabSettings, "UNLOAD", function() ScreenGui:Destroy(); getgenv().RoGG_Loaded = false end)

-- [[ DÖNGÜLER ]] --

local TracerLines = {}
local AimFOVCircle = Drawing.new("Circle"); AimFOVCircle.Color = Color3.fromRGB(0, 170, 255); AimFOVCircle.Thickness = 1; AimFOVCircle.NumSides = 60; AimFOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    -- FOV
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Radius = getgenv().Settings.AimFOV
    AimFOVCircle.Position = UserInputService:GetMouseLocation()

    -- AIMBOT
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local closest, shortest = nil, getgenv().Settings.AimFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
                if IsTeammate(v) then continue end -- DÜZELTİLMİŞ TEAM CHECK
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if onScreen and dist < shortest then closest = v.Character[getgenv().Settings.AimPart]; shortest = dist end
            end
        end
        if closest then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), getgenv().Settings.AimSmoothness) end
    end

    -- VISUALS LOOP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if not TracerLines[v.Name] then TracerLines[v.Name] = Drawing.new("Line"); TracerLines[v.Name].Thickness = 1; TracerLines[v.Name].Transparency = 1 end
            local line = TracerLines[v.Name]
            local char = v.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local isTeammate = IsTeammate(v) -- DÜZELTİLMİŞ TEAM CHECK

                if not isTeammate then
                    -- TRACERS
                    if getgenv().Settings.ESP_Tracers and onScreen then
                        line.Visible = true; line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = getgenv().Settings.ESP_Color
                    else line.Visible = false end
                    -- BOX
                    if getgenv().Settings.ESP_Box then
                        local hl = char:FindFirstChild("RoGG_Box") or Instance.new("Highlight", char); hl.Name = "RoGG_Box"; hl.FillTransparency = 1; hl.OutlineColor = getgenv().Settings.ESP_Color
                    elseif char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
                    -- NAME
                    if getgenv().Settings.ESP_Name then
                        local bg = char:FindFirstChild("RoGG_Info") or Instance.new("BillboardGui", char); bg.Name = "RoGG_Info"; bg.Adornee = char:FindFirstChild("Head"); bg.Size = UDim2.new(0,100,0,50); bg.StudsOffset = Vector3.new(0,2,0); bg.AlwaysOnTop = true
                        local txt = bg:FindFirstChild("Txt") or Instance.new("TextLabel", bg); txt.Name = "Txt"; txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = getgenv().Settings.ESP_Color; txt.TextStrokeTransparency = 0
                        txt.Text = v.Name .. "\n[" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. "m]"
                    elseif char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                else
                    line.Visible = false; if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end; if char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                end
            else line.Visible = false end
        else if TracerLines[v.Name] then TracerLines[v.Name]:Remove(); TracerLines[v.Name] = nil end end
    end
end)

-- SKIN CHANGER LOOP
task.spawn(function()
    while task.wait(0.1) do
        if LocalPlayer.Character then
            -- Rainbow Color Calculation
            local rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            
            for _, child in pairs(LocalPlayer.Character:GetChildren()) do
                if child:IsA("Tool") then
                    for _, part in pairs(child:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            if getgenv().Settings.Skin_Rainbow then
                                part.Color = rainbow
                            elseif getgenv().Settings.Skin_Custom then
                                part.Color = getgenv().Settings.Skin_Color
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- MOVEMENT
RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
    end
end)
local FlyBV = nil
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not FlyBV then FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge) end
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        FlyBV.Velocity = move * getgenv().Settings.FlySpeed
    else if FlyBV then FlyBV:Destroy(); FlyBV = nil end end
end)
UserInputService.JumpRequest:Connect(function() if getgenv().Settings.InfJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- UI DRAG & TOGGLE
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = input.Position; StartPos = Main.Position end end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then local Delta = input.Position - DragStart; Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
UserInputService.InputBegan:Connect(function(input) if input.KeyCode == getgenv().Settings.MenuKey then Main.Visible = not Main.Visible end end)

SendNotif("RoGG Hub v0.4 Skins & Fixes Loaded!", true)
