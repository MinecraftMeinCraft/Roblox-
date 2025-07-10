-- Roblox+ 4.0 "Fedora"
-- Fully Integrated Script
-- Uses Rayfield UI: https://sirius.menu/rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Window Setup
local Window = Rayfield:CreateWindow({
    Name = "Roblox+ 4.0 \"Fedora\"",
    LoadingTitle = "Roblox+",
    LoadingSubtitle = "Fedora",
    ConfigurationSaving = { Enabled = true, FolderName = "RobloxPlus", FileName = "config" },
    KeySystem = false,
})

-- ===== SCRIPT OPTIONS TAB =====
local OptionsTab = Window:CreateTab("Script Options", "settings")
local ThemeList = {"Default","AmberGlow","Amethyst","Bloom","DarkBlue","Green","Light","Ocean","Serenity"}
OptionsTab:CreateDropdown({
    Name = "Change Rayfield Theme",
    Options = ThemeList,
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "ThemeDropdown",
    Callback = function(opt) Window:ModifyTheme(opt[1]) end,
})
OptionsTab:CreateSlider({
    Name = "UI Scale (%)",
    Min = 50, Max = 150, Default = 100, Flag = "UIScale",
    Callback = function(val)
        local scale = val/100
        Window.Root:TweenSizeAndPosition(
            UDim2.new(scale,0,scale,0), UDim2.new(0.5-scale/2,0,0.5-scale/2,0),
            Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.3,true
        )
    end,
})
OptionsTab:CreateToggle({
    Name = "Dark Mode",
    Flag = "DarkMode",
    CurrentValue = true,
    Callback = function(val)
        Window:ModifyTheme(val and "Default" or "Light")
    end,
})

-- ===== PERFORMANCE TAB =====
local PerfTab = Window:CreateTab("Performance", "cpu")
PerfTab:CreateSection("Graphics Options")
PerfTab:CreateToggle({ Name="Disable Shadows", Flag="DisableShadows", CurrentValue=false, Callback=function(v) Lighting.GlobalShadows = not v end })
PerfTab:CreateToggle({ Name="Low Lighting Quality", Flag="LowLightingQuality", CurrentValue=false, Callback=function(v)
    if v then Lighting.FogEnd=100; Lighting.ExposureCompensation=-1; Lighting.Brightness=1
    else Lighting.FogEnd=100000; Lighting.ExposureCompensation=0; Lighting.Brightness=2 end
end })
PerfTab:CreateToggle({ Name="Disable Particles & Effects", Flag="DisableParticles", CurrentValue=false, Callback=function(v)
    for _, e in ipairs(workspace:GetDescendants()) do
        if e:IsA("ParticleEmitter") or e:IsA("Trail") or e:IsA("Beam") then e.Enabled = not v end
    end
end })
PerfTab:CreateToggle({ Name="Remove Meshes", Flag="RemoveMeshes", CurrentValue=false, Callback=function(v)
    for _, m in ipairs(workspace:GetDescendants()) do
        if m:IsA("MeshPart") or m:IsA("SpecialMesh") then m.Transparency = v and 1 or 0 end
    end
end })
PerfTab:CreateToggle({ Name="Unlock FPS", Flag="UnlockFPS", CurrentValue=false, Callback=function(v)
    if v then settings().Rendering.FramerateManager = Enum.FramerateManager.Disabled
    else settings().Rendering.FramerateManager = Enum.FramerateManager.Default end
end })
PerfTab:CreateSlider({ Name="Graphics Quality Level", Min=1, Max=10, Default=10, Flag="GraphicsQuality", Callback=function(v)
    settings().Rendering.QualityLevel = math.floor(v)
end })

-- FPS Display
local fpsLabel, fpsConn
PerfTab:CreateToggle({ Name="Show FPS", Flag="ShowFPS", CurrentValue=false, Callback=function(state)
    if state then
        if not fpsLabel then
            local gui=Instance.new("ScreenGui",game.CoreGui); gui.Name="FPSGui"
            fpsLabel=Instance.new("TextLabel",gui)
            fpsLabel.BackgroundTransparency=0.5; fpsLabel.BackgroundColor3=Color3.new(0,0,0)
            fpsLabel.Position=UDim2.new(0,0,0,0); fpsLabel.Size=UDim2.new(0,100,0,30)
            fpsLabel.Font=Enum.Font.SourceSansBold; fpsLabel.TextSize=20; fpsLabel.TextColor3=Color3.new(0,1,0)
        end
        local last,tCount = tick(),0
        fpsConn=RunService.RenderStepped:Connect(function()
            tCount+=1; local now=tick()
            if now-last>=1 then fpsLabel.Text="FPS: "..tCount; tCount=0; last=now end
        end)
    else
        if fpsConn then fpsConn:Disconnect(); fpsConn=nil end
        if fpsLabel then fpsLabel.Parent:Destroy(); fpsLabel=nil end
    end
end })

-- ===== VISUAL TAB =====
local VisTab=Window:CreateTab("Visual","eye")
VisTab:CreateSection("Fullbright Settings")
local fbMode="Remove Darkness"; local pl, nv
VisTab:CreateDropdown({ Name="Fullbright Mode", Options={"Remove Darkness","Point Light","Night Vision"}, CurrentOption={"Remove Darkness"}, Flag="FBMode", Callback=function(o) fbMode=o[1] end })
VisTab:CreateToggle({ Name="Enable Fullbright", Flag="FBToggle", CurrentValue=false, Callback=function(en)
    local L=Lighting
    if not en then
        L.Brightness=2; L.GlobalShadows=true; L.Ambient=Color3.new(0.5,0.5,0.5); L.OutdoorAmbient=Color3.new(0.5,0.5,0.5)
        if pl then pl:Destroy(); pl=nil end; if nv then nv:Destroy(); nv=nil end
    else
        if fbMode=="Remove Darkness" then L.Brightness=2; L.GlobalShadows=false; L.Ambient=Color3.new(1,1,1); L.OutdoorAmbient=Color3.new(1,1,1)
        elseif fbMode=="Point Light" then
            if not pl then pl=Instance.new("PointLight"); pl.Brightness=10; pl.Range=30; pl.Parent=LocalPlayer.Character.HumanoidRootPart end
        elseif fbMode=="Night Vision" then
            if not nv then nv=Instance.new("ScreenGui",game.CoreGui); local f=Instance.new("Frame",nv); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Color3.new(0,0.3,0); f.BackgroundTransparency=0.4; f.BorderSizePixel=0 end
        end
    end
end })

VisTab:CreateSection("ESP Settings")
local espOn=false; local espData={}
VisTab:CreateToggle({ Name="Enable ESP", Flag="ESPFlag", CurrentValue=false, Callback=function(en)
    espOn=en
    if en then
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart"); local hum=p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                espData[p]={boxes={},text=nil}
                for _,nm in ipairs({"HumanoidRootPart","Head","LeftHand","RightHand","LeftFoot","RightFoot"}) do
                    local part=p.Character:FindFirstChild(nm)
                    if part and part:IsA("BasePart") then
                        local b=Instance.new("BoxHandleAdornment",part)
                        b.Adornee=part; b.AlwaysOnTop=true; b.Size=part.Size; b.Transparency=0.5; b.ZIndex=10; table.insert(espData[p].boxes,b)
                    end
                end
                local bb=Instance.new("BillboardGui",hrp); bb.Size=UDim2.new(0,200,0,50); bb.StudsOffset=Vector3.new(0,2,0); bb.AlwaysOnTop=true
                local lbl=Instance.new("TextLabel",bb); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.TextScaled=true; lbl.Font=Enum.Font.SourceSansBold; espData[p].text=lbl
            end end end
        espData.conn=RunService.RenderStepped:Connect(function()
            for plr,data in pairs(espData) do if plr.Character and data.text then
                local hrp=plr.Character.HumanoidRootPart; local hum=plr.Character:FindFirstChildOfClass("Humanoid"); local d=(hrp.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local col=d<20 and Color3.new(0,1,0) or d<50 and Color3.new(1,0.65,0) or Color3.new(1,0,0)
                for _,b in ipairs(data.boxes) do b.Color3=col end
                data.text.Text=string.format("%s (%s)\nHP:%d  %.1f stud",plr.DisplayName,plr.Name,math.floor(hum.Health),d); data.text.TextColor3=col
            end end)
    else
        if espData.conn then espData.conn:Disconnect(); espData.conn=nil end
        for _,data in pairs(espData) do
            for _,b in ipairs(data.boxes) do b:Destroy() end; if data.text and data.text.Parent then data.text.Parent:Destroy() end
        end; espData={}
    end
end })

-- ===== UTILITIES TAB =====
local UtilTab=Window:CreateTab("Utilities","settings")
local noClip = false
local infJump = false
local flyMode = false
local moon = false
local gravityUnlocked = true
local walkSpeed = 16
local jumpPower = 50
local CustomGravity = workspace.Gravity
UtilTab:CreateToggle({ Name="Enable NoClip", Flag="NoClipToggle", CurrentValue=false, Callback=function(v) noClip=v end })
RunService.Stepped:Connect(function() if noClip and LocalPlayer.Character then for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)

UtilTab:CreateToggle({ Name="Infinite Jump", Flag="InfJump", CurrentValue=false, Callback=function(v) infJump=v end })
RunService.RenderStepped:Connect(function() if infJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(3) end end)

UtilTab:CreateToggle({ Name="Swim/Fly Mode", Flag="SwimFlyToggle", CurrentValue=false, Callback=function(v)
    flyMode=v; local h=LocalPlayer.Character.Humanoid
    if v then h:ChangeState(4); h.WalkSpeed=walkSpeed else h:ChangeState(0); h.WalkSpeed=walkSpeed end
end })

UtilTab:CreateToggle({ Name="Moon Jump", Flag="MoonJump", CurrentValue=false, Callback=function(v)
    moon=v; workspace.Gravity=v and 0.1 or CustomGravity
end })
UtilTab:CreateInput({ Name="Custom Gravity", Flag="GravInput", PlaceholderText=tostring(workspace.Gravity), Callback=function(val) if gravityUnlocked then workspace.Gravity=tonumber(val) end end })
UtilTab:CreateToggle({ Name="Unlock Gravity Input", Flag="GravUnlock", CurrentValue=true, Callback=function(v) gravityUnlocked=v end })
UtilTab:CreateButton({ Name="Give Teleport Tool", Callback=function()
    local tool=Instance.new("Tool"); tool.RequiresHandle=false; tool.Name="TeleportTool"; tool.Activated:Connect(function()
        local m=LocalPlayer:GetMouse(); if m.Hit then LocalPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,3,0)) end
    end); tool.Parent=LocalPlayer.Backpack
end })
UtilTab:CreateDropdown({ Name="Speed Presets", Options={"16","32","50","100","200"}, CurrentOption={"16"}, MultipleOptions=false, Flag="SpeedPresets", Callback=function(o)
    walkSpeed=tonumber(o[1]); LocalPlayer.Character.Humanoid.WalkSpeed=walkSpeed
end })
UtilTab:CreateDropdown({ Name="Jump Presets", Options={"50","75","100","150"}, CurrentOption={"50"}, MultipleOptions=false, Flag="JumpPresets", Callback=function(o)
    jumpPower=tonumber(o[1]); LocalPlayer.Character.Humanoid.JumpPower=jumpPower
end })
UtilTab:CreateToggle({ Name="Anti-AFK", Flag="AntiAFK", CurrentValue=false, Callback=function(v)
    if v then
        Players.LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
    end
end })
UtilTab:CreateToggle({ Name="Auto Rejoin", Flag="AutoRejoin", CurrentValue=false, Callback=function(v)
    if v then game:GetService("Players").LocalPlayer.OnTeleport = function() syn.queue_on_teleport([[loadstring(game:HttpGet('YOUR_SCRIPT_URL'))()]]) end end
end })

-- ===== MISC TAB =====
local MiscTab=Window:CreateTab("Misc","wrench")
MiscTab:CreateButton({ Name="Break Joints", Callback=function() LocalPlayer.Character:BreakJoints() end })
MiscTab:CreateButton({ Name="Set HP to 0", Callback=function() LocalPlayer.Character.Humanoid.Health=0 end })
MiscTab:CreateInput({ Name="Kick Message", Flag="KickMsg", PlaceholderText="You were kicked!", Callback=function(v) kickMsg=v end })
MiscTab:CreateButton({ Name="Kick Yourself", Callback=function() LocalPlayer:Kick(kickMsg) end })
MiscTab:CreateButton({ Name="Destroy Player", Callback=function() LocalPlayer:Destroy() end })

-- Auto-apply settings on respawn
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    local hum=char:WaitForChild("Humanoid")
    hum.WalkSpeed=walkSpeed; hum.JumpPower=jumpPower
    if flyMode then hum:ChangeState(4) end
    if moon then workspace.Gravity=0.1 elseif gravityUnlocked then workspace.Gravity=CustomGravity end
end)