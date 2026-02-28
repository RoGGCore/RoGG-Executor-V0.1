--[[
╔═══════════════════════════════════════════════════╗
║            ADVANCED ESP v2.0                      ║
║  Sekmeli Menü • FOV • Head Dot • Closest Vurgu   ║
║          INSERT → Aç/Kapat                        ║
╚═══════════════════════════════════════════════════╝
Sadece öğrenme amaçlıdır.
]]

-- ══════════════════════════════
--  SERVİSLER
-- ══════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local camera           = workspace.CurrentCamera
local lp               = Players.LocalPlayer

-- ══════════════════════════════
--  CONFIG
-- ══════════════════════════════
local CONFIG = {
    -- Genel
    enabled       = true,
    maxDistance   = 500,

    -- ESP Özellikleri
    box           = true,
    cornerBox     = false,   -- Köşe kutu stili
    healthBar     = true,
    names         = true,
    distance      = true,
    snapLines     = false,
    headDot       = true,    -- Kafaya nokta
    skeleton      = true,
    chams         = true,
    teamCheck     = true,
    showTeammates = false,

    -- Görsel Yardımcılar
    fovCircle     = true,
    fovRadius     = 120,     -- FOV çember yarıçapı (piksel)
    crosshair     = true,
    closestHighlight = true, -- En yakın düşmanı vurgula

    -- Renkler
    colorVisible      = Color3.fromRGB(0, 255, 80),
    colorWall         = Color3.fromRGB(255, 60, 60),
    colorTeammate     = Color3.fromRGB(60, 140, 255),
    colorClosest      = Color3.fromRGB(255, 220, 0),
    colorFOV          = Color3.fromRGB(255, 255, 255),
    colorCrosshair    = Color3.fromRGB(255, 255, 255),
}

-- ══════════════════════════════════════════════════
--  MENÜ GUI
-- ══════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name           = "ESP_v2"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = lp:WaitForChild("PlayerGui") end)

-- ── Ana pencere ──
local win = Instance.new("Frame")
win.Size              = UDim2.new(0, 260, 0, 380)
win.Position          = UDim2.new(0, 30, 0, 30)
win.BackgroundColor3  = Color3.fromRGB(12, 12, 18)
win.BorderSizePixel   = 0
win.Active            = true
win.Draggable         = true
win.Visible           = false
win.Parent            = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

-- Dış parlama efekti
local glow = Instance.new("UIStroke", win)
glow.Color     = Color3.fromRGB(0, 200, 100)
glow.Thickness = 1.5

-- ── Başlık çubuğu ──
local titleBar = Instance.new("Frame", win)
titleBar.Size            = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
titleBar.BorderSizePixel  = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

-- Alt köşe düzeltme
local fix = Instance.new("Frame", titleBar)
fix.Size             = UDim2.new(1, 0, 0.5, 0)
fix.Position         = UDim2.new(0, 0, 0.5, 0)
fix.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
fix.BorderSizePixel  = 0

-- Yeşil sol çizgi
local accent = Instance.new("Frame", titleBar)
accent.Size             = UDim2.new(0, 3, 0.7, 0)
accent.Position         = UDim2.new(0, 10, 0.15, 0)
accent.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
accent.BorderSizePixel  = 0
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

local titleTxt = Instance.new("TextLabel", titleBar)
titleTxt.Size                = UDim2.new(1, -20, 1, 0)
titleTxt.Position            = UDim2.new(0, 20, 0, 0)
titleTxt.BackgroundTransparency = 1
titleTxt.Text                = "⚡  ESP  v2.0"
titleTxt.TextColor3          = Color3.fromRGB(240, 240, 240)
titleTxt.TextSize             = 15
titleTxt.Font                 = Enum.Font.GothamBold
titleTxt.TextXAlignment       = Enum.TextXAlignment.Left

local subTxt = Instance.new("TextLabel", titleBar)
subTxt.Size                = UDim2.new(1, -20, 1, 0)
subTxt.Position            = UDim2.new(0, 20, 0, 0)
subTxt.BackgroundTransparency = 1
subTxt.Text                = "INSERT → aç/kapat"
subTxt.TextColor3          = Color3.fromRGB(80, 80, 100)
subTxt.TextSize             = 9
subTxt.Font                 = Enum.Font.Gotham
subTxt.TextXAlignment       = Enum.TextXAlignment.Right

-- ── Sekme çubuğu ──
local tabBar = Instance.new("Frame", win)
tabBar.Size             = UDim2.new(1, -20, 0, 30)
tabBar.Position         = UDim2.new(0, 10, 0, 46)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
tabBar.BorderSizePixel  = 0
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 6)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection  = Enum.FillDirection.Horizontal
tabLayout.SortOrder      = Enum.SortOrder.LayoutOrder
tabLayout.Padding        = UDim.new(0, 2)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- İçerik alanı
local content = Instance.new("Frame", win)
content.Size             = UDim2.new(1, -20, 1, -90)
content.Position         = UDim2.new(0, 10, 0, 84)
content.BackgroundTransparency = 1
content.BorderSizePixel  = 0
content.ClipsDescendants = true

-- ══════════════════════════════════════════════════
--  YARDIMCI: Sekme ve içerik sistemi
-- ══════════════════════════════════════════════════
local tabs        = {}
local tabPages    = {}
local activeTab   = nil

local function SetTab(name)
    for tabName, btn in pairs(tabs) do
        local isActive = tabName == name
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = isActive
                and Color3.fromRGB(0, 180, 80)
                or Color3.fromRGB(30, 30, 40),
            TextColor3 = isActive
                and Color3.fromRGB(255, 255, 255)
                or Color3.fromRGB(120, 120, 140),
        }):Play()
    end
    for pageName, page in pairs(tabPages) do
        page.Visible = pageName == name
    end
    activeTab = name
end

local function AddTab(name, icon)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size             = UDim2.new(0, 76, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel  = 0
    btn.Text             = icon .. "  " .. name
    btn.TextColor3       = Color3.fromRGB(120, 120, 140)
    btn.TextSize         = 10
    btn.Font             = Enum.Font.GothamBold
    btn.AutoButtonColor  = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local page = Instance.new("ScrollingFrame", content)
    page.Size             = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel  = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 80)
    page.Visible          = false
    page.CanvasSize       = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, 5)

    tabs[name]     = btn
    tabPages[name] = page

    btn.MouseButton1Click:Connect(function() SetTab(name) end)
    return page
end

-- ══════════════════════════════════════════════════
--  YARDIMCI: Toggle
-- ══════════════════════════════════════════════════
local function AddToggle(page, label, configKey, order)
    local row = Instance.new("Frame", page)
    row.Size             = UDim2.new(1, -4, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size                = UDim2.new(1, -50, 1, 0)
    lbl.Position            = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                = label
    lbl.TextColor3          = Color3.fromRGB(190, 190, 200)
    lbl.TextSize             = 12
    lbl.Font                 = Enum.Font.Gotham
    lbl.TextXAlignment       = Enum.TextXAlignment.Left

    local switchBG = Instance.new("Frame", row)
    switchBG.Size             = UDim2.new(0, 38, 0, 20)
    switchBG.Position         = UDim2.new(1, -46, 0.5, -10)
    switchBG.BackgroundColor3 = CONFIG[configKey]
        and Color3.fromRGB(0, 180, 80)
        or  Color3.fromRGB(50, 50, 70)
    switchBG.BorderSizePixel  = 0
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBG)
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.Position         = CONFIG[configKey]
        and UDim2.new(1, -17, 0.5, -7)
        or  UDim2.new(0, 3,   0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", row)
    btn.Size                = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                = ""

    btn.MouseButton1Click:Connect(function()
        CONFIG[configKey] = not CONFIG[configKey]
        local on = CONFIG[configKey]
        TweenService:Create(switchBG, TweenInfo.new(0.15), {
            BackgroundColor3 = on
                and Color3.fromRGB(0, 180, 80)
                or  Color3.fromRGB(50, 50, 70)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = on
                and UDim2.new(1, -17, 0.5, -7)
                or  UDim2.new(0, 3,   0.5, -7)
        }):Play()
    end)
end

-- ══════════════════════════════════════════════════
--  YARDIMCI: Slider
-- ══════════════════════════════════════════════════
local function AddSlider(page, label, configKey, minVal, maxVal, order)
    local row = Instance.new("Frame", page)
    row.Size             = UDim2.new(1, -4, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size                = UDim2.new(0.6, 0, 0, 20)
    lbl.Position            = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text                = label
    lbl.TextColor3          = Color3.fromRGB(190, 190, 200)
    lbl.TextSize             = 12
    lbl.Font                 = Enum.Font.Gotham
    lbl.TextXAlignment       = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size                = UDim2.new(0.4, -12, 0, 20)
    valLbl.Position            = UDim2.new(0.6, 0, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text                = tostring(CONFIG[configKey])
    valLbl.TextColor3          = Color3.fromRGB(0, 200, 90)
    valLbl.TextSize             = 12
    valLbl.Font                 = Enum.Font.GothamBold
    valLbl.TextXAlignment       = Enum.TextXAlignment.Right

    -- Track
    local track = Instance.new("Frame", row)
    track.Size             = UDim2.new(1, -24, 0, 4)
    track.Position         = UDim2.new(0, 12, 0, 33)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    -- Fill
    local frac  = (CONFIG[configKey] - minVal) / (maxVal - minVal)
    local fill  = Instance.new("Frame", track)
    fill.Size             = UDim2.new(frac, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    fill.BorderSizePixel  = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    -- Knob
    local knob = Instance.new("Frame", track)
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.Position         = UDim2.new(frac, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    -- Sürükleme
    local dragging = false
    local btn = Instance.new("TextButton", track)
    btn.Size                = UDim2.new(1, 0, 0, 20)
    btn.Position            = UDim2.new(0, 0, 0.5, -10)
    btn.BackgroundTransparency = 1
    btn.Text                = ""

    local function Update(inputX)
        local abs  = track.AbsolutePosition.X
        local wid  = track.AbsoluteSize.X
        local t    = math.clamp((inputX - abs) / wid, 0, 1)
        local val  = math.floor(minVal + t * (maxVal - minVal))
        CONFIG[configKey] = val
        valLbl.Text        = tostring(val)
        fill.Size          = UDim2.new(t, 0, 1, 0)
        knob.Position      = UDim2.new(t, -6, 0.5, -6)
    end

    btn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            Update(i.Position.X)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        Update(UserInputService:GetMouseLocation().X)
    end)
end

-- ══════════════════════════════════════════════════
--  SEKMELER + İÇERİKLER
-- ══════════════════════════════════════════════════

-- 1) ESP sekmesi
local espPage = AddTab("ESP", "👁")
AddToggle(espPage, "📦 Bounding Box",      "box",           1)
AddToggle(espPage, "🔲 Köşe Kutu Stili",   "cornerBox",     2)
AddToggle(espPage, "❤️  Can Barı",          "healthBar",     3)
AddToggle(espPage, "🏷️  İsim",              "names",         4)
AddToggle(espPage, "📏 Mesafe",             "distance",      5)
AddToggle(espPage, "📍 Snap Lines",         "snapLines",     6)
AddToggle(espPage, "🔴 Kafa Noktası",       "headDot",       7)
AddToggle(espPage, "💀 Skeleton",           "skeleton",      8)
AddToggle(espPage, "🎨 Chams",              "chams",         9)
AddSlider(espPage, "Max Mesafe",            "maxDistance",   100, 2000, 10)

-- 2) Takım sekmesi
local teamPage = AddTab("Takım", "👥")
AddToggle(teamPage, "👥 Team Check",         "teamCheck",     1)
AddToggle(teamPage, "🟦 Takım Arkadaşları", "showTeammates", 2)

-- 3) Görsel yardımcılar
local aimPage = AddTab("Görsel", "🎯")
AddToggle(aimPage, "⭕ FOV Çemberi",         "fovCircle",        1)
AddSlider(aimPage, "FOV Yarıçapı",           "fovRadius",    20, 400, 2)
AddToggle(aimPage, "✚ Crosshair",            "crosshair",        3)
AddToggle(aimPage, "🌟 En Yakın Vurgu",      "closestHighlight", 4)

-- İlk sekmeyi aç
SetTab("ESP")

-- ══════════════════════════════════════════════════
--  INSERT → MENÜ AÇ/KAPAT
-- ══════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        win.Visible = not win.Visible
        if win.Visible then
            win.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(win, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 260, 0, 380)
            }):Play()
        end
    end
end)

-- ══════════════════════════════════════════════════
--  GÖRSEL YARDIMCILAR: FOV + CROSSHAIR (Drawing)
-- ══════════════════════════════════════════════════

-- FOV Çemberi
local fovCircle = Drawing.new("Circle")
fovCircle.Radius      = CONFIG.fovRadius
fovCircle.Color       = CONFIG.colorFOV
fovCircle.Thickness   = 1.5
fovCircle.Filled      = false
fovCircle.Transparency = 0.7
fovCircle.Visible     = false
fovCircle.NumSides    = 64

-- Crosshair (4 çizgi)
local chLines = {
    Drawing.new("Line"), Drawing.new("Line"),
    Drawing.new("Line"), Drawing.new("Line"),
}
for _, l in ipairs(chLines) do
    l.Color     = CONFIG.colorCrosshair
    l.Thickness = 1.5
    l.Visible   = false
end

RunService.RenderStepped:Connect(function()
    local vp     = camera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2

    -- FOV çemberi
    fovCircle.Position = Vector2.new(cx, cy)
    fovCircle.Radius   = CONFIG.fovRadius
    fovCircle.Visible  = CONFIG.enabled and CONFIG.fovCircle

    -- Crosshair
    if CONFIG.enabled and CONFIG.crosshair then
        local g = 6  -- boşluk
        local s = 14 -- çizgi uzunluğu
        chLines[1].From = Vector2.new(cx - s - g, cy); chLines[1].To = Vector2.new(cx - g, cy)
        chLines[2].From = Vector2.new(cx + g, cy);     chLines[2].To = Vector2.new(cx + s + g, cy)
        chLines[3].From = Vector2.new(cx, cy - s - g); chLines[3].To = Vector2.new(cx, cy - g)
        chLines[4].From = Vector2.new(cx, cy + g);     chLines[4].To = Vector2.new(cx, cy + s + g)
        for _, l in ipairs(chLines) do l.Visible = true end
    else
        for _, l in ipairs(chLines) do l.Visible = false end
    end
end)

-- ══════════════════════════════════════════════════
--  ESP DRAWING SİSTEMİ
-- ══════════════════════════════════════════════════
local drawings = {}
local chams    = {}

local BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function L(thick)
    local l = Drawing.new("Line")
    l.Thickness = thick or 1.5
    l.Visible = false
    return l
end
local function T(sz)
    local t = Drawing.new("Text")
    t.Size = sz or 13; t.Center = true; t.Outline = true
    t.Font = Drawing.Fonts.UI; t.Visible = false
    return t
end
local function SQ(filled, col, trans)
    local s = Drawing.new("Square")
    s.Filled = filled or false
    s.Color = col or Color3.fromRGB(0,0,0)
    s.Transparency = trans or 1
    s.Visible = false
    return s
end
local function CIR(radius)
    local c = Drawing.new("Circle")
    c.Radius = radius or 4
    c.Filled = true
    c.Visible = false
    return c
end

local function CreateDrawings(player)
    local d = {
        boxTop=L(), boxBottom=L(), boxLeft=L(), boxRight=L(),
        -- Köşe kutu
        c1a=L(2), c1b=L(2), c2a=L(2), c2b=L(2),
        c3a=L(2), c3b=L(2), c4a=L(2), c4b=L(2),
        name=T(13), dist=T(11),
        healthBG=SQ(true,Color3.fromRGB(0,0,0),0.4), healthBar=SQ(true),
        snapLine=L(1),
        headDot=CIR(4),
        skeleton={},
    }
    for i = 1, #BONES do d.skeleton[i] = L(1) end
    drawings[player] = d
end

local function HideAll(player)
    local d = drawings[player]
    if not d then return end
    for k, v in pairs(d) do
        if k == "skeleton" then for _, l in ipairs(v) do l.Visible = false end
        else v.Visible = false end
    end
end

local function RemoveAll(player)
    local d = drawings[player]
    if not d then return end
    for k, v in pairs(d) do
        if k == "skeleton" then for _, l in ipairs(v) do l:Remove() end
        else v:Remove() end
    end
    drawings[player] = nil
end

-- ── Chams ──
local function CreateChams(player)
    local char = player.Character
    if not char then return end
    if chams[player] then chams[player]:Destroy() end
    local h = Instance.new("Highlight")
    h.FillTransparency    = 0.5
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee             = char
    h.Parent              = char
    chams[player]         = h
end
local function UpdateChams(player, visible, isTeam, isClosest)
    local h = chams[player]
    if not h then return end
    if isClosest and CONFIG.closestHighlight then
        h.FillColor    = CONFIG.colorClosest
        h.OutlineColor = CONFIG.colorClosest
    elseif isTeam then
        h.FillColor    = CONFIG.colorTeammate
        h.OutlineColor = Config.colorTeammate
    elseif visible then
        h.FillColor    = CONFIG.colorVisible
        h.OutlineColor = CONFIG.colorVisible
    else
        h.FillColor    = CONFIG.colorWall
        h.OutlineColor = CONFIG.colorWall
    end
end
local function RemoveChams(player)
    if chams[player] then chams[player]:Destroy(); chams[player] = nil end
end

-- ── Bounding Box ──
local function GetBoundingBox(character)
    local mnX,mnY =  math.huge, math.huge
    local mxX,mxY = -math.huge,-math.huge
    local any = false

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local s = part.Size
            local corners = {
                part.CFrame*CFrame.new( s.X/2, s.Y/2, s.Z/2),
                part.CFrame*CFrame.new(-s.X/2, s.Y/2, s.Z/2),
                part.CFrame*CFrame.new( s.X/2,-s.Y/2, s.Z/2),
                part.CFrame*CFrame.new(-s.X/2,-s.Y/2, s.Z/2),
                part.CFrame*CFrame.new( s.X/2, s.Y/2,-s.Z/2),
                part.CFrame*CFrame.new(-s.X/2, s.Y/2,-s.Z/2),
                part.CFrame*CFrame.new( s.X/2,-s.Y/2,-s.Z/2),
                part.CFrame*CFrame.new(-s.X/2,-s.Y/2,-s.Z/2),
            }
            for _, cf in ipairs(corners) do
                local sp, on = camera:WorldToViewportPoint(cf.Position)
                if on then
                    any = true
                    if sp.X < mnX then mnX=sp.X end
                    if sp.Y < mnY then mnY=sp.Y end
                    if sp.X > mxX then mxX=sp.X end
                    if sp.Y > mxY then mxY=sp.Y end
                end
            end
        end
    end

    if not any then return nil end
    return mnX, mnY, mxX-mnX, mxY-mnY
end

-- ── Görünürlük ──
local function IsVisible(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {lp.Character, character}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local origin = camera.CFrame.Position
    local result = workspace:Raycast(origin, hrp.Position - origin, rp)
    return result == nil
end

-- ── Oyuncu FOV içinde mi? ──
local function InFOV(hrp)
    local sp, onScreen = camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then return false, math.huge end
    local vp = camera.ViewportSize
    local dx = sp.X - vp.X/2
    local dy = sp.Y - vp.Y/2
    local dist2D = math.sqrt(dx*dx + dy*dy)
    return dist2D <= CONFIG.fovRadius, dist2D
end

-- ── Ana güncelleme ──
local function DrawCornerBox(d, bx, by, bw, bh, color)
    local cl = bw * 0.22
    local ch = bh * 0.22
    -- Üst-sol
    d.c1a.From=Vector2.new(bx,by);       d.c1a.To=Vector2.new(bx+cl,by)
    d.c1b.From=Vector2.new(bx,by);       d.c1b.To=Vector2.new(bx,by+ch)
    -- Üst-sağ
    d.c2a.From=Vector2.new(bx+bw,by);    d.c2a.To=Vector2.new(bx+bw-cl,by)
    d.c2b.From=Vector2.new(bx+bw,by);    d.c2b.To=Vector2.new(bx+bw,by+ch)
    -- Alt-sol
    d.c3a.From=Vector2.new(bx,by+bh);    d.c3a.To=Vector2.new(bx+cl,by+bh)
    d.c3b.From=Vector2.new(bx,by+bh);    d.c3b.To=Vector2.new(bx,by+bh-ch)
    -- Alt-sağ
    d.c4a.From=Vector2.new(bx+bw,by+bh); d.c4a.To=Vector2.new(bx+bw-cl,by+bh)
    d.c4b.From=Vector2.new(bx+bw,by+bh); d.c4b.To=Vector2.new(bx+bw,by+bh-ch)
    for _,l in pairs({d.c1a,d.c1b,d.c2a,d.c2b,d.c3a,d.c3b,d.c4a,d.c4b}) do
        l.Color=color; l.Visible=true
    end
    d.boxTop.Visible=false; d.boxBottom.Visible=false
    d.boxLeft.Visible=false; d.boxRight.Visible=false
end

local function DrawFullBox(d, bx, by, bw, bh, color)
    d.boxTop.From=Vector2.new(bx,by);       d.boxTop.To=Vector2.new(bx+bw,by)
    d.boxBottom.From=Vector2.new(bx,by+bh); d.boxBottom.To=Vector2.new(bx+bw,by+bh)
    d.boxLeft.From=Vector2.new(bx,by);      d.boxLeft.To=Vector2.new(bx,by+bh)
    d.boxRight.From=Vector2.new(bx+bw,by);  d.boxRight.To=Vector2.new(bx+bw,by+bh)
    for _,l in pairs({d.boxTop,d.boxBottom,d.boxLeft,d.boxRight}) do
        l.Color=color; l.Visible=true
    end
    for _,l in pairs({d.c1a,d.c1b,d.c2a,d.c2b,d.c3a,d.c3b,d.c4a,d.c4b}) do
        l.Visible=false
    end
end

local function UpdatePlayer(player, char, humanoid, hrp, lpRoot, isClosest)
    local d = drawings[player]
    if not d then return end

    local dist3D = (lpRoot.Position - hrp.Position).Magnitude
    local isTeam = CONFIG.teamCheck and IsSameTeam(player)
    local visible = IsVisible(char)

    local color
    if isClosest and CONFIG.closestHighlight then
        color = CONFIG.colorClosest
    elseif isTeam then
        color = CONFIG.colorTeammate
    elseif visible then
        color = CONFIG.colorVisible
    else
        color = CONFIG.colorWall
    end

    if isTeam and not CONFIG.showTeammates then
        HideAll(player)
        RemoveChams(player)
        return
    end

    local bx,by,bw,bh = GetBoundingBox(char)
    if not bx then HideAll(player); return end

    -- BOX
    if CONFIG.box then
        if CONFIG.cornerBox then
            DrawCornerBox(d, bx, by, bw, bh, color)
        else
            DrawFullBox(d, bx, by, bw, bh, color)
        end
    else
        for _,l in pairs({d.boxTop,d.boxBottom,d.boxLeft,d.boxRight,
                          d.c1a,d.c1b,d.c2a,d.c2b,d.c3a,d.c3b,d.c4a,d.c4b}) do
            l.Visible=false
        end
    end

    -- KAFA NOKTASI
    if CONFIG.headDot then
        local head = char:FindFirstChild("Head")
        if head then
            local sp, on = camera:WorldToViewportPoint(head.Position)
            if on then
                d.headDot.Position = Vector2.new(sp.X, sp.Y)
                d.headDot.Color    = color
                d.headDot.Radius   = math.clamp(8 / (dist3D / 50), 2, 8)
                d.headDot.Visible  = true
            else d.headDot.Visible = false end
        end
    else d.headDot.Visible = false end

    -- İSİM
    if CONFIG.names then
        d.name.Text=player.Name; d.name.Position=Vector2.new(bx+bw/2,by-16)
        d.name.Color=color; d.name.Visible=true
    else d.name.Visible=false end

    -- MESAFE
    if CONFIG.distance then
        d.dist.Text=string.format("%.0f studs", dist3D)
        d.dist.Position=Vector2.new(bx+bw/2, by+bh+2)
        d.dist.Color=Color3.fromRGB(180,180,180); d.dist.Visible=true
    else d.dist.Visible=false end

    -- CAN BARI
    if CONFIG.healthBar then
        local frac = math.clamp(humanoid.Health/humanoid.MaxHealth, 0, 1)
        local barH = bh * frac
        d.healthBG.Position=Vector2.new(bx-7,by); d.healthBG.Size=Vector2.new(4,bh); d.healthBG.Visible=true
        d.healthBar.Position=Vector2.new(bx-7, by+(bh-barH))
        d.healthBar.Size=Vector2.new(4,barH)
        d.healthBar.Color=Color3.fromRGB(math.floor(255*(1-frac)), math.floor(255*frac), 0)
        d.healthBar.Visible=true
    else d.healthBG.Visible=false; d.healthBar.Visible=false end

    -- SNAP LINE
    if CONFIG.snapLines then
        local vp=camera.ViewportSize
        d.snapLine.From=Vector2.new(vp.X/2,vp.Y); d.snapLine.To=Vector2.new(bx+bw/2,by+bh)
        d.snapLine.Color=color; d.snapLine.Transparency=0.4; d.snapLine.Visible=true
    else d.snapLine.Visible=false end

    -- SKELETON
    if CONFIG.skeleton then
        for i, conn in ipairs(BONES) do
            local pA=char:FindFirstChild(conn[1])
            local pB=char:FindFirstChild(conn[2])
            local line=d.skeleton[i]
            if pA and pB then
                local sA,onA=camera:WorldToViewportPoint(pA.Position)
                local sB,onB=camera:WorldToViewportPoint(pB.Position)
                if onA and onB then
                    line.From=Vector2.new(sA.X,sA.Y); line.To=Vector2.new(sB.X,sB.Y)
                    line.Color=color; line.Visible=true
                else line.Visible=false end
            else line.Visible=false end
        end
    else for _,l in ipairs(d.skeleton) do l.Visible=false end end

    -- CHAMS
    if CONFIG.chams then
        if not chams[player] then CreateChams(player) end
        UpdateChams(player, visible, isTeam, isClosest)
    else RemoveChams(player) end
end

-- ══════════════════════════════════════════════════
--  OYUNCU OLAYLARI
-- ══════════════════════════════════════════════════
Players.PlayerAdded:Connect(function(player)
    CreateDrawings(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if CONFIG.chams then CreateChams(player) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveAll(player)
    RemoveChams(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= lp then
        CreateDrawings(player)
        task.delay(1, function()
            if CONFIG.chams then CreateChams(player) end
        end)
    end
end

-- ══════════════════════════════════════════════════
--  ANA DÖNGÜ
-- ══════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if not CONFIG.enabled then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= lp then HideAll(pl); RemoveChams(pl) end
        end
        return
    end

    local lpChar = lp.Character
    if not lpChar then return end
    local lpRoot = lpChar:FindFirstChild("HumanoidRootPart")
    if not lpRoot then return end

    -- En yakın düşmanı bul
    local closestPlayer = nil
    local closestDist   = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local d = (lpRoot.Position - hrp.Position).Magnitude
        local inFov, _ = InFOV(hrp)
        -- En yakın = FOV içindeki en yakın
        if inFov and d < closestDist then
            closestDist   = d
            closestPlayer = player
        end
    end

    -- Herkesi çiz
    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end

        local char     = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local hrp      = char and char:FindFirstChild("HumanoidRootPart")

        if not char or not humanoid or not hrp then
            HideAll(player); continue
        end
        if humanoid.Health <= 0 then
            HideAll(player); RemoveChams(player); continue
        end

        local dist = (lpRoot.Position - hrp.Position).Magnitude
        if dist > CONFIG.maxDistance then HideAll(player); continue end

        if not drawings[player] then CreateDrawings(player) end
        UpdatePlayer(player, char, humanoid, hrp, lpRoot, player == closestPlayer)
    end
end)

print("[ESP v2] ✅ Hazır! INSERT → menü aç/kapat")
