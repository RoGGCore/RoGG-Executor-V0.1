-- [[ RoGG v0.2 - ENHANCED VERSION | DISCORD: bilalgg ]] --
if getgenv().RoGG_Loaded then 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RoGG",
        Text = "Script zaten çalışıyor!",
        Duration = 3
    })
    return 
end
getgenv().RoGG_Loaded = true

-- SERVİSLER
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGG_UI"
if syn and syn.protect_gui then -- Synapse/Script koruması varsa
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- UI STROKE (Kenar Çizgisi)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(200, 0, 0)
Stroke.Thickness = 2

-- SÜRÜKLEME FONKSİYONU (Modern Yöntem)
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- ÜST BAR (Sürükleme Alanı)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
MakeDraggable(TopBar, Main)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "RoGG v0.2 - Prison Life"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- KAPATMA VE KÜÇÜLTME BUTONLARI
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    getgenv().RoGG_Loaded = false
end)

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

-- İÇERİK ALANI
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0) -- Kaydırma alanı

local Layout = Instance.new("UIGridLayout", Container)
Layout.CellSize = UDim2.new(0, 230, 0, 40)
Layout.CellPadding = UDim2.new(0, 10, 0, 10)

-- YARDIMCI FONKSİYONLAR
local function SendNotif(msg)
    StarterGui:SetCore("SendNotification", {
        Title = "RoGG",
        Text = msg,
        Duration = 3
    })
end

local function AddHack(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- Hover Efekti
    btn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    btn
