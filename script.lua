local TweenService = game:GetService("TweenService")

local LockGui = Instance.new("ScreenGui")
LockGui.Name = "PulsarLock"
LockGui.ResetOnSpawn = false
LockGui.DisplayOrder = 9998
LockGui.IgnoreGuiInset = true
LockGui.Enabled = false

local LockButton = Instance.new("TextButton")
LockButton.Position = UDim2.new(0.5, -145, 0, 10)
LockButton.Size = UDim2.fromOffset(290, 30)
LockButton.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
LockButton.BackgroundTransparency = 0
LockButton.BorderSizePixel = 0
LockButton.Text = ""
LockButton.AutoButtonColor = false
LockButton.Parent = LockGui

local LockLabel = Instance.new("TextLabel")
LockLabel.Size = UDim2.new(1, -20, 1, 0)
LockLabel.Position = UDim2.fromOffset(10, 0)
LockLabel.BackgroundTransparency = 1
LockLabel.Text = "PULSAR 2.3 | FPS: 0 || Пинг: 0 мс"
LockLabel.TextColor3 = Color3.new(1, 1, 1)
LockLabel.Font = Enum.Font.Gotham
LockLabel.TextSize = 13
LockLabel.TextXAlignment = Enum.TextXAlignment.Left
LockLabel.Parent = LockButton

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

local LockStroke = Instance.new("UIStroke")
LockStroke.Color = Color3.fromRGB(45, 45, 50)
LockStroke.Thickness = 1
LockStroke.Parent = LockButton

local LockInput = game:GetService("UserInputService")
local lockDragging = false
local lockDragStart = nil
local lockStartPos = nil

LockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lockDragging = true
        lockDragStart = input.Position
        lockStartPos = LockButton.Position
    end
end)

LockInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lockDragging = false
    end
end)

LockInput.InputChanged:Connect(function(input)
    if lockDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - lockDragStart
        LockButton.Position = UDim2.new(
            lockStartPos.X.Scale, lockStartPos.X.Offset + delta.X,
            lockStartPos.Y.Scale, lockStartPos.Y.Offset + delta.Y
        )
    end
end)

if not pcall(function() LockGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) then
    LockGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

task.spawn(function()
    local RunServiceS = game:GetService("RunService")
    local StatsService = game:GetService("Stats")
    local frames = 0
    local acc = 0
    local ping = 0
    local conn = RunServiceS.Heartbeat:Connect(function(dt)
        frames = frames + 1
        acc = acc + dt
    end)
    while LockGui.Parent do
        task.wait(1)
        local fps = 0
        if acc > 0 then fps = math.floor(frames / acc + 0.5) end
        pcall(function()
            ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        pcall(function()
            LockLabel.Text = "PULSAR 2.3 | FPS: " .. fps .. " || Пинг: " .. math.floor(ping) .. " мс"
        end)
        frames = 0
        acc = 0
    end
    pcall(function() conn:Disconnect() end)
end)

local okLib, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
end)
if not okLib or type(Library) ~= "table" then
    warn("[PULSAR] Не удалось загрузить библиотеку Obsidian")
    return
end

pcall(function()
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"))()
    if type(Icons) == "table" and Library.SetIconModule then
        Library:SetIconModule(Icons)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "PULSAR 2.3",
    Footer = "Powered by Obsidian",
    Size = UDim2.fromOffset(540, 420),
    Center = true,
    AutoShow = true,
    Resizable = true,
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    MinSidebarWidth = 200,
    SidebarCompactWidth = 56,
    ToggleKeybind = Enum.KeyCode.M,
    ShowMobileButtons = true,
    SearchbarSize = UDim2.fromOffset(36, 36),
})
pcall(function() Window:SetCornerRadius(8) end)
pcall(function() LockGui.Enabled = true end)

local SearchCollapseSize = UDim2.fromOffset(36, 36)
task.spawn(function()
    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local searchBox
    for _ = 1, 60 do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextBox") and d.PlaceholderText == "Search" then
                searchBox = d
                break
            end
        end
        if searchBox then break end
        task.wait(0.1)
    end
    if not searchBox then return end
    pcall(function()
        local topBar = searchBox.Parent and searchBox.Parent.Parent
        if topBar and topBar:IsA("GuiObject") then
            searchBox.Parent = topBar
            searchBox.AnchorPoint = Vector2.new(1, 0.5)
            searchBox.Position = UDim2.new(1, -44, 0.5, 0)
            searchBox.ZIndex = 3
        end
    end)
    searchBox.PlaceholderText = ""
    Library:GiveSignal(searchBox.Focused:Connect(function()
        searchBox.PlaceholderText = "Search"
        pcall(function()
            TweenService:Create(searchBox, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(220, 36),
            }):Play()
        end)
    end))
    Library:GiveSignal(searchBox.FocusLost:Connect(function()
        searchBox.Text = ""
        searchBox.PlaceholderText = ""
        pcall(function()
            TweenService:Create(searchBox, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = SearchCollapseSize,
            }):Play()
        end)
    end))
end)

task.spawn(function()
    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local function FindSwitchParts(d)
        if not d:IsA("Frame") then return nil end
        if d.Size.X.Offset ~= 32 or d.Size.Y.Offset ~= 18 then return nil end
        local corner = d:FindFirstChildOfClass("UICorner")
        local stroke = d:FindFirstChildOfClass("UIStroke")
        if not corner or not stroke then return nil end
        for _, ch in ipairs(d:GetChildren()) do
            if ch:IsA("Frame") and ch.SizeConstraint == Enum.SizeConstraint.RelativeYY and ch:FindFirstChildOfClass("UICorner") then
                return { Frame = d, Corner = corner, Ball = ch }
            end
        end
        return nil
    end
    local function SquareSwitch(sw)
        sw.Frame:SetAttribute("PulsarSquare", true)
        sw.Ball.Visible = false
        sw.Corner.CornerRadius = UDim.new(0, 0)
        sw.Frame.Size = UDim2.fromOffset(18, 18)
    end
    pcall(function()
        Library:GiveSignal(root.DescendantAdded:Connect(function(d)
            task.defer(function()
                local sw = FindSwitchParts(d)
                if sw and not sw.Frame:GetAttribute("PulsarSquare") then
                    SquareSwitch(sw)
                end
            end)
        end))
    end)
    local emptyPasses = 0
    for _ = 1, 40 do
        local processed = 0
        for _, d in ipairs(root:GetDescendants()) do
            local sw = FindSwitchParts(d)
            if sw and not sw.Frame:GetAttribute("PulsarSquare") then
                SquareSwitch(sw)
                processed = processed + 1
            end
        end
        if processed == 0 then
            emptyPasses = emptyPasses + 1
            if emptyPasses >= 3 then break end
        else
            emptyPasses = 0
        end
        task.wait(0.3)
    end
end)

local Tabs = {
    { Name = "Home",         Icon = "house" },
    { Name = "Player",       Icon = "user" },
    { Name = "Combat",       Icon = "sword" },
    { Name = "Invincibility", Icon = "shield" },
    { Name = "Target",       Icon = "target" },
    { Name = "Blobman",      Icon = "ghost" },
    { Name = "Toys",         Icon = "blocks" },
    { Name = "Visual",       Icon = "eye" },
    { Name = "Music",        Icon = "music" },
    { Name = "Auto-Clicker", Icon = "zap" },
    { Name = "Misc",         Icon = "wrench" },
    { Name = "Lists",        Icon = "list" },
    { Name = "Settings",     Icon = "settings" },
}

local TabObjects = {}
for _, info in ipairs(Tabs) do
    TabObjects[info.Name] = Window:AddTab(info.Name, info.Icon)
end

local HomeGroup = TabObjects["Home"]:AddLeftGroupbox("Main Functions")

local HotkeyGroup = TabObjects["Home"]:AddLeftGroupbox("Горячие клавиши")
HotkeyGroup:AddLabel("Клавиша M — открыть/закрыть меню (на телефоне — экранные кнопки)")

local StatsGroup = TabObjects["Home"]:AddRightGroupbox("Статистика")
StatsGroup:AddLabel("Вкладок: 13")
StatsGroup:AddLabel("Шейдеров: 6")
local PlayersLabel = StatsGroup:AddLabel("Игроков в сервере: " .. #Players:GetPlayers())

local CreatorGroup = TabObjects["Home"]:AddRightGroupbox("Создатели")
CreatorGroup:AddLabel("Создатели: PULSAR (FTAP)")
CreatorGroup:AddLabel("Telegram: @FTAP_777")
CreatorGroup:AddButton({
    Text = "📢 Наш Telegram",
    Func = function()
        local ok = pcall(function() setclipboard("https://t.me/FTAP_777") end)
        if not ok then
            ok = pcall(function() toclipboard("https://t.me/FTAP_777") end)
        end
        if ok then
            Library:Notify("Ссылка на наш Telegram скопирована!")
        else
            Library:Notify("Копирование не поддерживается инжектором")
        end
    end,
})

pcall(function()
    HomeGroup:AddImage("LocalAvatar", {
        Image = "rbxthumb://type=Avatar&w=420&h=420&id=" .. LocalPlayer.UserId,
        Height = 150,
    })
end)

HomeGroup:AddLabel("PULSAR 2.3 — Obsidian Edition")

local ScriptStartTime = os.clock()

local TimeLabel = HomeGroup:AddLabel("Время: " .. os.date("%H:%M:%S"))
local UptimeLabel = HomeGroup:AddLabel("Запущено: 0:00")

task.spawn(function()
    while not Library.Unloaded do
        task.wait(1)
        local t = "Время: " .. os.date("%H:%M:%S")
        pcall(function() TimeLabel:SetText(t) end)
        pcall(function() TimeLabel.Text = t end)
        pcall(function() TimeLabel.TextLabel.Text = t end)

        local secs = math.floor(os.clock() - ScriptStartTime)
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        local up
        if h > 0 then
            up = string.format("%d:%02d:%02d", h, m, s)
        else
            up = string.format("%d:%02d", m, s)
        end
        local u = "Запущено: " .. up
        pcall(function() UptimeLabel:SetText(u) end)
        pcall(function() UptimeLabel.Text = u end)
        pcall(function() UptimeLabel.TextLabel.Text = u end)

        local p = "Игроков в сервере: " .. #Players:GetPlayers()
        pcall(function() PlayersLabel:SetText(p) end)
        pcall(function() PlayersLabel.Text = p end)
        pcall(function() PlayersLabel.TextLabel.Text = p end)
    end
end)

local function CopyText(text)
    if type(text) ~= "string" or text == "" then return false end
    local ok = pcall(function() setclipboard(text) end)
    if not ok then
        ok = pcall(function() toclipboard(text) end)
    end
    return ok
end

local PlayerImages = {}
local function BuildPlayerValues()
    local values = {}
    PlayerImages = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        values[#values + 1] = plr.Name
        PlayerImages[plr.Name] = "rbxthumb://type=AvatarHeadShot&w=48&h=48&id=" .. plr.UserId
    end
    return values
end

HomeGroup:AddButton({
    Text = "Список игроков",
    Func = function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            names[#names + 1] = "• " .. plr.Name
        end
        local ok = pcall(function()
            Window:AddDialog("PlayerList", {
                Title = "Игроки в сервере (" .. #names .. ")",
                Description = table.concat(names, "\n"),
                AutoDismiss = true,
                OutsideClickDismiss = true,
                FooterButtons = {
                    Confirm = {
                        Title = "Закрыть",
                        Variant = "Primary",
                        Callback = function() end,
                    },
                },
            })
        end)
        if not ok then
            Library:Notify("Список уже открыт")
        end
    end
})

HomeGroup:AddDropdown("CopyPlayerDropdown", {
    Values = BuildPlayerValues(),
    ValueImages = PlayerImages,
    Multi = true,
    AllowNull = true,
    Searchable = true,
    MaxVisibleDropdownItems = 4,
    Text = "Игроки (аватарки)",
    Callback = function() end,
})

local function RefreshPlayerList()
    local opts = Library.Options and Library.Options.CopyPlayerDropdown
    if not opts then return end
    local values = BuildPlayerValues()
    pcall(function() opts.ValueImages = PlayerImages end)
    local ok = pcall(function() opts:SetValues(values) end)
    if not ok then
        pcall(function() opts.Values = values end)
    end
    pcall(function() opts:SetValue(nil) end)
end

Players.PlayerAdded:Connect(function() task.defer(RefreshPlayerList) end)
Players.PlayerRemoving:Connect(function() task.defer(RefreshPlayerList) end)

HomeGroup:AddButton({
    Text = "Копировать ник",
    Func = function()
        local val = nil
        pcall(function() val = Library.Options.CopyPlayerDropdown.Value end)
        local name = nil
        if type(val) == "table" then
            local opts = Library.Options.CopyPlayerDropdown
            local values = opts and opts.Values
            for _, v in ipairs(values or {}) do
                if val[v] then name = v break end
            end
            if not name then
                for n in pairs(val) do
                    if type(n) == "string" then name = n break end
                end
            end
        elseif type(val) == "string" then
            name = val
        end
        if type(name) ~= "string" or name == "" then
            Library:Notify("Сначала выбери игрока в списке выше")
            return
        end
        if CopyText(name) then
            Library:Notify("Скопировано: " .. name)
        else
            Library:Notify("Копирование не поддерживается инжектором")
        end
    end
})

HomeGroup:AddButton({
    Text = "Копировать все ники",
    Func = function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            names[#names + 1] = plr.Name
        end
        if CopyText(table.concat(names, "\n")) then
            Library:Notify("Скопировано ников: " .. #names)
        else
            Library:Notify("Копирование не поддерживается инжектором")
        end
    end
})

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local ShaderPresets = {
    ["Scarlet Atmosphere"] = {
        Lighting = { Brightness=2.14, ColorShift_Bottom=Color3.fromRGB(11,0,20), ColorShift_Top=Color3.fromRGB(240,127,14), OutdoorAmbient=Color3.fromRGB(34,0,49), ClockTime=6.7, FogColor=Color3.fromRGB(94,76,106), FogEnd=1000, FogStart=0, ExposureCompensation=0.24, ShadowSoftness=0, Ambient=Color3.fromRGB(59,33,27) },
        Bloom={Intensity=0.1,Threshold=0,Size=100}, Blur={Size=2},
        ColorCorrection={Saturation=0.05,TintColor=Color3.fromRGB(255,224,219)},
        SunRays={Intensity=0.05},
    },
    ["Golden Hour"] = {
        Lighting = { Brightness=1.8, ClockTime=17.8, FogEnd=100000, ExposureCompensation=-0.03, ShadowSoftness=0.6, Ambient=Color3.fromRGB(38,38,42), OutdoorAmbient=Color3.fromRGB(155,155,170), ColorShift_Top=Color3.fromRGB(255,210,160) },
        Bloom={Intensity=0.55,Threshold=0.95,Size=42},
        ColorCorrection={Brightness=0.03,Saturation=0.16,Contrast=0.44,TintColor=Color3.fromRGB(255,230,200)},
        SunRays={Intensity=0.18,Spread=0.9},
        Atmosphere={Density=0.32,Offset=0.15,Haze=1.4,Glare=0.35,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Dreamy"] = {
        Lighting = { Brightness=2, ClockTime=16.8, FogEnd=100000, ExposureCompensation=0.08, ShadowSoftness=0.9, Ambient=Color3.fromRGB(61,61,68) },
        Bloom={Intensity=0.9,Threshold=0.75,Size=70}, Blur={Size=0.35},
        ColorCorrection={Brightness=0.06,Saturation=0.18,Contrast=0.17,TintColor=Color3.fromRGB(255,230,255)},
        SunRays={Intensity=0.08,Spread=0.65},
        Atmosphere={Density=0.28,Offset=0.15,Haze=1.4,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},    },
    ["Синтивейв"] = {
        Lighting = { Brightness=2.3, ClockTime=18.3, FogEnd=3500, FogStart=0, FogColor=Color3.fromRGB(180,80,200), ExposureCompensation=0.15, ShadowSoftness=0.3, Ambient=Color3.fromRGB(90,40,120), ColorShift_Bottom=Color3.fromRGB(70,0,95), ColorShift_Top=Color3.fromRGB(255,110,230), OutdoorAmbient=Color3.fromRGB(150,60,140) },
        Bloom={Intensity=0.9,Threshold=0.75,Size=60},
        ColorCorrection={Saturation=0.35,Contrast=0.25,TintColor=Color3.fromRGB(255,205,255)},
        SunRays={Intensity=0.12,Spread=0.7},
        Atmosphere={Density=0.35,Offset=0.15,Haze=2.0,Glare=0.3,Color=Color3.fromRGB(255,150,220),Decay=Color3.fromRGB(140,60,150)},
    },
    ["Lavender Fields"] = {
        Lighting = { Brightness=1.9, ClockTime=19, FogEnd=6000, FogColor=Color3.fromRGB(170,150,200), ExposureCompensation=0.04, ShadowSoftness=0.6, Ambient=Color3.fromRGB(75,65,100), OutdoorAmbient=Color3.fromRGB(140,125,170), ColorShift_Top=Color3.fromRGB(205,165,255) },
        Bloom={Intensity=0.6,Threshold=0.74,Size=52},
        ColorCorrection={Brightness=0.03,Saturation=0.2,Contrast=0.18,TintColor=Color3.fromRGB(232,218,255)},
        SunRays={Intensity=0.1,Spread=0.75},
        Atmosphere={Density=0.3,Offset=0.15,Haze=1.5,Glare=0.25,Color=Color3.fromRGB(215,195,255),Decay=Color3.fromRGB(140,110,180)},
    },
    ["Slender"] = {
        Lighting = { Brightness=1.6, ClockTime=7, FogEnd=300, FogStart=0, FogColor=Color3.fromRGB(200,200,200), ExposureCompensation=0.05, ShadowSoftness=0.9, Ambient=Color3.fromRGB(140,140,140), OutdoorAmbient=Color3.fromRGB(175,175,175), ColorShift_Bottom=Color3.fromRGB(150,150,150), ColorShift_Top=Color3.fromRGB(215,215,215) },
        Bloom={Intensity=0.25,Threshold=0.9,Size=30},
        ColorCorrection={Brightness=0.03,Saturation=-0.55,Contrast=0.15,TintColor=Color3.fromRGB(235,235,235)},
        SunRays={Intensity=0,Spread=0.5},
        Atmosphere={Density=0.85,Offset=0.1,Haze=3.5,Glare=0.1,Color=Color3.fromRGB(210,210,210),Decay=Color3.fromRGB(160,160,160)},
    },
}

local ShaderOrder = { "Scarlet Atmosphere", "Golden Hour", "Dreamy", "Синтивейв", "Lavender Fields", "Slender" }

local Original = { Lighting = {}, Sky = nil, Atmosphere = nil, Saved = false }
local ActiveEffects = {}

local function SaveOriginal()
    if Original.Saved then return end
    Original.Saved = true
    local L = Original.Lighting
    L.Brightness = Lighting.Brightness
    L.ColorShift_Bottom = Lighting.ColorShift_Bottom
    L.ColorShift_Top = Lighting.ColorShift_Top
    L.OutdoorAmbient = Lighting.OutdoorAmbient
    L.ClockTime = Lighting.ClockTime
    L.FogColor = Lighting.FogColor
    L.FogEnd = Lighting.FogEnd
    L.FogStart = Lighting.FogStart
    L.ExposureCompensation = Lighting.ExposureCompensation
    L.ShadowSoftness = Lighting.ShadowSoftness
    L.Ambient = Lighting.Ambient
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        Original.Sky = {
            SkyboxBk=sky.SkyboxBk, SkyboxDn=sky.SkyboxDn, SkyboxFt=sky.SkyboxFt,
            SkyboxLf=sky.SkyboxLf, SkyboxRt=sky.SkyboxRt, SkyboxUp=sky.SkyboxUp,
            StarCount=sky.StarCount, SunAngularSize=sky.SunAngularSize,
            MoonAngularSize=sky.MoonAngularSize, CelestialBodiesShown=sky.CelestialBodiesShown,
        }
    end
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then
        Original.Atmosphere = { Density=atm.Density, Offset=atm.Offset, Haze=atm.Haze, Glare=atm.Glare, Color=atm.Color, Decay=atm.Decay }
    end
end

local function DestroyEffects()
    for i = #ActiveEffects, 1, -1 do
        local e = ActiveEffects[i]
        if e and e.Parent then e:Destroy() end
        ActiveEffects[i] = nil
    end
end

local function RestoreOriginal()
    for k, v in pairs(Original.Lighting) do Lighting[k] = v end
    if Original.Sky then
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        for k, v in pairs(Original.Sky) do sky[k] = v end
        sky.Parent = Lighting
    end
    if Original.Atmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if atm then
            for k, v in pairs(Original.Atmosphere) do atm[k] = v end
        end
    end
end

local function lerpNum(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t)
    local r = a.R + (b.R - a.R) * t
    local g = a.G + (b.G - a.G) * t
    local bl = a.B + (b.B - a.B) * t
    if r < 0 then r = 0 elseif r > 1 then r = 1 end
    if g < 0 then g = 0 elseif g > 1 then g = 1 end
    if bl < 0 then bl = 0 elseif bl > 1 then bl = 1 end
    return Color3.new(r, g, bl)
end

local ShaderState = { Active = false, CurrentName = "Scarlet Atmosphere", Level = 8 }

local function ApplyShader(shaderName, level)
    SaveOriginal()
    DestroyEffects()
    RestoreOriginal()
    local preset = ShaderPresets[shaderName]
    if not preset then return false end

    level = math.clamp(tonumber(level) or 8, 0, 10)
    local t = level / 10
    local orig = Original.Lighting
    local L = preset.Lighting

    if L.Brightness then Lighting.Brightness = lerpNum(orig.Brightness, L.Brightness, t) end
    if L.ClockTime then Lighting.ClockTime = lerpNum(orig.ClockTime, L.ClockTime, t) end
    if L.FogEnd then Lighting.FogEnd = lerpNum(orig.FogEnd, L.FogEnd, t) end
    if L.FogStart then Lighting.FogStart = lerpNum(orig.FogStart, L.FogStart, t) end
    if L.ExposureCompensation then Lighting.ExposureCompensation = lerpNum(orig.ExposureCompensation, L.ExposureCompensation, t) end
    if L.ShadowSoftness then Lighting.ShadowSoftness = lerpNum(orig.ShadowSoftness, L.ShadowSoftness, t) end
    if L.ColorShift_Bottom then Lighting.ColorShift_Bottom = lerpColor(orig.ColorShift_Bottom, L.ColorShift_Bottom, t) end
    if L.ColorShift_Top then Lighting.ColorShift_Top = lerpColor(orig.ColorShift_Top, L.ColorShift_Top, t) end
    if L.OutdoorAmbient then Lighting.OutdoorAmbient = lerpColor(orig.OutdoorAmbient, L.OutdoorAmbient, t) end
    if L.FogColor then Lighting.FogColor = lerpColor(orig.FogColor, L.FogColor, t) end
    if L.Ambient then Lighting.Ambient = lerpColor(orig.Ambient, L.Ambient, t) end

    if preset.Bloom then
        local b = Instance.new("BloomEffect", Lighting)
        b.Name = "SavitarBloom"
        b.Intensity = preset.Bloom.Intensity * t
        b.Threshold = preset.Bloom.Threshold
        b.Size = preset.Bloom.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    if preset.Blur then
        local b = Instance.new("BlurEffect", Lighting)
        b.Name = "SavitarBlur"
        b.Size = preset.Blur.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    local ccData = preset.CC or preset.ColorCorrection
    if ccData then
        local cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "SavitarCC"
        cc.Brightness = (ccData.Brightness or 0) * t
        cc.Saturation = (ccData.Saturation or 0) * t
        cc.Contrast = (ccData.Contrast or 0) * t
        cc.TintColor = lerpColor(Color3.new(1,1,1), ccData.TintColor or Color3.new(1,1,1), t)
        ActiveEffects[#ActiveEffects+1] = cc
    end
    if preset.SunRays then
        local sr = Instance.new("SunRaysEffect", Lighting)
        sr.Name = "SavitarSR"
        sr.Intensity = (preset.SunRays.Intensity or 0) * t
        sr.Spread = preset.SunRays.Spread or 0.65
        ActiveEffects[#ActiveEffects+1] = sr
    end
    if preset.Atmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atm then
            atm = Instance.new("Atmosphere", Lighting)
            atm.Name = "SavitarAtm"
            ActiveEffects[#ActiveEffects+1] = atm
        end
        local A = preset.Atmosphere
        local base = Original.Atmosphere or { Density=0.22, Offset=0.15, Haze=0.8, Glare=0.15, Color=Color3.fromRGB(200,210,255), Decay=Color3.fromRGB(100,110,130) }
        atm.Density = lerpNum(base.Density, A.Density, t)
        atm.Offset = lerpNum(base.Offset, A.Offset, t)
        atm.Haze = lerpNum(base.Haze, A.Haze, t)
        atm.Glare = lerpNum(base.Glare, A.Glare, t)
        atm.Color = lerpColor(base.Color, A.Color, t)
        atm.Decay = lerpColor(base.Decay, A.Decay, t)
    end
    if shaderName == "Scarlet Atmosphere" then
        local sky = Instance.new("Sky", Lighting)
        sky.Name = "SavitarSky"
        sky.SkyboxUp = "rbxassetid://323493360"
        sky.SkyboxLf = "rbxassetid://323494252"
        sky.SkyboxBk = "rbxassetid://323494035"
        sky.SkyboxFt = "rbxassetid://323494130"
        sky.SkyboxDn = "rbxassetid://323494368"
        sky.SkyboxRt = "rbxassetid://323494067"
        sky.SunAngularSize = 14
        ActiveEffects[#ActiveEffects+1] = sky
    end
    if shaderName == "Синтивейв" then
        local swSky = Instance.new("Sky", Lighting)
        swSky.Name = "SavitarSynthSky"
        swSky.SkyboxUp = "rbxassetid://323493360"
        swSky.SkyboxLf = "rbxassetid://323494252"
        swSky.SkyboxBk = "rbxassetid://323494035"
        swSky.SkyboxFt = "rbxassetid://323494130"
        swSky.SkyboxDn = "rbxassetid://323494368"
        swSky.SkyboxRt = "rbxassetid://323494067"
        swSky.SunAngularSize = 30
        swSky.StarCount = 1500
        ActiveEffects[#ActiveEffects+1] = swSky
    end

    ShaderState.Active = true
    ShaderState.CurrentName = shaderName
    ShaderState.Level = level
    return true
end

local function RemoveShader()
    DestroyEffects()
    RestoreOriginal()
    ShaderState.Active = false
end

local SoundService = game:GetService("SoundService")

local PulsarSoundMuteOff
local GfxUnload
local PulsarMusicStop
local PulsarCustomSkyOff
local PulsarTargetStop

local function VisualsCleanup()
    if PulsarSoundMuteOff then pcall(PulsarSoundMuteOff) end
    RemoveShader()
    if PulsarCustomSkyOff then pcall(PulsarCustomSkyOff) end
    if GfxUnload then pcall(GfxUnload) end
    if PulsarMusicStop then pcall(PulsarMusicStop) end
    if PulsarTargetStop then pcall(PulsarTargetStop) end
    pcall(function() LockGui:Destroy() end)
end

pcall(function()
    Library:OnUnload(VisualsCleanup)
end)

local MusicTracks = {
    ["TOMA FUNK PHONK"] = 129098116998483,
    ["AURA = ∞ (Brazilian Phonk)"] = 95131770144654,
    ["ROBLOX PHONK"] = 136932193331774,
    ["FUNK FESTA"] = 103409297553965,
    ["DRIFT NIGHT PHONK (Car Motion Edit)"] = 85735197482652,
    ["Rat Dance Phonk"] = 119598380829349,
    ["Lost Phonk"] = 139266399633943,
    ["Noisestorm - Crab Rave"] = 5410086218,
    ["LIKE THE MOONLIGHT (Funky House Mix)"] = 111560286322896,
    ["sad violin"] = 135308045,
    ["Funky Stepper"] = 1835422714,
    ["Terranova"] = 1835422879,
    ["Russian Run"] = 1836175982,
    ["Russian Sorrow"] = 1836176147,
    ["Russian Celebration"] = 1836732530,
    ["Tokyo Drift"] = 1837015626,
    ["Paradise Falls"] = 1837879082,
    ["Clair De Lune"] = 1838457617,
    ["Russian Folk Dance"] = 1840183276,
    ["Soviet March"] = 1841140365,
    ["Life in an Elevator"] = 1841647093,
    ["Believer"] = 1845016505,
    ["Montage No. 19"] = 1845091827,
    ["Schweben Im Raum"] = 1845728301,
    ["Town Talk"] = 1845756489,
    ["National Anthem Of China B"] = 1845918434,
    ["Kalinka"] = 1845924062,
    ["Morning Mood (peer Gynt Suite No.1)"] = 1846088038,
    ["Wake Up"] = 1846293018,
    ["The Nutcracker (D) Russian Dance"] = 1846627685,
    ["Nutcracker Suite Op.71a, The @ Russian Dance"] = 1848059091,
    ["Horror"] = 9039981149,
    ["State Anthem of the Russian Federation (a)"] = 9040163991,
    ["State Anthem of the Russian Federation (b 60)"] = 9040168257,
    ["Just a Russian Waltz - No intro"] = 9044560194,
    ["Phonk Vol. 2 - The Final Phonk"] = 14145620056,
    ["PHONK DRIFT"] = 72653741821355,
    ["alone"] = 75485931767123,
    ["SHADOW PHONK BRAZIL (Dark Atmosphere Edit)"] = 77701977147898,
    ["Wheel"] = 87871612084824,
    ["Miguel Phonk"] = 92299938059573,
    ["Bao Bao"] = 95796504549340,
    ["ELECTRIC PHANTOM (Phonk)"] = 103415930328599,
    ["Rogue City Phonk"] = 111109407506851,
    ["Tung Tung Tung Sahur Phonk"] = 128438366056581,
    ["TIKI TIKI FUNK (Sped Up)"] = 128510578554487,
    ["Phonk Roblox Meme"] = 135209837340816,
    ["Blood on the Asphalt"] = 140439256760765,
    ["Football Edit – Phonk Trap"] = 140504265985079,
    ["Voltstorm (Overload Phonk Energy)"] = 140580823167015,
    ["Desprezo, (Aggressive Phonk), Slowed + Reverb"] = 140667339171815,
    ["HYDERABADI PHONK (MARFA STYLE)"] = 140691985128867,
    ["Elpaparon"] = 121336955981923,
    ["test1"] = 86255623393834,
    ["Лава Лава"] = 115410878431589,
    ["russian mem"] = 128015593975204,
}

local MusicPlayer = { Sound = nil, Track = nil, Volume = 50, Paused = false, CustomName = nil }
local MusicPlayBtn, NowPlayingLabel = nil, nil
local MusicPlay = nil

local MusicHeadOn = false
local function MusicHeadAttach()
    pcall(function()
        local s = MusicPlayer.Sound
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        if MusicHeadOn and s and head then
            s.Parent = head
            s.RollOffMode = Enum.RollOffMode.InverseTapered
            s.RollOffMaxDistance = 60
        end
    end)
end
local function MusicHeadDetach()
    pcall(function()
        local s = MusicPlayer.Sound
        if s then
            s.Parent = SoundService
            s.RollOffMaxDistance = 10000
        end
    end)
end

local function SetPlayBtnText(text)
    if MusicPlayBtn then
        pcall(function() MusicPlayBtn:SetText(text) end)
    end
end

local function MusicStop()
    if MusicPlayer.Sound then
        pcall(function() MusicPlayer.Sound:Stop() end)
        pcall(function() MusicPlayer.Sound:Destroy() end)
        MusicPlayer.Sound = nil
    end
    MusicPlayer.Paused = false
    SetPlayBtnText("▶")
    pcall(function() NowPlayingLabel:SetText("🎵 Трек не играет") end)
end
PulsarMusicStop = MusicStop

local function MusicTogglePlay()
    local s = MusicPlayer.Sound
    if s then
        if MusicPlayer.Paused then
            pcall(function() s:Resume() end)
            MusicPlayer.Paused = false
            SetPlayBtnText("| |")
        else
            pcall(function() s:Pause() end)
            MusicPlayer.Paused = true
            SetPlayBtnText("▶")
        end
        return
    end
    MusicPlay()
end

local function MusicSkip(dir)
    local order = {}
    for name in pairs(MusicTracks) do
        order[#order + 1] = name
    end
    if #order == 0 then
        Library:Notify("Плейлист пуст — треки добавим позже")
        return
    end
    table.sort(order)
    local idx = 1
    for i, name in ipairs(order) do
        if name == MusicPlayer.Track then idx = i break end
    end
    idx = ((idx - 1 + dir) % #order) + 1
    MusicPlayer.Track = order[idx]
    MusicPlay()
end

function MusicPlay()
    MusicStop()
    MusicPlayer.CustomName = nil
    local id = MusicTracks[MusicPlayer.Track]
    if not id then
        Library:Notify("Плейлист пуст — треки добавим позже")
        return
    end
    local s = Instance.new("Sound")
    s.Name = "PulsarMusic"
    s.SoundId = "rbxassetid://" .. id
    s.Volume = MusicPlayer.Volume / 50
    s.Parent = SoundService
    local t0 = os.clock()
    while not s.IsLoaded and os.clock() - t0 < 5 do
        task.wait(0.1)
    end
    if not s.IsLoaded or s.TimeLength == 0 then
        pcall(function() s:Destroy() end)
        Library:Notify("Трек не загрузился (ограничение Roblox)")
        return
    end
    MusicPlayer.Sound = s
    MusicPlayer.Paused = false
    s:Play()
    SetPlayBtnText("| |")
    if MusicHeadOn then task.spawn(MusicHeadAttach) end
end

local MusicGroup = TabObjects["Music"]:AddLeftGroupbox("Плеер")

NowPlayingLabel = MusicGroup:AddLabel("🎵 Трек не играет")
task.spawn(function()
    while not Library.Unloaded do
        task.wait(1)
        local s = MusicPlayer.Sound
        if s and s.IsLoaded and NowPlayingLabel then
            local pos, dur = math.floor(s.TimePosition + 0.5), math.floor(s.TimeLength + 0.5)
            local txt = string.format("🎵 %s — %d:%02d / %d:%02d", MusicPlayer.CustomName or MusicPlayer.Track or "?", pos // 60, pos % 60, dur // 60, dur % 60)
            pcall(function() NowPlayingLabel:SetText(txt) end)
            pcall(function() NowPlayingLabel.TextLabel.Text = txt end)
        end
    end
end)
local MusicOrder = {}
for name in pairs(MusicTracks) do
    MusicOrder[#MusicOrder + 1] = name
end
table.sort(MusicOrder)

MusicGroup:AddDropdown("PulsarMusicTrack", {
    Values = MusicOrder,
    Multi = false,
    AllowNull = true,
    Searchable = true,
    Text = "Трек",
    Callback = function(value)
        if type(value) ~= "string" or not MusicTracks[value] then return end
        MusicPlayer.Track = value
        MusicPlay()
    end,
})

MusicGroup:AddSlider("PulsarMusicVolume", {
    Text = "Громкость (%)",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(v)
        MusicPlayer.Volume = v
        if MusicPlayer.Sound then
            pcall(function() MusicPlayer.Sound.Volume = v / 50 end)
        end
    end,
})

MusicGroup:AddToggle("PulsarMusicHead", {
    Text = "🔊 Музыка над головой (слышат рядом)",
    Default = false,
    Callback = function(on)
        MusicHeadOn = on
        if on then MusicHeadAttach() else MusicHeadDetach() end
    end,
})

MusicGroup:AddInput("PulsarMusicCustomId", {
    Text = "Своя трек (ID)",
    Placeholder = "Вставь ID аудио…",
})
MusicGroup:AddButton({
    Text = "🎵 Включить свой трек",
    Func = function()
        local raw = ""
        pcall(function() raw = tostring(Library.Options.PulsarMusicCustomId.Value or "") end)
        local id = tonumber((raw:match("%d+") or ""))
        if not id then
            Library:Notify("Вставь числовой ID аудио Roblox")
            return
        end
        MusicStop()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = MusicPlayer.Volume / 50
        s.Parent = SoundService
        local t0 = os.clock()
        while not s.IsLoaded and os.clock() - t0 < 5 do
            task.wait(0.1)
        end
        if not s.IsLoaded or s.TimeLength == 0 then
            pcall(function() s:Destroy() end)
            Library:Notify("Трек не загрузился (закрыт или не существует)")
            return
        end
        MusicPlayer.Sound, MusicPlayer.Paused = s, false
        MusicPlayer.CustomName = "Свой трек (ID: " .. id .. ")"
        s:Play()
        SetPlayBtnText("| |")
        if MusicHeadOn then task.spawn(MusicHeadAttach) end
    end,
})

local PlayBtn = MusicGroup:AddButton({ Text = "▶", Func = MusicTogglePlay })
MusicPlayBtn = PlayBtn
local PrevBtn = PlayBtn:AddButton({ Text = "<<", Func = function() MusicSkip(-1) end })
local NextBtn = PlayBtn:AddButton({ Text = ">>", Func = function() MusicSkip(1) end })

pcall(function() PrevBtn.Base.LayoutOrder = 0 end)
pcall(function() PlayBtn.Base.LayoutOrder = 1 end)
pcall(function() NextBtn.Base.LayoutOrder = 2 end)

for _, btn in ipairs({ PlayBtn, PrevBtn, NextBtn }) do
    pcall(function()
        btn.Base.BackgroundColor3 = Library.Scheme.BackgroundColor
        btn.Label.TextColor3 = Color3.new(1, 1, 1)
        btn.Label.TextTransparency = 0
    end)
end

MusicGroup:AddToggle("PulsarVoiceBroadcast", {
    Text = "🎙 Транслировать по войсу",
    Default = false,
    Callback = function(on)
        if on then
            Library:Notify("В войс идёт только микрофон устройства — сам звук скриптом туда не подать", 7)
            Library:Notify("Схема: поставь Voicemeeter, выход Roblox = VAIO, микрофон в Roblox = Voicemeeter Output (B1) — и включи трек в Плеере", 10)
        end
    end,
})

local VisualTab = TabObjects["Visual"]

local currentShader = "Scarlet Atmosphere"
local currentLevel = 8

local ShaderGroup = VisualTab:AddLeftGroupbox("Shaders")

ShaderGroup:AddDropdown("SavitarShader", {
    Values = ShaderOrder,
    Default = 1,
    Multi = false,
    Text = "Шейдер",
    Callback = function(v)
        currentShader = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end,
})

ShaderGroup:AddSlider("SavitarIntensity", {
    Text = "Интенсивность",
    Default = 8,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(v)
        currentLevel = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end,
})

ShaderGroup:AddToggle("SavitarShaderOn", {
    Text = "Включить шейдер",
    Default = false,
    Callback = function(on)
        if on then
            ApplyShader(currentShader, currentLevel)
        else
            RemoveShader()
        end
    end,
})

local CustomSkySets = {
    ["☁️ Голубые облака"] = { Bk = 225469345, Dn = 225469349, Ft = 225469359, Lf = 225469364, Rt = 225469372, Up = 225469380 },
    ["🌇 Закат с холмами"] = { Bk = 92464172, Dn = 92464250, Ft = 92464217, Lf = 92464234, Rt = 92464189, Up = 92464157 },
    ["🧱 MC-небо (квадратное)"] = { MC = true },
}
local CustomSkyOrder = { "☁️ Голубые облака", "🌇 Закат с холмами", "🧱 MC-небо (квадратное)" }

local CustomSkyState = { Sky = nil, Backup = nil }
local MCState = { Root = nil, Sun = nil, Conn = nil, SavedClouds = {}, SavedSky = nil }

local function MCSkyRemove()
    if MCState.Conn then pcall(function() MCState.Conn:Disconnect() end) MCState.Conn = nil end
    if MCState.Sun then pcall(function() MCState.Sun:Destroy() end) MCState.Sun = nil end
    if MCState.Root then pcall(function() MCState.Root:Destroy() end) MCState.Root = nil end
    for c, _ in pairs(MCState.SavedClouds) do
        pcall(function() c.Enabled = true end)
    end
    MCState.SavedClouds = {}
    if MCState.SavedSky then
        pcall(function() MCState.SavedSky.CelestialBodiesShown = true end)
        MCState.SavedSky = nil
    end
end

local function MCSkyApply()
    if MCState.Root and MCState.Root.Parent then return true end
    pcall(function()
        for _, c in ipairs(workspace.Terrain:GetChildren()) do
            if c:IsA("Clouds") and c.Enabled then
                MCState.SavedClouds[c] = true
                c.Enabled = false
            end
        end
        local base = Lighting:FindFirstChildOfClass("Sky")
        if base and base.CelestialBodiesShown then
            base.CelestialBodiesShown = false
            MCState.SavedSky = base
        end
    end)
    local ok, root = pcall(function()
        local model = Instance.new("Model")
        model.Name = "PulsarMCSky"
        local cell, th, radius, height = 96, 8, 10, 340
        for cx = -radius, radius do
            for cz = -radius, radius do
                local n = (cx * 31 + cz * 17) % 10
                if n >= 4 then
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(cell, th, cell)
                    p.Position = Vector3.new(cx * cell, height + (n % 2) * 3, cz * cell)
                    p.Anchored = true
                    p.CanCollide = false
                    p.CanQuery = false
                    p.CanTouch = false
                    p.CastShadow = false
                    p.Material = Enum.Material.SmoothPlastic
                    p.Color = Color3.new(1, 1, 1)
                    p.Transparency = 0.15
                    p.Parent = model
                end
            end
        end
        model.Parent = workspace
        return model
    end)
    if not ok or not root then
        MCSkyRemove()
        return false
    end
    MCState.Root = root
    local okSun, sun = pcall(function()
        local sp = Instance.new("Part")
        sp.Name = "PulsarMCSun"
        sp.Size = Vector3.new(90, 90, 1)
        sp.Anchored = true
        sp.CanCollide = false
        sp.CanQuery = false
        sp.CanTouch = false
        sp.CastShadow = false
        sp.Material = Enum.Material.Neon
        sp.Color = Color3.fromRGB(255, 235, 160)
        sp.Parent = workspace
        return sp
    end)
    if not okSun or not sun then
        MCSkyRemove()
        return false
    end
    MCState.Sun = sun
    MCState.Conn = RunService.Heartbeat:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and sun.Parent then
            local dir = Vector3.new(0.45, 0.6, 0.25).Unit
            pcall(function()
                sun.CFrame = CFrame.lookAt(cam.CFrame.Position + dir * 900, cam.CFrame.Position)
            end)
        end
    end)
    return true
end

local function CustomSkyRemove()
    if MCSkyRemove then pcall(MCSkyRemove) end
    if CustomSkyState.Sky then
        pcall(function() CustomSkyState.Sky:Destroy() end)
        CustomSkyState.Sky = nil
    end
    local backup = CustomSkyState.Backup
    CustomSkyState.Backup = nil
    if backup then
        pcall(function()
            local sky = Instance.new("Sky")
            sky.Name = "PulsarSkyRestored"
            for k, v in pairs(backup) do sky[k] = v end
            sky.Parent = Lighting
        end)
    end
end
PulsarCustomSkyOff = CustomSkyRemove

local function CustomSkyApply(faces)
    if not faces then return false end
    CustomSkyRemove()
    if faces.MC then
        return MCSkyApply()
    end
    pcall(function()
        local old = Lighting:FindFirstChildOfClass("Sky")
        if old then
            CustomSkyState.Backup = {
                SkyboxBk = old.SkyboxBk, SkyboxDn = old.SkyboxDn, SkyboxFt = old.SkyboxFt,
                SkyboxLf = old.SkyboxLf, SkyboxRt = old.SkyboxRt, SkyboxUp = old.SkyboxUp,
                StarCount = old.StarCount, SunAngularSize = old.SunAngularSize,
            }
            old:Destroy()
        end
    end)
    local sky = Instance.new("Sky")
    sky.Name = "PulsarCustomSky"
    sky.CelestialBodiesShown = false
    sky.SkyboxBk = "rbxassetid://" .. faces.Bk
    sky.SkyboxDn = "rbxassetid://" .. faces.Dn
    sky.SkyboxFt = "rbxassetid://" .. faces.Ft
    sky.SkyboxLf = "rbxassetid://" .. faces.Lf
    sky.SkyboxRt = "rbxassetid://" .. faces.Rt
    sky.SkyboxUp = "rbxassetid://" .. faces.Up
    sky.Parent = Lighting
    CustomSkyState.Sky = sky
    return true
end

local CustomSkyGroup = VisualTab:AddLeftGroupbox("Настоящее небо")

CustomSkyGroup:AddDropdown("PulsarCustomSkyQuick", {
    Values = CustomSkyOrder,
    Default = 1,
    Multi = false,
    Text = "Набор неба",
    Callback = function() end,
})

CustomSkyGroup:AddInput("PulsarCustomSkyId", {
    Text = "Свой ID (по желанию)",
    Placeholder = "ID КАРТИНКИ (не декали)…",
})

CustomSkyGroup:AddToggle("PulsarCustomSkyOn", {
    Text = "Включить небо",
    Default = false,
    Callback = function(on)
        if on then
            local faces = nil
            local raw = ""
            pcall(function() raw = tostring(Library.Options.PulsarCustomSkyId.Value or "") end)
            local id = tonumber((raw:match("%d+") or ""))
            if id then
                faces = { Bk = id, Dn = id, Ft = id, Lf = id, Rt = id, Up = id }
            else
                local setName = nil
                pcall(function() setName = Library.Options.PulsarCustomSkyQuick.Value end)
                faces = CustomSkySets[setName or ""]
            end
            if not faces then
                Library:Notify("Выбери Набор неба или вставь ID КАРТИНКИ (не декали)")
                pcall(function() Library.Options.PulsarCustomSkyOn:SetValue(false) end)
                return
            end
            if CustomSkyApply(faces) then
                Library:Notify("Небо поставлено — вся карта видна")
            else
                Library:Notify("Не удалось создать MC-небо")
                pcall(function() Library.Options.PulsarCustomSkyOn:SetValue(false) end)
            end
        else
            CustomSkyRemove()
            Library:Notify("Своё прежнее небо возвращено")
        end
    end,
})

local TargetGroup = TabObjects["Target"]:AddLeftGroupbox("Target", "circle-user-round")
local ApplyGroup = TabObjects["Target"]:AddLeftGroupbox("Apply", "dock")
local MethodsGroup = TabObjects["Target"]:AddRightGroupbox("Method Settings", "apple")

local ResT = {
    Selected = {},
    Methods = { ["Kick"] = true, ["Void"] = true },
    DelayMode = "Normal",
    RagdollNK = true,
    AntiKickNK = true,
    EKI = false,
    NKOffset = 15,
    ServerMethod = "Circle + Lag",
    RagdollRG = false,
    Loops = { Sel = false, Serv = false },
    Tokens = {},
    KillCd = {},
    KickSrvCd = {},
    Ragdolling = false,
    VoidPart = nil,
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SNORemote = nil
local LNORemote = nil
local SpawnToyRemote = nil
local DestroyToyRemote = nil
pcall(function()
    SNORemote = ReplicatedStorage:WaitForChild("GrabEvents", 9):WaitForChild("SetNetworkOwner", 9)
end)
pcall(function()
    LNORemote = ReplicatedStorage:WaitForChild("GrabEvents", 9):WaitForChild("DestroyGrabLine", 9)
end)
pcall(function()
    SpawnToyRemote = ReplicatedStorage:WaitForChild("MenuToys", 9):WaitForChild("SpawnToyRemoteFunction", 9)
end)
pcall(function()
    DestroyToyRemote = ReplicatedStorage:WaitForChild("MenuToys", 9):WaitForChild("DestroyToy", 9)
end)

local FPDH = -500
pcall(function() FPDH = workspace.FallenPartsDestroyHeight end)

local function TChar(plr)
    local char = plr and plr.Character
    if not char then return end
    local root = char:FindFirstChild("realHrp") or char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if char.Parent and root and root.Parent and hum and hum.Parent then
        return char, root, hum
    end
end

local function TIsPartOwner(part)
    if not (part and part:IsA("BasePart")) then return false end
    if part.Name == "HumanoidRootPart" or part.Name == "Head" then
        local head = part.Parent and part.Parent:FindFirstChild("Head")
        local po = head and head:FindFirstChild("PartOwner")
        if po then return po.Value == LocalPlayer.Name end
    end
    local po = part:FindFirstChild("PartOwner") or (part.Parent and part.Parent:FindFirstChild("PartOwner", true))
    if po then return po.Value == LocalPlayer.Name end
    return false
end

local function TIsNetworkOwner(part)
    if not (part and part:IsA("BasePart")) then return false end
    local asm = part.AssemblyRootPart or part
    return not asm.Anchored and asm.ReceiveAge == 0
end

local function TGrab(part)
    if not SNORemote then
        pcall(function()
            SNORemote = ReplicatedStorage:WaitForChild("GrabEvents", 3):WaitForChild("SetNetworkOwner", 3)
        end)
    end
    local myChar, myRoot = TChar(LocalPlayer)
    if not (myRoot and part and part.Parent and part:IsA("BasePart") and SNORemote) then return end
    local base = myRoot.CFrame * CFrame.new(0, 1.593, 0)
    pcall(function()
        SNORemote:FireServer(part, CFrame.new(base.Position, part.CFrame.Position))
    end)
end

local function TSNO(part, timeout)
    if not (part and part:IsA("BasePart")) then return false end
    if TIsPartOwner(part) or TIsNetworkOwner(part) then return true end
    if not SNORemote then return false end
    local limit = timeout or 1
    local t0 = os.clock()
    while part.Parent and os.clock() - t0 < limit do
        TGrab(part)
        task.wait()
        if TIsPartOwner(part) or TIsNetworkOwner(part) then return true end
    end
    return TIsPartOwner(part) or TIsNetworkOwner(part)
end

local function TResetVelocity(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.AssemblyLinearVelocity = Vector3.zero
            obj.AssemblyAngularVelocity = Vector3.zero
        else
            for _, p in ipairs(obj:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.AssemblyLinearVelocity = Vector3.zero
                    p.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end)
end

local function TTeleport(part, cf)
    if not (part and part:IsA("BasePart") and cf) then return false end
    if part.CFrame ~= cf then part.CFrame = cf end
    TResetVelocity(part)
    return true
end

local function TRNO(part)
    if LNORemote and part then
        pcall(function() LNORemote:FireServer(part) end)
    end
end

local function TPivotTo(model, cf)
    if not (model and model:IsA("Model") and typeof(cf) == "CFrame") then return false end
    local rel = cf * model:GetPivot():Inverse()
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") and not p.Anchored then
            local asm = p.AssemblyRootPart
            if asm and not asm.Anchored then
                p.CFrame = rel * p.CFrame
            end
        end
    end
    return true
end

local function TFindNicePart(model)
    if not (model and model:IsA("Model")) then return end
    local fallback = nil
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") and p.CanQuery and not p.Anchored and p.Name ~= "Button" then
            fallback = fallback or p
            if (p.AssemblyRootPart or p) == p then return p end
        end
    end
    return fallback
end

local function TDestroyToy(model)
    if DestroyToyRemote and model and model:IsA("Model") then
        pcall(function() DestroyToyRemote:FireServer(model) end)
    end
end

local function TSpawnToy(name)
    if not SpawnToyRemote or type(name) ~= "string" then return end
    local folder = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    local existing = folder and folder:FindFirstChild(name)
    if existing then return existing end
    local myChar, myRoot = TChar(LocalPlayer)
    if not myRoot then return end
    local canSpawn = true
    pcall(function() canSpawn = LocalPlayer.CanSpawnToy.Value end)
    if canSpawn == false then return end
    local cf = myRoot.CFrame + Vector3.new(0, 15, 0)
    local pos = CFrame.new(cf.Position) + Vector3.new(0, 0, 20)
    task.spawn(function()
        pcall(function() SpawnToyRemote:InvokeServer(name, pos, Vector3.zero) end)
    end)
    local t0 = tick()
    while not existing and tick() - t0 < 1.3 do
        RunService.Heartbeat:Wait()
        folder = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        existing = folder and folder:FindFirstChild(name)
    end
    return existing
end

local function TRemoveSticky(char)
    if not (char and char.Parent) then return end
    pcall(function()
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                for _, c in ipairs(p:GetConnectedParts()) do
                    if c.Name == "StickyPart" then
                        for _, ch in ipairs(c:GetChildren()) do
                            if ch:IsA("TouchInterest") then
                                ch:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function TApproach(root)
    local myChar, myRoot, myHum = TChar(LocalPlayer)
    if not (myRoot and myHum and myHum.Health > 0 and root and root.Parent) then return nil end
    if (myRoot.Position - root.Position).Magnitude <= 40 then return nil end
    local back = myRoot.CFrame
    TTeleport(myRoot, root.CFrame - Vector3.new(0, 12, 0))
    return back
end

local function TReturn(back)
    if not back then return end
    task.delay(0.6, function()
        local myChar, myRoot = TChar(LocalPlayer)
        if myRoot and myRoot.Parent then TTeleport(myRoot, back) end
    end)
end

local function TRagdoll(char, root, hum)
    if not (char and root and hum) or ResT.Ragdolling then return false end
    local rh = hum:FindFirstChild("Ragdolled")
    if not (rh and rh.Value == false) then return false end
    ResT.Ragdolling = true
    local toy = TSpawnToy("PalletLightBrown")
    local soundPart = toy and toy:FindFirstChild("SoundPart")
    local main = soundPart and toy:FindFirstChild("Main")
    if main and soundPart and TSNO(soundPart) then
        for _, p in ipairs(toy:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
        local bp = Instance.new("BodyPosition")
        bp.Name = "PulsarRagdollBP"
        bp.D = 1500
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = Vector3.new(0, 100000, 0)
        bp.Parent = main
        local t0 = tick()
        while tick() - t0 < 0.5 do
            if soundPart.Parent then
                soundPart.Position = root.Position
                soundPart.Velocity = Vector3.new(0, -10, 0)
            end
            task.wait(0.1)
            if rh.Value or not main.Parent or not char.Parent then break end
        end
    else
        if toy then TDestroyToy(toy) end
    end
    ResT.Ragdolling = false
    return rh.Value
end

local function TGetInventory(plr)
    local inv = plr and workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    local plot = nil
    pcall(function()
        for _, plotFolder in ipairs(workspace.Plots:GetChildren()) do
            pcall(function()
                for _, signVal in ipairs(plotFolder.PlotSign.ThisPlotsOwners:GetChildren()) do
                    if signVal:IsA("StringValue") and signVal.Value == plr.Name then
                        plot = workspace.PlotItems:FindFirstChild(plotFolder.Name)
                    end
                end
            end)
        end
    end)
    return inv, plot
end

local function TBring(plr)
    local char, root, hum = TChar(plr)
    local myChar, myRoot, myHum = TChar(LocalPlayer)
    if not (root and hum and hum.Health > 0 and myRoot and myHum and myHum.Health > 0) then return end
    if not TIsNetworkOwner(root) and not TSNO(root) then return end
    local goal = myRoot.CFrame * CFrame.new(0, 0, -5)
    local parts = char:GetDescendants()
    for _ = 1, 3 do
        if not (root.Parent and char.Parent and hum.Health > 0) then break end
        TPivotTo(char, goal * root.CFrame:Inverse() * char:GetPivot())
        for _, p in ipairs(parts) do
            if p:IsA("BasePart") then TResetVelocity(p) end
        end
        RunService.Heartbeat:Wait()
    end
    if root.Parent then TRNO(root) end
    return root.Parent ~= nil and hum.Health > 0
end

local function TVoid(plr)
    local char, root, hum = TChar(plr)
    if not (hum and hum.Health ~= 0 and root and char) then return end
    local spawnLoc = workspace:FindFirstChild("SpawnLocation")
    if spawnLoc and (spawnLoc.Position - root.Position).Magnitude >= 15000 then return end
    local back = TApproach(root)
    if not TSNO(root, 2) then
        TReturn(back)
        local t = os.clock()
        if t - (ResT.NotifCd or 0) > 4 then
            ResT.NotifCd = t
            Library:Notify("Не получил жертву — подойди ближе и попробуй снова")
        end
        return
    end
    local cf = CFrame.new(0, 9e9, 0)
    TPivotTo(char, cf * root.CFrame:Inverse() * char:GetPivot())
    TTeleport(root, cf)
    root.Velocity = Vector3.new(0, 9e9, 0)
    task.delay(0.35, function()
        if root.Parent then TRNO(root) end
    end)
    TReturn(back)
end

local function TKill(plr)
    local char, root, hum = TChar(plr)
    if not (hum and hum.Health ~= 0 and root and char) or ResT.KillCd[char] then return end
    local spawnLoc = workspace:FindFirstChild("SpawnLocation")
    if spawnLoc and (spawnLoc.Position - root.Position).Magnitude >= 15000 then return end
    ResT.KillCd[char] = true
    local back = TApproach(root)
    hum.BreakJointsOnDeath = false
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
    if TSNO(root, 2) then
        pcall(function()
            workspace.FallenPartsDestroyHeight = -100
            TPivotTo(char, CFrame.new(0, -11111, 0))
        end)
        task.delay(0.5, function()
            pcall(function()
                if root.Parent then TRNO(root) end
                workspace.FallenPartsDestroyHeight = FPDH
            end)
        end)
    end
    TReturn(back)
    task.delay(1, function() ResT.KillCd[char] = nil end)
end

local function TRemoveGucci(plr)
    local myChar, myRoot, myHum = TChar(LocalPlayer)
    if not (myHum and myHum.Health > 0 and myRoot) then return end
    local char, root = TChar(plr)
    if not (char and root) then return end
    for _, seat in ipairs(char:GetChildren()) do
        if (seat:IsA("VehicleSeat") or seat:IsA("Seat")) and not seat.Occupant then
            if ResT.RagdollRG then TSNO(root, 1.5) end
            pcall(function() seat.Disabled = true end)
            pcall(function()
                local weld = seat:FindFirstChild("SeatWeld")
                if weld then weld:Destroy() end
            end)
        end
    end
    local conn = char.ChildAdded:Connect(function(c)
        if c:IsA("LocalScript") and c.Name:lower():find("control") then
            pcall(function()
                c.Enabled = false
                c:Destroy()
            end)
        end
    end)
    task.delay(4, function()
        pcall(function() conn:Disconnect() end)
    end)
end

local function TFixGucci()
    for plr in pairs(ResT.Selected) do
        if plr and plr.Parent then
            local char = plr.Character
            if char then
                for _, c in ipairs(char:GetChildren()) do
                    if c:IsA("Seat") or c:IsA("VehicleSeat") then pcall(function() c.Disabled = false end) end
                end
            end
            local inv, plot = TGetInventory(plr)
            for _, holder in ipairs({ inv, plot }) do
                if holder then
                    for _, toy in ipairs(holder:GetChildren()) do
                        pcall(function()
                            for _, c in ipairs(toy:GetDescendants()) do
                                if c:IsA("Seat") or c:IsA("VehicleSeat") then c.Disabled = false end
                            end
                        end)
                    end
                end
            end
        end
    end
    Library:Notify("Сиденья восстановлены у выбранных игроков")
end

local function TEatFood(plr)
    local inv = plr and workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    local char, root = TChar(plr)
    if not (inv and char and root) then return end
    for _, toy in ipairs(inv:GetChildren()) do
        if toy:IsA("Model") and toy.Name:lower():find("food") then
            local main = toy:FindFirstChild("Main") or TFindNicePart(toy)
            if main and TSNO(main) then
                for _ = 1, 3 do
                    if not toy.Parent or not root.Parent then break end
                    TTeleport(main, root.CFrame)
                    RunService.Heartbeat:Wait()
                end
            end
        end
    end
end

local function TDelSeats(plr)
    local inv, plot = TGetInventory(plr)
    for _, holder in ipairs({ inv, plot }) do
        if holder then
            for _, toy in ipairs(holder:GetChildren()) do
                if toy:IsA("Model") then
                    local seat = toy:FindFirstChildWhichIsA("VehicleSeat", true) or toy:FindFirstChildWhichIsA("Seat", true)
                    if seat and not seat.Occupant then
                        TDestroyToy(toy)
                    end
                end
            end
        end
    end
end

local function TKickServer(useCooldown)
    if ResT.Running then return false end
    local now = os.clock()
    local targets = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch, rt, hum = TChar(plr)
            if hum and hum.Health > 0 then
                local cdOk = not useCooldown or now - (ResT.KickSrvCd[plr] or -math.huge) >= 15
                if cdOk then targets[#targets + 1] = plr end
            end
        end
    end
    if #targets == 0 then return false end
    local myChar, myRoot, myHum = TChar(LocalPlayer)
    if not (myRoot and myHum and myHum.Health > 0) then return false end
    ResT.Running = true
    local pos = myRoot.Position
    local holds = {}
    local conn = RunService.Heartbeat:Connect(function()
        for part, cf in pairs(holds) do
            if part.Parent then
                part.CFrame = cf
                TResetVelocity(part)
            else
                holds[part] = nil
            end
        end
    end)
    local roots = {}
    for i, plr in ipairs(targets) do
        local ch, rt, hum = TChar(plr)
        if rt and hum and hum.Health > 0 then
            if useCooldown then ResT.KickSrvCd[plr] = os.clock() end
            if TSNO(rt) then
                local ang = i / #targets * math.pi * 2
                roots[#roots + 1] = rt
                holds[rt] = CFrame.new(pos + Vector3.new(math.cos(ang) * 15, ResT.NKOffset, math.sin(ang) * 15))
                TTeleport(rt, holds[rt])
            end
        end
    end
    for i, rt in ipairs(roots) do
        local ang = i / #roots * math.pi * 2
        holds[rt] = CFrame.new(pos + Vector3.new(math.cos(ang) * 15, ResT.NKOffset, math.sin(ang) * 15))
    end
    RunService.Heartbeat:Wait()
    task.spawn(function()
        local t = os.clock() + 3
        while os.clock() < t do RunService.Heartbeat:Wait() end
        pcall(function() conn:Disconnect() end)
    end)
    task.wait(0.15)
    for _, rt in ipairs(roots) do
        if rt.Parent then TRNO(rt) end
    end
    for _, rt in ipairs(roots) do
        if rt.Parent then task.spawn(TRemoveSticky, rt.Parent) end
    end
    task.wait(6)
    ResT.Running = false
    return #roots > 0
end

local function TGetTargets(isServer)
    local list = {}
    if isServer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then table.insert(list, plr) end
        end
    else
        for plr in pairs(ResT.Selected) do
            if plr and plr.Parent and plr.Character then
                table.insert(list, plr)
            else
                ResT.Selected[plr] = nil
            end
        end
    end
    return list
end

local function TProcessPlayer(plr, isLoop, isServer)
    local char, root, hum = TChar(plr)
    if not char then return end
    if ResT.Methods["Remove Invisibility"] and root then
        pcall(function() root.Massless = false end)
    end
    if ResT.Methods.Bring then pcall(TBring, plr) end
    local kickAsVoid = ResT.Methods.Kick and ((isServer and ResT.ServerMethod == "Void") or (not isServer and not isLoop))
    if kickAsVoid then pcall(TVoid, plr) end
    if ResT.Methods.Kill then pcall(TKill, plr) end
    if ResT.Methods.Void then pcall(TVoid, plr) end
    if ResT.Methods["Remove Gucci"] then pcall(TRemoveGucci, plr) end
    if ResT.Methods["Destroy Food"] then pcall(TEatFood, plr) end
    if ResT.Methods["Delete Seatables"] then pcall(TDelSeats, plr) end
    if isLoop and ResT.Methods.Kick then
        if ResT.AntiKickNK then pcall(TRemoveSticky, char) end
        if ResT.RagdollNK then pcall(TRagdoll, char, root, hum) end
    end
end

local function TStartLoop(key, isServer)
    ResT.Tokens[key] = (ResT.Tokens[key] or 0) + 1
    local tok = ResT.Tokens[key]
    task.spawn(function()
        while ResT.Loops[key] and ResT.Tokens[key] == tok do
            local circleLag = isServer and ResT.Methods.Kick and ResT.ServerMethod == "Circle + Lag"
            if circleLag then
                pcall(TKickServer, true)
            end
            for _, plr in ipairs(TGetTargets(isServer)) do
                if not (ResT.Loops[key] and ResT.Tokens[key] == tok) then break end
                pcall(TProcessPlayer, plr, true, isServer)
                if not (ResT.Loops[key] and ResT.Tokens[key] == tok) then break end
                task.wait()
            end
            if circleLag then task.wait(9) end
            task.wait()
        end
    end)
end

PulsarTargetStop = function()
    ResT.Loops.Sel = false
    ResT.Loops.Serv = false
    ResT.Tokens.Sel = (ResT.Tokens.Sel or 0) + 1
    ResT.Tokens.Serv = (ResT.Tokens.Serv or 0) + 1
    if ResT.VoidPart then
        pcall(function() ResT.VoidPart:Destroy() end)
        ResT.VoidPart = nil
    end
end

TargetGroup:AddDropdown("TargetPlayers", {
    Values = BuildPlayerValues(),
    ValueImages = PlayerImages,
    Multi = true,
    AllowNull = true,
    Searchable = true,
    Text = "Targets",
    Callback = function(v)
        ResT.Selected = {}
        for name in pairs(v or {}) do
            local plr = Players:FindFirstChild(name)
            if plr then ResT.Selected[plr] = true end
        end
    end,
})

local function RefreshTargetPlayers()
    local opts = Library.Options and Library.Options.TargetPlayers
    if not opts then return end
    local values = BuildPlayerValues()
    pcall(function() opts.ValueImages = PlayerImages end)
    local ok = pcall(function() opts:SetValues(values) end)
    if not ok then pcall(function() opts.Values = values end) end
end

Players.PlayerAdded:Connect(function() task.defer(RefreshTargetPlayers) end)
Players.PlayerRemoving:Connect(function() task.defer(RefreshTargetPlayers) end)

TargetGroup:AddButton({
    Text = "Тест захвата",
    Tooltip = "Проверяет ремоут и захват выбранной жертвы — скажи, что напишет",
    Func = function()
        local plr = next(ResT.Selected)
        if not plr then
            Library:Notify("Тест: сначала выбери жертву в Targets")
            return
        end
        local char, root, hum = TChar(plr)
        if not root then
            Library:Notify("Тест: у жертвы нет персонажа")
            return
        end
        local myChar, myRoot = TChar(LocalPlayer)
        local dist = (myRoot and root) and math.floor((myRoot.Position - root.Position).Magnitude) or -1
        Library:Notify("Тест: ремоут SetNetworkOwner " .. (SNORemote and "найден" or "НЕ найден"))
        Library:Notify("Тест: дистанция " .. dist .. " стадов")
        task.spawn(function()
            local got = TSNO(root, 2)
            Library:Notify("Тест: захват " .. (got and "OK" or "НЕ удался"))
        end)
    end,
})

TargetGroup:AddButton({
    Text = "Добавить игрока под курсором",
    Func = function()
        local target = LocalPlayer:GetMouse().Target
        if not (target and target.Parent) then return end
        local plr = Players:FindFirstChild(target.Parent.Name)
        if not plr or plr == LocalPlayer then return end
        local opts = Library.Options and Library.Options.TargetPlayers
        if not (opts and opts.SetValue) then return end
        local cur = {}
        pcall(function()
            for k, val in pairs(opts.Value) do
                if k ~= plr.Name then cur[k] = val end
            end
        end)
        if cur[plr.Name] then
            Library:Notify(("Убрал %s из Target"):format(plr.Name))
        else
            cur[plr.Name] = true
            Library:Notify(("Выбрал %s в Target!"):format(plr.Name))
        end
        pcall(function() opts:SetValue(cur) end)
    end,
})

ApplyGroup:AddToggle("TargetLoopSel", {
    Text = "Loop Apply Method Selected",
    Default = false,
    Tooltip = "Крутит выбранные методы по выбранным игрокам",
    Callback = function(v)
        ResT.Loops.Sel = v
        if v then TStartLoop("Sel", false) end
    end,
})

ApplyGroup:AddToggle("TargetLoopServ", {
    Text = "Loop Apply Method Server",
    Default = false,
    Tooltip = "Крутит выбранные методы по всему серверу",
    Callback = function(v)
        ResT.Loops.Serv = v
        if v then TStartLoop("Serv", true) end
    end,
})

ApplyGroup:AddButton({
    Text = "Apply Method Selected",
    Func = function()
        task.spawn(function()
            for _, plr in ipairs(TGetTargets(false)) do
                pcall(TProcessPlayer, plr, false, false)
            end
        end)
    end,
})

ApplyGroup:AddButton({
    Text = "Apply Method Server",
    Func = function()
        task.spawn(function()
            if ResT.Methods.Kick and ResT.ServerMethod == "Circle + Lag" then
                pcall(TKickServer, false)
            end
            for _, plr in ipairs(TGetTargets(true)) do
                pcall(TProcessPlayer, plr, false, true)
            end
        end)
    end,
})

MethodsGroup:AddDropdown("TargetMethods", {
    Values = { "Kick", "Void", "Kill", "Bring", "Destroy Food", "Remove Gucci", "Remove Invisibility", "Delete Seatables" },
    Multi = true,
    AllowNull = true,
    Default = { "Kick", "Void" },
    Text = "Methods",
    Callback = function(v)
        ResT.Methods = {}
        for name, on in pairs(v or {}) do
            if on then ResT.Methods[name] = true end
        end
    end,
})

local KickBox = MethodsGroup
pcall(function()
    local dep = MethodsGroup:AddDependencyBox()
    dep:SetupDependencies({ { Library.Options.TargetMethods, "Kick" } })
    KickBox = dep
end)

KickBox:AddDivider()
KickBox:AddLabel("Kick Settings")
KickBox:AddDropdown("NKDelayConf", {
    Values = { "Normal", "Faster but worse" },
    Multi = false,
    Default = 1,
    Text = "Delay Mode",
    Callback = function(v) ResT.DelayMode = v end,
})
KickBox:AddToggle("RagdollNK", {
    Text = "Loop Ragdoll",
    Default = true,
    Callback = function(v) ResT.RagdollNK = v end,
})
KickBox:AddToggle("AntiKickRemoverNK", {
    Text = "Remove Anti-Kick",
    Default = true,
    Callback = function(v) ResT.AntiKickNK = v end,
})
KickBox:AddToggle("EKIToggle", {
    Text = "Experimental Kick Improvements [BETA]",
    Default = false,
    Risky = true,
    Tooltip = "Улучшает кик, но бывает багованным",
    Disabled = typeof(sethiddenproperty) ~= "function",
    Callback = function(v) ResT.EKI = v end,
})
KickBox:AddSlider("HeightNK", {
    Text = "Kick Height",
    Default = 15,
    Min = 0,
    Max = 28,
    Rounding = 0,
    Callback = function(v) ResT.NKOffset = v end,
})
KickBox:AddButton({
    Text = "TP To Void Platform",
    Tooltip = "Телепорт на платформу, где жертва не сможет кидать анти-кик сюрикены",
    Func = function()
        local myChar, myRoot, myHum = TChar(LocalPlayer)
        if not myRoot then return end
        if not ResT.VoidPart then
            ResT.VoidPart = Instance.new("Part")
            ResT.VoidPart.Name = "PulsarVoidPlatform"
            ResT.VoidPart.Size = Vector3.new(16, 1, 16)
            ResT.VoidPart.Anchored = true
            ResT.VoidPart.CFrame = CFrame.new(0, 5000, 5000)
            ResT.VoidPart.Parent = workspace
        end
        TTeleport(myRoot, ResT.VoidPart.CFrame + Vector3.new(0, 4, 0))
    end,
})
KickBox:AddDivider()
KickBox:AddLabel("Kick Server Settings")
KickBox:AddDropdown("KickServerMethod", {
    Values = { "Circle + Lag", "Void" },
    Multi = false,
    Default = 1,
    Text = "Kick Server Method",
    Callback = function(v) ResT.ServerMethod = v end,
})

local RGBox = MethodsGroup
pcall(function()
    local dep2 = MethodsGroup:AddDependencyBox()
    dep2:SetupDependencies({ { Library.Options.TargetMethods, "Remove Gucci" } })
    RGBox = dep2
end)

RGBox:AddDivider()
RGBox:AddLabel("Remove-Gucci Settings")
RGBox:AddToggle("RagdollInRG", {
    Text = "Break Player? [Inf Ragdoll]",
    Default = false,
    Tooltip = "Занимает 1.5 секунды, используй только если есть время",
    Callback = function(v) ResT.RagdollRG = v end,
})
RGBox:AddButton({
    Text = "Fix Gucci Remover",
    Tooltip = "Чинит сиденья, если Remove Gucci не работает",
    Func = TFixGucci,
})


local SoundMuteCatGroup = TabObjects["Music"]:AddRightGroupbox("Звуки")
local MuteSoundConn = nil
local MutedOriginals = {}

local function TryMuteSound(obj, cat)
    local current = obj.SoundGroup
    if current and string.find(current.Name, "PulsarMute", 1, true) then
        return
    end
    if MutedOriginals[obj] ~= nil then
        return
    end
    MutedOriginals[obj] = current or false
    obj.SoundGroup = cat.Group
end

local function RestoreSound(obj)
    local prev = MutedOriginals[obj]
    if prev == nil then return end
    MutedOriginals[obj] = nil
    pcall(function()
        if prev ~= false then
            obj.SoundGroup = prev
        else
            obj.SoundGroup = nil
        end
    end)
end

local SoundCategories = {
    { Name = "Ambience",     Text = "Mute Ambience",              Patterns = { "ambien", "wind", "birds", "bird", "nature", "crowd", "city", "forest", "ocean", "rain" } },
    { Name = "Boombox",      Text = "Mute Boomboxes & Jukeboxes", Patterns = { "boombox", "jukebox", "radio", "speaker", "stereo", "music", "cassette", "tape", "gramophone" } },
    { Name = "Screams",      Text = "Mute Screams",               Patterns = { "scream", "yell", "shout", "panic", "horror", "crying", "squeal" } },
    { Name = "Explosions",   Text = "Mute Explosions",            Patterns = { "explos", "blast", "grenade", "bomb", "rocket", "cannon", "firework", "gunshot", "shot", "bang" } },
    { Name = "Soundwaves",   Text = "Mute Soundwaves",            Patterns = { "soundwave", "sound wave", "siren", "alarm", "airhorn", "megaphone" } },
    { Name = "RhythmMakers", Text = "Mute Rhythm Makers",         Patterns = { "rhythm", "beatbox", "metronome", "melody", "tempo", "beat" } },
    { Name = "Instruments",  Text = "Mute Instruments",           Patterns = { "instrument", "piano", "drum", "guitar", "trumpet", "flute", "violin", "sax", "banjo", "harp", "xylophone", "accordion", "chime" } },
    { Name = "Ragdoll",      Text = "Mute Ragdoll Sounds",        Patterns = { "ragdoll", "bodyfall", "thud", "splat", "bonk" } },
}

local function MatchesPatterns(sound, patterns)
    local node = sound
    local names = {}
    while node and node ~= game do
        names[#names + 1] = string.lower(node.Name)
        node = node.Parent
    end
    for _, pattern in ipairs(patterns) do
        for _, name in ipairs(names) do
            if string.find(name, pattern, 1, true) then return true end
        end
    end
    return false
end

local function UninstallGroup(group)
    if not group then return end
    pcall(function()
        for obj, _prev in pairs(MutedOriginals) do
            if not obj.Parent or not obj:IsA("Sound") then
                MutedOriginals[obj] = nil
            elseif obj.SoundGroup == group then
                RestoreSound(obj)
            end
        end
    end)
    pcall(function() group:Destroy() end)
end

local MuteScanRunning = false

local function MuteScanOnce()
    pcall(function()
        for obj in pairs(MutedOriginals) do
            if typeof(obj) ~= "Instance" or not obj.Parent then
                MutedOriginals[obj] = nil
            end
        end
    end)
    local t0 = os.clock()
    pcall(function()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Sound") then
                for _, cat2 in ipairs(SoundCategories) do
                    if cat2.Group and MatchesPatterns(obj, cat2.Patterns) then
                        TryMuteSound(obj, cat2)
                    end
                end
            end
            if os.clock() - t0 > 0.15 then
                task.wait()
                t0 = os.clock()
            end
        end
    end)
end

local function UpdateMuteWatcher()
    local anyActive = false
    for _, cat in ipairs(SoundCategories) do
        if cat.Group then anyActive = true break end
    end
    if anyActive and not MuteScanRunning then
        MuteScanRunning = true
        task.spawn(function()
            while true do
                task.wait(3)
                local any = false
                for _, c in ipairs(SoundCategories) do
                    if c.Group then any = true break end
                end
                if not any then break end
                MuteScanOnce()
            end
            MuteScanRunning = false
        end)
    end
    if anyActive and not MuteSoundConn then
        MuteSoundConn = game.DescendantAdded:Connect(function(obj)
            if not obj:IsA("Sound") then return end
            task.defer(function()
                for _, cat2 in ipairs(SoundCategories) do
                    pcall(function()
                        if cat2.Group and MatchesPatterns(obj, cat2.Patterns) then
                            TryMuteSound(obj, cat2)
                        end
                    end)
                end
            end)
        end)
        task.defer(MuteScanOnce)
    elseif not anyActive and MuteSoundConn then
        MuteSoundConn:Disconnect()
        MuteSoundConn = nil
    end
end

PulsarSoundMuteOff = function()
    for _, cat in ipairs(SoundCategories) do
        UninstallGroup(cat.Group)
        cat.Group = nil
    end
    if MuteSoundConn then
        MuteSoundConn:Disconnect()
        MuteSoundConn = nil
    end
end

for _, cat in ipairs(SoundCategories) do
    cat.Group = nil
    SoundMuteCatGroup:AddToggle("PulsarMute_" .. cat.Name, {
        Text = cat.Text,
        Default = false,
        Callback = function(on)
            if on then
                if not cat.Group then
                    cat.Group = Instance.new("SoundGroup")
                    cat.Group.Name = "PulsarMute_" .. cat.Name
                    cat.Group.Volume = 0
                    cat.Group.Parent = SoundService
                end
                local group = cat.Group
                pcall(function()
                    for _, obj in ipairs(game:GetDescendants()) do
                        if obj:IsA("Sound") and MatchesPatterns(obj, cat.Patterns) then
                            TryMuteSound(obj, cat)
                        end
                    end
                end)
                UpdateMuteWatcher()
            else
                UninstallGroup(cat.Group)
                cat.Group = nil
                UpdateMuteWatcher()
            end
        end,
    })
end

do

    local GfxWaterTimeSlice = 0.1

    local GfxState = {
        RuntimeConnections = {},
        ParticleSettings = {
            Enabled = false,
            BoxSize = 500,
            Texture = "rbxassetid://5857892330",
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0,
            ParticleSize = 1,
            Count = 2500,
            SpeedMin = 0.5,
            SpeedMax = 2,
            LifeTime = 10,
        },
    }

    local function GfxQueryDescendants(inst, classNames)
        if not inst then return {} end
        local ok, result = pcall(function() return inst:QueryDescendants(classNames) end)
        if ok and type(result) == "table" then
            return result
        end
        local wanted = {}
        for cls in string.gmatch(classNames or "", "[^,%s]+") do
            wanted[cls] = true
        end
        local list = {}
        pcall(function()
            for _, obj in ipairs(inst:GetDescendants()) do
                if wanted[obj.ClassName] then
                    list[#list + 1] = obj
                end
            end
        end)
        return list
    end

    local function GfxSetConn(name, event, enabled, fn)
        local existing = GfxState.RuntimeConnections[name]

        if not enabled then
            if existing then
                pcall(function() existing:Disconnect() end)
            end
            GfxState.RuntimeConnections[name] = nil
            return
        end

        if existing and existing.Connected then
            return
        end
        GfxState.RuntimeConnections[name] = event:Connect(fn)
    end

    local GfxPart = Instance.new("Part")
    pcall(function()
        GfxPart.Name = "partcieslyes"
        GfxPart.Transparency = 1
        GfxPart.CanCollide = false
        GfxPart.CanQuery = false
        GfxPart.CanTouch = false
        GfxPart.Anchored = true
        GfxPart.Parent = workspace
    end)

    local GfxEmitter = Instance.new("ParticleEmitter")
    pcall(function()
        GfxEmitter.Enabled = false
        GfxEmitter.Shape = Enum.ParticleEmitterShape.Box
        GfxEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        GfxEmitter.LightEmission = 0
        GfxEmitter.LightInfluence = 0
        GfxEmitter.ZOffset = 0
        GfxEmitter.Parent = GfxPart
    end)

    local function GfxUpdateParticles(prop)
        local settings = GfxState.ParticleSettings
        local all = not prop

        pcall(function()
            if all or prop == "BoxSize" then
                GfxPart.Size = Vector3.one * settings.BoxSize
            end
            if all or prop == "Texture" then
                GfxEmitter.Texture = settings.Texture
            end
            if all or prop == "Count" then
                GfxEmitter.Rate = settings.Count
            end
            if all or prop == "LifeTime" then
                GfxEmitter.Lifetime = NumberRange.new(settings.LifeTime)
            end
            if all or prop == "SpeedMin" or prop == "SpeedMax" then
                GfxEmitter.Speed = NumberRange.new(settings.SpeedMin, settings.SpeedMax)
            end
            if all or prop == "Color" then
                GfxEmitter.Color = ColorSequence.new(settings.Color)
            end
            if all or prop == "ParticleSize" then
                GfxEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.1, settings.ParticleSize),
                    NumberSequenceKeypoint.new(0.9, settings.ParticleSize),
                    NumberSequenceKeypoint.new(1, 0),
                })
            end
            if all or prop == "Transparency" then
                GfxEmitter.Transparency = NumberSequence.new(settings.Transparency)
            end
        end)
    end

    local function GfxUpdateParticlePosition()
        local camera = workspace.CurrentCamera
        if camera then
            pcall(function() GfxPart.CFrame = camera.CFrame end)
        end
    end

    local function GfxSetParticlesEnabled(enabled)
        GfxState.ParticleSettings.Enabled = enabled
        pcall(function()
            local camera = workspace.CurrentCamera
            GfxSetConn("Particles", camera:GetPropertyChangedSignal("CFrame"), enabled, GfxUpdateParticlePosition)
        end)
        pcall(function() GfxEmitter.Enabled = enabled end)

        if enabled then
            GfxUpdateParticles()
            GfxUpdateParticlePosition()
        else
            pcall(function() GfxEmitter:Clear() end)
        end
    end

    local function GfxSetParticleProp(prop, value)
        GfxState.ParticleSettings[prop] = value
        if GfxState.ParticleSettings.Enabled then
            GfxUpdateParticles(prop)
        end
    end

    local GfxBoost = {
        Revert = {},
        Active = false,
        Applied = false,
        Busy = false,
        Stale = false,
        Options = { Materials = true, Textures = true, Reflections = true, Shadows = true },
    }

    local function GfxSetProp(inst, prop, value)
        local original
        pcall(function() original = inst[prop] end)
        if original == value then
            return
        end

        local ok = pcall(function()
            inst[prop] = value
        end)
        if not ok then
            return
        end

        local slot = GfxBoost.Revert[inst]
        if not slot then
            slot = {}
            GfxBoost.Revert[inst] = slot
        end
        if not slot[prop] then
            slot[prop] = { original, value }
        end
    end

    local function GfxBoostApply(inst)
        if not GfxBoost.Active then
            return
        end
        local opts = GfxBoost.Options

        if inst:IsA("BasePart") and not inst:IsA("Terrain") then
            if opts.Materials and inst.Material ~= Enum.Material.ForceField then
                GfxSetProp(inst, "Material", Enum.Material.SmoothPlastic)
                GfxSetProp(inst, "MaterialVariant", "")
            end
            if opts.Reflections then
                GfxSetProp(inst, "Reflectance", 0)
            end
            if opts.Shadows then
                GfxSetProp(inst, "CastShadow", false)
            end
            if opts.Textures and inst:IsA("MeshPart") then
                GfxSetProp(inst, "TextureID", "")
            end
        elseif opts.Textures and (inst:IsA("Decal") or inst:IsA("Texture")) then
            GfxSetProp(inst, "Transparency", 1)
        elseif opts.Textures and inst:IsA("SpecialMesh") then
            GfxSetProp(inst, "TextureId", "")
        end
    end

    local function GfxSetBoostFPS(enabled)
        GfxBoost.Active = enabled and not Library.Unloaded

        local skip
        if GfxBoost.Busy then
            skip = GfxBoost.Busy
        else
            skip = (GfxBoost.Active == GfxBoost.Applied) and not GfxBoost.Stale
        end
        if skip then
            return
        end
        GfxBoost.Busy = true

        task.spawn(function()
            while true do
                local now = os.clock()

                if GfxBoost.Active and not GfxBoost.Applied then
                    GfxBoost.Applied = true
                    GfxBoost.Stale = false

                    if GfxBoost.Options.Shadows then
                        GfxSetProp(Lighting, "GlobalShadows", false)
                    end

                    GfxSetConn("BoostFPSAdded", workspace.DescendantAdded, true, function(desc)
                        pcall(GfxBoostApply, desc)
                    end)

                    for _, desc in ipairs(GfxQueryDescendants(workspace, "BasePart, Decal, Texture, SpecialMesh")) do
                        if GfxBoost.Active then
                            pcall(GfxBoostApply, desc)
                            if os.clock() - now > GfxWaterTimeSlice then
                                task.wait()
                                now = os.clock()
                            end
                        else
                            break
                        end
                    end
                else
                    GfxSetConn("BoostFPSAdded", nil, false)

                    for inst, props in pairs(GfxBoost.Revert) do
                        if inst.Parent then
                            for prop, entry in pairs(props) do
                                local ok, current = pcall(function() return inst[prop] end)
                                if ok and current == entry[2] then
                                    pcall(function()
                                        inst[prop] = entry[1]
                                    end)
                                end
                            end
                        end

                        if not Library.Unloaded and os.clock() - now > GfxWaterTimeSlice then
                            task.wait()
                            now = os.clock()
                        end
                    end

                    table.clear(GfxBoost.Revert)
                    GfxBoost.Applied = false

                    if not GfxBoost.Active then
                        GfxBoost.Stale = false
                    end
                end

                if not (GfxBoost.Active == GfxBoost.Applied and not GfxBoost.Stale) then
                    continue
                end
                break
            end

            GfxBoost.Busy = false
        end)
    end

    local function GfxSetBoostFPSOptions(selected)
        if type(selected) ~= "table" then
            selected = {}
        end
        GfxBoost.Options = selected
        GfxBoost.Stale = GfxBoost.Active
        GfxSetBoostFPS(GfxBoost.Active)
    end

    local Graphics
    local okGraphics = pcall(function()
        Graphics = VisualTab:AddRightGroupbox("Graphics", "file-image")
    end)
    if not okGraphics or not Graphics then
        Graphics = VisualTab:AddRightGroupbox("Graphics")
    end

    local function GfxDivider(name)
        local ok = false
        pcall(function()
            Graphics:AddDivider(name)
            ok = true
        end)
        if not ok then
            pcall(function() Graphics:AddDivider() end)
        end
    end

    local function GfxDepbox(deps)
        local ok, box = pcall(function()
            local b = Graphics:AddDependencyBox()
            b:SetupDependencies(deps)
            return b
        end)
        if ok and box then
            return box
        end
        return nil
    end

    GfxDivider("Particles")

    local ParticlesToggle = Graphics:AddToggle("ParticlesT", {
        Text = "Particles",
        Default = false,
        Callback = GfxSetParticlesEnabled,
    })

    pcall(function()
        ParticlesToggle:AddColorPicker("ParticlesCo", {
            Default = GfxState.ParticleSettings.Color,
            Title = "Color",
            Callback = function(value)
                GfxSetParticleProp("Color", value)
            end,
        })
    end)

    local ParticleTextures = {
        ["Dot"] = "rbxassetid://5857892330",
        ["Sparkles"] = "rbxasset://textures/particles/sparkles_main.dds",
        ["Fire"] = "rbxasset://textures/particles/fire_main.dds",
        ["Smoke"] = "rbxasset://textures/particles/smoke_main.dds",
        ["Sparks"] = "rbxassetid://6711256324",
        ["Star"] = "rbxassetid://6772783963",
        ["Star Small"] = "rbxassetid://5860841663",
        ["Heart"] = "rbxassetid://5857851618",
        ["Diamond"] = "rbxassetid://6772766413",
        ["Leaf"] = "rbxassetid://6703369286",
        ["Paw"] = "rbxassetid://6803084085",
        ["Lightning"] = "rbxassetid://6772766551",
        ["Explosion"] = "rbxassetid://5833235272",
    }
    local ParticleTextureOrder = { "Dot", "Sparkles", "Fire", "Smoke", "Sparks", "Star", "Star Small", "Heart", "Diamond", "Leaf", "Paw", "Lightning", "Explosion" }

    local ParticlesBox = GfxDepbox({ { Library.Options.ParticlesT, true } })

    if not ParticlesBox then
        ParticlesBox = Graphics
    end

    if ParticlesBox then
        ParticlesBox:AddDropdown("ParticlesDropdown", {
            Values = ParticleTextureOrder,
            Multi = false,
            Default = "Dot",
            Searchable = true,
            Text = "Texture",
            Callback = function(value)
                local tex = ParticleTextures[value]
                if tex then
                    GfxSetParticleProp("Texture", tex)
                end
            end,
        })

        ParticlesBox:AddSlider("PDensity", {
            Text = "Density (Count)",
            Default = GfxState.ParticleSettings.Count,
            Min = 100,
            Max = 5000,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("Count", value)
            end,
        })

        ParticlesBox:AddSlider("PSize", {
            Text = "Size",
            Default = GfxState.ParticleSettings.ParticleSize,
            Min = 0.1,
            Max = 5,
            Rounding = 1,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("ParticleSize", value)
            end,
        })

        ParticlesBox:AddSlider("PMaxSp", {
            Text = "Max Speed",
            Default = GfxState.ParticleSettings.SpeedMax,
            Min = 0,
            Max = 10,
            Rounding = 1,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("SpeedMax", value)
            end,
        })

        ParticlesBox:AddSlider("PBoxSize", {
            Text = "Box Size",
            Default = GfxState.ParticleSettings.BoxSize,
            Min = 50,
            Max = 2000,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("BoxSize", value)
            end,
        })
    end

    GfxDivider("Boost FPS")

    Graphics:AddToggle("BoostFPS", {
        Text = "Boost FPS",
        Default = false,
        Callback = GfxSetBoostFPS,
    })

    Graphics:AddDropdown("BoostFPSOptions", {
        Text = "Disable",
        Values = { "Materials", "Textures", "Reflections", "Shadows" },
        Default = { "Materials", "Textures", "Reflections", "Shadows" },
        Multi = true,
        AllowNull = true,
        Callback = GfxSetBoostFPSOptions,
    })

    GfxUnload = function()
        pcall(function() GfxSetParticlesEnabled(false) end)
        pcall(function() GfxSetBoostFPS(false) end)
        pcall(function() GfxSetConn("BoostFPSAdded", nil, false) end)
        pcall(function() GfxPart:Destroy() end)
        for _, conn in pairs(GfxState.RuntimeConnections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(GfxState.RuntimeConnections)
    end
end

local FogGroup = VisualTab:AddRightGroupbox("Туман")
local FogState = { On = false, Density = 5, Saved = false, Color = Color3.fromRGB(200, 200, 200), OldStart = 0, OldEnd = 100000, OldColor = Color3.new(1, 1, 1) }
local function FogApply()
    if not FogState.Saved then
        FogState.Saved = true
        FogState.OldStart, FogState.OldEnd, FogState.OldColor = Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor
    end
    pcall(function()
        Lighting.FogStart = 0
        Lighting.FogEnd = 5000 - FogState.Density * 490
        Lighting.FogColor = FogState.Color
    end)
end
local function FogRestore()
    if not FogState.Saved then return end
    FogState.Saved = false
    pcall(function()
        Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = FogState.OldStart, FogState.OldEnd, FogState.OldColor
    end)
end
local FogToggle = FogGroup:AddToggle("PulsarFogOn", {
    Text = "Туман",
    Default = false,
    Callback = function(on)
        FogState.On = on
        if on then FogApply() else FogRestore() end
    end,
})
pcall(function()
    FogToggle:AddColorPicker("PulsarFogColor", {
        Default = FogState.Color, Title = "Цвет тумана",
        Callback = function(v)
            FogState.Color = v
            if FogState.On then FogApply() end
        end,
    })
end)
FogGroup:AddSlider("PulsarFogDensity", {
    Text = "Плотность", Default = 5, Min = 0, Max = 10, Rounding = 1,
    Callback = function(v)
        FogState.Density = v
        if FogState.On then FogApply() end
    end,
})
pcall(function() Library:OnUnload(FogRestore) end)

do
    local HttpService = game:GetService("HttpService")
    local CHAT_TOPIC = "pulsar23-chat-k7f2q9xw"
    local ChatHistory = {}
    local ChatLabels = {}
    local SeenChatIds = {}
    local ChatConn = nil

    local InputGroup = TabObjects["Lists"]:AddLeftGroupbox("PULSAR Чат — Написать")
    local MsgGroup = TabObjects["Lists"]:AddRightGroupbox("Сообщения")

    local function ChatClean(text)
        text = tostring(text or ""):gsub("[\r\n\t]", " ")
        if #text > 120 then text = text:sub(1, 120) end
        return text
    end

    for i = 1, 12 do
        ChatLabels[i] = MsgGroup:AddLabel(i == 1 and "Сообщений пока нет" or "…")
    end

    local function SetChatLabel(label, text)
        local ok = pcall(function() label:SetText(text) end)
        if not ok then
            pcall(function() label.Text = text end)
            pcall(function() label.TextLabel.Text = text end)
        end
    end

    local function UpdateChatLabels()
        local total = #ChatHistory
        for i = 1, 12 do
            local from = total - (12 - i)
            local msg = (from >= 1) and ChatHistory[from] or "…"
            pcall(function() SetChatLabel(ChatLabels[i], msg) end)
        end
    end

    local function ChatPush(nick, text)
        local entry = nick .. ": " .. text
        if ChatHistory[#ChatHistory] == entry then return end
        ChatHistory[#ChatHistory + 1] = entry
        while #ChatHistory > 12 do table.remove(ChatHistory, 1) end
        UpdateChatLabels()
    end

    local function ChatHttpPost(url, body)
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if type(req) == "function" then
            local okr, resp = pcall(function()
                return req({ Url = url, Uri = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
            end)
            if okr and type(resp) == "table" then
                local rb = (type(resp.Body) == "string" and resp.Body) or (type(resp.body) == "string" and resp.body) or ""
                return true, rb
            end
        end
        local okp, resp = pcall(function()
            return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
        end)
        if okp and type(resp) == "string" then
            return true, resp
        end
        local okq, resp2 = pcall(function()
            return HttpService:RequestAsync({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
        end)
        if okq and type(resp2) == "table" and resp2.Success then
            return true, type(resp2.Body) == "string" and resp2.Body or ""
        end
        return false, ""
    end

    local function ChatHttpGet(url)
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if type(req) == "function" then
            local okr, resp = pcall(function()
                return req({ Url = url, Uri = url, Method = "GET" })
            end)
            if okr and type(resp) == "table" then
                local rb = (type(resp.Body) == "string" and resp.Body) or (type(resp.body) == "string" and resp.body)
                if rb then
                    return true, rb
                end
            end
        end
        local okh, body = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if okh and type(body) == "string" then
            return true, body
        end
        return pcall(function()
            return game:HttpGet(url)
        end)
    end

    local PollFailNotified = false

    local function PollOnce()
        local ok, body = ChatHttpGet("https://ntfy.sh/" .. CHAT_TOPIC .. "/json?poll=1&since=60s")
        if not (ok and type(body) == "string") then
            if not PollFailNotified then
                PollFailNotified = true
                pcall(function() Library:Notify("Чат: сообщения не приходят (HTTP заблокирован?)") end)
            end
            return false
        end
        PollFailNotified = false
        for _, line in ipairs(string.split(body, "\n")) do
            local okd, data = pcall(function() return HttpService:JSONDecode(line) end)
            if okd and type(data) == "table" and data.event == "message" and data.id and not SeenChatIds[data.id] then
                SeenChatIds[data.id] = true
                ChatPush(ChatClean(data.title or "guest"), ChatClean(data.message or ""))
            end
        end
        return true
    end

    local function MarkSeen(body)
        if type(body) ~= "string" or #body == 0 then return end
        pcall(function()
            local d = HttpService:JSONDecode(body)
            if type(d) == "table" and d.id then
                SeenChatIds[d.id] = true
            end
        end)
    end

    InputGroup:AddInput("PulsarChatNick", {
        Text = "Ник",
        Default = LocalPlayer.Name,
        Finished = false,
    })

    InputGroup:AddInput("PulsarChatMsg", {
        Text = "Сообщение",
        Placeholder = "Ввести сообщение…",
        Finished = false,
    })

    local function ChatUrlEncode(text)
        local out = tostring(text or ""):gsub("[^%w%-_%.~]", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        return out
    end

    local function ChatSend()
        local nick = ""
        pcall(function() nick = tostring(Library.Options.PulsarChatNick.Value or "") end)
        if nick == "" then nick = "guest" end
        local text = ""
        pcall(function() text = tostring(Library.Options.PulsarChatMsg.Value or "") end)
        if text == "" then
            Library:Notify("Введи сообщение")
            return
        end
        local body = HttpService:JSONEncode({ topic = CHAT_TOPIC, title = nick, message = text })
        local ok, respBody = ChatHttpPost("https://ntfy.sh/", body)
        if not ok then
            local url = "https://ntfy.sh/" .. CHAT_TOPIC .. "/publish?title=" .. ChatUrlEncode(nick) .. "&message=" .. ChatUrlEncode(text)
            local okG, gBody = ChatHttpGet(url)
            if okG and type(gBody) == "string" and string.find(gBody, '"id"', 1, true) then
                ok = true
                respBody = gBody
            end
        end
        if ok then
            MarkSeen(respBody)
            ChatPush(nick, text)
            pcall(function() Library.Options.PulsarChatMsg:SetValue("") end)
            pcall(function() Library.Options.PulsarChatMsg.Value = "" end)
            pcall(function() Library.Options.PulsarChatMsg:SetText("") end)
        else
            Library:Notify("Отправка не удалась — включи доступ к HTTP-запросам в инжекторе")
        end
    end

    local function StartPolling()
        if ChatConn then return end
        ChatConn = task.spawn(function()
            while Library and not Library.Unloaded do
                pcall(PollOnce)
                task.wait(1)
            end
        end)
    end

    local function StopPolling()
        if ChatConn then
            pcall(function() task.cancel(ChatConn) end)
            ChatConn = nil
        end
    end

    InputGroup:AddButton({ Text = "📨 Отправить", Func = ChatSend })

    MsgGroup:AddButton({ Text = "🔄 Обновить", Func = function() pcall(PollOnce) end })

    InputGroup:AddToggle("PulsarChatAuto", {
        Text = "Автообновление (1 сек)",
        Default = true,
        Callback = function(on)
            if on then
                StartPolling()
            else
                StopPolling()
            end
        end,
    })

    task.defer(StartPolling)

    pcall(function()
        Library:OnUnload(StopPolling)
    end)
end