--[[
MonK Hub V2 | Animated Splash + Fluent UI
Features:
- Fluid purple/red/blue/black background animation
- Blooming flower at start
- "MonK Hub V2 Loaded" text (exactly 3 seconds)
- Touch ripple effect (screen-wide + buttons)
- Fluent modern UI with animations
- Notification sound
- Live watermark (FPS/Ping/Time)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

-- Safe GUI parent (works on mobile executors)
local function getGuiParent()
    local ok, hui = pcall(function() return gethui() end)
    if ok and hui then return hui end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================================
-- SPLASH SCREEN
-- ==========================================================
local function showSplash()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MonK_Splash"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = getGuiParent()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = gui

    -- Fluid blobs (purple / red / blue)
    local fluid = Instance.new("Frame")
    fluid.Size = UDim2.fromScale(1, 1)
    fluid.BackgroundTransparency = 1
    fluid.ZIndex = 2
    fluid.ClipsDescendants = true
    fluid.Parent = bg

    local blobColors = {
        Color3.fromRGB(150, 30, 220),   -- purple
        Color3.fromRGB(220, 30, 60),    -- red
        Color3.fromRGB(30, 100, 220),   -- blue
        Color3.fromRGB(80, 20, 120),    -- deep purple
    }
    local blobs = {}
    for i = 1, 4 do
        local blob = Instance.new("Frame")
        blob.Size = UDim2.fromOffset(600, 600)
        blob.AnchorPoint = Vector2.new(0.5, 0.5)
        blob.Position = UDim2.fromScale(0.5, 0.5)
        blob.BackgroundColor3 = blobColors[i]
        blob.BackgroundTransparency = 0.65
        blob.BorderSizePixel = 0
        blob.ZIndex = 2
        blob.Parent = fluid

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = blob

        blobs[i] = {
            frame = blob,
            baseX = math.random(), baseY = math.random(),
            phase = math.random() * math.pi * 2,
            speed = 0.25 + math.random() * 0.35
        }
    end

    local fluidHeart = RunService.Heartbeat:Connect(function()
        local t = tick()
        for _, b in ipairs(blobs) do
            local x = 0.5 + math.sin(t * b.speed + b.phase) * 0.45
            local y = 0.5 + math.cos(t * b.speed * 0.85 + b.phase) * 0.45
            b.frame.Position = UDim2.fromScale(x, y)
        end
    end)

    -- Vignette overlay (darkens edges for focus)
    local vignette = Instance.new("Frame")
    vignette.Size = UDim2.fromScale(1, 1)
    vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vignette.BackgroundTransparency = 0.6
    vignette.BorderSizePixel = 0
    vignette.ZIndex = 3
    vignette.Parent = bg

    local vigGrad = Instance.new("UIGradient")
    vigGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    vigGrad.Parent = vignette

    -- Flower container
    local flower = Instance.new("Frame")
    flower.Size = UDim2.fromOffset(300, 300)
    flower.Position = UDim2.fromScale(0.5, 0.42)
    flower.AnchorPoint = Vector2.new(0.5, 0.5)
    flower.BackgroundTransparency = 1
    flower.ZIndex = 5
    flower.Parent = bg

    -- Glow behind flower
    local glow = Instance.new("Frame")
    glow.Size = UDim2.fromOffset(260, 260)
    glow.Position = UDim2.fromScale(0.5, 0.5)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundColor3 = Color3.fromRGB(220, 30, 60)
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = 4
    glow.Parent = flower

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow

    TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.75
    }):Play()

    -- Petals (8 radiating ellipses)
    local petals = {}
    local numPetals = 8
    for i = 1, numPetals do
        local petal = Instance.new("Frame")
        petal.Size = UDim2.fromOffset(55, 130)
        petal.Position = UDim2.fromScale(0.5, 0.5)
        petal.AnchorPoint = Vector2.new(0.5, 1)
        petal.BackgroundColor3 = Color3.fromRGB(220, 30, 60)
        petal.BackgroundTransparency = 1
        petal.BorderSizePixel = 0
        petal.Rotation = (360 / numPetals) * (i - 1)
        petal.ZIndex = 5
        petal.Parent = flower

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = petal

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 60)),   -- red
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 220)),  -- purple
        })
        grad.Rotation = 90
        grad.Parent = petal

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 100, 150)
        stroke.Thickness = 1
        stroke.Transparency = 0.7
        stroke.Parent = petal

        petals[i] = petal
    end

    -- Flower center
    local center = Instance.new("Frame")
    center.Size = UDim2.fromOffset(55, 55)
    center.Position = UDim2.fromScale(0.5, 0.5)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.BackgroundColor3 = Color3.fromRGB(255, 210, 80)
    center.BackgroundTransparency = 1
    center.BorderSizePixel = 0
    center.ZIndex = 6
    center.Parent = flower

    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = center

    local centerGrad = Instance.new("UIGradient")
    centerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 40)),
    })
    centerGrad.Rotation = 45
    centerGrad.Parent = center

    -- Bloom petals (staggered)
    for i, petal in ipairs(petals) do
        task.spawn(function()
            task.wait(0.05 * i)
            TweenService:Create(petal, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.05
            }):Play()
            TweenService:Create(petal, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(65, 145)
            }):Play()
        end)
    end

    task.wait(0.6)
    TweenService:Create(center, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        BackgroundTransparency = 0
    }):Play()

    -- Continuous flower rotation
    local flowerSpin = RunService.Heartbeat:Connect(function()
        flower.Rotation = flower.Rotation + 0.35
    end)

    -- "MonK Hub V2 Loaded" text
    task.wait(0.9)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.fromScale(1, 0.1)
    textLabel.Position = UDim2.fromScale(0, 0.7)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "MonK Hub V2 Loaded"
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextSize = 38
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextTransparency = 1
    textLabel.ZIndex = 10
    textLabel.Parent = bg

    local textGrad = Instance.new("UIGradient")
    textGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 60)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 50, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 255)),
    })
    textGrad.Parent = textLabel

    TweenService:Create(textLabel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        TextTransparency = 0
    }):Play()

    -- Hold text exactly 3 seconds
    task.wait(3)

    -- Fade out everything
    fluidHeart:Disconnect()
    flowerSpin:Disconnect()

    local fadeGroup = {bg, vignette}
    for _, p in ipairs(petals) do table.insert(fadeGroup, p) end
    table.insert(fadeGroup, center)
    table.insert(fadeGroup, glow)
    for _, b in ipairs(blobs) do table.insert(fadeGroup, b.frame) end

    for _, obj in ipairs(fadeGroup) do
        local goal = {}
        if obj:IsA("TextLabel") then
            goal.TextTransparency = 1
        elseif obj:IsA("Frame") then
            goal.BackgroundTransparency = 1
        end
        TweenService:Create(obj, TweenInfo.new(0.6, Enum.EasingStyle.Quad), goal):Play()
    end
    TweenService:Create(textLabel, TweenInfo.new(0.6), {TextTransparency = 1}):Play()

    task.wait(0.7)
    gui:Destroy()
end

-- ==========================================================
-- TOUCH RIPPLE EFFECT (screen-wide)
-- ==========================================================
local function enableTouchFX()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MonK_TouchFX"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 50
    gui.Parent = getGuiParent()

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
        if not (isTouch or isMouse) then return end
        local pos = input.Position
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.fromOffset(10, 10)
        ripple.Position = UDim2.fromOffset(pos.X - 5, pos.Y - 5)
        ripple.BackgroundColor3 = Color3.fromRGB(220, 30, 60)
        ripple.BackgroundTransparency = 0.45
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 50
        ripple.Parent = gui

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = ripple

        TweenService:Create(ripple, TweenInfo.new(0.55, Enum.EasingStyle.Quad), {
            Size = UDim2.fromOffset(90, 90),
            Position = UDim2.fromOffset(pos.X - 45, pos.Y - 45),
            BackgroundTransparency = 1
        }):Play()

        task.delay(0.6, function() ripple:Destroy() end)
    end)
end

-- ==========================================================
-- LOAD SPLASH + TOUCH EFFECT FIRST
-- ==========================================================
task.spawn(showSplash)
enableTouchFX()

-- ==========================================================
-- FLUENT UI (main window)
-- ==========================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MonK Hub V2",
    SubTitle = "Premium • Animated",
    TabWidth = 140,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local function notify(title, content, duration)
    pcall(function()
        Fluent:Notify({
            Title = tostring(title or "MonK Hub V2"),
            Content = tostring(content or ""),
            Duration = duration or 3
        })
    end)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9046890495"
        s.Volume = 0.25
        s.Parent = SoundService
        s:Play()
        task.delay(1, function() s:Destroy() end)
    end)
end

local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Troll = Window:AddTab({ Title = "Troll", Icon = "skull" }),
    Protection = Window:AddTab({ Title = "Protection", Icon = "shield" }),
}

-- ==========================================================
-- INFO TAB
-- ==========================================================
Tabs.Info:AddSection({ Title = "About" })
Tabs.Info:AddParagraph({ Title = "MonK Hub V2", Content = "Premium Animated Edition • Blackout + Crimson + Fluid" })
Tabs.Info:AddParagraph({ Title = "Credits", Content = "Developed by MONK" })

Tabs.Info:AddSection({ Title = "Community" })
Tabs.Info:AddButton({
    Title = "Copy Discord Invite",
    Description = "Tap to copy the invite link",
    Callback = function()
        local link = "https://discord.gg/EVaFEpdrM"
        if typeof(setclipboard) == "function" then
            setclipboard(link)
            notify("Copied", "Discord invite copied.")
        else
            notify("Discord", link)
        end
    end
})

-- ==========================================================
-- PLAYER TAB
-- ==========================================================
local walkSpeed, jumpPower, gravity = 16, 50, 196.2
local fieldOfView = 70
local infiniteJumpEnabled = false
local noclipConnection

local function getHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

Tabs.Player:AddSection({ Title = "Movement" })
Tabs.Player:AddSlider({
    Title = "Speed", Min = 1, Max = 500, Default = 16, Rounding = 0,
    Callback = function(v) walkSpeed = v; local h = getHumanoid(); if h then h.WalkSpeed = v end end
})
Tabs.Player:AddSlider({
    Title = "Jump Power", Min = 1, Max = 500, Default = 50, Rounding = 0,
    Callback = function(v)
        jumpPower = v
        local h = getHumanoid()
        if h then pcall(function() h.UseJumpPower = true end); h.JumpPower = v end
    end
})
Tabs.Player:AddSlider({
    Title = "Gravity", Min = 1, Max = 500, Default = 196, Rounding = 0,
    Callback = function(v) gravity = v; Workspace.Gravity = v end
})
Tabs.Player:AddToggle({
    Title = "Infinite Jump", Default = false,
    Callback = function(v) infiniteJumpEnabled = v; notify("Infinite Jump", v and "Enabled" or "Disabled") end
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local h = getHumanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Tabs.Player:AddToggle({
    Title = "Ultimate Noclip", Default = false,
    Callback = function(v)
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if v then
            noclipConnection = RunService.Stepped:Connect(function()
                local c = LocalPlayer.Character
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
            notify("Noclip", "Enabled")
        else
            local c = LocalPlayer.Character
            if c then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end
            notify("Noclip", "Disabled")
        end
    end
})

Tabs.Player:AddSection({ Title = "FOV" })
Tabs.Player:AddSlider({
    Title = "Field of View", Min = 50, Max = 120, Default = 70, Rounding = 0,
    Callback = function(v)
        fieldOfView = v
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = v end
    end
})

Tabs.Player:AddButton({
    Title = "Reset Values",
    Description = "Restore default player values",
    Callback = function()
        walkSpeed, jumpPower, gravity, fieldOfView = 16, 50, 196.2, 70
        Workspace.Gravity = gravity
        local h = getHumanoid()
        if h then
            h.WalkSpeed = walkSpeed
            pcall(function() h.UseJumpPower = true end)
            h.JumpPower = jumpPower
        end
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = fieldOfView end
        infiniteJumpEnabled = false
        notify("Reset", "Values restored.")
    end
})

-- ==========================================================
-- MAIN TAB (script execute)
-- ==========================================================
Tabs.Main:AddSection({ Title = "Script Executor" })
Tabs.Main:AddParagraph({
    Title = "Execute Scripts",
    Content = "Tap any button to fetch + run that script. Requires HttpGet + loadstring."
})

local function executeFromUrl(name, url)
    local fetchOk, source = pcall(function() return game:HttpGet(url) end)
    if not fetchOk or type(source) ~= "string" or source == "" then
        notify("Fetch Failed", name, 4)
        return
    end
    local fn, err = loadstring(source, "=" .. name)
    if not fn then notify("Load Error", tostring(err), 5); return end
    local ran, runErr = pcall(fn)
    if not ran then notify("Runtime Error", name .. " • " .. tostring(runErr), 5) else notify("Executed", name) end
end

local scriptEntries = {
    {"FE FLING ALL", "https://raw.githubusercontent.com/MANASMCPE/FlingScripT/refs/heads/main/flingGG.lua.txt"},
    {"LIFE TOGETHER", "https://raw.githubusercontent.com/MANASMCPE/MonKHubRed/refs/heads/main/13967668166_RED.lua"},
    {"Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"FE CHAT DRAW", "https://raw.githubusercontent.com/MANASMCPE/FeChatdraw/refs/heads/main/FeChaTDraw.lua"},
    {"ZM x SPAMMER", "https://raw.githubusercontent.com/MANASMCPE/Zm/refs/heads/main/ZmSpammer.lua"},
    {"Shaders", "https://raw.githubusercontent.com/Uranus197/-Univers-Hub-Graphics-Script-/refs/heads/main/UniversHub"},
    {"COPY AVATAR", "https://raw.githubusercontent.com/MANASMCPE/FiTcopierDeobfByMonK/refs/heads/main/deobfuscated_by_MONK.lua"},
    {"TRAP GUI", "https://raw.githubusercontent.com/MANASMCPE/LIFETOGETHERRPSCRIPTOPENSLURCE-/refs/heads/main/trap.lua"},
    {"WELD Max", "https://raw.githubusercontent.com/MANASMCPE/CelestialWeldByMonKandLisa/refs/heads/main/CELESTIAL.lua"}
}
for _, entry in ipairs(scriptEntries) do
    local name, url = entry[1], entry[2]
    Tabs.Main:AddButton({
        Title = name,
        Description = "Tap to execute",
        Callback = function() executeFromUrl(name, url) end
    })
end

-- ==========================================================
-- TROLL TAB (preview only — disruptive actions disabled)
-- ==========================================================
Tabs.Troll:AddSection({ Title = "Player Preview" })
local selectedPlayerName = nil
local viewConnection

local options = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(options, p.Name) end
end
if #options == 0 then table.insert(options, "No player available") end
table.sort(options)

Tabs.Troll:AddDropdown({
    Title = "Select Player",
    Options = options,
    Default = options[1],
    Callback = function(v)
        if type(v) == "table" then v = v[1] end
        if v == "No player available" or not v then selectedPlayerName = nil
        else selectedPlayerName = tostring(v) end
        notify("Selected", selectedPlayerName or "None")
    end
})

Tabs.Troll:AddToggle({
    Title = "View Target (Camera)",
    Default = false,
    Callback = function(v)
        if viewConnection then viewConnection:Disconnect(); viewConnection = nil end
        if not v then
            local cam = Workspace.CurrentCamera; local h = getHumanoid()
            if cam and h then cam.CameraSubject = h end
            return
        end
        viewConnection = RunService.Heartbeat:Connect(function()
            local t = selectedPlayerName and Players:FindFirstChild(selectedPlayerName)
            local th = t and t.Character and t.Character:FindFirstChildOfClass("Humanoid")
            local cam = Workspace.CurrentCamera
            if cam and th then cam.CameraSubject = th end
        end)
    end
})

Tabs.Troll:AddSection({ Title = "Disabled Features" })
Tabs.Troll:AddParagraph({ Title = "Fling / Bang / Drag", Content = "Disabled — disruptive to other players." })
Tabs.Troll:AddParagraph({ Title = "Fling All", Content = "Disabled — disrupts entire server." })

-- ==========================================================
-- PROTECTION TAB
-- ==========================================================
Tabs.Protection:AddSection({ Title = "Notes" })
Tabs.Protection:AddParagraph({ Title = "Anti Void / God Mode", Content = "Client-side only. No server-side protection guaranteed." })
Tabs.Protection:AddButton({
    Title = "Show Protection Notes",
    Callback = function()
        notify("Protection", "Client-side only. Depends on game/server.", 5)
    end
})

-- ==========================================================
-- WATERMARK + CLEANUP
-- ==========================================================
local function createWatermark()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MonK_Watermark"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 100
    gui.Parent = getGuiParent()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(230, 40)
    frame.Position = UDim2.new(1, -240, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(220, 30, 60)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(235, 235, 240)
    label.Text = "MonK Hub V2"
    label.Parent = frame

    task.spawn(function()
        while gui.Parent do
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            label.Text = string.format("MonK Hub V2  |  %d FPS  |  %d ms", fps, ping)
        end
    end)
end
createWatermark()

Players.PlayerRemoving:Connect(function(p)
    if selectedPlayerName == p.Name then
        selectedPlayerName = nil
        if viewConnection then viewConnection:Disconnect(); viewConnection = nil end
        local cam = Workspace.CurrentCamera; local h = getHumanoid()
        if cam and h then cam.CameraSubject = h end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.4)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = walkSpeed
        pcall(function() h.UseJumpPower = true end)
        h.JumpPower = jumpPower
    end
end)

notify("MonK Hub V2", "Loaded successfully. Welcome!", 4)