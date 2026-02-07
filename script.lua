-- [[ RoGG V0.1.1 - DISCORD: bilalgg | GITHUB READY ]] --

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)

-- ANA PANEL TASARIMI (Görselindeki gibi)
Main.Name = "RoGG_Professional_V01"
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 0, 0) -- Neon Kırmızı Çerçeve

-- [[ SOL NAVİGASYON SÜTUNU ]] --
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Koyu Kırmızımsı Siyah
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "RoGG V0.1"
Logo.TextColor3 = Color3.fromRGB(255, 0, 0)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.BackgroundTransparency = 1

local UserLabel = Instance.new("TextLabel", Sidebar)
UserLabel.Position = UDim2.new(0, 0, 1, -40)
UserLabel.Size = UDim2.new(1, 0, 0, 30)
UserLabel.Text = "Discord: bilalgg"
UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
UserLabel.Font = Enum.Font.Gotham
UserLabel.TextSize = 12
UserLabel.BackgroundTransparency = 1

-- [[ SAYFA SİSTEMİ (TAB SYSTEM) ]] --
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(0.65, 0, 0.85, 0)
Pages.Position = UDim2.new(0.32, 0, 0.1, 0)
Pages.BackgroundTransparency = 1

local HacksPage = Instance.new("ScrollingFrame", Pages)
HacksPage.Size = UDim2.new(1, 0, 1, 0)
HacksPage.BackgroundTransparency = 1
HacksPage.ScrollBarThickness = 2
HacksPage.Visible = true

local SettingsPage = Instance.new("Frame", Pages)
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false

local UIGrid = Instance.new("UIGridLayout", HacksPage)
UIGrid.CellSize = UDim2.new(0, 150, 0, 45)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

-- TAB DEĞİŞTİRME BUTONLARI
local function createTab(name, yPos, pageToOpen)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        HacksPage.Visible = false
        SettingsPage.Visible = false
        pageToOpen.Visible = true
    end)
end

createTab("🔥 Hileler", 80, HacksPage)
createTab("⚙️ Ayarlar", 125, SettingsPage)

-- [[ HİLE BUTONLARI ]] --
local function addHack(name, func)
    local h = Instance.new("TextButton", HacksPage)
    h.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    h.Text = name
    h.TextColor3 = Color3.new(1,1,1)
    h.Font = Enum.Font.GothamBold
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)
    h.MouseButton1Click:Connect(func)
end

addHack("⚡ Speed Boost", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 150 end)
addHack("🌍 Server Hop", function() -- Hop Kodun -- end)
addHack("👁️ Red ESP", function() -- ESP Kodun -- end)
addHack("🛑 KILL GUI", function() ScreenGui:Destroy() end)

-- AYARLAR İÇERİĞİ
local Ver = Instance.new("TextLabel", SettingsPage)
Ver.Size = UDim2.new(1, 0, 0, 100)
Ver.Text = "Build: v0.1.1-Stable\nGitHub Sync: Aktif\nUI Engine: RoGG-Neon"
Ver.TextColor3 = Color3.fromRGB(150, 150, 150)
Ver.BackgroundTransparency = 1

-- SAĞ SHIFT TOGGLE
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end