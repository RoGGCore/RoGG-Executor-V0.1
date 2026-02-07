-- [[ RoGG v0.1 - STABLE VERSION | DISCORD: bilalgg ]] --
if getgenv().RoGG_Loaded then return end
getgenv().RoGG_Loaded = true

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI ANA YAPI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0)

-- BAŞLIK
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "RoGG v0.1 - Prison Life"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- BUTON ALANI
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIGridLayout", Container)
Layout.CellSize = UDim2.new(0, 230, 0, 40)
Layout.CellPadding = UDim2.new(0, 10, 0, 10)

local function AddHack(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- HİLELER
AddHack("⚡ Speed (100)", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

AddHack("💀 Kill All", function()
    local gun = LocalPlayer.Backpack:FindFirstChild("Remington 870") or LocalPlayer.Character:FindFirstChild("Remington 870")
    if gun then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                game.ReplicatedStorage.ShootEvent:FireServer({{["Hit"] = v.Character.Head, ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), ["Distance"] = 0}}, gun)
            end
        end
    end
end)

AddHack("🏃 Escape Prison", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-943, 95, 2055)
end)

AddHack("🔫 Get AK-47", function()
    workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
end)

AddHack("🛑 Close Menu", function() ScreenGui:Destroy(); getgenv().RoGG_Loaded = false end)

-- TOGGLE (Sağ Shift)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end
end)

print("RoGG v0.1: Basariyla yuklendi!")
