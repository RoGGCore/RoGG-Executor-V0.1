-- [[ RoGG V0.1.5 - BYPASS EDITION | DISCORD: bilalgg ]] --

-- GÜVENLİK KONTROLLERİ (Tekrar açılmayı önler)
if getgenv().RoGG_Loaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RoGG V0.1",
        Text = "Panel zaten çalışıyor! (Sağ Shift ile aç)",
        Duration = 3
    })
    return
end
getgenv().RoGG_Loaded = true

-- SERVİSLER
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end -- Synapse/gelişmiş executor koruması
ScreenGui.Parent = CoreGui
ScreenGui.Name = "RoGG_Bypass_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 550, 0, 360)
Main.Position = UDim2.new(0.5, -275, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- NEON EFEKTİ (Daha Yumuşak)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(255, 0, 0)

-- DEĞİŞKENLER (Bypass için)
local Flags = {
    Speed = false,
    SpeedVal = 100,
    Noclip = false,
    InfJump = false
}

-- [[ SOL MENÜ ]] --
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "RoGG V0.1"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.BackgroundTransparency = 1

-- [[ SAĞ İÇERİK ]] --
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(0.65, 0, 0.85, 0)
Container.Position = UDim2.new(0.32, 0, 0.08, 0)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2

local Grid = Instance.new("UIGridLayout", Container)
Grid.CellSize = UDim2.new(0, 160, 0, 45)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)

-- BUTON FONKSİYONU
local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- Tıklama Animasyonu
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)
end

-- [[ BYPASS HİLELERİ ]] --

-- 1. SPEED BYPASS (Oyun hızını düşürürse tekrar yükseltir)
CreateBtn("⚡ Speed (Loop)", function()
    Flags.Speed = not Flags.Speed
    if Flags.Speed then
        -- Anti-Cheat Loop
        RunService.Stepped:Connect(function()
            if Flags.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Flags.SpeedVal
            end
        end)
    end
end)

-- 2. NOCLIP (Duvarlardan Geçme - Fizik Bypass)
CreateBtn("👻 Noclip (Bypass)", function()
    Flags.Noclip = not Flags.Noclip
    RunService.Stepped:Connect(function()
        if Flags.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

-- 3. ESP (Highlight - Chams)
CreateBtn("👁️ Safe ESP", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("RoGG_ESP") then
                local h = Instance.new("Highlight", v.Character)
                h.Name = "RoGG_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

-- 4. SERVER HOP (Güvenli Geçiş)
CreateBtn("🌍 Server Hop", function()
    local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
        end
    end
end)

-- 5. ANTI-AFK (Kick Koruması)
CreateBtn("🛡️ Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    print("Anti-AFK Aktif! Artık atılmazsın.")
end)

-- KAPATMA
CreateBtn("🛑 KILL GUI", function()
    getgenv().RoGG_Loaded = false
    ScreenGui:Destroy()
end)

-- SAĞ SHIFT TOGGLE
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

print("RoGG V0.1.5 (Bypass) Yüklendi!")
