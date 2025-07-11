-- Roblox+ 11.0 GhostBSD --!strict
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Roblox+ 11.0 GhostBSD",
    LoadingTitle = "Roblox+",
    LoadingSubtitle = "GhostBSD Update",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LinuxHub",
        FileName = "robloxplus-11.0-GhostBSD"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Roblox+ GhostBSD",
        Subtitle = "Key System",
        Note = "Get key from Swimmiel",
        FileName = "GhostBSDKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"3141", "31415", "314159", "3141596", "31415962", "FOODGOOD"}
    }
})

-- TABS
local MovementTab = Window:CreateTab("Movement", 4483362458)
local EnhancementsTab = Window:CreateTab("Enhancements", 4483362458)
local AdminTab = Window:CreateTab("Admin", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- MOVEMENT INPUTS
local gravityInput = MovementTab:CreateInput({
    Name = "Gravity",
    PlaceholderText = "Enter Gravity",
    Flag = "GravityInput",
    Callback = function(value)
        local val = tonumber(value)
        if val then
            workspace.Gravity = val
        end
    end,
    RemoveTextAfterFocusLost = false,
})

local walkspeedInput = MovementTab:CreateInput({
    Name = "WalkSpeed",
    PlaceholderText = "Enter WalkSpeed",
    Flag = "WalkspeedInput",
    Callback = function(value)
        local val = tonumber(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if val and humanoid then
            humanoid.WalkSpeed = val
        end
    end,
    RemoveTextAfterFocusLost = false,
})

local jumppowerInput = MovementTab:CreateInput({
    Name = "JumpPower",
    PlaceholderText = "Enter JumpPower",
    Flag = "JumpPowerInput",
    Callback = function(value)
        local val = tonumber(value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if val and humanoid then
            humanoid.JumpPower = val
        end
    end,
    RemoveTextAfterFocusLost = false,
})

-- Animation speed and pause toggles omitted here for brevity (add if needed)

-- HITBOX EXPANSION (Head hitbox multiplier)
local function ExpandHeadHitbox(multiplier)
    local character = LocalPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        -- Reset to normal size first
        head.Size = Vector3.new(2, 1, 1)
        -- Apply multiplier to size (scale uniformly on all axes or just X/Z)
        -- Typical head size is roughly Vector3(2,1,1), let's scale X and Z (width & depth)
        local newSize = Vector3.new(2 * multiplier, 1, 1 * multiplier)
        head.Size = newSize
        
        -- Optional: adjust the hitbox offset (e.g., hitbox part position) if needed here
    end
end

local hitboxMultiplier = 1
local hitboxInput = MovementTab:CreateInput({
    Name = "Hitbox Size Multiplier",
    PlaceholderText = "Enter 1 for normal, 2 for double size...",
    Flag = "HitboxMultiplierInput",
    Callback = function(value)
        local val = tonumber(value)
        if val and val >= 1 then
            hitboxMultiplier = val
            ExpandHeadHitbox(hitboxMultiplier)
        end
    end,
    RemoveTextAfterFocusLost = false,
})

-- NOCLIP TOGGLE (moved to Movement tab)
local noclipEnabled = false
MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(state)
        noclipEnabled = state
    end,
})

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- PANIC TOGGLE (changed from hold to toggle)
local panicActive = false
MiscTab:CreateToggle({
    Name = "Panic Mode",
    CurrentValue = false,
    Flag = "PanicToggle",
    Callback = function(state)
        panicActive = state
        if panicActive then
            local rayfieldUI = game.CoreGui:FindFirstChild("Rayfield")
            if rayfieldUI then
                rayfieldUI:Destroy()
            end
        end
    end,
})

-- ENHANCEMENTS TAB
EnhancementsTab:CreateButton({
    Name = "Load Voidware",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRewrite/main/NewMainScript.lua", true))()
    end,
})

-- ADMIN TAB
local adminOption = {"Nameless Admin"}
AdminTab:CreateDropdown({
    Name = "Select Admin Script",
    Options = {"Infinite Yield", "Nameless Admin", "Honeycomb 8.1 🍯"},
    CurrentOption = {"Nameless Admin"},
    MultipleOptions = false,
    Flag = "AdminDropdown",
    Callback = function(option)
        adminOption = option
    end,
})

AdminTab:CreateButton({
    Name = "Run Admin Script",
    Callback = function()
        if adminOption[1] == "Infinite Yield" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        elseif adminOption[1] == "Nameless Admin" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NA%20testing.lua"))()
        elseif adminOption[1] == "Honeycomb 8.1 🍯" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/MinecraftMeinCraft/Roblox-/refs/heads/main/Honeycomb%20Admin%208.1%20Oreo%20(BASIC)", true))()
        end
    end,
})

-- MISC TAB
local flingEnabled = false
MiscTab:CreateToggle({
    Name = "Fling Toggle",
    CurrentValue = false,
    Flag = "FlingToggle",
    Callback = function(value)
        flingEnabled = value
        if value then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt', true))()
        end
    end,
})

MiscTab:CreateToggle({
    Name = "Anti-Fling",
    CurrentValue = false,
    Flag = "AntiFling",
    Callback = function(enabled)
        if enabled and LocalPlayer.Character then
            for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CustomPhysicalProperties = PhysicalProperties.new(9e110, 9e110, 9e110)
                end
            end
        end
    end,
})

MiscTab:CreateButton({
    Name = "Teleport Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(pos.Position)
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end,
})

local playerOption = {"player:kick"}
local kickMessage = "You have been kicked!"
MiscTab:CreateDropdown({
    Name = "Select Player Action",
    Options = {"player:kick", "player:destroy"},
    CurrentOption = {"player:kick"},
    MultipleOptions = false,
    Flag = "PlayerAction",
    Callback = function(option)
        playerOption = option
    end,
})

MiscTab:CreateInput({
    Name = "Kick Message",
    PlaceholderText = "Enter message",
    Flag = "KickMessage",
    Callback = function(msg)
        kickMessage = msg
    end,
    RemoveTextAfterFocusLost = false,
})

MiscTab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        if playerOption[1] == "player:kick" then
            LocalPlayer:Kick(kickMessage)
        else
            LocalPlayer:Destroy()
        end
    end,
})

-- Keybinds (Infinite Jump Hold, etc.) - add if needed, matching the style from your previous versions

return Window
