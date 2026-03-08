--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    RoGG HUB V3.0                          ║
    ║              Ultimate Roblox Cheat 2025                   ║
    ║         Made for: Arsenal, Phantom Forces, Da Hood        ║
    ╚═══════════════════════════════════════════════════════════╝
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local Settings = {
    -- Combat
    Aimbot = false,
    AimbotKey = Enum.KeyCode.C,
    AimbotPart = "Head",
    AimbotSmooth = 5,
    SilentAim = false,
    Triggerbot = false,
    NoRecoil = false,
    NoSpread = false,
    InfiniteAmmo = false,
    RapidFire = false,
    
    -- Visuals
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPTracers = false,
    Chams = false,
    
    -- Movement
    SpeedHack = false,
    SpeedValue = 100,
    JumpPower = false,
    JumpValue = 100,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    
    -- Misc
    FOV = 90,
    Crosshair = false,
    ThirdPerson = false,
    FullBright = false,
    AntiAFK = true,
    AutoRespawn = false,
}

-- Colors
local Colors = {
    Primary = Color3.fromRGB(138, 43, 226),      -- Mor
    Secondary = Color3.fromRGB(75, 0, 130),      -- Koyu mor
    Accent = Color3.fromRGB(255, 20, 147),       -- Pembe
    Background = Color3.fromRGB(15, 15, 20),     -- Siyah
    Text = Color3.fromRGB(255, 255, 255),        -- Beyaz
    Success = Color3.fromRGB(0, 255, 127),       -- Yeşil
    Danger = Color3.fromRGB(255, 69, 0),         -- Kırmızı
}

-- GUI Creation
local RoGGHub = Instance.new("ScreenGui")
RoGGHub.Name = "RoGGHub"
RoGGHub.Parent = game.CoreGui
RoGGHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
RoGGHub.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = RoGGHub
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.ClipsDescendants = true
MainFrame.Active = true

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Colors.Primary
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarGradient = Instance.new("UIGradient")
TopBarGradient.Parent = TopBar
TopBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Colors.Primary),
    ColorSequenceKeypoint.new(1, Colors.Secondary)
}
TopBarGradient.Rotation = 90

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "RoGG HUB"
Title.TextColor3 = Colors.Text
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Version
local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Parent = TopBar
Version.BackgroundTransparency = 1
Version.Position = UDim2.new(0, 15, 0, 20)
Version.Size = UDim2.new(0, 200, 0, 15)
Version.Font = Enum.Font.Gotham
Version.Text = "v3.0 | 2025"
Version.TextColor3 = Colors.Text
Version.TextSize = 10
Version.TextTransparency = 0.5
Version.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Colors.Danger
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Colors.Text
CloseButton.TextSize = 20
CloseButton.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Colors.Accent
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -65, 0.5, -12)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Colors.Text
MinimizeButton.TextSize = 16
MinimizeButton.AutoButtonColor = false

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = MainFrame
TabsContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabsContainer.BorderSizePixel = 0
TabsContainer.Position = UDim2.new(0, 0, 0, 40)
TabsContainer.Size = UDim2.new(0, 120, 1, -40)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Colors.Background
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 120, 0, 40)
ContentContainer.Size = UDim2.new(1, -120, 1, -40)

-- Scrolling Frame for Content
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Parent = ContentContainer
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.Size = UDim2.new(1, -20, 1, -20)
ContentScroll.Position = UDim2.new(0, 10, 0, 10)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Colors.Primary

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScroll
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)

-- Tab System
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local Tab = {}
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 45)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = "  " .. icon .. "  " .. name
    TabButton.TextColor3 = Colors.Text
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentScroll
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Parent = TabContent
    TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentLayout.Padding = UDim.new(0, 8)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = Colors.Primary
        TabContent.Visible = true
        CurrentTab = Tab
        
        -- Update canvas size
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    Tab.Layout = TabContentLayout
    
    table.insert(Tabs, Tab)
    return Tab
end

-- Create Toggle Function
local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Colors.Success or Color3.fromRGB(60, 60, 65)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 35, 0, 20)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleButton
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local buttonTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Colors.Success or Color3.fromRGB(60, 60, 65)
        })
        local circleTween = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        })
        
        buttonTween:Play()
        circleTween:Play()
        
        pcall(callback, toggled)
    end)
    
    return ToggleFrame
end

-- Create Slider Function
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 15, 0, 5)
    SliderLabel.Size = UDim2.new(1, -30, 0, 15)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Parent = SliderFrame
    SliderValue.BackgroundTransparency = 1
    SliderValue.Position = UDim2.new(1, -50, 0, 5)
    SliderValue.Size = UDim2.new(0, 35, 0, 15)
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.Text = tostring(default)
    SliderValue.TextColor3 = Colors.Accent
    SliderValue.TextSize = 13
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 15, 1, -20)
    SliderBar.Size = UDim2.new(1, -30, 0, 6)
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Colors.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderDot = Instance.new("Frame")
    SliderDot.Parent = SliderBar
    SliderDot.BackgroundColor3 = Colors.Text
    SliderDot.BorderSizePixel = 0
    SliderDot.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    SliderDot.Size = UDim2.new(0, 12, 0, 12)
    
    local SliderDotCorner = Instance.new("UICorner")
    SliderDotCorner.CornerRadius = UDim.new(1, 0)
    SliderDotCorner.Parent = SliderDot
    
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            SliderFill:TweenSize(UDim2.new(percent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
            SliderDot:TweenPosition(UDim2.new(percent, -6, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
            SliderValue.Text = tostring(value)
            
            pcall(callback, value)
        end
    end)
    
    return SliderFrame
end

-- Create Button Function
local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = Colors.Primary
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Text = text
    ButtonFrame.TextColor3 = Colors.Text
    ButtonFrame.TextSize = 14
    ButtonFrame.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Parent = ButtonFrame
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Primary),
        ColorSequenceKeypoint.new(1, Colors.Secondary)
    }
    ButtonGradient.Rotation = 90
    
    ButtonFrame.MouseButton1Click:Connect(function()
        ButtonFrame.BackgroundColor3 = Colors.Accent
        wait(0.1)
        ButtonFrame.BackgroundColor3 = Colors.Primary
        pcall(callback)
    end)
    
    return ButtonFrame
end

-- Create Tabs
local CombatTab = CreateTab("Combat", "⚔️")
local VisualsTab = CreateTab("Visuals", "👁️")
local MovementTab = CreateTab("Movement", "🏃")
local MiscTab = CreateTab("Misc", "⚙️")

-- Combat Tab
CreateToggle(CombatTab.Content, "Aimbot", Settings.Aimbot, function(val)
    Settings.Aimbot = val
end)

CreateToggle(CombatTab.Content, "Silent Aim", Settings.SilentAim, function(val)
    Settings.SilentAim = val
end)

CreateToggle(CombatTab.Content, "Triggerbot", Settings.Triggerbot, function(val)
    Settings.Triggerbot = val
end)

CreateToggle(CombatTab.Content, "No Recoil", Settings.NoRecoil, function(val)
    Settings.NoRecoil = val
end)

CreateToggle(CombatTab.Content, "Infinite Ammo", Settings.InfiniteAmmo, function(val)
    Settings.InfiniteAmmo = val
end)

CreateSlider(CombatTab.Content, "Aimbot Smoothness", 1, 20, Settings.AimbotSmooth, function(val)
    Settings.AimbotSmooth = val
end)

-- Visuals Tab
CreateToggle(VisualsTab.Content, "ESP", Settings.ESP, function(val)
    Settings.ESP = val
end)

CreateToggle(VisualsTab.Content, "ESP Box", Settings.ESPBox, function(val)
    Settings.ESPBox = val
end)

CreateToggle(VisualsTab.Content, "ESP Name", Settings.ESPName, function(val)
    Settings.ESPName = val
end)

CreateToggle(VisualsTab.Content, "ESP Distance", Settings.ESPDistance, function(val)
    Settings.ESPDistance = val
end)

CreateToggle(VisualsTab.Content, "Crosshair", Settings.Crosshair, function(val)
    Settings.Crosshair = val
end)

CreateToggle(VisualsTab.Content, "Full Bright", Settings.FullBright, function(val)
    Settings.FullBright = val
    if val then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = true
    end
end)

CreateSlider(VisualsTab.Content, "Field of View", 70, 120, Settings.FOV, function(val)
    Settings.FOV = val
    Camera.FieldOfView = val
end)

-- Movement Tab
CreateToggle(MovementTab.Content, "Speed Hack", Settings.SpeedHack, function(val)
    Settings.SpeedHack = val
end)

CreateSlider(MovementTab.Content, "Speed Value", 16, 200, Settings.SpeedValue, function(val)
    Settings.SpeedValue = val
end)

CreateToggle(MovementTab.Content, "Fly", Settings.Fly, function(val)
    Settings.Fly = val
end)

CreateSlider(MovementTab.Content, "Fly Speed", 10, 200, Settings.FlySpeed, function(val)
    Settings.FlySpeed = val
end)

CreateToggle(MovementTab.Content, "Infinite Jump", Settings.InfiniteJump, function(val)
    Settings.InfiniteJump = val
end)

CreateToggle(MovementTab.Content, "Noclip", Settings.Noclip, function(val)
    Settings.Noclip = val
end)

-- Misc Tab
CreateToggle(MiscTab.Content, "Anti AFK", Settings.AntiAFK, function(val)
    Settings.AntiAFK = val
end)

CreateButton(MiscTab.Content, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(MiscTab.Content, "Server Hop", function()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    local body = HttpService:JSONDecode(req)
    for i, v in pairs(body.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    end
end)

CreateButton(MiscTab.Content, "Copy Game Link", function()
    setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
end)

-- Dragging
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    RoGGHub:Destroy()
end)

-- Minimize Button
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 40)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 450)}):Play()
    end
end)

-- Open Animation
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 600, 0, 450)}):Play()

-- Select First Tab
if #Tabs > 0 then
    Tabs[1].Button.BackgroundColor3 = Colors.Primary
    Tabs[1].Content.Visible = true
    CurrentTab = Tabs[1]
end

-- ESP System
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    esp.Box.Thickness = 2
    esp.Box.Color = Color3.fromRGB(255, 0, 0)
    esp.Box.Filled = false
    esp.Box.Transparency = 1
    
    esp.Name.Size = 13
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = Color3.fromRGB(255, 255, 255)
    esp.Name.Font = 2
    
    esp.Distance.Size = 13
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Color = Color3.fromRGB(255, 255, 0)
    esp.Distance.Font = 2
    
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = Color3.fromRGB(255, 0, 0)
    esp.Tracer.Transparency = 1
    
    ESPObjects[player] = esp
    
    spawn(function()
        while player and player.Character and Settings.ESP do
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            if hrp and head then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    if Settings.ESPBox then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end
                    
                    if Settings.ESPName then
                        esp.Name.Position = Vector2.new(pos.X, headPos.Y - 15)
                        esp.Name.Text = player.Name
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end
                    
                    if Settings.ESPDistance then
                        local distance = math.floor((hrp.Position - Camera.CFrame.Position).magnitude)
                        esp.Distance.Position = Vector2.new(pos.X, legPos.Y + 5)
                        esp.Distance.Text = tostring(distance) .. "m"
                        esp.Distance.Visible = true
                    else
                        esp.Distance.Visible = false
                    end
                    
                    if Settings.ESPTracers then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    esp.Tracer.Visible = false
                end
            end
            
            wait()
        end
        
        -- Cleanup
        for _, v in pairs(esp) do
            v:Remove()
        end
        ESPObjects[player] = nil
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function() CreateESP(player) end)
        if player.Character then CreateESP(player) end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function() CreateESP(player) end)
end)

-- Aimbot
local function GetClosestPlayerToCursor()
    local closest, shortestDistance = nil, math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.AimbotPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character[Settings.AimbotPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = part
                end
            end
        end
    end
    
    return closest
end

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Settings.Aimbot and UserInputService:IsKeyDown(Settings.AimbotKey) then
        local target = GetClosestPlayerToCursor()
        if target then
            local targetPos = target.Position
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1/Settings.AimbotSmooth)
        end
    end
    
    -- Speed Hack
    if Settings.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.SpeedValue
    end
    
    -- Jump Power
    if Settings.JumpPower and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = Settings.JumpValue
    end
    
    -- Noclip
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local flyVelocity

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F and Settings.Fly then
        flying = not flying
        
        if flying then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            end
        else
            if flyVelocity then
                flyVelocity:Destroy()
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if flying and flyVelocity and LocalPlayer.Character then
        local velocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + Camera.CFrame.LookVector * Settings.FlySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - Camera.CFrame.LookVector * Settings.FlySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - Camera.CFrame.RightVector * Settings.FlySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + Camera.CFrame.RightVector * Settings.FlySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, Settings.FlySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity - Vector3.new(0, Settings.FlySpeed, 0)
        end
        
        flyVelocity.Velocity = velocity
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti AFK
if Settings.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Notification
local function Notify(text, duration)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Parent = RoGGHub
    NotificationFrame.BackgroundColor3 = Colors.Primary
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Position = UDim2.new(1, -320, 1, 20)
    NotificationFrame.Size = UDim2.new(0, 300, 0, 60)
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = NotificationFrame
    NotifText.BackgroundTransparency = 1
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.Font = Enum.Font.GothamSemibold
    NotifText.Text = text
    NotifText.TextColor3 = Colors.Text
    NotifText.TextSize = 14
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextWrapped = true
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -80)}):Play()
    
    wait(duration or 3)
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, 20)}):Play()
    wait(0.3)
    NotificationFrame:Destroy()
end

-- Welcome Message
Notify("RoGG HUB v3.0 Loaded Successfully!", 5)
Notify("Press F to toggle Fly | Hold C for Aimbot", 5)

print([[
╔═══════════════════════════════════════════════════════════╗
║                    RoGG HUB V3.0                          ║
║              Successfully Loaded!                         ║
║                                                           ║
║  Features:                                                ║
║  • Aimbot (Hold C)                                        ║
║  • ESP (Full Customization)                               ║
║  • Fly (Press F)                                          ║
║  • Speed Hack                                             ║
║  • Noclip                                                 ║
║  • And much more...                                       ║
║                                                           ║
║  Made with ❤️ by RoGG Team                                ║
╚═══════════════════════════════════════════════════════════╝
]])
