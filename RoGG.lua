-- [[ RoGG Script Hub | ULTIMATE FINAL EDITION ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Version: v0.1 Stable ]] --

-- 1. GÜVENLİK VE TEMİZLİK
if getgenv().RoGG_Loaded then
    getgenv().RoGG_Loaded = false
    if game.CoreGui:FindFirstChild("RoGG_UI_System") then
        game.CoreGui.RoGG_UI_System:Destroy()
    end
end
getgenv().RoGG_Loaded = true

-- 2. SERVİSLER
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 3. AYARLAR (CONFIG)
getgenv().Settings = {
    -- Combat
    Aimbot = false,
    AimPart = "Head",
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.15,
    AimFOV = 150,
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Health = false,
    ESP_Tracers = false,
    ESP_TeamCheck = true,
    ESP_Color = Color3.fromRGB(255, 0, 0), -- Neon Kırmızı
    Crosshair = false,
    Fullbright = false,
    -- Player
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfJump = false,
    WalkSpeed = 16,
    JumpPower = 50,
    -- Misc
    Skin_Rainbow = false,
    MenuKey = Enum.KeyCode.Insert
}

-- 4. UI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_UI_System"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

-- BİLDİRİM SİSTEMİ (DİKDÖRTGEN)
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
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    if status == true then Stroke.Color = Color3.fromRGB(0, 255, 100) -- Açık (Yeşil)
    elseif status == false then Stroke.Color = Color3.fromRGB(255, 0, 0) -- Kapalı (Kırmızı)
    else Stroke.Color = Color3.fromRGB(255, 255, 255) end -- Bilgi (Beyaz)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Animasyon
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

-- ANA MENÜ ÇERÇEVESİ
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5) -- Simsiyah
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- NEON EFEKT (STROKE)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2

-- Nefes Alma Animasyonu
task.spawn(function()
    while Main.Parent do
        TweenService:Create(MainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(255, 0, 0), Thickness = 4}):Play()
        task.wait(2)
        TweenService:Create(MainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(100, 0, 0), Thickness = 2}):Play()
        task.wait(2)
    end
end)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Koyu Kırmızı
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | ULTIMATE"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TAB SİSTEMİ
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -50)
Pages.Position = UDim2.new(0, 150, 0, 45)
Pages.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
            t.Btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            t.Page.Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(255, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        page.Visible = true
    end)
    table.insert(tabs, {Btn = btn, Page = page})
    if #tabs == 1 then btn.TextColor3 = Color3.fromRGB(255, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); page.Visible = true end
    return page
end

local function CreateToggle(parent, text, configName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
    Status.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UIStroke", Status).Color = Color3.fromRGB(80, 80, 80)

    btn.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            Status.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Aktif Kırmızı
            SendNotif(text .. ": ON", true)
        else
            Status.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            SendNotif(text .. ": OFF", false)
        end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Kırmızı Dolgu

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
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- 5. SAYFALAR
local TabCombat = CreateTab("Combat")
local TabVisuals = CreateTab("Visuals")
local TabPlayer = CreateTab("Player")
local TabMisc = CreateTab("Misc")
local TabSettings = CreateTab("Settings")

-- COMBAT
CreateToggle(TabCombat, "Aimbot", "Aimbot")
CreateSlider(TabCombat, "FOV Size", 50, 500, 150, function(v) getgenv().Settings.AimFOV = v end)
CreateSlider(TabCombat, "Smoothness", 1, 20, 2, function(v) getgenv().Settings.AimSmoothness = v/10 end)

-- VISUALS
CreateToggle(TabVisuals, "Box ESP", "ESP_Box")
CreateToggle(TabVisuals, "Name ESP", "ESP_Name")
CreateToggle(TabVisuals, "Distance ESP", "ESP_Distance")
CreateToggle(TabVisuals, "Health ESP", "ESP_Health")
CreateToggle(TabVisuals, "Tracers (Lines)", "ESP_Tracers")
CreateToggle(TabVisuals, "Team Check", "ESP_TeamCheck")
CreateToggle(TabVisuals, "Fullbright", "Fullbright", function(s) 
    if s then Lighting.Brightness=2; Lighting.GlobalShadows=false else Lighting.Brightness=1; Lighting.GlobalShadows=true end 
end)
CreateToggle(TabVisuals, "Crosshair", "Crosshair", function(s)
    if s then 
        local c = Instance.new("Frame", ScreenGui); c.Name="Cross"; c.Size=UDim2.new(0,6,0,6); c.Position=UDim2.new(0.5,-3,0.5,-3); c.BackgroundColor3=Color3.fromRGB(0,255,0); Instance.new("UICorner",c).CornerRadius=UDim.new(1,0)
    else if ScreenGui:FindFirstChild("Cross") then ScreenGui.Cross:Destroy() end end
end)

-- PLAYER
CreateToggle(TabPlayer, "Fly [X]", "Fly")
CreateToggle(TabPlayer, "Noclip", "Noclip")
CreateToggle(TabPlayer, "Infinite Jump", "InfJump")
CreateSlider(TabPlayer, "Fly Speed", 10, 200, 50, function(v) getgenv().Settings.FlySpeed = v end)
CreateSlider(TabPlayer, "WalkSpeed", 16, 200, 16, function(v) getgenv().Settings.WalkSpeed = v end)
CreateSlider(TabPlayer, "JumpPower", 50, 200, 50, function(v) getgenv().Settings.JumpPower = v end)

-- MISC
CreateToggle(TabMisc, "Rainbow Skin", "Skin_Rainbow")
CreateButton(TabMisc, "Save Config", function() writefile("RoGG_Cfg.json", HttpService:JSONEncode(getgenv().Settings)); SendNotif("Config Saved!", true) end)

-- SETTINGS
CreateButton(TabSettings, "UNLOAD SCRIPT", function()
    ScreenGui:Destroy()
    getgenv().RoGG_Loaded = false
end)

-- 6. MANTIK VE DÖNGÜLER

-- Tracer Setup
local TracerLines = {}
local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness=1; FOVCircle.NumSides=60; FOVCircle.Filled=false; FOVCircle.Color=Color3.fromRGB(255,0,0)

-- Render Loop (Visuals & Aimbot)
RunService.RenderStepped:Connect(function()
    -- FOV
    FOVCircle.Visible = getgenv().Settings.Aimbot
    FOVCircle.Radius = getgenv().Settings.AimFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    -- AIMBOT
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local closest, shortest = nil, getgenv().Settings.AimFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
                if getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if onScreen and dist < shortest then closest = v.Character[getgenv().Settings.AimPart]; shortest = dist end
            end
        end
        if closest then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), getgenv().Settings.AimSmoothness) end
    end

    -- ESP SYSTEM
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            -- Tracer Management
            if not TracerLines[v.Name] then TracerLines[v.Name] = Drawing.new("Line"); TracerLines[v.Name].Thickness=1; TracerLines[v.Name].Transparency=1 end
            local line = TracerLines[v.Name]
            local char = v.Character

            if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local isTeam = (getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team)

                if not isTeam then
                    -- TRACER
                    if getgenv().Settings.ESP_Tracers and onScreen then
                        line.Visible=true; line.From=Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To=Vector2.new(pos.X, pos.Y); line.Color=getgenv().Settings.ESP_Color
                    else line.Visible=false end
                    
                    -- BOX
                    if getgenv().Settings.ESP_Box then
                        local hl = char:FindFirstChild("RoGG_Box") or Instance.new("Highlight", char); hl.Name="RoGG_Box"; hl.FillTransparency=1; hl.OutlineColor=getgenv().Settings.ESP_Color
                    elseif char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end

                    -- INFO (Name, Dist, Health)
                    if getgenv().Settings.ESP_Name or getgenv().Settings.ESP_Distance or getgenv().Settings.ESP_Health then
                        local bg = char:FindFirstChild("RoGG_Info") or Instance.new("BillboardGui", char); bg.Name="RoGG_Info"; bg.Adornee=char:FindFirstChild("Head"); bg.Size=UDim2.new(0,100,0,50); bg.StudsOffset=Vector3.new(0,2,0); bg.AlwaysOnTop=true
                        local txt = bg:FindFirstChild("T") or Instance.new("TextLabel", bg); txt.Name="T"; txt.BackgroundTransparency=1; txt.Size=UDim2.new(1,0,1,0); txt.TextColor3=getgenv().Settings.ESP_Color; txt.TextStrokeTransparency=0
                        
                        local info = ""
                        if getgenv().Settings.ESP_Name then info = info..v.Name.."\n" end
                        if getgenv().Settings.ESP_Distance then info = info.."["..math.floor((LocalPlayer.Character.HumanoidRootPart.Position-hrp.Position).Magnitude).."m]\n" end
                        if getgenv().Settings.ESP_Health then info = info.."["..math.floor(char.Humanoid.Health).."%]" end
                        txt.Text = info
                    elseif char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                else
                    line.Visible=false; if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end; if char:FindFirstChild("RoGG_Info") then char.RoGG_Info:Destroy() end
                end
            else line.Visible=false end
        else if TracerLines[v.Name] then TracerLines[v.Name]:Remove(); TracerLines[v.Name]=nil end end
    end
end)

-- Player Remove
Players.PlayerRemoving:Connect(function(p) if TracerLines[p.Name] then TracerLines[p.Name]:Remove(); TracerLines[p.Name]=nil end end)

-- Physics Loop (Fly, Noclip)
local FlyBV = nil
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end
    end
    if getgenv().Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not FlyBV then FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge) end
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        FlyBV.Velocity = move * getgenv().Settings.FlySpeed
    else if FlyBV then FlyBV:Destroy(); FlyBV=nil end end
end)

-- WalkSpeed Loop
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed
            if LocalPlayer.Character.Humanoid.UseJumpPower then LocalPlayer.Character.Humanoid.JumpPower = getgenv().Settings.JumpPower end
        end
    end
end)

-- Skin Changer Loop
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Settings.Skin_Rainbow and LocalPlayer.Character then
            local col = Color3.fromHSV(tick()%5/5, 1, 1)
            for _,t in pairs(LocalPlayer.Character:GetChildren()) do
                if t:IsA("Tool") then for _,p in pairs(t:GetDescendants()) do if p:IsA("BasePart") or p:IsA("MeshPart") then p.Color=col end end end
            end
        end
    end
end)

-- INPUTS
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == getgenv().Settings.MenuKey then Main.Visible = not Main.Visible end
    if i.KeyCode == Enum.KeyCode.X then getgenv().Settings.Fly = not getgenv().Settings.Fly end
end)
UserInputService.JumpRequest:Connect(function() if getgenv().Settings.InfJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- SÜRÜKLEME
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = input.Position; StartPos = Main.Position end end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then local Delta = input.Position - DragStart; Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

SendNotif("RoGG Hub ULTIMATE Loaded!", true)
