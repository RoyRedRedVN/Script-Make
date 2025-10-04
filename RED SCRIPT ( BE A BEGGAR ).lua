-- RED AUTO FARM - Compact Material Design 🔥💸
local P = game:GetService("Players")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local MS = game:GetService("MarketplaceService")
local p = P.LocalPlayer

local auto, stop, loop, mc, bc = false, false, nil, 0, 0
local currentTab = "money"

-- UI Setup
local g = Instance.new("ScreenGui", game.CoreGui)
g.Name = "RedAutoFarm"
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local f = Instance.new("Frame", g)
f.Name = "MainFrame"
f.BackgroundColor3 = Color3.fromRGB(255,255,255)
f.BorderSizePixel = 0
f.Position = UDim2.new(0.5,0,0.5,0)
f.Size = UDim2.new(0,0,0,0)
f.Active = true
f.Draggable = true
f.ClipsDescendants = true

local function ac(e,r) 
    local u = Instance.new("UICorner",e) 
    u.CornerRadius = UDim.new(0,r) 
end
ac(f,12)

-- Top Bar
local tb = Instance.new("Frame", f)
tb.Name = "TopBar"
tb.BackgroundColor3 = Color3.fromRGB(211,47,47)
tb.Size = UDim2.new(1,0,0,50)
tb.BorderSizePixel = 0

local g1 = Instance.new("UIGradient",tb)
g1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(229,57,53)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(211,47,47))
}
g1.Rotation = 90

local ic = Instance.new("TextLabel", tb)
ic.Name = "Icon"
ic.BackgroundTransparency = 1
ic.Position = UDim2.new(0,12,0,8)
ic.Size = UDim2.new(0,34,0,34)
ic.Font = Enum.Font.GothamBold
ic.Text = "🔥"
ic.TextColor3 = Color3.new(1,1,1)
ic.TextSize = 26

local ti = Instance.new("TextLabel", tb)
ti.Name = "Title"
ti.BackgroundTransparency = 1
ti.Position = UDim2.new(0,50,0,4)
ti.Size = UDim2.new(0,160,0,18)
ti.Font = Enum.Font.GothamBold
ti.Text = "Loading..."
ti.TextColor3 = Color3.new(1,1,1)
ti.TextSize = 13
ti.TextXAlignment = Enum.TextXAlignment.Left

local dev = Instance.new("TextLabel",tb)
dev.Name = "Dev"
dev.BackgroundTransparency = 1
dev.Position = UDim2.new(0,50,0,24)
dev.Size = UDim2.new(0,160,0,14)
dev.Font = Enum.Font.GothamMedium
dev.Text = "DEV: REDMOD"
dev.TextColor3 = Color3.fromRGB(255,255,255)
dev.TextTransparency = 0.2
dev.TextSize = 9
dev.TextXAlignment = Enum.TextXAlignment.Left

local mi = Instance.new("TextButton", tb)
mi.Name = "MinimizeBtn"
mi.BackgroundColor3 = Color3.fromRGB(255,255,255)
mi.BackgroundTransparency = 0.9
mi.BorderSizePixel = 0
mi.Position = UDim2.new(1,-68,0,12)
mi.Size = UDim2.new(0,26,0,26)
mi.Font = Enum.Font.GothamBold
mi.Text = "−"
mi.TextColor3 = Color3.new(1,1,1)
mi.TextSize = 16
mi.AutoButtonColor = false
ac(mi,13)

local cl = Instance.new("TextButton", tb)
cl.Name = "CloseBtn"
cl.BackgroundColor3 = Color3.fromRGB(255,255,255)
cl.BackgroundTransparency = 0.9
cl.BorderSizePixel = 0
cl.Position = UDim2.new(1,-38,0,12)
cl.Size = UDim2.new(0,26,0,26)
cl.Font = Enum.Font.GothamBold
cl.Text = "✕"
cl.TextColor3 = Color3.new(1,1,1)
cl.TextSize = 14
cl.AutoButtonColor = false
ac(cl,13)

-- Content Area
local c = Instance.new("Frame", f)
c.Name = "Content"
c.BackgroundTransparency = 1
c.Position = UDim2.new(0,0,0,50)
c.Size = UDim2.new(1,0,1,-50)

-- Tabs
local tabs = Instance.new("Frame", c)
tabs.Name = "Tabs"
tabs.BackgroundTransparency = 1
tabs.Position = UDim2.new(0,12,0,6)
tabs.Size = UDim2.new(1,-24,0,36)

local tab1 = Instance.new("TextButton", tabs)
tab1.Name = "MoneyTab"
tab1.BackgroundTransparency = 1
tab1.Position = UDim2.new(0,0,0,0)
tab1.Size = UDim2.new(0.5,0,1,0)
tab1.Font = Enum.Font.GothamBold
tab1.Text = "💰 MONEY"
tab1.TextColor3 = Color3.fromRGB(211,47,47)
tab1.TextSize = 12
tab1.AutoButtonColor = false

local tab2 = Instance.new("TextButton", tabs)
tab2.Name = "NPCTab"
tab2.BackgroundTransparency = 1
tab2.Position = UDim2.new(0.5,0,0,0)
tab2.Size = UDim2.new(0.5,0,1,0)
tab2.Font = Enum.Font.GothamBold
tab2.Text = "🙏 NPC"
tab2.TextColor3 = Color3.fromRGB(117,117,117)
tab2.TextSize = 12
tab2.AutoButtonColor = false

local tabIndicator = Instance.new("Frame", tabs)
tabIndicator.Name = "Indicator"
tabIndicator.BackgroundColor3 = Color3.fromRGB(211,47,47)
tabIndicator.BorderSizePixel = 0
tabIndicator.Position = UDim2.new(0,0,1,-2)
tabIndicator.Size = UDim2.new(0.5,0,0,2)

-- Status Card
local sc = Instance.new("Frame", c)
sc.Name = "StatusCard"
sc.BackgroundColor3 = Color3.fromRGB(245,245,245)
sc.Position = UDim2.new(0,12,0,48)
sc.Size = UDim2.new(1,-24,0,48)
sc.BorderSizePixel = 0
ac(sc,10)

local si = Instance.new("TextLabel", sc)
si.Name = "StatusIcon"
si.BackgroundTransparency = 1
si.Position = UDim2.new(0,12,0,10)
si.Size = UDim2.new(0,28,0,28)
si.Font = Enum.Font.GothamBold
si.Text = "⚪"
si.TextColor3 = Color3.fromRGB(158,158,158)
si.TextSize = 22

local sl = Instance.new("TextLabel", sc)
sl.Name = "StatusLabel"
sl.BackgroundTransparency = 1
sl.Position = UDim2.new(0,48,0,6)
sl.Size = UDim2.new(1,-60,0,36)
sl.Font = Enum.Font.GothamMedium
sl.Text = "Status: OFF"
sl.TextColor3 = Color3.fromRGB(66,66,66)
sl.TextSize = 13
sl.TextXAlignment = Enum.TextXAlignment.Left

-- Speed Control
local pc = Instance.new("Frame", c)
pc.Name = "SpeedCard"
pc.BackgroundColor3 = Color3.fromRGB(245,245,245)
pc.Position = UDim2.new(0,12,0,104)
pc.Size = UDim2.new(1,-24,0,42)
pc.BorderSizePixel = 0
ac(pc,10)

local pl = Instance.new("TextLabel", pc)
pl.Name = "SpeedLabel"
pl.BackgroundTransparency = 1
pl.Position = UDim2.new(0,12,0,3)
pl.Size = UDim2.new(0.5,-20,0,16)
pl.Font = Enum.Font.GothamMedium
pl.Text = "⚡ Speed"
pl.TextColor3 = Color3.fromRGB(66,66,66)
pl.TextSize = 11
pl.TextXAlignment = Enum.TextXAlignment.Left

local ps = Instance.new("TextBox", pc)
ps.Name = "SpeedInput"
ps.BackgroundColor3 = Color3.fromRGB(255,255,255)
ps.Position = UDim2.new(0,12,0,20)
ps.Size = UDim2.new(1,-24,0,18)
ps.Font = Enum.Font.Gotham
ps.Text = "0.45"
ps.TextColor3 = Color3.fromRGB(33,33,33)
ps.TextSize = 12
ps.PlaceholderText = "Delay"
ps.ClearTextOnFocus = false
ps.BorderSizePixel = 0
ac(ps,5)

-- Stats Frame
local sf = Instance.new("Frame", c)
sf.Name = "StatsFrame"
sf.BackgroundTransparency = 1
sf.Position = UDim2.new(0,12,0,154)
sf.Size = UDim2.new(1,-24,0,75)

local m1 = Instance.new("Frame", sf)
m1.Name = "MoneyCard"
m1.BackgroundColor3 = Color3.fromRGB(255,243,224)
m1.Position = UDim2.new(0,0,0,0)
m1.Size = UDim2.new(0.48,0,0,75)
m1.BorderSizePixel = 0
ac(m1,10)

local mi1 = Instance.new("TextLabel", m1)
mi1.BackgroundTransparency = 1
mi1.Position = UDim2.new(0,0,0,6)
mi1.Size = UDim2.new(1,0,0,22)
mi1.Font = Enum.Font.GothamBold
mi1.Text = "💰"
mi1.TextSize = 22

local ml1 = Instance.new("TextLabel", m1)
ml1.BackgroundTransparency = 1
ml1.Position = UDim2.new(0,6,0,32)
ml1.Size = UDim2.new(1,-12,0,14)
ml1.Font = Enum.Font.GothamMedium
ml1.Text = "Money"
ml1.TextColor3 = Color3.fromRGB(230,126,34)
ml1.TextSize = 10

local mc1 = Instance.new("TextLabel", m1)
mc1.Name = "Count"
mc1.BackgroundTransparency = 1
mc1.Position = UDim2.new(0,6,0,48)
mc1.Size = UDim2.new(1,-12,0,22)
mc1.Font = Enum.Font.GothamBold
mc1.Text = "0"
mc1.TextColor3 = Color3.fromRGB(33,33,33)
mc1.TextSize = 18

local m2 = Instance.new("Frame", sf)
m2.Name = "NPCCard"
m2.BackgroundColor3 = Color3.fromRGB(232,245,233)
m2.Position = UDim2.new(0.52,0,0,0)
m2.Size = UDim2.new(0.48,0,0,75)
m2.BorderSizePixel = 0
ac(m2,10)

local mi2 = Instance.new("TextLabel", m2)
mi2.BackgroundTransparency = 1
mi2.Position = UDim2.new(0,0,0,6)
mi2.Size = UDim2.new(1,0,0,22)
mi2.Font = Enum.Font.GothamBold
mi2.Text = "🙏"
mi2.TextSize = 22

local ml2 = Instance.new("TextLabel", m2)
ml2.BackgroundTransparency = 1
ml2.Position = UDim2.new(0,6,0,32)
ml2.Size = UDim2.new(1,-12,0,14)
ml2.Font = Enum.Font.GothamMedium
ml2.Text = "NPCs"
ml2.TextColor3 = Color3.fromRGB(76,175,80)
ml2.TextSize = 10

local mc2 = Instance.new("TextLabel", m2)
mc2.Name = "Count"
mc2.BackgroundTransparency = 1
mc2.Position = UDim2.new(0,6,0,48)
mc2.Size = UDim2.new(1,-12,0,22)
mc2.Font = Enum.Font.GothamBold
mc2.Text = "0"
mc2.TextColor3 = Color3.fromRGB(33,33,33)
mc2.TextSize = 18

-- Start/Stop Button
local bt = Instance.new("TextButton", c)
bt.Name = "StartStopBtn"
bt.BackgroundColor3 = Color3.fromRGB(211,47,47)
bt.Position = UDim2.new(0,12,1,-52)
bt.Size = UDim2.new(1,-24,0,40)
bt.AutoButtonColor = false
bt.Font = Enum.Font.GothamBold
bt.Text = "START"
bt.TextColor3 = Color3.new(1,1,1)
bt.TextSize = 13
bt.BorderSizePixel = 0
ac(bt,20)

-- Functions
local function gc() return p.Character or p.CharacterAdded:Wait() end

local function fm()
    local ch = gc()
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r,n,s = ch.HumanoidRootPart,nil,math.huge
    local mf = workspace:FindFirstChild("Money")
    if mf then
        for _,v in pairs(mf:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local mp = v:IsA("Model") and v:GetPrimaryPartCFrame().Position or v.Position
                local d = (r.Position-mp).Magnitude
                if d < s then s,n = d,v end
            end
        end
    end
    return n
end

local function fn()
    local ch = gc()
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r,n,s = ch.HumanoidRootPart,nil,math.huge
    local nf = workspace:FindFirstChild("NPCS") or workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Npcs")
    if nf then
        for _,v in pairs(nf:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                local d = (r.Position-v.HumanoidRootPart.Position).Magnitude
                if d < s then s,n = d,v end
            end
        end
    end
    return n
end

local function cm(m)
    local ch = gc()
    if not ch then return false end
    local r = ch:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    local tp = m:IsA("Model") and m:GetPrimaryPartCFrame() or m.CFrame
    r.CFrame = tp + Vector3.new(0,3,0)
    task.wait(.1)
    local pr = m:FindFirstChildOfClass("ProximityPrompt")
    if pr then fireproximityprompt(pr) mc=mc+1 return true end
    local cd = m:FindFirstChildOfClass("ClickDetector")
    if cd then fireclickdetector(cd) mc=mc+1 return true end
    task.wait(.3)
    if not m.Parent then mc=mc+1 return true end
    return false
end

local function bn(n)
    local ch = gc()
    if not ch then return false end
    local r = ch:FindFirstChild("HumanoidRootPart")
    if not r or not n:FindFirstChild("HumanoidRootPart") then return false end
    r.CFrame = n.HumanoidRootPart.CFrame + Vector3.new(0,0,3)
    task.wait(.2)
    local pr = n:FindFirstChildOfClass("ProximityPrompt",true)
    if not pr then
        for _,d in pairs(n:GetDescendants()) do
            if d:IsA("ProximityPrompt") then pr=d break end
        end
    end
    if pr then fireproximityprompt(pr) bc=bc+1 return true end
    local cd = n:FindFirstChildOfClass("ClickDetector",true)
    if not cd then
        for _,d in pairs(n:GetDescendants()) do
            if d:IsA("ClickDetector") then cd=d break end
        end
    end
    if cd then fireclickdetector(cd) bc=bc+1 return true end
    return false
end

local function st()
    stop = false
    loop = R.Heartbeat:Connect(function()
        if not auto or stop then
            if loop then loop:Disconnect() loop=nil end
            return
        end
        pcall(function()
            local ch = gc()
            if not ch then return end
            local h,r = ch:FindFirstChild("Humanoid"),ch:FindFirstChild("HumanoidRootPart")
            if not h or not r or h.Health <= 0 then return end
            local sp = tonumber(ps.Text) or .45
            
            if currentTab == "money" then
                local m = fm()
                if m then
                    si.Text,si.TextColor3,sl.Text = "🟢",Color3.fromRGB(76,175,80),"Collecting..."
                    cm(m)
                    mc1.Text = tostring(mc)
                    task.wait(sp)
                else
                    si.Text,si.TextColor3,sl.Text = "🔍",Color3.fromRGB(158,158,158),"No money"
                    task.wait(1)
                end
            elseif currentTab == "npc" then
                local n = fn()
                if n then
                    si.Text,si.TextColor3,sl.Text = "🙏",Color3.fromRGB(255,193,7),"Begging..."
                    bn(n)
                    mc2.Text = tostring(bc)
                    task.wait(sp*2)
                else
                    si.Text,si.TextColor3,sl.Text = "🔍",Color3.fromRGB(158,158,158),"No NPCs"
                    task.wait(1)
                end
            end
        end)
    end)
end

local function sp()
    stop,auto = true,false
    if loop then loop:Disconnect() loop=nil end
    si.Text,si.TextColor3,sl.Text = "⚪",Color3.fromRGB(158,158,158),"Status: OFF"
end

-- Tab Switch
local function switchTab(tab)
    currentTab = tab
    if tab == "money" then
        T:Create(tabIndicator,TweenInfo.new(.3,Enum.EasingStyle.Quad),{Position=UDim2.new(0,0,1,-2)}):Play()
        T:Create(tab1,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(211,47,47)}):Play()
        T:Create(tab2,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play()
    else
        T:Create(tabIndicator,TweenInfo.new(.3,Enum.EasingStyle.Quad),{Position=UDim2.new(.5,0,1,-2)}):Play()
        T:Create(tab1,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play()
        T:Create(tab2,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(211,47,47)}):Play()
    end
end

tab1.MouseButton1Click:Connect(function() switchTab("money") end)
tab2.MouseButton1Click:Connect(function() switchTab("npc") end)

-- Start/Stop
bt.MouseButton1Click:Connect(function()
    if auto then
        sp()
        T:Create(bt,TweenInfo.new(.3,Enum.EasingStyle.Quad),{
            BackgroundColor3=Color3.fromRGB(211,47,47),
            Size=UDim2.new(1,-24,0,40)
        }):Play()
        bt.Text = "START"
    else
        auto = true
        st()
        T:Create(bt,TweenInfo.new(.3,Enum.EasingStyle.Quad),{
            BackgroundColor3=Color3.fromRGB(76,175,80),
            Size=UDim2.new(1,-20,0,44)
        }):Play()
        task.wait(.15)
        T:Create(bt,TweenInfo.new(.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,-24,0,40)}):Play()
        bt.Text = "STOP"
    end
end)

-- Close Button
cl.MouseButton1Click:Connect(function()
    sp()
    T:Create(cl,TweenInfo.new(.2),{Rotation=90}):Play()
    T:Create(f,TweenInfo.new(.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(.5,0,.5,0)
    }):Play()
    task.wait(.4)
    g:Destroy()
end)

-- Minimize System
local minimized = false
local miniBtn = nil

local function createMiniBtn()
    miniBtn = Instance.new("TextButton", g)
    miniBtn.Name = "MiniButton"
    miniBtn.BackgroundColor3 = Color3.fromRGB(211,47,47)
    miniBtn.Size = UDim2.new(0,60,0,60)
    miniBtn.Position = UDim2.new(1,-80,1,-80)
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.Visible = false
    miniBtn.Active = true
    miniBtn.Draggable = true
    ac(miniBtn,30)
    
    local miniIcon = Instance.new("TextLabel", miniBtn)
    miniIcon.BackgroundTransparency = 1
    miniIcon.Size = UDim2.new(1,0,1,0)
    miniIcon.Font = Enum.Font.GothamBold
    miniIcon.Text = "🔥"
    miniIcon.TextColor3 = Color3.new(1,1,1)
    miniIcon.TextSize = 26
    
    local miniGlow = Instance.new("UIGradient", miniBtn)
    miniGlow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(229,57,53)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(211,47,47))
    }
    
    miniBtn.MouseButton1Click:Connect(function()
        minimized = false
        miniBtn.Visible = false
        f.Visible = true
        T:Create(f,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,300,0,340),
            Position=UDim2.new(.38,0,.3,0)
        }):Play()
    end)
end

mi.MouseButton1Click:Connect(function()
    if not minimized then
        minimized = true
        if not miniBtn then createMiniBtn() end
        
        T:Create(f,TweenInfo.new(.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,60,0,60),
            Position=UDim2.new(1,-80,1,-80)
        }):Play()
        
        task.wait(.4)
        f.Visible = false
        miniBtn.Visible = true
    end
end)

-- Character Respawn
p.CharacterAdded:Connect(function()
    task.wait(2)
    if auto then sp() task.wait(.5) st() end
end)

-- Get Game Name
pcall(function()
    local success, result = pcall(function()
        return MS:GetProductInfo(game.PlaceId).Name
    end)
    if success then
        ti.Text = result
    else
        ti.Text = "RED AUTO"
    end
end)

-- Opening Animation
task.wait(.1)
T:Create(f,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,300,0,340),
    Position=UDim2.new(.38,0,.3,0)
}):Play()

game.StarterGui:SetCore("SendNotification",{
    Title="🔥 RED AUTO",
    Text="Loaded Successfully! 💎",
    Duration=3
})

print("🔥 RED AUTO FARM - Ready!")
