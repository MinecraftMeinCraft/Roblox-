--!strict
-- Roblox+ 8.2.2 "Fedora"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Roblox+ 8.2.2 Fedora",
    LoadingTitle = "Roblox+",
    LoadingSubtitle = "Fedora Update",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LinuxHub",
        FileName = "robloxplus"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Roblox+ Fedora",
        Subtitle = "Key System",
        Note = "Get key from Swimmiel",
        FileName = "FedoraKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"3141", "31415", "314159", "3141596", "31415962", "FOODGOOD"}
    }
})

-- TABS
local MovementTab = Window:CreateTab("Movement", 4483362458)
local EnhancementsTab = Window:CreateTab("Enhancements", 4483362458)
local AdminTab = Window:CreateTab("Weird Stuff", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

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
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if val and humanoid then
            humanoid.JumpPower = val
        end
    end,
    RemoveTextAfterFocusLost = false,
})

-- FLY TOGGLE (No Speed Edit)
local flying = false
MovementTab:CreateToggle({
    Name = "Fly Toggle (E)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(state)
        flying = state
    end,
})

-- FLY LOGIC (Key E)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        flying = not flying
    end
end)

RunService.RenderStepped:Connect(function()
    if flying then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)

-- INFINITE JUMP
local infJump = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space and infJump then
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(state)
        infJump = state
    end,
})

-- ADMIN SCRIPT SELECTOR
local adminOption = {"Nameless Admin"}

AdminTab:CreateDropdown({
    Name = "Select Admin Script",
    Options = {"Infinite Yield", "Nameless Admin"},
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
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NA%20testing.lua"))()
        end
    end,
})

-- ENHANCEMENTS TAB
EnhancementsTab:CreateButton({
    Name = "Load Syla Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SylaHub/Syla-Hub/refs/heads/main/Loader"))()
    end,
})

EnhancementsTab:CreateButton({
    Name = "Load Voidware",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRewrite/main/NewMainScript.lua", true))()
    end,
})

EnhancementsTab:CreateButton({
    Name = "Load Flicker",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MinecraftMeinCraft/Roblox-/refs/heads/main/Flicker",true))()
    end,
})

-- MISC TAB

-- Fling toggle (run script when toggled on)
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

-- Anti-Fling toggle
MiscTab:CreateToggle({
    Name = "Anti-Fling",
    CurrentValue = false,
    Flag = "AntiFling",
    Callback = function(enabled)
        if enabled then
            for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CustomPhysicalProperties = PhysicalProperties.new(9e110, 9e110, 9e110)
                end
            end
        end
    end,
})

-- Teleport tool button
MiscTab:CreateButton({
    Name = "Teleport Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        tool.Activated:Connect(function()
            local mouse = game.Players.LocalPlayer:GetMouse()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            game.Players.LocalPlayer.Character:MoveTo(pos.Position)
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end,
})

-- Player action dropdown and input
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
            game.Players.LocalPlayer:Kick(kickMessage)
        else
            game.Players.LocalPlayer:Destroy()
        end
    end,
})

-- KEYBINDS

-- Infinite Jump Hold Keybind
MiscTab:CreateKeybind({
    Name = "Toggle Infinite Jump (Hold)",
    CurrentKeybind = "H",
    HoldToInteract = true,
    Flag = "HoldJump",
    Callback = function(held)
        infJump = held
    end,
})

-- Panic Button Hold Keybind (quick Rayfield unload)
MiscTab:CreateKeybind({
    Name = "Panic Button (Hold)",
    CurrentKeybind = "P",
    HoldToInteract = true,
    Flag = "Panic",
    Callback = function(held)
        if held then
            local rayfieldUI = game.CoreGui:FindFirstChild("Rayfield")
            if rayfieldUI then
                rayfieldUI:Destroy()
            end
        end
    end,
})

-- Lag Switch toggle (packet suspension simulation)
local lagSwitchEnabled = false
MiscTab:CreateToggle({
    Name = "Lag Switch",
    CurrentValue = false,
    Flag = "LagSwitch",
    Callback = function(value)
        lagSwitchEnabled = value
        if lagSwitchEnabled then
            -- Simulate packet suspension by disconnecting CharacterRootPart position updates (simple mock)
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                hrp:GetPropertyChangedSignal("CFrame"):Connect(function()
                    if lagSwitchEnabled then
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end,
})

return Window
