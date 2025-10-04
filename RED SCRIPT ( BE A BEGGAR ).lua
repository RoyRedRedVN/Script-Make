-- BE A BEGGAR AUTO FARM - Rayfield Library 🍊💸
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local P = game:GetService("Players")
local R = game:GetService("RunService")
local p = P.LocalPlayer

-- Variables
local auto, stop, loop = false, false, nil
local mc, bc = 0, 0
local speed = 0.45

if not shared.AutoClick then
    shared.AutoClick = Instance.new("BoolValue")
    shared.AutoClick.Value = false
end

-- Create Window with Orange Theme
local Window = Rayfield:CreateWindow({
    Name = "🍊 BE A BEGGAR AUTO FARM",
    LoadingTitle = "BE A BEGGAR AUTO FARM",
    LoadingSubtitle = "by REDMOD",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BeABeggarAutoFarm",
        FileName = "BeggarConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = {
        Accent = Color3.fromRGB(255, 140, 0), -- Orange
        SecondaryAccent = Color3.fromRGB(255, 165, 0), -- Light Orange
        Background = Color3.fromRGB(25, 25, 25),
        SecondaryBackground = Color3.fromRGB(35, 35, 35),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
})

-- Functions
local function gc()
    return p.Character or p.CharacterAdded:Wait()
end

local function fm()
    local ch = gc()
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r, n, s = ch.HumanoidRootPart, nil, math.huge
    local mf = workspace:FindFirstChild("Money")
    if mf then
        for _, v in pairs(mf:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local mp = v:IsA("Model") and v:GetPrimaryPartCFrame().Position or v.Position
                local d = (r.Position - mp).Magnitude
                if d < s then
                    s, n = d, v
                end
            end
        end
    end
    return n
end

local function fn()
    local ch = gc()
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local r, n, s = ch.HumanoidRootPart, nil, math.huge
    local nf = workspace:FindFirstChild("NPCS") or workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Npcs")
    if nf then
        for _, v in pairs(nf:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                local d = (r.Position - v.HumanoidRootPart.Position).Magnitude
                if d < s then
                    s, n = d, v
                end
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
    r.CFrame = tp + Vector3.new(0, 3, 0)
    task.wait(0.1)
    local pr = m:FindFirstChildOfClass("ProximityPrompt")
    if pr then
        fireproximityprompt(pr)
        mc = mc + 1
        return true
    end
    local cd = m:FindFirstChildOfClass("ClickDetector")
    if cd then
        fireclickdetector(cd)
        mc = mc + 1
        return true
    end
    task.wait(0.3)
    if not m.Parent then
        mc = mc + 1
        return true
    end
    return false
end

local function bn(n)
    local ch = gc()
    if not ch then return false end
    local r = ch:FindFirstChild("HumanoidRootPart")
    if not r or not n:FindFirstChild("HumanoidRootPart") then return false end
    r.CFrame = n.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
    task.wait(0.2)
    local pr = n:FindFirstChildOfClass("ProximityPrompt", true)
    if not pr then
        for _, d in pairs(n:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                pr = d
                break
            end
        end
    end
    if pr then
        fireproximityprompt(pr)
        bc = bc + 1
        return true
    end
    local cd = n:FindFirstChildOfClass("ClickDetector", true)
    if not cd then
        for _, d in pairs(n:GetDescendants()) do
            if d:IsA("ClickDetector") then
                cd = d
                break
            end
        end
    end
    if cd then
        fireclickdetector(cd)
        bc = bc + 1
        return true
    end
    return false
end

-- Money Tab
local MoneyTab = Window:CreateTab("💰 Money Farm", 4483362458)
local MoneySection = MoneyTab:CreateSection("Money Collection")

local MoneyLabel = MoneyTab:CreateLabel("Collected: 0")

local MoneyToggle = MoneyTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Flag = "MoneyToggle",
    Callback = function(Value)
        auto = Value
        if Value then
            stop = false
            loop = R.Heartbeat:Connect(function()
                if not auto or stop then
                    if loop then
                        loop:Disconnect()
                        loop = nil
                    end
                    return
                end
                pcall(function()
                    local ch = gc()
                    if not ch then return end
                    local h, r = ch:FindFirstChild("Humanoid"), ch:FindFirstChild("HumanoidRootPart")
                    if not h or not r or h.Health <= 0 then return end
                    local m = fm()
                    if m then
                        cm(m)
                        MoneyLabel:Set("Collected: " .. tostring(mc))
                        task.wait(speed)
                    else
                        task.wait(1)
                    end
                end)
            end)
        else
            stop = true
            if loop then
                loop:Disconnect()
                loop = nil
            end
        end
    end,
})

local SpeedSlider = MoneyTab:CreateSlider({
    Name = "Collection Speed",
    Range = {0.1, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.45,
    Flag = "SpeedSlider",
    Callback = function(Value)
        speed = Value
    end,
})

MoneyTab:CreateButton({
    Name = "Reset Counter",
    Callback = function()
        mc = 0
        MoneyLabel:Set("Collected: 0")
        Rayfield:Notify({
            Title = "Reset",
            Content = "Money counter reset!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- NPC Tab
local NPCTab = Window:CreateTab("🙏 NPC Farm", 4483362458)
local NPCSection = NPCTab:CreateSection("NPC Begging")

local NPCLabel = NPCTab:CreateLabel("Begged: 0")

local NPCToggle = NPCTab:CreateToggle({
    Name = "Auto Beg NPCs",
    CurrentValue = false,
    Flag = "NPCToggle",
    Callback = function(Value)
        auto = Value
        if Value then
            stop = false
            loop = R.Heartbeat:Connect(function()
                if not auto or stop then
                    if loop then
                        loop:Disconnect()
                        loop = nil
                    end
                    return
                end
                pcall(function()
                    local ch = gc()
                    if not ch then return end
                    local h, r = ch:FindFirstChild("Humanoid"), ch:FindFirstChild("HumanoidRootPart")
                    if not h or not r or h.Health <= 0 then return end
                    local n = fn()
                    if n then
                        bn(n)
                        NPCLabel:Set("Begged: " .. tostring(bc))
                        task.wait(speed * 2)
                    else
                        task.wait(1)
                    end
                end)
            end)
        else
            stop = true
            if loop then
                loop:Disconnect()
                loop = nil
            end
        end
    end,
})

local NPCSpeedSlider = NPCTab:CreateSlider({
    Name = "Begging Speed",
    Range = {0.1, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.45,
    Flag = "NPCSpeedSlider",
    Callback = function(Value)
        speed = Value
    end,
})

NPCTab:CreateButton({
    Name = "Reset Counter",
    Callback = function()
        bc = 0
        NPCLabel:Set("Begged: 0")
        Rayfield:Notify({
            Title = "Reset",
            Content = "NPC counter reset!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Minigame Tab
local MiniTab = Window:CreateTab("🎮 Minigame", 4483362458)
local MiniSection = MiniTab:CreateSection("Auto Click Minigame")

MiniTab:CreateParagraph({
    Title = "How it works",
    Content = "Automatically fires minigame event to win circles. Enable this before starting NPC farm."
})

local miniLoop = nil

local MiniToggle = MiniTab:CreateToggle({
    Name = "Auto Win Minigame",
    CurrentValue = false,
    Flag = "MiniToggle",
    Callback = function(Value)
        if Value then
            miniLoop = task.spawn(function()
                while shared.AutoClick and shared.AutoClick.Value do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.MinigameEvent:FireServer(true)
                    end)
                    task.wait(0.1)
                end
            end)
            Rayfield:Notify({
                Title = "Minigame Auto Win",
                Content = "Auto win enabled! Start begging NPCs.",
                Duration = 5,
                Image = 4483362458,
            })
        else
            if miniLoop then
                task.cancel(miniLoop)
                miniLoop = nil
            end
            Rayfield:Notify({
                Title = "Minigame Auto Win",
                Content = "Auto win disabled.",
                Duration = 3,
                Image = 4483362458,
            })
        end
        shared.AutoClick.Value = Value
    end,
})

MiniTab:CreateLabel("Status: " .. (shared.AutoClick and shared.AutoClick.Value and "ON" or "OFF"))

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Configuration")

SettingsTab:CreateButton({
    Name = "Respawn Character",
    Callback = function()
        if p.Character then
            p.Character:BreakJoints()
            Rayfield:Notify({
                Title = "Respawn",
                Content = "Respawning character...",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Reset All Stats",
    Callback = function()
        mc, bc = 0, 0
        MoneyLabel:Set("Collected: 0")
        NPCLabel:Set("Begged: 0")
        Rayfield:Notify({
            Title = "Reset Complete",
            Content = "All stats have been reset!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        stop = true
        auto = false
        shared.AutoClick.Value = false
        if loop then
            loop:Disconnect()
            loop = nil
        end
        Rayfield:Destroy()
    end,
})

-- Character Respawn Handler
p.CharacterAdded:Connect(function()
    task.wait(2)
    if auto then
        stop = true
        task.wait(0.5)
        stop = false
    end
end)

-- Load Notification
Rayfield:Notify({
    Title = "🍊 BE A BEGGAR AUTO FARM",
    Content = "Loaded successfully! Ready to farm.",
    Duration = 5,
    Image = 4483362458,
})

print("🍊 BE A BEGGAR AUTO FARM - Rayfield Library Loaded!")