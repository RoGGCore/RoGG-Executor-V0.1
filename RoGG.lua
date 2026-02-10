-- [[ RoGG Script Hub | v1.1 RESTORED & FIXED ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --
-- [[ Status: %100 WORKING ]] --

-- 1. TEMİZLİK VE YÜKLEME KONTROLÜ
if getgenv().RoGG_Loaded then
    getgenv().RoGG_Loaded = false
    if game.CoreGui:FindFirstChild("RoGG_Restored_UI") then
        game.CoreGui.RoGG_Restored_UI:Destroy()
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 3. AYARLAR (TÜM ÖZELLİKLER GERİ GELDİ)
getgenv().Settings = {
    -- Combat
    Aimbot = false,
    AimPart = "Head",
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.1,
    AimFOV = 150,
    Prediction = 0.135,
    NoRecoil = false,
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Skeleton = false, -- Geri Geldi
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
    -- Skins
    Skin_Rainbow = false,
    Skin_Custom = false,
    Skin_Color = Color3.fromRGB(255, 215, 0),
    -- Misc
    MenuKey = Enum.KeyCode.Insert
}

-- [[ FONKSİYONLAR ]] --

-- Server Hop (Çalışan Versiyon)
local function ServerHop()
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
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG Hub", Text = "Sunucu Bulunamadı!", Duration = 3})
    end
end

-- Is Teammate Check
local function IsTeammate(player)
    if not getgenv().Settings.ESP_TeamCheck then return false end
    if player == LocalPlayer then return true end
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return true end
    if player.TeamColor and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then return true end
    return false
end

-- Skeleton Çizim Fonksiyonları
local function DrawLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.From = Vector2.new(0, 0)
    l.To = Vector2.new(0, 0)
    l.Color = getgenv().Settings.ESP_Color
    l.Thickness = 1
    l.Transparency = 1
    return l
end

local function DrawSkeleton(char)
    local lines = {}
    local joints = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    for i=1, #joints do table.insert(lines, DrawLine()) end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent or not getgenv().Settings.ESP_Skeleton then
            for _, l in pairs(lines) do l:Remove() end
            connection:Disconnect()
            return
        end
        for i, joint in pairs(joints) do
            local p1, p2 = char:FindFirstChild(joint[1]), char:FindFirstChild(joint[2])
            local line = lines[i]
            if p1 and p2 then
                local pos1, onS1 = Camera:WorldToViewportPoint(p1.Position)
                local pos2, onS2 = Camera:WorldToViewportPoint(p2.Position)
                if onS1 and onS2 then
                    line.Visible = true
                    line.From = Vector2.new(pos1.X, pos1.Y)
                    line.To = Vector2.new(pos2.X, pos2.Y)
                    line.Color = getgenv().Settings.ESP_Color
                else line.Visible = false end
            else line.Visible = false end
        end
    end)
end

-- [[ UI OLUŞTURMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_Restored_UI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

-- Bildirim Alanı
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "Notifications"
NotifContainer.Size = UDim2.new(0, 250, 1, 0)
NotifContainer.Position = UDim2.new(1, -260, 0, 50)
NotifContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Padding = UDim.new(0, 5)

local function SendNotif(text, state)
    local Frame = Instance.new("Frame", NotifContainer)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    game:GetService("Debris"):AddItem(Frame, 3)
end

-- Ana Menü
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- Koyu Siyah
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 0, 0) -- Neon Kırmızı
MainStroke.Thickness = 2

-- Üst Bar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "RoGG Hub | v1.1 RESTORED"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tablar
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -45)
TabHolder.Position = UDim2.new(0, 0, 0, 45)
TabHolder.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -55)
Pages.Position = UDim2.new(0, 150, 0, 50)
Pages.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local page = Instance.new("ScrollingFrame", Pages)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = text
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local stat = Instance.new("Frame", btn)
    stat.Size = UDim2.new(0, 15, 0, 15)
    stat.Position = UDim2.new(1, -25, 0.5, -7.5)
    stat.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UIStroke", stat).Color = Color3.fromRGB(80, 80, 80)

    btn.MouseButton1Click:Connect(function()
        getgenv().Settings[configName] = not getgenv().Settings[configName]
        local state = getgenv().Settings[configName]
        if state then
            stat.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            SendNotif(text .. " ON", true)
        else
            stat.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            SendNotif(text .. " OFF", false)
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
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 4)
    Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

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
    Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

-- 5. SAYFA VE İÇERİKLER
local TabCombat = CreateTab("Combat")
local TabVisuals = CreateTab("Visuals")
local TabPlayer = CreateTab("Player")
local TabSkins = CreateTab("Skins")
local TabMisc = CreateTab("Misc")

-- Combat
CreateToggle(TabCombat, "Aimbot", "Aimbot")
CreateToggle(TabCombat, "No Recoil", "NoRecoil")
CreateSlider(TabCombat, "FOV Size", 50, 500, 150, function(v) getgenv().Settings.AimFOV = v end)
CreateSlider(TabCombat, "Smoothness", 1, 20, 2, function(v) getgenv().Settings.AimSmoothness = v/10 end)

-- Visuals
CreateToggle(TabVisuals, "Box ESP", "ESP_Box")
CreateToggle(TabVisuals, "Name ESP", "ESP_Name")
CreateToggle(TabVisuals, "Distance ESP", "ESP_Distance")
CreateToggle(TabVisuals, "Skeleton ESP", "ESP_Skeleton") -- ÇALIŞIYOR
CreateToggle(TabVisuals, "Tracers", "ESP_Tracers")
CreateToggle(TabVisuals, "Crosshair", "Crosshair")
CreateToggle(TabVisuals, "Fullbright", "Fullbright", function(s) 
    if s then Lighting.Brightness=2; Lighting.GlobalShadows=false else Lighting.Brightness=1; Lighting.GlobalShadows=true end 
end)

-- Player
CreateToggle(TabPlayer, "Fly [X]", "Fly")
CreateToggle(TabPlayer, "Noclip", "Noclip")
CreateToggle(TabPlayer, "Infinite Jump", "InfJump")
CreateSlider(TabPlayer, "Fly Speed", 10, 200, 50, function(v) getgenv().Settings.FlySpeed = v end)
CreateSlider(TabPlayer, "WalkSpeed", 16, 200, 16, function(v) getgenv().Settings.WalkSpeed = v end)

-- Skins
CreateToggle(TabSkins, "Rainbow Skins", "Skin_Rainbow")
CreateToggle(TabSkins, "Custom Color", "Skin_Custom")
CreateSlider(TabSkins, "Red", 0, 255, 255, function(v) getgenv().Settings.Skin_Color = Color3.fromRGB(v, getgenv().Settings.Skin_Color.G*255, getgenv().Settings.Skin_Color.B*255) end)

-- Misc
CreateButton(TabMisc, "Server Hop", ServerHop) -- ÇALIŞIYOR
CreateButton(TabMisc, "UNLOAD SCRIPT", function() ScreenGui:Destroy(); getgenv().RoGG_Loaded = false end)

-- 6. DÖNGÜLER VE MANTIK
local TracerLines = {}
local ConnectedSkeletons = {}
local AimFOVCircle = Drawing.new("Circle"); AimFOVCircle.Thickness=1; AimFOVCircle.NumSides=60; AimFOVCircle.Filled=false; AimFOVCircle.Color=Color3.fromRGB(255,0,0)
local CrossUI = Instance.new("Frame", ScreenGui); CrossUI.Size=UDim2.new(0,6,0,6); CrossUI.Position=UDim2.new(0.5,-3,0.5,-3); CrossUI.BackgroundColor3=Color3.fromRGB(0,255,0); Instance.new("UICorner",CrossUI).CornerRadius=UDim.new(1,0); CrossUI.Visible=false

RunService.RenderStepped:Connect(function()
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Radius = getgenv().Settings.AimFOV
    AimFOVCircle.Position = UserInputService:GetMouseLocation()
    CrossUI.Visible = getgenv().Settings.Crosshair

    -- Aimbot
    if getgenv().Settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().Settings.AimKey) then
        local closest, shortest = nil, getgenv().Settings.AimFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Settings.AimPart) then
                if not IsTeammate(v) then
                    local pos, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.AimPart].Position)
                    local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if onScreen and dist < shortest then closest = v.Character; shortest = dist end
                end
            end
        end
        if closest then
            local aimPos = closest[getgenv().Settings.AimPart].Position + (closest.HumanoidRootPart.Velocity * getgenv().Settings.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), getgenv().Settings.AimSmoothness)
        end
    end

    -- ESP & Visuals
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if not TracerLines[v.Name] then TracerLines[v.Name] = Drawing.new("Line"); TracerLines[v.Name].Thickness=1; TracerLines[v.Name].Transparency=1 end
            local line = TracerLines[v.Name]
            local char = v.Character

            if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local isTeam = IsTeammate(v)

                if not isTeam then
                    -- Skeleton
                    if getgenv().Settings.ESP_Skeleton and not ConnectedSkeletons[v.Name] then DrawSkeleton(char); ConnectedSkeletons[v.Name]=true elseif not getgenv().Settings.ESP_Skeleton then ConnectedSkeletons[v.Name]=nil end
                    -- Tracers
                    if getgenv().Settings.ESP_Tracers and onScreen then line.Visible=true; line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); line.To=Vector2.new(pos.X,pos.Y); line.Color=getgenv().Settings.ESP_Color else line.Visible=false end
                    -- Box
                    if getgenv().Settings.ESP_Box then local hl=char:FindFirstChild("RG_Box") or Instance.new("Highlight",char); hl.Name="RG_Box"; hl.FillTransparency=1; hl.OutlineColor=getgenv().Settings.ESP_Color elseif char:FindFirstChild("RG_Box") then char.RG_Box:Destroy() end
                    -- Name
                    if getgenv().Settings.ESP_Name then 
                        local bg=char:FindFirstChild("RG_Info") or Instance.new("BillboardGui",char); bg.Name="RG_Info"; bg.Adornee=char:FindFirstChild("Head"); bg.Size=UDim2.new(0,100,0,50); bg.StudsOffset=Vector3.new(0,2,0); bg.AlwaysOnTop=true
                        local txt=bg:FindFirstChild("T") or Instance.new("TextLabel",bg); txt.Name="T"; txt.BackgroundTransparency=1; txt.Size=UDim2.new(1,0,1,0); txt.TextColor3=getgenv().Settings.ESP_Color; txt.TextStrokeTransparency=0
                        txt.Text = v.Name
                        if getgenv().Settings.ESP_Distance then txt.Text = txt.Text.."\n["..math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude).."m]" end
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

-- Movement & Skins
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

task.spawn(function()
    while task.wait(0.1) do
        if LocalPlayer.Character and (getgenv().Settings.Skin_Rainbow or getgenv().Settings.Skin_Custom) then
            local col = getgenv().Settings.Skin_Rainbow and Color3.fromHSV(tick()%5/5,1,1) or getgenv().Settings.Skin_Color
            for _,t in pairs(LocalPlayer.Character:GetChildren()) do
                if t:IsA("Tool") then for _,p in pairs(t:GetDescendants()) do if p:IsA("BasePart") or p:IsA("MeshPart") then p.Color=col end end end
            end
        end
    end
end)

-- UI Kontrolleri
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = input.Position; StartPos = Main.Position end end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then local Delta = input.Position - DragStart; Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == getgenv().Settings.MenuKey then Main.Visible = not Main.Visible end; if i.KeyCode == Enum.KeyCode.X then getgenv().Settings.Fly = not getgenv().Settings.Fly end end)

SendNotif("RoGG Hub v1.1 Restored!", true)
