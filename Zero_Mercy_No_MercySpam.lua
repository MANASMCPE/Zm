-- ZERO MERCY | NO MERCY EDITION
-- Local UI redesign for Roblox. Safe preview mode: does not spam public chat,
-- invoke game remotes, or run owner/admin commands against other players.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local OLD_NAME = "ZeroMercyNoMercyUI"
local previous = PlayerGui:FindFirstChild(OLD_NAME)
if previous then previous:Destroy() end

local C = {
    bg = Color3.fromRGB(8, 8, 11),
    panel = Color3.fromRGB(17, 17, 23),
    card = Color3.fromRGB(25, 22, 28),
    red = Color3.fromRGB(255, 35, 65),
    redDark = Color3.fromRGB(115, 8, 27),
    white = Color3.fromRGB(245, 242, 246),
    muted = Color3.fromRGB(160, 150, 160),
    green = Color3.fromRGB(110, 255, 165),
}

local gui = Instance.new("ScreenGui")
gui.Name = OLD_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.red
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function clickSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://12221967"
    s.Volume = 0.25
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function makeLabel(parent, text, size, pos, font, color, textSize)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = pos
    l.Font = font or Enum.Font.Gotham
    l.TextColor3 = color or C.white
    l.TextSize = textSize or 13
    l.TextWrapped = true
    l.Parent = parent
    return l
end

local function makeButton(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = C.card
    b.Text = text
    b.TextColor3 = C.white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = parent
    corner(b, 8)
    local st = stroke(b, C.redDark, 1)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(48, 16, 27)}):Play()
        st.Color = C.red
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.card}):Play()
        st.Color = C.redDark
    end)
    b.Activated:Connect(clickSound)
    return b
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 430, 0, 430)
main.Position = UDim2.new(0.5, -215, 0.5, -215)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 14)
stroke(main, C.red, 1.5)
local mainConstraint = Instance.new("UISizeConstraint")
mainConstraint.MinSize = Vector2.new(300, 350)
mainConstraint.MaxSize = Vector2.new(560, 540)
mainConstraint.Parent = main

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 8, 15)),
    ColorSequenceKeypoint.new(0.55, C.bg),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 7, 16)),
})
gradient.Rotation = 35
gradient.Parent = main

-- Dragging works with mouse or touch; drag from the top header.
local header = Instance.new("Frame")
header.Name = "DragHeader"
header.Size = UDim2.new(1, 0, 0, 64)
header.BackgroundColor3 = C.panel
header.BorderSizePixel = 0
header.Parent = main
corner(header, 14)
local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 15)
headerCover.Position = UDim2.new(0, 0, 1, -15)
headerCover.BackgroundColor3 = C.panel
headerCover.BorderSizePixel = 0
headerCover.Parent = header

makeLabel(header, "ZERO MERCY", UDim2.new(1, -112, 0, 28), UDim2.new(0, 16, 0, 8), Enum.Font.GothamBlack, C.red, 21).TextXAlignment = Enum.TextXAlignment.Left
makeLabel(header, "NO MERCY EDITION  //  LOCAL UI", UDim2.new(1, -120, 0, 18), UDim2.new(0, 17, 0, 36), Enum.Font.Code, C.muted, 9).TextXAlignment = Enum.TextXAlignment.Left

local minimize = makeButton(header, "—", UDim2.new(0, 32, 0, 30), UDim2.new(1, -76, 0, 16))
local close = makeButton(header, "×", UDim2.new(0, 32, 0, 30), UDim2.new(1, -38, 0, 16))
close.BackgroundColor3 = Color3.fromRGB(80, 12, 28)

local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -24, 0, 36)
tabs.Position = UDim2.new(0, 12, 0, 74)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local spamTab = makeButton(tabs, "CONTROL", UDim2.new(0.5, -4, 1, 0), UDim2.new(0, 0, 0, 0))
local infoTab = makeButton(tabs, "INFO / MEMBERS", UDim2.new(0.5, -4, 1, 0), UDim2.new(0.5, 4, 0, 0))

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -124)
content.Position = UDim2.new(0, 12, 0, 118)
content.BackgroundTransparency = 1
content.Parent = main

local controlPage = Instance.new("Frame")
controlPage.Size = UDim2.new(1, 0, 1, 0)
controlPage.BackgroundTransparency = 1
controlPage.Parent = content

makeLabel(controlPage, "TARGET SCANNER", UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, 0), Enum.Font.GothamBlack, C.white, 13).TextXAlignment = Enum.TextXAlignment.Left
local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(1, 0, 0, 42)
targetBox.Position = UDim2.new(0, 0, 0, 28)
targetBox.BackgroundColor3 = C.panel
targetBox.TextColor3 = C.white
targetBox.PlaceholderColor3 = C.muted
targetBox.PlaceholderText = "Enter target name (try MonK)"
targetBox.Text = ""
targetBox.ClearTextOnFocus = false
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 13
targetBox.Parent = controlPage
corner(targetBox, 8)
stroke(targetBox, C.redDark, 1)

local detect = makeButton(controlPage, "SCAN TARGET", UDim2.new(0.48, -4, 0, 38), UDim2.new(0, 0, 0, 80))
local preview = makeButton(controlPage, "START LOCAL PREVIEW", UDim2.new(0.52, -4, 0, 38), UDim2.new(0.48, 8, 0, 80))
local statusCard = Instance.new("Frame")
statusCard.Size = UDim2.new(1, 0, 0, 78)
statusCard.Position = UDim2.new(0, 0, 0, 130)
statusCard.BackgroundColor3 = C.panel
statusCard.Parent = controlPage
corner(statusCard, 10)
stroke(statusCard, C.redDark, 1)
local statusTitle = makeLabel(statusCard, "SYSTEM STATUS", UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 8), Enum.Font.GothamBold, C.red, 11)
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
local statusText = makeLabel(statusCard, "READY  •  Preview mode is idle.", UDim2.new(1, -20, 0, 38), UDim2.new(0, 10, 0, 30), Enum.Font.Code, C.white, 11)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top

makeLabel(controlPage, "Preview runs only inside this GUI; it does not send chat spam.", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 220), Enum.Font.Gotham, C.muted, 10)

local infoPage = Instance.new("Frame")
infoPage.Size = UDim2.new(1, 0, 1, 0)
infoPage.BackgroundTransparency = 1
infoPage.Visible = false
infoPage.Parent = content

makeLabel(infoPage, "ZERO MERCY MEMBERS", UDim2.new(1, 0, 0, 24), UDim2.new(0, 0, 0, 0), Enum.Font.GothamBlack, C.red, 14).TextXAlignment = Enum.TextXAlignment.Left
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 34)
searchBox.Position = UDim2.new(0, 0, 0, 28)
searchBox.BackgroundColor3 = C.panel
searchBox.TextColor3 = C.white
searchBox.PlaceholderColor3 = C.muted
searchBox.PlaceholderText = "Search members..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.Parent = infoPage
corner(searchBox, 8)
stroke(searchBox, C.redDark, 1)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, 0, 1, -72)
list.Position = UDim2.new(0, 0, 0, 70)
list.BackgroundColor3 = C.panel
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.ScrollBarImageColor3 = C.red
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = infoPage
corner(list, 9)
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list
local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 8)
listPadding.PaddingRight = UDim.new(0, 8)
listPadding.Parent = list

local members = {
    "LUFFY", "UMAIR", "VENOM", "AZAN", "SUKI", "AYANNU", "VIKRANSH",
    "ABUDL SABOOR", "ALMEER", "SAMRAT", "NIL", "ALPHA", "BUNNY",
    "ISHANT", "MADARA", "HUNTER", "RAIYAN", "KAIRO", "DEMON", "TALHA",
    "KOF", "ZENEX", "SHAFI", "KUMAIL", "SAIF", "ROLEX", "ERROR", "MEHDI",
    "ABUDLLAH", "ALI", "KHAN", "KAISER", "SAAD", "YUSIF", "MOMI", "AWAIS",
    "INDRA", "HARSH"
}
local memberRows = {}
for i, name in ipairs(members) do
    local row = Instance.new("Frame")
    row.Name = "Member_" .. name:gsub("%s+", "_")
    row.Size = UDim2.new(1, -2, 0, 32)
    row.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(27, 22, 29) or Color3.fromRGB(21, 19, 25)
    row.LayoutOrder = i
    row.Parent = list
    corner(row, 6)
    local indexLabel = makeLabel(row, string.format("%02d", i), UDim2.new(0, 34, 1, 0), UDim2.new(0, 7, 0, 0), Enum.Font.Code, C.red, 11)
    indexLabel.TextXAlignment = Enum.TextXAlignment.Left
    local nameLabel = makeLabel(row, name, UDim2.new(1, -52, 1, 0), UDim2.new(0, 42, 0, 0), Enum.Font.GothamBold, C.white, 11)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    memberRows[#memberRows + 1] = {frame = row, name = name}
end

local function filterMembers()
    local query = searchBox.Text:lower()
    for _, item in ipairs(memberRows) do
        item.frame.Visible = query == "" or item.name:lower():find(query, 1, true) ~= nil
    end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(filterMembers)

local function showPage(which)
    clickSound()
    local showInfo = which == "info"
    controlPage.Visible = not showInfo
    infoPage.Visible = showInfo
    spamTab.BackgroundColor3 = not showInfo and Color3.fromRGB(70, 12, 28) or C.card
    infoTab.BackgroundColor3 = showInfo and Color3.fromRGB(70, 12, 28) or C.card
end
spamTab.Activated:Connect(function() showPage("control") end)
infoTab.Activated:Connect(function() showPage("info") end)

detect.Activated:Connect(function()
    local query = targetBox.Text:lower():gsub("%s+", "")
    if query == "" then
        statusTitle.Text = "TARGET REQUIRED"
        statusText.Text = "Enter a target name to scan."
        statusTitle.TextColor3 = C.red
    elseif query:find("monk", 1, true) then
        statusTitle.Text = "OWNER DETECTED"
        statusText.Text = "MonK matched the owner keyword. This is a local UI indicator only."
        statusTitle.TextColor3 = C.green
    else
        statusTitle.Text = "SCAN COMPLETE"
        statusText.Text = "No owner keyword detected for: " .. targetBox.Text
        statusTitle.TextColor3 = C.red
    end
end)

local running = false
local demoMessages = {
    "ZERO MERCY // SYSTEM READY",
    "NO MERCY MODE // LOCAL PREVIEW",
    "OWNER CHECK // UI SIGNAL ONLY",
    "ZERO MERCY MEMBERS // DIRECTORY ONLINE",
}
preview.Activated:Connect(function()
    running = not running
    preview.Text = running and "STOP LOCAL PREVIEW" or "START LOCAL PREVIEW"
    if running then
        statusTitle.Text = "PREVIEW ACTIVE"
        statusTitle.TextColor3 = C.green
        task.spawn(function()
            local i = 0
            while running and gui.Parent do
                i = (i % #demoMessages) + 1
                statusText.Text = demoMessages[i]
                task.wait(1.4)
            end
        end)
    else
        statusTitle.Text = "PREVIEW STOPPED"
        statusTitle.TextColor3 = C.red
        statusText.Text = "Ready. No messages were sent to public chat."
    end
end)

-- A local-only overhead title for the matching account if it is in this server.
-- BillboardGui is created on this client only and does not grant real permissions.
local function addLocalOwnerTitle(player)
    if player.Name:lower() ~= "supermonkxscripts" then return end
    local function attach(character)
        local head = character:WaitForChild("Head", 8)
        if not head or not gui.Parent then return end
        local old = head:FindFirstChild("ZeroMercyOwnerTitle_Local")
        if old then old:Destroy() end
        local tag = Instance.new("BillboardGui")
        tag.Name = "ZeroMercyOwnerTitle_Local"
        tag.Size = UDim2.new(0, 180, 0, 44)
        tag.StudsOffset = Vector3.new(0, 2.8, 0)
        tag.AlwaysOnTop = true
        tag.Adornee = head
        tag.Parent = head
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "✦ OWNER ✦"
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 17
        label.TextColor3 = C.red
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0.15
        label.Parent = tag
        local outline = Instance.new("UIStroke")
        outline.Color = C.redDark
        outline.Thickness = 1
        outline.Parent = label
    end
    if player.Character then task.spawn(attach, player.Character) end
    player.CharacterAdded:Connect(attach)
end
for _, p in ipairs(Players:GetPlayers()) do addLocalOwnerTitle(p) end
Players.PlayerAdded:Connect(addLocalOwnerTitle)

local minimized = false
local oldSize = main.Size
minimize.Activated:Connect(function()
    minimized = not minimized
    clickSound()
    if minimized then
        oldSize = main.Size
        content.Visible = false
        tabs.Visible = false
        TweenService:Create(main, TweenInfo.new(0.18), {Size = UDim2.new(0, 300, 0, 64)}):Play()
        minimize.Text = "+"
    else
        TweenService:Create(main, TweenInfo.new(0.18), {Size = oldSize}):Play()
        task.delay(0.18, function()
            if main.Parent then
                content.Visible = true
                tabs.Visible = true
            end
        end)
        minimize.Text = "—"
    end
end)

close.Activated:Connect(function()
    clickSound()
    running = false
    gui:Destroy()
end)

-- Subtle animated border pulse.
task.spawn(function()
    local s = main:FindFirstChildOfClass("UIStroke")
    while gui.Parent and s do
        TweenService:Create(s, TweenInfo.new(0.8), {Transparency = 0.35}):Play()
        task.wait(0.8)
        if not gui.Parent then break end
        TweenService:Create(s, TweenInfo.new(0.8), {Transparency = 0}):Play()
        task.wait(0.8)
    end
end)

showPage("control")
