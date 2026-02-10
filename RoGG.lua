-- [[ RoGG Script Hub | v0.5 FIXED & STABLE ]] --
-- [[ Developer: RoGG | Owner: BilalGG ]] --

-- 1. TEMİZLİK
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
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 3. AYARLAR
getgenv().Settings = {
    -- Combat
    Aimbot = false,
    AimPart = "Head",
    AimKey = Enum.UserInputType.MouseButton2,
    AimSmoothness = 0.1,
    AimFOV = 150,
    Prediction = 0.135, -- Düzeltilmiş Değer
    NoRecoil = false,
    -- Visuals
    ESP_Box = false,
    ESP_Name = false,
    ESP_Skeleton = false, -- Skeleton Fix
    ESP_Tracers = false,
    ESP_TeamCheck = true,
    ESP_Color = Color3.fromRGB(255, 0, 0),
    Crosshair = false,
    -- Misc
    Fly = false,
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    Skin_Rainbow = false,
    MenuKey = Enum.KeyCode.Insert
}

-- 4. SERVER HOP FONKSİYONU
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
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG Hub", Text = "Sunucu bulunamadı!", Duration = 3})
    end
end

-- 5. SKELETON ESP FONKSİYONLARI
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
    -- R15 Bağlantı Noktaları
    local joints = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }

    for i=1, #joints do
        table.insert(lines, DrawLine())
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent or not getgenv().Settings.ESP_Skeleton then
            for _, l in pairs(lines) do l:Remove() end
            connection:Disconnect()
            return
        end

        for i, joint in pairs(joints) do
            local p1 = char:FindFirstChild(joint[1])
            local p2 = char:FindFirstChild(joint[2])
            local line = lines[i]

            if p1 and p2 then
                local pos1, onScreen1 = Camera:WorldToViewportPoint(p1.Position)
                local pos2, onScreen2 = Camera:WorldToViewportPoint(p2.Position)

                if onScreen1 and onScreen2 then
                    line.Visible = true
                    line.From = Vector2.new(pos1.X, pos1.Y)
                    line.To = Vector2.new(pos2.X, pos2.Y)
                    line.Color = getgenv().Settings.ESP_Color
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end)
end

-- UI OLUŞTURMA (ÖZET)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_UI_System"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui else ScreenGui.Parent = CoreGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(255, 0, 0); Stroke.Thickness = 2

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)
local Title = Instance.new("TextLabel", TopBar); Title.Text = "RoGG Hub | v0.5 FIXED"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16

local TabHolder = Instance.new("Frame", Main); TabHolder.Size = UDim2.new(0, 140, 1, -40); TabHolder.Position = UDim2.new(0, 0, 0, 40); TabHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -150, 1, -50); Pages.Position = UDim2.new(0, 150, 0, 45); Pages.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder); btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10); btn.Text = name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
    local page = Instance.new("ScrollingFrame", Pages); page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() for _, t in pairs(tabs) do t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.Btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10); t.Page.Visible = false end; btn.TextColor3 = Color3.fromRGB(255, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); page.Visible = true end)
    table.insert(tabs, {Btn = btn, Page = page})
    if #tabs == 1 then btn.TextColor3 = Color3.fromRGB(255, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); page.Visible = true end
    return page
end

local function CreateToggle(parent, text, configName)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, -10, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.Text = ""
    local lbl = Instance.new("TextLabel", btn); lbl.Text = text; lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(200, 200, 200); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local st = Instance.new("Frame", btn); st.Size = UDim2.new(0, 15, 0, 15); st.Position = UDim2.new(1, -25, 0.5, -7.5); st.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UIStroke", st).Color = Color3.fromRGB(80, 80, 80)
    btn.MouseButton1Click:Connect(function() getgenv().Settings[configName] = not getgenv().Settings[configName]; st.BackgroundColor3 = getgenv().Settings[configName] and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(10, 10, 10) end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, -10, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6); btn.MouseButton1Click:Connect(callback)
end

-- TABLAR
local TabCombat = CreateTab("Combat")
local TabVisuals = CreateTab("Visuals")
local TabPlayer = CreateTab("Player")
local TabMisc = CreateTab("Misc")

-- COMBAT
CreateToggle(TabCombat, "Aimbot", "Aimbot")
CreateToggle(TabCombat, "No Recoil", "NoRecoil")

-- VISUALS
CreateToggle(TabVisuals, "Skeleton ESP", "ESP_Skeleton") -- YENİ FIX
CreateToggle(TabVisuals, "Box ESP", "ESP_Box")
CreateToggle(TabVisuals, "Name ESP", "ESP_Name")
CreateToggle(TabVisuals, "Tracers", "ESP_Tracers")
CreateToggle(TabVisuals, "Crosshair", "Crosshair")

-- PLAYER
CreateToggle(TabPlayer, "Fly", "Fly")
CreateToggle(TabPlayer, "Noclip", "Noclip")
CreateToggle(TabPlayer, "Inf Jump", "InfJump")

-- MISC
CreateToggle(TabMisc, "Rainbow Skin", "Skin_Rainbow")
CreateButton(TabMisc, "Server Hop (Sunucu Değiştir)", ServerHop) -- YENİ
CreateButton(TabMisc, "UNLOAD", function() ScreenGui:Destroy(); getgenv().RoGG_Loaded = false end)

-- MANTIK (LOGIC)
local AimFOVCircle = Drawing.new("Circle"); AimFOVCircle.Thickness=1; AimFOVCircle.NumSides=60; AimFOVCircle.Filled=false; AimFOVCircle.Color=Color3.fromRGB(255,0,0)
local TracerLines = {}
local ConnectedSkeletons = {} -- Skeleton takibi için

RunService.RenderStepped:Connect(function()
    -- FOV
    AimFOVCircle.Visible = getgenv().Settings.Aimbot
    AimFOVCircle.Radius = getgenv().Settings.AimFOV
    AimFOVCircle.Position = UserInputService:GetMouseLocation()

    -- AIMBOT + PREDICTION FIX
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
            local part = closest[getgenv().Settings.AimPart]
            local predictedPos = part.Position + (closest.HumanoidRootPart.Velocity * getgenv().Settings.Prediction) -- PREDICTION FIX
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predictedPos), getgenv().Settings.AimSmoothness)
        end
    end

    -- VISUALS LOOP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local isTeam = (getgenv().Settings.ESP_TeamCheck and v.Team == LocalPlayer.Team)

            if not isTeam and char.Humanoid.Health > 0 then
                -- SKELETON ESP TRIGGER
                if getgenv().Settings.ESP_Skeleton and not ConnectedSkeletons[v.Name] then
                    DrawSkeleton(char)
                    ConnectedSkeletons[v.Name] = true
                elseif not getgenv().Settings.ESP_Skeleton then
                    ConnectedSkeletons[v.Name] = nil
                end
                
                -- TRACERS & BOX (Mevcut kodlar korunarak)
                if not TracerLines[v.Name] then TracerLines[v.Name] = Drawing.new("Line"); TracerLines[v.Name].Thickness=1; TracerLines[v.Name].Transparency=1 end
                local line = TracerLines[v.Name]
                local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)

                if getgenv().Settings.ESP_Tracers and onScreen then
                    line.Visible=true; line.From=Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To=Vector2.new(pos.X, pos.Y); line.Color=getgenv().Settings.ESP_Color
                else line.Visible=false end

                if getgenv().Settings.ESP_Box then
                    local hl = char:FindFirstChild("RoGG_Box") or Instance.new("Highlight", char); hl.Name="RoGG_Box"; hl.FillTransparency=1; hl.OutlineColor=getgenv().Settings.ESP_Color
                elseif char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
            else
                if TracerLines[v.Name] then TracerLines[v.Name].Visible = false end
                if char:FindFirstChild("RoGG_Box") then char.RoGG_Box:Destroy() end
            end
        else
             if TracerLines[v.Name] then TracerLines[v.Name]:Remove(); TracerLines[v.Name]=nil end
        end
    end
end)

-- MOVEMENT
RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end
    end
end)
local FlyBV = nil
RunService.RenderStepped:Connect(function()
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

-- SÜRÜKLEME
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = input.Position; StartPos = Main.Position end end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then local Delta = input.Position - DragStart; Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
UserInputService.InputBegan:Connect(function(input) if input.KeyCode == getgenv().Settings.MenuKey then Main.Visible = not Main.Visible end end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoGG Hub v0.5", Text = "Loaded!", Duration = 3})
