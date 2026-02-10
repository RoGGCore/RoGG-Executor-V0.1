-- [[ RoGG Hub v1.0 | THE GENESIS UPDATE ]] --
-- [[ Design: Cyberpunk Red & Black ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --

-- 1. TEMİZLİK VE YÜKLEME KONTROLÜ
if getgenv().RoGG_Loaded then
    getgenv().RoGG_Loaded = false
    if game.CoreGui:FindFirstChild("RoGG_Genesis_UI") then
        game.CoreGui.RoGG_Genesis_UI:Destroy()
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
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 3. AYARLAR (CONFIG)
getgenv().Settings = {
    Aimbot = false, AimPart = "Head", AimKey = Enum.UserInputType.MouseButton2, AimSmoothness = 0.1, AimFOV = 150, Prediction = 0.135, NoRecoil = false,
    ESP_Box = false, ESP_Name = false, ESP_Skeleton = false, ESP_Tracers = false, ESP_TeamCheck = true, ESP_Color = Color3.fromRGB(255, 40, 40),
    Crosshair = false, Fly = false, FlySpeed = 50, WalkSpeed = 16, JumpPower = 50, Skin_Rainbow = false, MenuKey = Enum.KeyCode.Insert
}

-- [[ UI LIBRARY - TASARIM MOTORU ]] --
local UI = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Genesis_UI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

-- RENKLER
local Theme = {
    Main = Color3.fromRGB(10, 10, 15), -- Çok koyu arka plan
    Stroke = Color3.fromRGB(255, 40, 40), -- Neon Kırmızı
    Text = Color3.fromRGB(240, 240, 240),
    DarkText = Color3.fromRGB(150, 150, 150),
    Button = Color3.fromRGB(20, 20, 25),
    Hover = Color3.fromRGB(30, 30, 35)
}

-- BİLDİRİM SİSTEMİ (Resimdeki gibi sağ üst köşe)
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "Notifications"
NotifContainer.Size = UDim2.new(0, 250, 1, 0)
NotifContainer.Position = UDim2.new(1, -270, 0, 20)
NotifContainer.BackgroundTransparency = 1
local NotifList = Instance.new("UIListLayout", NotifContainer)
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.Padding = UDim.new(0, 8)
NotifList.VerticalAlignment = Enum.VerticalAlignment.Top

function UI:Notify(text, type) -- type: "success", "error", "info"
    local Frame = Instance.new("Frame", NotifContainer)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Theme.Main
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 1
    if type == "success" then Stroke.Color = Color3.fromRGB(0, 255, 100)
    elseif type == "error" then Stroke.Color = Color3.fromRGB(255, 50, 50)
    else Stroke.Color = Theme.Stroke end

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Animasyon
    Frame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Stroke.Transparency = 1
    
    TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()

    task.delay(3, function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- ANA PENCERE
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- Taşmaları gizle
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- NEON STROKE (Parlayan Kenar)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Theme.Stroke
-- Nefes alma efekti
task.spawn(function()
    while MainFrame.Parent do
        TweenService:Create(MainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Theme.Stroke, Transparency = 0}):Play()
        task.wait(2)
        TweenService:Create(MainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(150, 20, 20), Transparency = 0.2}):Play()
        task.wait(2)
    end
end)

-- BAŞLIK (Header)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, -40, 0, 50)
Header.Position = UDim2.new(0, 20, 0, 10)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "RoGG Hub | v1.0 - The Genesis Update"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Theme.Stroke
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Version = Instance.new("TextLabel", Header)
Version.Text = "v1.0"
Version.Font = Enum.Font.Gotham
Version.TextSize = 14
Version.TextColor3 = Theme.DarkText
Version.Size = UDim2.new(0.3, 0, 1, 0)
Version.Position = UDim2.new(0.7, 0, 0, 0)
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.BackgroundTransparency = 1

local Line = Instance.new("Frame", Header)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Theme.Stroke
Line.BorderSizePixel = 0

-- MENÜ VE İÇERİK ALANI
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -80)
Sidebar.Position = UDim2.new(0, 20, 0, 70)
Sidebar.BackgroundTransparency = 1
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 10)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -190, 1, -80)
ContentArea.Position = UDim2.new(0, 180, 0, 70)
ContentArea.BackgroundTransparency = 1

-- SÜRÜKLEME (Drag)
local Dragging, DragInput, DragStart, StartPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = input.Position; StartPos = MainFrame.Position end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then local Delta = input.Position - DragStart; MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

-- UI FONKSİYONLARI
local Tabs = {}

function UI:Tab(name)
    local TabButton = Instance.new("TextButton", Sidebar)
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Theme.Button
    TabButton.Text = name
    TabButton.TextColor3 = Theme.Text
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
    
    local Stroke = Instance.new("UIStroke", TabButton)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1
    Stroke.Transparency = 1 -- Pasifken gizli

    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Stroke
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button}):Play()
            TweenService:Create(t.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            t.Page.Visible = false
        end
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Stroke}):Play() -- Aktif olunca kırmızı
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        Page.Visible = true
    end)
    
    table.insert(Tabs, {Btn = TabButton, Page = Page, Stroke = Stroke})
    if #Tabs == 1 then TabButton.MouseButton1Click:Fire() end -- İlkini aç
    return Page
end

function UI:Toggle(parent, text, configName)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, -5, 0, 45)
    Container.BackgroundColor3 = Theme.Button
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Container)
    Label.Text = text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBG = Instance.new("TextButton", Container)
    SwitchBG.Text = ""
    SwitchBG.Size = UDim2.new(0, 40, 0, 20)
    SwitchBG.Position = UDim2.new(1, -55, 0.5, -10)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0) -- Yuvarlak

    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        
        if state then
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Stroke}):Play()
            UI:Notify(text .. " Enabled", "success")
        else
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
            UI:Notify(text .. " Disabled", "info")
        end
    end)
end

function UI:Slider(parent, text, min, max, default, callback)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, -5, 0, 55)
    Container.BackgroundColor3 = Theme.Button
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Container)
    Label.Text = text
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", Container)
    ValueLabel.Text = tostring(default)
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Theme.Stroke
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 13

    local BarBG = Instance.new("Frame", Container)
    BarBG.Size = UDim2.new(1, -30, 0, 6)
    BarBG.Position = UDim2.new(0, 15, 0, 35)
    BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", BarBG)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Stroke
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Trigger = Instance.new("TextButton", BarBG)
    Trigger.Size = UDim2.new(1, 0, 1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""

    local function Update(input)
        local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + ((max - min) * pos))
        ValueLabel.Text = tostring(val)
        if callback then callback(val) end
    end

    local dragging = false
    Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
end

function UI:Button(parent, text, color, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = color or Theme.Button
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Stroke}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = color or Theme.Button}):Play()
        callback()
    end)
end

-- 6. SAYFALARI OLUŞTURMA
local TabCombat = UI:Tab("COMBAT")
local TabVisuals = UI:Tab("VISUALS")
local TabPlayer = UI:Tab("PLAYER")
local TabMisc = UI:Tab("MISC")
local TabSettings = UI:Tab("SETTINGS")

-- COMBAT
UI:Toggle(TabCombat, "Aimbot", "Aimbot")
UI:Toggle(TabCombat, "No Recoil", "NoRecoil")
UI:Slider(TabCombat, "FOV Radius", 50, 500, 150, function(v) getgenv().Settings.AimFOV = v end)
UI:Slider(TabCombat, "Smoothness", 1, 20, 2, function(v) getgenv().Settings.AimSmoothness = v/10 end)

-- VISUALS
UI:Toggle(TabVisuals, "Skeleton ESP", "ESP_Skeleton")
UI:Toggle(TabVisuals, "Box ESP", "ESP_Box")
UI:Toggle(TabVisuals, "Name ESP", "ESP_Name")
UI:Toggle(TabVisuals, "Tracers", "ESP_Tracers")
UI:Toggle(TabVisuals, "Crosshair", "Crosshair")
UI:Slider(TabVisuals, "ESP Red", 0, 255, 255, function(v) getgenv().Settings.ESP_Color = Color3.fromRGB(v, getgenv().Settings.ESP_Color.G*255, getgenv().Settings.ESP_Color.B*255) end)

-- PLAYER
UI:Toggle(TabPlayer, "Fly [X]", "Fly")
UI:Toggle(TabPlayer, "Noclip", "Noclip")
UI:Slider(TabPlayer, "Fly Speed", 10, 200, 50, function(v) getgenv().Settings.FlySpeed = v end)
UI:Slider(TabPlayer, "Walk Speed", 16, 200, 16, function(v) getgenv().Settings.WalkSpeed = v end)

-- MISC
UI:Toggle(TabMisc, "Rainbow Skin", "Skin_Rainbow")
UI:Button(TabMisc, "Server Hop (Sunucu Değiştir)", Theme.Button, function()
    local servers = {}
    local req = request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)})
    local body = HttpService:JSONDecode(req.Body)
    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end
    if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer) else UI:Notify("Sunucu bulunamadı", "error") end
end)

-- SETTINGS (Alt Kısım Butonları Gibi)
UI:Button(TabSettings, "SAVE CONFIG", Theme.Button, function() 
    writefile("RoGG_Config.json", HttpService:JSONEncode(getgenv().Settings))
    UI:Notify("Config Saved!", "success")
end)
UI:Button(TabSettings, "UNLOAD", Color3.fromRGB(50, 0, 0), function() ScreenGui:Destroy(); getgenv().RoGG_Loaded = false end)

-- 7. ÇEKİRDEK MANTIK (LOGIC)
local AimFOVCircle = Drawing.new("Circle"); AimFOVCircle.Thickness=1; AimFOVCircle.NumSides=60; AimFOVCircle.Filled=false; AimFOVCircle.Color=Theme.Stroke
local TracerLines = {}
local ConnectedSkeletons = {}

-- SKELETON DRAW FUNCTION
local function DrawLine() local l=Drawing.new("Line"); l.Visible=false; l.Color=getgenv().Settings.ESP_Color; l.Thickness=1; l.Transparency=1; return l end
local function DrawSkeleton(char)
    local lines = {}; local joints={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
    for i=1,#joints do table.insert(lines, DrawLine()) end
    local connection; connection=RunService.RenderStepped:Connect(function()
        if not char or not char.Parent or not getgenv().Settings.ESP_Skeleton then for _,l in pairs(lines) do l:Remove() end; connection:Disconnect(); return end
        for i,j in pairs(joints) do
            local p1,p2=char:FindFirstChild(j[1]),char:FindFirstChild(j[2])
            local l=lines[i]
            if p1 and p2 then
                local pos1,os1=Camera:WorldToViewportPoint(p1.Position); local pos2,os2=Camera:WorldToViewportPoint(p2.Position)
                if os1 and os2 then l.Visible=true; l.From=Vector2.new(pos1.X,pos1.Y); l.To=Vector2.new(pos2.X,pos2.Y); l.Color=getgenv().Settings.ESP_Color else l.Visible=false end
            else l.Visible=false end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Radius = getgenv().Settings.AimFOV
    AimFOVCircle.Position = UserInputService:GetMouseLocation()

    -- AIMBOT
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local closest, shortest = nil, getgenv().Settings.AimFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
                if getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if onScreen and dist < shortest then closest = v.Character; shortest = dist end
            end
        end
        if closest then
            local aimPos = closest[getgenv().Settings.AimPart].Position + (closest.HumanoidRootPart.Velocity * getgenv().Settings.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), getgenv().Settings.AimSmoothness)
        end
    end

    -- ESP & TRACERS
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
             if not TracerLines[v.Name] then TracerLines[v.Name] = Drawing.new("Line"); TracerLines[v.Name].Thickness=1; TracerLines[v.Name].Transparency=1 end
             local line = TracerLines[v.Name]
             local char = v.Character
             if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                 local hrp = char.HumanoidRootPart
                 local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                 local isTeam = (getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team)

                 if not isTeam then
                    -- SKELETON
                    if getgenv().Settings.ESP_Skeleton and not ConnectedSkeletons[v.Name] then DrawSkeleton(char); ConnectedSkeletons[v.Name]=true elseif not getgenv().Settings.ESP_Skeleton then ConnectedSkeletons[v.Name]=nil end
                    -- TRACER
                    if getgenv().Settings.ESP_Tracers and onScreen then line.Visible=true; line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); line.To=Vector2.new(pos.X,pos.Y); line.Color=getgenv().Settings.ESP_Color else line.Visible=false end
                    -- BOX
                    if getgenv().Settings.ESP_Box then local hl=char:FindFirstChild("RG_Box") or Instance.new("Highlight",char); hl.Name="RG_Box"; hl.FillTransparency=1; hl.OutlineColor=getgenv().Settings.ESP_Color elseif char:FindFirstChild("RG_Box") then char.RG_Box:Destroy() end
                    -- NAME
                    if getgenv().Settings.ESP_Name then 
                        local bg=char:FindFirstChild("RG_Info") or Instance.new("BillboardGui",char); bg.Name="RG_Info"; bg.Adornee=char:FindFirstChild("Head"); bg.Size=UDim2.new(0,100,0,50); bg.StudsOffset=Vector3.new(0,2,0); bg.AlwaysOnTop=true
                        local txt=bg:FindFirstChild("T") or Instance.new("TextLabel",bg); txt.Name="T"; txt.BackgroundTransparency=1; txt.Size=UDim2.new(1,0,1,0); txt.TextColor3=getgenv().Settings.ESP_Color; txt.TextStrokeTransparency=0
                        txt.Text = v.Name
                    elseif char:FindFirstChild("RG_Info") then char.RG_Info:Destroy() end
                 else
                    line.Visible=false; if char:FindFirstChild("RG_Box") then char.RG_Box:Destroy() end; if char:FindFirstChild("RG_Info") then char.RG_Info:Destroy() end
                 end
             else
                line.Visible=false
             end
        else
            if TracerLines[v.Name] then TracerLines[v.Name]:Remove(); TracerLines[v.Name]=nil end
        end
    end
end)

-- MOVEMENT
local FlyBV=nil
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    if getgenv().Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp=LocalPlayer.Character.HumanoidRootPart
        if not FlyBV then FlyBV=Instance.new("BodyVelocity",hrp); FlyBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge) end
        local move=Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move=move+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move=move-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move=move-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move=move+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move=move-Vector3.new(0,1,0) end
        FlyBV.Velocity=move*getgenv().Settings.FlySpeed
    else if FlyBV then FlyBV:Destroy(); FlyBV=nil end end
end)

-- CROSSHAIR UI
local CrossFrame = Instance.new("Frame", ScreenGui)
CrossFrame.Visible = false
CrossFrame.Name = "CrossUI"
CrossFrame.Size = UDim2.new(0, 6, 0, 6)
CrossFrame.Position = UDim2.new(0.5, -3, 0.5, -3)
CrossFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Instance.new("UICorner", CrossFrame).CornerRadius = UDim.new(1, 0)
RunService.RenderStepped:Connect(function() CrossFrame.Visible = getgenv().Settings.Crosshair end)

-- MENU TOGGLE
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == getgenv().Settings.MenuKey then MainFrame.Visible = not MainFrame.Visible end end)

UI:Notify("RoGG Hub Loaded Successfully!", "success")
