local l=loadstring or load
local t=l(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local p=game:GetService("Players")
local lp=p.LocalPlayer
local r=game:GetService("RunService")
local u=game:GetService("UserInputService")
local w=game:GetService("Workspace")
local lgt=game:GetService("Lighting")

local win=t:CreateWindow({Title="Roblox+ Lite",SubTitle="Obfuscated",Theme="Dark",Size=UDim2.fromOffset(580,460)})

local mainTab=win:AddTab({Title="Main",Icon=""})

local opt=t.Options

mainTab:AddParagraph({Title="Controls",Content="Toggle walkspeed, jump power, noclip and performance tweaks."})

local ws=16
local jp=50
local noclipOn=false
local shadowsOff=false
local fpsLabel,fpsConn

mainTab:AddSlider("WalkSpeed",{Title="Walk Speed",Min=8,Max=200,Default=ws,Callback=function(v) ws=v; if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then lp.Character.Humanoid.WalkSpeed=ws end end})

mainTab:AddSlider("JumpPower",{Title="Jump Power",Min=20,Max=150,Default=jp,Callback=function(v) jp=v; if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then lp.Character.Humanoid.JumpPower=jp end end})

mainTab:AddToggle("NoClip",{Title="Enable NoClip",Default=false,Callback=function(v) noclipOn=v end})

r.Stepped:Connect(function()
    if noclipOn and lp.Character then
        for _,p in ipairs(lp.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

mainTab:AddToggle("DisableShadows",{Title="Disable Shadows",Default=false,Callback=function(v) shadowsOff=v; lgt.GlobalShadows=not v end})

mainTab:AddToggle("ShowFPS",{Title="Show FPS",Default=false,Callback=function(on)
    if on then
        if not fpsLabel then
            local g=Instance.new("ScreenGui",game.CoreGui)
            g.Name="FPSGui"
            fpsLabel=Instance.new("TextLabel",g)
            fpsLabel.BackgroundTransparency=0.5
            fpsLabel.BackgroundColor3=Color3.new(0,0,0)
            fpsLabel.Position=UDim2.new(0,0,0,0)
            fpsLabel.Size=UDim2.new(0,100,0,30)
            fpsLabel.Font=Enum.Font.SourceSansBold
            fpsLabel.TextSize=20
            fpsLabel.TextColor3=Color3.new(0,1,0)
        end
        local last,tickCount=tick(),0
        fpsConn=r.RenderStepped:Connect(function()
            tickCount=tickCount+1
            local now=tick()
            if now-last>=1 then
                fpsLabel.Text="FPS: "..tickCount
                tickCount=0
                last=now
            end
        end)
    else
        if fpsConn then fpsConn:Disconnect() fpsConn=nil end
        if fpsLabel then fpsLabel.Parent:Destroy() fpsLabel=nil end
    end
end})

lp.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    local h=char:WaitForChild("Humanoid")
    h.WalkSpeed=ws
    h.JumpPower=jp
end)