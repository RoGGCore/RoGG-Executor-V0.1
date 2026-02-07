-- [[ RoGG v0.1 - THE ULTIMATE HUB | DISCORD: bilalgg ]] --
-- Sürüm: v0.1 (Stable)
-- Eklenenler: Invisibility, MM2, Blox Fruits, Prison Life

if getgenv().RoGG_Loaded then return end
getgenv().RoGG_Loaded = true

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI ANA YAPI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0)

-- [[ SOL PANEL (TABS) ]] --
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "RoGG v0.1"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local UserTag = Instance.new("TextLabel", Sidebar)
UserTag.Size = UDim2.new(1, 0, 0, 30)
UserTag.Position = UDim2.new(0, 0, 1, -30)
UserTag.Text = "bilalgg"
UserTag.TextColor3 = Color3.fromRGB(100, 100, 100)
UserTag.BackgroundTransparency = 1

-- [[ SAYFA SİSTEMİ ]] --
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(0, 440, 0, 350)
Pages.Position = UDim2.new(0, 170, 0, 60)
Pages.BackgroundTransparency = 1

local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 2
    local grid = Instance.new("UIGridLayout", p)
    grid.CellSize = UDim2.new(0, 200, 0, 45)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    return p
end

local UniversalPage = CreatePage()
local PrisonPage = CreatePage()
local MM2Page = CreatePage()
local BloxPage = CreatePage()
UniversalPage.Visible = true

local function AddTab(name, page, y)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
        page.Visible = true
    end)
end

AddTab("🌍 Genel", UniversalPage, 60)
AddTab("⛓️ Prison Life", PrisonPage, 105)
AddTab("🔪 MM2", MM2Page, 150)
AddTab("🍎 Blox Fruits", BloxPage, 195)

local function AddHack(name, page, callback)
    local btn = Instance.new("TextButton", page)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- --- [ GENEL HİLELER ] ---
AddHack("⚡ Speed Loop", UniversalPage, function()
    getgenv().Speed = not getgenv().Speed
    RunService.Stepped:Connect(function()
        if getgenv().Speed and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 100
        end
    end)
end)

AddHack("👻 Görünmezlik (Invis)", UniversalPage, function()
    local char = LocalPlayer.Character
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            v.Transparency = (v.Transparency == 0 and 1 or 0)
        end
    end
end)

-- --- [ MM2 HİLELERİ ] ---
AddHack("🕵️ Katili Göster", MM2Page, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

AddHack("🔫 Şerifi Göster", MM2Page, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(0, 0, 255)
        end
    end
end)

-- --- [ BLOX FRUITS ] ---
AddHack("👊 Auto Click", BloxPage, function()
    getgenv().AutoClick = not getgenv().AutoClick
    while getgenv().AutoClick do
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        wait(0.1)
    end
end)

AddHack("📦 Sandık Bul (ESP)", BloxPage, function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name:find("Chest") then
            local h = Instance.new("Highlight", v)
            h.FillColor = Color3.fromRGB(0, 255, 0)
        end
