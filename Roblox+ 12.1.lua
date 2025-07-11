local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Roblox+ 12.1 Tiramisu",
    LoadingTitle = "Roblox+ Loading",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LinuxHub", -- Config folder
        FileName = "RobloxPlusConfig"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ===== Movement Tab =====
local MovementTab = Window:CreateTab("Movement", 4483362458)

local walkSpeedInput = MovementTab:CreateInput({
    Name = "WalkSpeed",
    PlaceholderText = "16 (default)",
    RemoveTextAfterFocusLost = false,
    Flag = "WalkSpeedInput",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.WalkSpeed = num
            end
        end
    end,
})

local jumpPowerInput = MovementTab:CreateInput({
    Name = "JumpPower",
    PlaceholderText = "50 (default)",
    RemoveTextAfterFocusLost = false,
    Flag = "JumpPowerInput",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.JumpPower = num
            end
        end
    end,
})

local gravityInput = MovementTab:CreateInput({
    Name = "Gravity",
    PlaceholderText = "196.2 (default)",
    RemoveTextAfterFocusLost = false,
    Flag = "GravityInput",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            workspace.Gravity = num
        end
    end,
})

MovementTab:CreateButton({
    Name = "Reset Movement",
    Callback = function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = 16
            lp.Character.Humanoid.JumpPower = 50
        end
        workspace.Gravity = 196.2
    end,
})

-- ===== Hitbox Tab =====
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

local hitboxSizeXInput = HitboxTab:CreateInput({
    Name = "Hitbox Size X",
    PlaceholderText = "4",
    RemoveTextAfterFocusLost = false,
    Flag = "HitboxSizeX",
})

local hitboxSizeYInput = HitboxTab:CreateInput({
    Name = "Hitbox Size Y",
    PlaceholderText = "5",
    RemoveTextAfterFocusLost = false,
    Flag = "HitboxSizeY",
})

local hitboxSizeZInput = HitboxTab:CreateInput({
    Name = "Hitbox Size Z",
    PlaceholderText = "4",
    RemoveTextAfterFocusLost = false,
    Flag = "HitboxSizeZ",
})

local hitboxColorPicker = HitboxTab:CreateColorPicker({
    Name = "Hitbox Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "HitboxColor",
})

local hitboxTransparencyInput = HitboxTab:CreateInput({
    Name = "Hitbox Transparency",
    PlaceholderText = "0.5",
    RemoveTextAfterFocusLost = false,
    Flag = "HitboxTransparency",
})

local hitboxMaterialInput = HitboxTab:CreateInput({
    Name = "Hitbox Material",
    PlaceholderText = "Neon",
    RemoveTextAfterFocusLost = false,
    Flag = "HitboxMaterial",
})

local hitboxToggle = HitboxTab:CreateToggle({
    Name = "Enable Hitbox Expansion",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(enabled)
        if enabled then
            RunService:BindToRenderStep("HitboxExpand", 301, function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local root = player.Character.HumanoidRootPart
                        root.Size = Vector3.new(
                            tonumber(hitboxSizeXInput:GetValue()) or 4,
                            tonumber(hitboxSizeYInput:GetValue()) or 5,
                            tonumber(hitboxSizeZInput:GetValue()) or 4
                        )
                        root.Transparency = tonumber(hitboxTransparencyInput:GetValue()) or 0.5
                        root.Color = hitboxColorPicker:GetColor()
                        root.Material = Enum.Material[hitboxMaterialInput:GetValue()] or Enum.Material.Neon
                        root.CanCollide = false
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep("HitboxExpand")
            -- Reset all hitboxes to default sizes & properties on disable
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                    root.Color = Color3.new(1, 1, 1)
                    root.Material = Enum.Material.Plastic
                    root.CanCollide = true
                end
            end
        end
    end,
})

-- ===== Utility Tab =====
local UtilityTab = Window:CreateTab("Utility", 4483362458)

UtilityTab:CreateButton({
    Name = "Panic Destroy UI",
    Callback = function()
        if Window then
            Window:Destroy()
        end
        Rayfield:Notify({
            Title = "Panic Activated",
            Content = "UI destroyed. Reload script to use again.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

UtilityTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId)
    end,
})

-- ===== Admin Tab =====
local AdminTab = Window:CreateTab("Admin", 4483362458)

AdminTab:CreateDropdown({
    Name = "Admin Script",
    Options = {"Infinite Yield", "Honeycomb"},
    CurrentOption = "Honeycomb",
    Flag = "AdminScriptDropdown",
    Callback = function(selected)
        if selected == "Infinite Yield" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source.lua"))()
        elseif selected == "Honeycomb" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/MinecraftMeinCraft/Roblox-/refs/heads/main/Honeycomb%20Admin%208.1%20Oreo%20(BASIC)"))()
        end
    end,
})

-- End of script
