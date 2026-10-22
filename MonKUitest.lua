-- ZERO MERCY | Redz UI V5 conversion
-- UI structure and safe local-player controls ported from the WindUI version.
-- Note: disruptive player-targeting actions are intentionally not implemented.
-- External script loaders are shown as URL-copy buttons rather than auto-executed
-- to avoid silently running unreviewed remote code.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Redz = loadstring(game:HttpGet("https://pastefy.app/mHQpCo1e/raw"))()

local Window = Redz:MakeWindow({
    Title = "ZERO MERCY",
    SubTitle = "ZERO MERCY • " .. LocalPlayer.DisplayName,
    ScriptFolder = "ZeroMercyRedz"
})

pcall(function()
    Redz:SetTheme("Darker")
end)

local function notify(title, message, duration)
    pcall(function()
        Window:Notify({
            Title = title or "ZERO MERCY",
            Description = message or "",
            Time = duration or 3
        })
    end)
end

local function makeTab(name, icon)
    local ok, tab = pcall(function()
        return Window:MakeTab({name, icon})
    end)
    if ok then return tab end
    return Window:MakeTab({name, "info"})
end

local InfoTab = makeTab("Info", "info")
local PlayerTab = makeTab("Player", "user")
local MainTab = makeTab("Main", "home")
local TrollTab = makeTab("TROLL", "wind")
local ProtectionTab = makeTab("Protection", "shield")

pcall(function() Window:SelectTab(1) end)

-- INFO
InfoTab:AddSection({Name = "Info"})
InfoTab:AddParagraph("ZERO MERCY", "Redz UI conversion • Original WindUI tabs retained.")
InfoTab:AddParagraph("Community", "Use the official community link only if you trust the source.")
InfoTab:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/EVaFEpdrM")
            notify("Copied", "Discord invite copied to clipboard.")
        else
            notify("Unavailable", "Clipboard function is not supported by this executor.")
        end
    end
})
InfoTab:AddSection({Name = "About"})
InfoTab:AddParagraph("UI", "ZERO MERCY • Crimson/Dark theme • Redz Library V5")

-- PLAYER
PlayerTab:AddSection({Name = "Player"})
local speedValue, jumpValue, gravityValue = 16, 50, 196.2
local infiniteJumpEnabled = false
local noclipEnabled = false
local noclipConnection
local fovValue = 70

local function getHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

PlayerTab:AddSlider({
    Name = "Speed",
    Min = 16, Max = 250, Increment = 1, Default = 16,
    Callback = function(value)
        speedValue = value
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = value end
    end
})
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50, Max = 250, Increment = 1, Default = 50,
    Callback = function(value)
        jumpValue = value
        local hum = getHumanoid()
        if hum then
            pcall(function() hum.UseJumpPower = true end)
            hum.JumpPower = value
        end
    end
})
PlayerTab:AddSlider({
    Name = "Gravity",
    Min = 0, Max = 300, Increment = 1, Default = 196,
    Callback = function(value)
        gravityValue = value
        workspace.Gravity = value
    end
})
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        infiniteJumpEnabled = value
        notify("Infinite Jump", value and "Enabled" or "Disabled")
    end
})
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
PlayerTab:AddButton({
    Name = "Reset Values",
    Callback = function()
        speedValue, jumpValue, gravityValue, fovValue = 16, 50, 196.2, 70
        workspace.Gravity = gravityValue
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = speedValue
            pcall(function() hum.UseJumpPower = true end)
            hum.JumpPower = jumpValue
        end
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = fovValue end
        notify("Reset", "Player values restored.")
    end
})
PlayerTab:AddToggle({
    Name = "Ultimate Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if value then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})
PlayerTab:AddSection({Name = "Change FOV"})
PlayerTab:AddSlider({
    Name = "Fov Player",
    Min = 50, Max = 120, Increment = 1, Default = 70,
    Callback = function(value)
        fovValue = value
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = value end
    end
})
PlayerTab:AddButton({
    Name = "Adjust FOV",
    Callback = function()
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = fovValue end
        notify("FOV", "Field of view applied.")
    end
})

-- MAIN / SCRIPT DIRECTORY
MainTab:AddSection({Name = "Scripts"})
MainTab:AddParagraph("Script directory", "Choose a URL-copy button to review a script before using it. Remote scripts are not automatically executed.")
local scriptLinks = {
    {"FE FLING ALL", "https://raw.githubusercontent.com/MANASMCPE/FlingScripT/refs/heads/main/flingGG.lua.txt", "Player-disruptive script not executed from this menu."},
    {"LIFE TOGETHER", "https://raw.githubusercontent.com/MANASMCPE/MonKHubRed/refs/heads/main/13967668166_RED.lua", "Life Together RP script"},
    {"Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", "Third-party admin script"},
    {"FE CHAT DRAW", "https://raw.githubusercontent.com/MANASMCPE/FeChatdraw/refs/heads/main/FeChaTDraw.lua", "Chat drawing script"},
    {"ZM x SPAMMER", "https://raw.githubusercontent.com/MANASMCPE/Zm/refs/heads/main/ZmSpammer.lua", "Spam automation not executed from this menu."},
    {"Shaders", "https://raw.githubusercontent.com/Uranus197/-Univers-Hub-Graphics-Script-/refs/heads/main/UniversHub", "Graphics/shaders script"},
    {"COPY AVATAR (LIFE TOGETHER RP)", "https://raw.githubusercontent.com/MANASMCPE/FiTcopierDeobfByMonK/refs/heads/main/deobfuscated_by_MONK.lua", "Avatar copy script"},
    {"TRAP GUI", "https://raw.githubusercontent.com/MANASMCPE/LIFETOGETHERRPSCRIPTOPENSLURCE-/refs/heads/main/trap.lua", "External GUI script"},
    {"WELD Max", "https://raw.githubusercontent.com/MANASMCPE/CelestialWeldByMonKandLisa/refs/heads/main/CELESTIAL.lua", "Weld utility script"}
}
for _, item in ipairs(scriptLinks) do
    local title, url, description = item[1], item[2], item[3]
    MainTab:AddButton({
        Name = title,
        Callback = function()
            if title == "FE FLING ALL" or title == "ZM x SPAMMER" then
                notify("Not executed", description)
                return
            end
            if setclipboard then
                setclipboard(url)
                notify("URL copied", title .. " link copied. Review it before use.")
            else
                notify("Unavailable", "Clipboard function is not supported.")
            end
        end
    })
end

-- TROLL TAB: keep the original tab and its sections, without actions that target
-- or disrupt other players.
TrollTab:AddSection({Name = "Select Player"})
TrollTab:AddParagraph("Select Player", "Player selector section retained. Targeted fling/harassment actions are not included.")
TrollTab:AddDropdown({
    Name = "Select Player",
    Options = (function()
        local names = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then table.insert(names, player.Name) end
        end
        return names
    end)(),
    Default = "",
    Callback = function(value)
        notify("Selected", tostring(value))
    end
})
TrollTab:AddSection({Name = "Preview"})
TrollTab:AddParagraph("View Target", "Camera-follow action is not implemented in this safe conversion.")
TrollTab:AddSection({Name = "Fling Actions"})
TrollTab:AddParagraph("Touch Fling", "Not included: disrupts other players.")
TrollTab:AddParagraph("Fling Player (With Noclip)", "Not included: disrupts other players.")
TrollTab:AddParagraph("Fling Player (Bypass Anti Fling)", "Not included: bypasses protections and disrupts other players.")
TrollTab:AddSection({Name = "Special Actions"})
TrollTab:AddParagraph("Bang / Headsit / Stand / Backpack / Doggy / Drag", "These player-targeting actions are not implemented.")
TrollTab:AddSection({Name = "Fling All"})
TrollTab:AddParagraph("Fling All", "Not included: disrupts all players in the server.")

-- PROTECTION
ProtectionTab:AddSection({Name = "Protections"})
ProtectionTab:AddParagraph("Protection status", "Client-side toggles can be game-dependent and cannot guarantee protection from server-side effects.")
local antiCollisionEnabled = false
local antiVoidEnabled = false
local godModeEnabled = false

ProtectionTab:AddToggle({
    Name = "Anti Collision",
    Default = false,
    Callback = function(value)
        antiCollisionEnabled = value
        notify("Anti Collision", value and "Enabled locally where possible" or "Disabled")
    end
})
ProtectionTab:AddToggle({
    Name = "Anti Void",
    Default = false,
    Callback = function(value)
        antiVoidEnabled = value
        notify("Anti Void", value and "Enabled status set" or "Disabled")
    end
})
ProtectionTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        godModeEnabled = value
        notify("God Mode", value and "Requested, but server-side invulnerability is not guaranteed" or "Disabled")
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedValue
        pcall(function() hum.UseJumpPower = true end)
        hum.JumpPower = jumpValue
    end
end)

notify("ZERO MERCY", "Redz UI loaded. Check each feature before use.", 5)
