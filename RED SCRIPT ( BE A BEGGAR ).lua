-- RED AUTO FARM - Compact 🔥💸
local P,R,T,MS = game:GetService("Players"),game:GetService("RunService"),game:GetService("TweenService"),game:GetService("MarketplaceService")
local p = P.LocalPlayer
local auto,stop,loop,mc,bc,currentTab = false,false,nil,0,0,"money"

if not shared.AutoClick then shared.AutoClick = Instance.new("BoolValue") shared.AutoClick.Value = false end

-- UI
local g = Instance.new("ScreenGui",game.CoreGui) g.Name = "RedAutoFarm"
local f = Instance.new("Frame",g) f.BackgroundColor3 = Color3.fromRGB(255,255,255) f.BorderSizePixel = 0
f.Position,f.Size,f.Active,f.Draggable,f.ClipsDescendants = UDim2.new(.5,0,.5,0),UDim2.new(0,0,0,0),true,true,true
local function ac(e,r) Instance.new("UICorner",e).CornerRadius = UDim.new(0,r) end
ac(f,12)

-- Top Bar
local tb = Instance.new("Frame",f) tb.BackgroundColor3 = Color3.fromRGB(211,47,47) tb.Size = UDim2.new(1,0,0,50) tb.BorderSizePixel = 0
local g1 = Instance.new("UIGradient",tb) g1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(229,57,53)),ColorSequenceKeypoint.new(1,Color3.fromRGB(211,47,47))} g1.Rotation = 90
local ic = Instance.new("TextLabel",tb) ic.BackgroundTransparency,ic.Position,ic.Size,ic.Font,ic.Text,ic.TextColor3,ic.TextSize = 1,UDim2.new(0,12,0,8),UDim2.new(0,34,0,34),Enum.Font.GothamBold,"🔥",Color3.new(1,1,1),26
local ti = Instance.new("TextLabel",tb) ti.BackgroundTransparency,ti.Position,ti.Size,ti.Font,ti.Text,ti.TextColor3,ti.TextSize,ti.TextXAlignment = 1,UDim2.new(0,50,0,4),UDim2.new(0,160,0,18),Enum.Font.GothamBold,"RED AUTO",Color3.new(1,1,1),13,Enum.TextXAlignment.Left
local dev = Instance.new("TextLabel",tb) dev.BackgroundTransparency,dev.Position,dev.Size,dev.Font,dev.Text,dev.TextColor3,dev.TextTransparency,dev.TextSize,dev.TextXAlignment = 1,UDim2.new(0,50,0,24),UDim2.new(0,160,0,14),Enum.Font.GothamMedium,"DEV: REDMOD",Color3.fromRGB(255,255,255),.2,9,Enum.TextXAlignment.Left
local mi = Instance.new("TextButton",tb) mi.BackgroundColor3,mi.BackgroundTransparency,mi.BorderSizePixel,mi.Position,mi.Size,mi.Font,mi.Text,mi.TextColor3,mi.TextSize,mi.AutoButtonColor = Color3.fromRGB(255,255,255),.9,0,UDim2.new(1,-68,0,12),UDim2.new(0,26,0,26),Enum.Font.GothamBold,"−",Color3.new(1,1,1),16,false
ac(mi,13)
local cl = Instance.new("TextButton",tb) cl.BackgroundColor3,cl.BackgroundTransparency,cl.BorderSizePixel,cl.Position,cl.Size,cl.Font,cl.Text,cl.TextColor3,cl.TextSize,cl.AutoButtonColor = Color3.fromRGB(255,255,255),.9,0,UDim2.new(1,-38,0,12),UDim2.new(0,26,0,26),Enum.Font.GothamBold,"✕",Color3.new(1,1,1),14,false
ac(cl,13)

-- Content
local c = Instance.new("Frame",f) c.BackgroundTransparency,c.Position,c.Size = 1,UDim2.new(0,0,0,50),UDim2.new(1,0,1,-50)
local tabs = Instance.new("Frame",c) tabs.BackgroundTransparency,tabs.Position,tabs.Size = 1,UDim2.new(0,12,0,6),UDim2.new(1,-24,0,36)
local tab1 = Instance.new("TextButton",tabs) tab1.BackgroundTransparency,tab1.Position,tab1.Size,tab1.Font,tab1.Text,tab1.TextColor3,tab1.TextSize,tab1.AutoButtonColor = 1,UDim2.new(0,0,0,0),UDim2.new(.33,0,1,0),Enum.Font.GothamBold,"💰",Color3.fromRGB(211,47,47),12,false
local tab2 = Instance.new("TextButton",tabs) tab2.BackgroundTransparency,tab2.Position,tab2.Size,tab2.Font,tab2.Text,tab2.TextColor3,tab2.TextSize,tab2.AutoButtonColor = 1,UDim2.new(.33,0,0,0),UDim2.new(.33,0,1,0),Enum.Font.GothamBold,"🙏",Color3.fromRGB(117,117,117),12,false
local tab3 = Instance.new("TextButton",tabs) tab3.BackgroundTransparency,tab3.Position,tab3.Size,tab3.Font,tab3.Text,tab3.TextColor3,tab3.TextSize,tab3.AutoButtonColor = 1,UDim2.new(.66,0,0,0),UDim2.new(.34,0,1,0),Enum.Font.GothamBold,"🎮",Color3.fromRGB(117,117,117),12,false
local tabInd = Instance.new("Frame",tabs) tabInd.BackgroundColor3,tabInd.BorderSizePixel,tabInd.Position,tabInd.Size = Color3.fromRGB(211,47,47),0,UDim2.new(0,0,1,-2),UDim2.new(.33,0,0,2)

-- Status
local sc = Instance.new("Frame",c) sc.BackgroundColor3,sc.Position,sc.Size,sc.BorderSizePixel = Color3.fromRGB(245,245,245),UDim2.new(0,12,0,48),UDim2.new(1,-24,0,48),0 ac(sc,10)
local si = Instance.new("TextLabel",sc) si.BackgroundTransparency,si.Position,si.Size,si.Font,si.Text,si.TextColor3,si.TextSize = 1,UDim2.new(0,12,0,10),UDim2.new(0,28,0,28),Enum.Font.GothamBold,"⚪",Color3.fromRGB(158,158,158),22
local sl = Instance.new("TextLabel",sc) sl.BackgroundTransparency,sl.Position,sl.Size,sl.Font,sl.Text,sl.TextColor3,sl.TextSize,sl.TextXAlignment = 1,UDim2.new(0,48,0,6),UDim2.new(1,-60,0,36),Enum.Font.GothamMedium,"Status: OFF",Color3.fromRGB(66,66,66),13,Enum.TextXAlignment.Left

-- Speed
local pc = Instance.new("Frame",c) pc.BackgroundColor3,pc.Position,pc.Size,pc.BorderSizePixel = Color3.fromRGB(245,245,245),UDim2.new(0,12,0,104),UDim2.new(1,-24,0,42),0 ac(pc,10)
local pl = Instance.new("TextLabel",pc) pl.BackgroundTransparency,pl.Position,pl.Size,pl.Font,pl.Text,pl.TextColor3,pl.TextSize,pl.TextXAlignment = 1,UDim2.new(0,12,0,3),UDim2.new(.5,-20,0,16),Enum.Font.GothamMedium,"⚡ Speed",Color3.fromRGB(66,66,66),11,Enum.TextXAlignment.Left
local ps = Instance.new("TextBox",pc) ps.BackgroundColor3,ps.Position,ps.Size,ps.Font,ps.Text,ps.TextColor3,ps.TextSize,ps.BorderSizePixel = Color3.fromRGB(255,255,255),UDim2.new(0,12,0,20),UDim2.new(1,-24,0,18),Enum.Font.Gotham,"0.45",Color3.fromRGB(33,33,33),12,0 ac(ps,5)

-- Stats
local sf = Instance.new("Frame",c) sf.BackgroundTransparency,sf.Position,sf.Size = 1,UDim2.new(0,12,0,154),UDim2.new(1,-24,0,75)
local function makeCard(n,bg,e,t,x)
    local m = Instance.new("Frame",sf) m.BackgroundColor3,m.Position,m.Size,m.BorderSizePixel = bg,UDim2.new(x,0,0,0),UDim2.new(.48,0,0,75),0 ac(m,10)
    Instance.new("TextLabel",m).BackgroundTransparency,Instance.new("TextLabel",m).Position,Instance.new("TextLabel",m).Size,Instance.new("TextLabel",m).Font,Instance.new("TextLabel",m).Text,Instance.new("TextLabel",m).TextSize = 1,UDim2.new(0,0,0,6),UDim2.new(1,0,0,22),Enum.Font.GothamBold,e,22
    local l = Instance.new("TextLabel",m) l.BackgroundTransparency,l.Position,l.Size,l.Font,l.Text,l.TextColor3,l.TextSize = 1,UDim2.new(0,6,0,32),UDim2.new(1,-12,0,14),Enum.Font.GothamMedium,t,Color3.fromRGB(230,126,34),10
    local c = Instance.new("TextLabel",m) c.Name,c.BackgroundTransparency,c.Position,c.Size,c.Font,c.Text,c.TextColor3,c.TextSize = "Count",1,UDim2.new(0,6,0,48),UDim2.new(1,-12,0,22),Enum.Font.GothamBold,"0",Color3.fromRGB(33,33,33),18
    return c
end
local mc1 = makeCard("M",Color3.fromRGB(255,243,224),"💰","Money",0)
local mc2 = makeCard("N",Color3.fromRGB(232,245,233),"🙏","NPCs",.52)

-- Minigame
local mgc = Instance.new("Frame",c) mgc.BackgroundColor3,mgc.Position,mgc.Size,mgc.BorderSizePixel,mgc.Visible = Color3.fromRGB(245,245,245),UDim2.new(0,12,0,104),UDim2.new(1,-24,0,125),0,false ac(mgc,10)
Instance.new("TextLabel",mgc).BackgroundTransparency,Instance.new("TextLabel",mgc).Position,Instance.new("TextLabel",mgc).Size,Instance.new("TextLabel",mgc).Font,Instance.new("TextLabel",mgc).Text,Instance.new("TextLabel",mgc).TextSize = 1,UDim2.new(0,0,0,8),UDim2.new(1,0,0,28),Enum.Font.GothamBold,"🎮",24
local mgl = Instance.new("TextLabel",mgc) mgl.BackgroundTransparency,mgl.Position,mgl.Size,mgl.Font,mgl.Text,mgl.TextColor3,mgl.TextSize = 1,UDim2.new(0,12,0,40),UDim2.new(1,-24,0,18),Enum.Font.GothamBold,"AUTO MINIGAME",Color3.fromRGB(33,33,33),12
local mgd = Instance.new("TextLabel",mgc) mgd.BackgroundTransparency,mgd.Position,mgd.Size,mgd.Font,mgd.Text,mgd.TextColor3,mgd.TextSize,mgd.TextWrapped = 1,UDim2.new(0,12,0,60),UDim2.new(1,-24,0,30),Enum.Font.Gotham,"Auto-click circles when begging",Color3.fromRGB(117,117,117),9,true
local mgt = Instance.new("TextButton",mgc) mgt.BackgroundColor3,mgt.Position,mgt.Size,mgt.Font,mgt.Text,mgt.TextColor3,mgt.TextSize,mgt.BorderSizePixel,mgt.AutoButtonColor = Color3.fromRGB(158,158,158),UDim2.new(0,12,0,95),UDim2.new(1,-24,0,20),Enum.Font.GothamBold,"OFF",Color3.new(1,1,1),10,0,false ac(mgt,10)

-- Button
local bt = Instance.new("TextButton",c) bt.BackgroundColor3,bt.Position,bt.Size,bt.AutoButtonColor,bt.Font,bt.Text,bt.TextColor3,bt.TextSize,bt.BorderSizePixel = Color3.fromRGB(211,47,47),UDim2.new(0,12,1,-52),UDim2.new(1,-24,0,40),false,Enum.Font.GothamBold,"START",Color3.new(1,1,1),13,0 ac(bt,20)

-- Logic
local function gc() return p.Character or p.CharacterAdded:Wait() end
local function fm()
    local ch = gc() if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r,n,s = ch.HumanoidRootPart,nil,math.huge
    local mf = workspace:FindFirstChild("Money") if mf then for _,v in pairs(mf:GetChildren()) do if v:IsA("BasePart") or v:IsA("Model") then local mp = v:IsA("Model") and v:GetPrimaryPartCFrame().Position or v.Position local d = (r.Position-mp).Magnitude if d < s then s,n = d,v end end end end
    return n
end
local function fn()
    local ch = gc() if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r,n,s = ch.HumanoidRootPart,nil,math.huge
    local nf = workspace:FindFirstChild("NPCS") or workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Npcs") if nf then for _,v in pairs(nf:GetChildren()) do if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then local d = (r.Position-v.HumanoidRootPart.Position).Magnitude if d < s then s,n = d,v end end end end
    return n
end
local function cm(m)
    local ch = gc() if not ch then return false end local r = ch:FindFirstChild("HumanoidRootPart") if not r then return false end
    local tp = m:IsA("Model") and m:GetPrimaryPartCFrame() or m.CFrame r.CFrame = tp + Vector3.new(0,3,0) task.wait(.1)
    local pr = m:FindFirstChildOfClass("ProximityPrompt") if pr then fireproximityprompt(pr) mc=mc+1 return true end
    local cd = m:FindFirstChildOfClass("ClickDetector") if cd then fireclickdetector(cd) mc=mc+1 return true end
    task.wait(.3) if not m.Parent then mc=mc+1 return true end return false
end
local function bn(n)
    local ch = gc() if not ch then return false end local r = ch:FindFirstChild("HumanoidRootPart") if not r or not n:FindFirstChild("HumanoidRootPart") then return false end
    r.CFrame = n.HumanoidRootPart.CFrame + Vector3.new(0,0,3) task.wait(.2)
    local pr = n:FindFirstChildOfClass("ProximityPrompt",true) if not pr then for _,d in pairs(n:GetDescendants()) do if d:IsA("ProximityPrompt") then pr=d break end end end
    if pr then fireproximityprompt(pr) bc=bc+1 return true end
    local cd = n:FindFirstChildOfClass("ClickDetector",true) if not cd then for _,d in pairs(n:GetDescendants()) do if d:IsA("ClickDetector") then cd=d break end end end
    if cd then fireclickdetector(cd) bc=bc+1 return true end return false
end

local function st()
    stop = false loop = R.Heartbeat:Connect(function()
        if not auto or stop then if loop then loop:Disconnect() loop=nil end return end
        pcall(function()
            local ch = gc() if not ch then return end local h,r = ch:FindFirstChild("Humanoid"),ch:FindFirstChild("HumanoidRootPart")
            if not h or not r or h.Health <= 0 then return end local sp = tonumber(ps.Text) or .45
            if currentTab == "money" then local m = fm() if m then si.Text,si.TextColor3,sl.Text = "🟢",Color3.fromRGB(76,175,80),"Collecting..." cm(m) mc1.Text = tostring(mc) task.wait(sp) else si.Text,si.TextColor3,sl.Text = "🔍",Color3.fromRGB(158,158,158),"No money" task.wait(1) end
            elseif currentTab == "npc" then local n = fn() if n then si.Text,si.TextColor3,sl.Text = "🙏",Color3.fromRGB(255,193,7),"Begging..." bn(n) mc2.Text = tostring(bc) task.wait(sp*2) else si.Text,si.TextColor3,sl.Text = "🔍",Color3.fromRGB(158,158,158),"No NPCs" task.wait(1) end end
        end)
    end)
end
local function sp() stop,auto = true,false if loop then loop:Disconnect() loop=nil end si.Text,si.TextColor3,sl.Text = "⚪",Color3.fromRGB(158,158,158),"Status: OFF" end

-- Tabs
local function switchTab(tab)
    currentTab = tab
    if tab == "minigame" then pc.Visible,sf.Visible,mgc.Visible,bt.Visible = false,false,true,false else pc.Visible,sf.Visible,mgc.Visible,bt.Visible = true,true,false,true end
    if tab == "money" then T:Create(tabInd,TweenInfo.new(.3,Enum.EasingStyle.Quad),{Position=UDim2.new(0,0,1,-2)}):Play() T:Create(tab1,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(211,47,47)}):Play() T:Create(tab2,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play() T:Create(tab3,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play()
    elseif tab == "npc" then T:Create(tabInd,TweenInfo.new(.3,Enum.EasingStyle.Quad),{Position=UDim2.new(.33,0,1,-2)}):Play() T:Create(tab1,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play() T:Create(tab2,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(211,47,47)}):Play() T:Create(tab3,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play()
    else T:Create(tabInd,TweenInfo.new(.3,Enum.EasingStyle.Quad),{Position=UDim2.new(.66,0,1,-2)}):Play() T:Create(tab1,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play() T:Create(tab2,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(117,117,117)}):Play() T:Create(tab3,TweenInfo.new(.3),{TextColor3=Color3.fromRGB(211,47,47)}):Play() end
end
tab1.MouseButton1Click:Connect(function() switchTab("money") end)
tab2.MouseButton1Click:Connect(function() switchTab("npc") end)
tab3.MouseButton1Click:Connect(function() switchTab("minigame") end)

mgt.MouseButton1Click:Connect(function()
    shared.AutoClick.Value = not shared.AutoClick.Value
    if shared.AutoClick.Value then mgt.Text,mgt.BackgroundColor3 = "ON",Color3.fromRGB(76,175,80) T:Create(mgt,TweenInfo.new(.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,-20,0,22)}):Play() task.wait(.1) T:Create(mgt,TweenInfo.new(.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,-24,0,20)}):Play()
    else mgt.Text,mgt.BackgroundColor3 = "OFF",Color3.fromRGB(158,158,158) end
end)

bt.MouseButton1Click:Connect(function()
    if auto then sp() T:Create(bt,TweenInfo.new(.3,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(211,47,47),Size=UDim2.new(1,-24,0,40)}):Play() bt.Text = "START"
    else auto = true st() T:Create(bt,TweenInfo.new(.3,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(76,175,80),Size=UDim2.new(1,-20,0,44)}):Play() task.wait(.15) T:Create(bt,TweenInfo.new(.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,-24,0,40)}):Play() bt.Text = "STOP" end
end)

cl.MouseButton1Click:Connect(function() sp() shared.AutoClick.Value = false T:Create(cl,TweenInfo.new(.2),{Rotation=90}):Play() T:Create(f,TweenInfo.new(.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(.5,0,.5,0)}):Play() task.wait(.4) g:Destroy() end)

-- Minimize
local minimized,miniBtn = false,nil
local function createMiniBtn()
    miniBtn = Instance.new("TextButton",g) miniBtn.BackgroundColor3,miniBtn.Size,miniBtn.Position,miniBtn.BorderSizePixel,miniBtn.Text,miniBtn.Visible,miniBtn.Active,miniBtn.Draggable = Color3.fromRGB(211,47,47),UDim2.new(0,60,0,60),UDim2.new(1,-80,1,-80),0,"",false,true,true ac(miniBtn,30)
    local miniIcon = Instance.new("TextLabel",miniBtn) miniIcon.BackgroundTransparency,miniIcon.Size,miniIcon.Font,miniIcon.Text,miniIcon.TextColor3,miniIcon.TextSize = 1,UDim2.new(1,0,1,0),Enum.Font.GothamBold,"🔥",Color3.new(1,1,1),26
    miniBtn.MouseButton1Click:Connect(function() minimized,miniBtn.Visible,f.Visible = false,false,true T:Create(f,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,300,0,340),Position=UDim2.new(.38,0,.3,0)}):Play() end)
end
mi.MouseButton1Click:Connect(function() if not minimized then minimized = true if not miniBtn then createMiniBtn() end T:Create(f,TweenInfo.new(.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,60,0,60),Position=UDim2.new(1,-80,1,-80)}):Play() task.wait(.4) f.Visible,miniBtn.Visible = false,true end end)

p.CharacterAdded:Connect(function() task.wait(2) if auto then sp() task.wait(.5) st() end end)
pcall(function() local s,r = pcall(function() return MS:GetProductInfo(game.PlaceId).Name end) if s then ti.Text = r else ti.Text = "RED AUTO" end end)

task.wait(.1) T:Create(f,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,300,0,340),Position=UDim2.new(.38,0,.3,0)}):Play()
game.StarterGui:SetCore("SendNotification",{Title="🔥 RED AUTO",Text="Loaded! 💎",Duration=3})
print("🔥 RED AUTO - Ready!")