--!strict
-- Red Script - Aim Bot V3 + NPC Auto Aim + Advanced Targeting
local Players, RunService, Workspace = game:GetService("Players"), game:GetService("RunService"), workspace
local Camera, LocalPlayer = Workspace.CurrentCamera, Players.LocalPlayer

-- Load UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Config
local Config = {
    ESP = {Enabled = false, BoxColor = Color3.fromRGB(138, 43, 226), GradientColor = Color3.fromRGB(255, 100, 255),
        SnaplineEnabled = true, SnaplinePosition = "Center", RainbowEnabled = false, GradientEnabled = false,
        ShowDistance = true, ShowHealth = true, TeamCheck = false, TeamColor = true, ShowNPCs = true},
    Aimbot = {Enabled = false, FOV = 30, MaxDistance = 200, ShowFOV = false, ShowCrosshair = false,
        CrosshairSize = 10, CrosshairThickness = 2, CrosshairColor = Color3.fromRGB(255, 255, 255),
        TargetPart = "Head", Smoothness = 0.5, TeamCheck = false, 
        TargetMode = "Nearest Player", -- "Nearest Player", "Selected Player", "NPCs Only"
        SelectedPlayer = nil, IgnoreBehind = false},
    BehindAlert = {Enabled = false, AlertDistance = 20, CheckInterval = 1, SoundAlert = false}
}

local behindAlertCache = {}
local lastBehindCheck = 0

local ESPObjects = {}

-- Drawing Objects
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.NumSides, FOVCircle.Filled, FOVCircle.Visible = 2, 100, false, false

local Crosshair = {Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")}
for _, line in pairs(Crosshair) do line.Thickness, line.Visible = 2, false end

local CrosshairDot = Drawing.new("Circle")
CrosshairDot.Radius, CrosshairDot.Filled, CrosshairDot.Visible = 2, true, false

local SelectedIndicator = Drawing.new("Circle")
SelectedIndicator.Thickness, SelectedIndicator.NumSides, SelectedIndicator.Filled, SelectedIndicator.Visible = 3, 50, false, false

-- Helper Functions
local function IsTeammate(player)
    return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
end

local function GetTeamColor(player)
    return player.Team and player.Team.TeamColor.Color or Config.ESP.BoxColor
end

local function GetPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(list, player.Name) end
    end
    return list
end

local function IsBehindPlayer(targetPos)
    if not Config.Aimbot.IgnoreBehind then return false end
    local cameraLook = Camera.CFrame.LookVector
    local directionToTarget = (targetPos - Camera.CFrame.Position).Unit
    local dotProduct = cameraLook:Dot(directionToTarget)
    return dotProduct < 0 -- Behind if dot product is negative
end

local function CheckEnemiesBehind()
    if not Config.BehindAlert.Enabled then return end
    
    local currentTime = tick()
    if currentTime - lastBehindCheck < Config.BehindAlert.CheckInterval then return end
    lastBehindCheck = currentTime
    
    local enemiesBehind = {}
    local cameraPos = Camera.CFrame.Position
    local cameraLook = Camera.CFrame.LookVector
    
    -- Check Players
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or (Config.Aimbot.TeamCheck and IsTeammate(player)) then continue end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = player.Character.HumanoidRootPart
                local distance = (cameraPos - rootPart.Position).Magnitude
                
                if distance <= Config.BehindAlert.AlertDistance then
                    local directionToEnemy = (rootPart.Position - cameraPos).Unit
                    local dotProduct = cameraLook:Dot(directionToEnemy)
                    
                    if dotProduct < -0.3 then -- Behind (wider angle)
                        table.insert(enemiesBehind, {
                            name = player.Name,
                            distance = math.floor(distance),
                            type = "Player"
                        })
                    end
                end
            end
        end
    end
    
    -- Check NPCs
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and IsValidNPC(obj) then
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if rootPart then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local distance = (cameraPos - rootPart.Position).Magnitude
                    
                    if distance <= Config.BehindAlert.AlertDistance then
                        local directionToEnemy = (rootPart.Position - cameraPos).Unit
                        local dotProduct = cameraLook:Dot(directionToEnemy)
                        
                        if dotProduct < -0.3 then
                            table.insert(enemiesBehind, {
                                name = obj.Name,
                                distance = math.floor(distance),
                                type = "NPC"
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- Send notifications
    if #enemiesBehind > 0 then
        for _, enemy in ipairs(enemiesBehind) do
            local cacheKey = enemy.name .. "_" .. enemy.distance
            if not behindAlertCache[cacheKey] then
                behindAlertCache[cacheKey] = true
                
                local alertMsg = string.format("%s behind you! (%dm)", enemy.type, enemy.distance)
                Rayfield:Notify({
                    Title = "⚠️ ENEMY BEHIND!",
                    Content = enemy.name .. " - " .. alertMsg,
                    Duration = 3,
                    Image = 4483362458
                })
                
                -- Clear cache after 5 seconds
                task.delay(5, function()
                    behindAlertCache[cacheKey] = nil
                end)
            end
        end
    end
end

-- NPC Detection
local function IsValidNPC(model)
    if not model:IsA("Model") then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    
    if humanoid and rootPart and humanoid.Health > 0 then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character == model then return false end
        end
        return true
    end
    return false
end

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "💎 Red Script V3 Advanced",
    LoadingTitle = "Red Script Loading...",
    LoadingSubtitle = "Aim Bot V3 - Advanced Targeting",
    ConfigurationSaving = {Enabled = true, FolderName = "RedScript_AimBot", FileName = "config_v3_adv"},
    Discord = {Enabled = false}, KeySystem = false, Theme = "Amethyst"
})

-- ESP Tab
local ESPTab = Window:CreateTab("🎯 ESP", 4483362458)
ESPTab:CreateToggle({Name = "Enable ESP", CurrentValue = false, Callback = function(v) Config.ESP.Enabled = v end})
ESPTab:CreateToggle({Name = "Show NPCs/Mobs", CurrentValue = true, Callback = function(v) Config.ESP.ShowNPCs = v end})
ESPTab:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) Config.ESP.TeamCheck = v end})
ESPTab:CreateToggle({Name = "Snaplines", CurrentValue = true, Callback = function(v) Config.ESP.SnaplineEnabled = v end})
ESPTab:CreateToggle({Name = "Rainbow", CurrentValue = false, Callback = function(v) Config.ESP.RainbowEnabled = v end})
ESPTab:CreateColorPicker({Name = "Box Color", Color = Color3.fromRGB(138, 43, 226), Callback = function(v) Config.ESP.BoxColor = v end})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("🎮 Aimbot", 4483362458)
AimbotTab:CreateToggle({Name = "Enable Aimbot", CurrentValue = false, Callback = function(v) Config.Aimbot.Enabled = v end})
AimbotTab:CreateToggle({Name = "Ignore Behind Camera", CurrentValue = false, 
    Callback = function(v) Config.Aimbot.IgnoreBehind = v end})
AimbotTab:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) Config.Aimbot.TeamCheck = v end})
AimbotTab:CreateToggle({Name = "Show FOV", CurrentValue = false, Callback = function(v) Config.Aimbot.ShowFOV = v; FOVCircle.Visible = v end})
AimbotTab:CreateToggle({Name = "Show Crosshair", CurrentValue = false, Callback = function(v) Config.Aimbot.ShowCrosshair = v end})

AimbotTab:CreateSection("Target Selection")

local TargetModeDropdown = AimbotTab:CreateDropdown({
    Name = "Target Mode", 
    Options = {"Nearest Player", "Selected Player", "NPCs Only"}, 
    CurrentOption = "Nearest Player",
    Callback = function(v)
        Config.Aimbot.TargetMode = v
        if v == "Nearest Player" or v == "NPCs Only" then 
            Config.Aimbot.SelectedPlayer = nil 
            SelectedIndicator.Visible = false
        end
        Rayfield:Notify({Title = "Target Mode", Content = "Changed to: " .. v, Duration = 2})
    end
})

local PlayerSelectDropdown = AimbotTab:CreateDropdown({
    Name = "Select Player Target", 
    Options = GetPlayerList(), 
    CurrentOption = "None",
    Callback = function(v)
        local target = Players:FindFirstChild(v)
        if target then
            Config.Aimbot.SelectedPlayer = target
            Config.Aimbot.TargetMode = "Selected Player"
            TargetModeDropdown:Set("Selected Player")
            Rayfield:Notify({Title = "Target Selected", Content = "Now targeting: " .. v, Duration = 3})
        end
    end
})

AimbotTab:CreateButton({Name = "🔄 Refresh Player List", Callback = function() 
    PlayerSelectDropdown:Refresh(GetPlayerList()) 
    Rayfield:Notify({Title = "Refreshed", Content = "Player list updated", Duration = 2})
end})

AimbotTab:CreateButton({Name = "❌ Clear Target", Callback = function() 
    Config.Aimbot.SelectedPlayer = nil
    SelectedIndicator.Visible = false
    Config.Aimbot.TargetMode = "Nearest Player"
    TargetModeDropdown:Set("Nearest Player")
    Rayfield:Notify({Title = "Target Cleared", Content = "Switched to Nearest Player mode", Duration = 2})
end})

AimbotTab:CreateSection("Settings")

AimbotTab:CreateSlider({Name = "FOV", Range = {10, 100}, Increment = 1, CurrentValue = 30, Callback = function(v) Config.Aimbot.FOV = v end})
AimbotTab:CreateSlider({Name = "Max Distance", Range = {50, 1000}, Increment = 10, CurrentValue = 200, Callback = function(v) Config.Aimbot.MaxDistance = v end})
AimbotTab:CreateSlider({Name = "Smoothness", Range = {0, 1}, Increment = 0.01, CurrentValue = 0.5, Callback = function(v) Config.Aimbot.Smoothness = v end})
AimbotTab:CreateDropdown({Name = "Target Part", Options = {"Head", "Torso", "HumanoidRootPart", "UpperTorso"}, CurrentOption = "Head",
    Callback = function(v) Config.Aimbot.TargetPart = v end})

-- Alert Tab
local AlertTab = Window:CreateTab("⚠️ Alerts", 4483362458)
AlertTab:CreateToggle({
    Name = "Enemy Behind Alert", 
    CurrentValue = false, 
    Callback = function(v) 
        Config.BehindAlert.Enabled = v
        if v then
            Rayfield:Notify({Title = "Alert System", Content = "Enemy behind alerts enabled!", Duration = 3})
        end
    end
})

AlertTab:CreateSlider({
    Name = "Alert Distance (meters)", 
    Range = {5, 50}, 
    Increment = 1, 
    CurrentValue = 20, 
    Callback = function(v) Config.BehindAlert.AlertDistance = v end
})

AlertTab:CreateSlider({
    Name = "Check Interval (seconds)", 
    Range = {0.5, 5}, 
    Increment = 0.5, 
    CurrentValue = 1, 
    Callback = function(v) Config.BehindAlert.CheckInterval = v end
})

AlertTab:CreateSection("Alert Info")
AlertTab:CreateParagraph({
    Title = "How it works:",
    Content = "Detects enemies (Players & NPCs) behind your camera and sends notifications with their name and distance. Adjust the alert distance and check interval to your preference."
})

-- ESP Functions
local function CreateESP(target, isNPC)
    if not isNPC and target == LocalPlayer then return end
    local esp = {}
    local parts = {"TopLeft1", "TopRight1", "BottomLeft1", "BottomRight1", "TopLine", "BottomLine", "LeftLine", "RightLine"}
    for _, part in pairs(parts) do
        esp[part] = Drawing.new("Line")
        esp[part].Thickness, esp[part].Visible = 2, false
    end
    
    esp.HealthBarBg = Drawing.new("Square")
    esp.HealthBarBg.Filled, esp.HealthBarBg.Color, esp.HealthBarBg.Transparency, esp.HealthBarBg.Visible = true, Color3.new(0.1, 0.1, 0.1), 0.5, false
    
    esp.HealthBar = Drawing.new("Square")
    esp.HealthBar.Filled, esp.HealthBar.Visible = true, false
    
    for _, txt in pairs({"Name", "Distance", "HealthText"}) do
        esp[txt] = Drawing.new("Text")
        esp[txt].Center, esp[txt].Outline, esp[txt].OutlineColor, esp[txt].Visible = true, true, Color3.new(0, 0, 0), false
    end
    esp.Name.Size, esp.Distance.Size, esp.HealthText.Size = 15, 16, 14
    esp.HealthText.Center = false
    
    esp.Snapline = Drawing.new("Line")
    esp.Snapline.Thickness, esp.Snapline.Visible = 2, false
    
    esp.isNPC = isNPC
    ESPObjects[target] = esp
end

local function UpdateESP(target, esp)
    local character = esp.isNPC and target or target.Character
    
    if not Config.ESP.Enabled or not character or (esp.isNPC and not Config.ESP.ShowNPCs) or 
       (not esp.isNPC and Config.ESP.TeamCheck and IsTeammate(target)) then
        for _, obj in pairs(esp) do if typeof(obj) ~= "boolean" then obj.Visible = false end end
        return
    end
    
    local humanoid, rootPart, head = character:FindFirstChildOfClass("Humanoid"), 
        character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"), character:FindFirstChild("Head")
    
    if not humanoid or humanoid.Health <= 0 or not rootPart or not head then
        for _, obj in pairs(esp) do if typeof(obj) ~= "boolean" then obj.Visible = false end end
        return
    end
    
    local topPos = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
    local bottomPos = rootPart.Position - Vector3.new(0, rootPart.Size.Y / 2 + 2, 0)
    local topScreen, topOn = Camera:WorldToViewportPoint(topPos)
    local bottomScreen, bottomOn = Camera:WorldToViewportPoint(bottomPos)
    local rootScreen, rootOn = Camera:WorldToViewportPoint(rootPart.Position)
    
    if not topOn and not bottomOn and not rootOn then
        for _, obj in pairs(esp) do if typeof(obj) ~= "boolean" then obj.Visible = false end end
        return
    end
    
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    local boxHeight, boxWidth = math.abs(topScreen.Y - bottomScreen.Y), math.abs(topScreen.Y - bottomScreen.Y) * 0.55
    local boxX, boxY = rootScreen.X - boxWidth / 2, topScreen.Y
    local cornerRadius = math.min(boxWidth * 0.15, boxHeight * 0.08)
    
    local boxColor = esp.isNPC and Color3.fromRGB(255, 100, 50) or 
        (Config.ESP.RainbowEnabled and Color3.fromHSV((tick() * 0.5) % 1, 1, 1) or 
        (Config.ESP.TeamColor and GetTeamColor(target) or Config.ESP.BoxColor))
    
    -- Highlight selected player
    if not esp.isNPC and target == Config.Aimbot.SelectedPlayer then
        boxColor = Color3.fromRGB(255, 0, 255) -- Magenta for selected
    end
    
    -- Draw box
    esp.TopLeft1.From, esp.TopLeft1.To = Vector2.new(boxX + cornerRadius, boxY), Vector2.new(boxX, boxY + cornerRadius)
    esp.TopRight1.From, esp.TopRight1.To = Vector2.new(boxX + boxWidth - cornerRadius, boxY), Vector2.new(boxX + boxWidth, boxY + cornerRadius)
    esp.BottomLeft1.From, esp.BottomLeft1.To = Vector2.new(boxX, boxY + boxHeight - cornerRadius), Vector2.new(boxX + cornerRadius, boxY + boxHeight)
    esp.BottomRight1.From, esp.BottomRight1.To = Vector2.new(boxX + boxWidth - cornerRadius, boxY + boxHeight), Vector2.new(boxX + boxWidth, boxY + boxHeight - cornerRadius)
    esp.TopLine.From, esp.TopLine.To = Vector2.new(boxX + cornerRadius, boxY), Vector2.new(boxX + boxWidth - cornerRadius, boxY)
    esp.BottomLine.From, esp.BottomLine.To = Vector2.new(boxX + cornerRadius, boxY + boxHeight), Vector2.new(boxX + boxWidth - cornerRadius, boxY + boxHeight)
    esp.LeftLine.From, esp.LeftLine.To = Vector2.new(boxX, boxY + cornerRadius), Vector2.new(boxX, boxY + boxHeight - cornerRadius)
    esp.RightLine.From, esp.RightLine.To = Vector2.new(boxX + boxWidth, boxY + cornerRadius), Vector2.new(boxX + boxWidth, boxY + boxHeight - cornerRadius)
    
    for _, part in pairs({"TopLeft1", "TopRight1", "BottomLeft1", "BottomRight1", "TopLine", "BottomLine", "LeftLine", "RightLine"}) do
        esp[part].Color, esp[part].Visible = boxColor, true
    end
    
    -- Health Bar
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    local healthBarWidth, healthBarX = 4, boxX - 10
    esp.HealthBarBg.Size, esp.HealthBarBg.Position, esp.HealthBarBg.Visible = Vector2.new(healthBarWidth, boxHeight), Vector2.new(healthBarX, boxY), Config.ESP.ShowHealth
    local healthBarHeight = boxHeight * healthPercent
    esp.HealthBar.Size, esp.HealthBar.Position = Vector2.new(healthBarWidth, healthBarHeight), Vector2.new(healthBarX, boxY + (boxHeight - healthBarHeight))
    esp.HealthBar.Color = healthPercent > 0.6 and Color3.fromRGB(0, 255, 0) or (healthPercent > 0.3 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
    esp.HealthBar.Visible = Config.ESP.ShowHealth
    esp.HealthText.Text, esp.HealthText.Position, esp.HealthText.Color, esp.HealthText.Visible = 
        string.format("%d HP", math.floor(humanoid.Health)), Vector2.new(healthBarX - 2, boxY + boxHeight + 2), esp.HealthBar.Color, Config.ESP.ShowHealth
    
    local displayName = esp.isNPC and (character.Name .. " [NPC]") or target.Name
    esp.Name.Text, esp.Name.Position, esp.Name.Color, esp.Name.Visible = displayName, Vector2.new(rootScreen.X, boxY - 18), boxColor, true
    esp.Distance.Text, esp.Distance.Position, esp.Distance.Visible = string.format("%dm", math.floor(distance)), Vector2.new(rootScreen.X, boxY + boxHeight + 5), Config.ESP.ShowDistance
    
    if Config.ESP.SnaplineEnabled then
        local snapY = Config.ESP.SnaplinePosition == "Bottom" and Camera.ViewportSize.Y or (Config.ESP.SnaplinePosition == "Top" and 0 or Camera.ViewportSize.Y / 2)
        esp.Snapline.From, esp.Snapline.To, esp.Snapline.Color, esp.Snapline.Visible = 
            Vector2.new(rootScreen.X, boxY + boxHeight), Vector2.new(Camera.ViewportSize.X / 2, snapY), boxColor, true
    else
        esp.Snapline.Visible = false
    end
end

-- Advanced Aimbot Targeting
local function GetClosestTarget()
    local closest, minDist = nil, math.huge
    
    -- Mode: Selected Player
    if Config.Aimbot.TargetMode == "Selected Player" and Config.Aimbot.SelectedPlayer then
        local player = Config.Aimbot.SelectedPlayer
        if player.Character and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            local targetPart = player.Character[Config.Aimbot.TargetPart]
            if not IsBehindPlayer(targetPart.Position) then
                local dir = (targetPart.Position - Camera.CFrame.Position).Unit
                local angle = math.deg(math.acos(math.clamp(dir:Dot(Camera.CFrame.LookVector), -1, 1)))
                local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                
                if angle <= Config.Aimbot.FOV / 2 and dist <= Config.Aimbot.MaxDistance then
                    return player.Character
                end
            end
        end
    end
    
    -- Mode: Nearest Player
    if Config.Aimbot.TargetMode == "Nearest Player" then
        for _, player in pairs(Players:GetPlayers()) do
            if (Config.Aimbot.TeamCheck and IsTeammate(player)) or player == LocalPlayer then continue end
            if player.Character and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
                local targetPart = player.Character[Config.Aimbot.TargetPart]
                if not IsBehindPlayer(targetPart.Position) then
                    local dir = (targetPart.Position - Camera.CFrame.Position).Unit
                    local angle = math.deg(math.acos(math.clamp(dir:Dot(Camera.CFrame.LookVector), -1, 1)))
                    
                    if angle <= Config.Aimbot.FOV / 2 then
                        local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                        if dist <= Config.Aimbot.MaxDistance and dist < minDist then
                            closest, minDist = player.Character, dist
                        end
                    end
                end
            end
        end
    end
    
    -- Mode: NPCs Only
    if Config.Aimbot.TargetMode == "NPCs Only" then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and IsValidNPC(obj) then
                local targetPart = obj:FindFirstChild(Config.Aimbot.TargetPart) or obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
                if targetPart and not IsBehindPlayer(targetPart.Position) then
                    local dir = (targetPart.Position - Camera.CFrame.Position).Unit
                    local angle = math.deg(math.acos(math.clamp(dir:Dot(Camera.CFrame.LookVector), -1, 1)))
                    
                    if angle <= Config.Aimbot.FOV / 2 then
                        local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                        if dist <= Config.Aimbot.MaxDistance and dist < minDist then
                            closest, minDist = obj, dist
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- Main Loop
local npcUpdateInterval = 0
RunService.RenderStepped:Connect(function()
    local centerX, centerY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    
    -- Check enemies behind
    CheckEnemiesBehind()
    
    -- FOV Circle
    FOVCircle.Radius, FOVCircle.Position = (Config.Aimbot.FOV / 2) * (Camera.ViewportSize.Y / 90), Vector2.new(centerX, centerY)
    FOVCircle.Visible, FOVCircle.Color = Config.Aimbot.ShowFOV, Config.ESP.RainbowEnabled and Color3.fromHSV((tick() * 0.5) % 1, 1, 1) or Color3.fromRGB(138, 43, 226)
    
    -- Crosshair
    if Config.Aimbot.ShowCrosshair then
        local size, gap = Config.Aimbot.CrosshairSize, 5
        for _, line in pairs(Crosshair) do line.Color, line.Thickness, line.Visible = Config.Aimbot.CrosshairColor, Config.Aimbot.CrosshairThickness, true end
        Crosshair[1].From, Crosshair[1].To = Vector2.new(centerX, centerY - gap), Vector2.new(centerX, centerY - gap - size)
        Crosshair[2].From, Crosshair[2].To = Vector2.new(centerX, centerY + gap), Vector2.new(centerX, centerY + gap + size)
        Crosshair[3].From, Crosshair[3].To = Vector2.new(centerX - gap, centerY), Vector2.new(centerX - gap - size, centerY)
        Crosshair[4].From, Crosshair[4].To = Vector2.new(centerX + gap, centerY), Vector2.new(centerX + gap + size, centerY)
        CrosshairDot.Position, CrosshairDot.Color, CrosshairDot.Visible = Vector2.new(centerX, centerY), Config.Aimbot.CrosshairColor, true
    else
        for _, line in pairs(Crosshair) do line.Visible = false end
        CrosshairDot.Visible = false
    end
    
    -- Selected Player Indicator
    if Config.Aimbot.SelectedPlayer and Config.Aimbot.SelectedPlayer.Character then
        local head = Config.Aimbot.SelectedPlayer.Character:FindFirstChild("Head")
        if head then
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local scale = 1000 / (head.Position - Camera.CFrame.Position).Magnitude
                SelectedIndicator.Position, SelectedIndicator.Radius = Vector2.new(pos.X, pos.Y), math.clamp(scale * 0.8, 20, 80)
                SelectedIndicator.Color, SelectedIndicator.Visible = Color3.fromRGB(255, 0, 255), true
            else
                SelectedIndicator.Visible = false
            end
        end
    else
        SelectedIndicator.Visible = false
    end
    
    -- Update Player ESP
    for player, esp in pairs(ESPObjects) do
        if not esp.isNPC then UpdateESP(player, esp) end
    end
    
    -- Update NPC ESP (every 0.5s)
    npcUpdateInterval = npcUpdateInterval + 1
    if npcUpdateInterval >= 30 and Config.ESP.ShowNPCs then
        npcUpdateInterval = 0
        for obj, esp in pairs(ESPObjects) do
            if esp.isNPC then
                if not IsValidNPC(obj) then
                    for _, drawing in pairs(esp) do if typeof(drawing) ~= "boolean" then drawing:Remove() end end
                    ESPObjects[obj] = nil
                else
                    UpdateESP(obj, esp)
                end
            end
        end
        
        -- Add new NPCs
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and IsValidNPC(obj) and not ESPObjects[obj] then
                CreateESP(obj, true)
            end
        end
    end
    
    -- Aimbot
    if Config.Aimbot.Enabled then
        local target = GetClosestTarget()
        if target then
            local targetPart = target:FindFirstChild(Config.Aimbot.TargetPart) or target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local targetPos = targetPart.Position
                if Config.Aimbot.Smoothness > 0 then
                    local smoothedLook = Camera.CFrame.LookVector:Lerp((targetPos - Camera.CFrame.Position).Unit, 1 - Config.Aimbot.Smoothness)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + smoothedLook)
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                end
            end
        end
    end
end)

-- Player Events
for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer then CreateESP(player, false) end end

Players.PlayerAdded:Connect(function(player) 
    CreateESP(player, false)
    task.wait(1)
    PlayerSelectDropdown:Refresh(GetPlayerList())
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do if typeof(obj) ~= "boolean" then obj:Remove() end end
        ESPObjects[player] = nil
    end
    if Config.Aimbot.SelectedPlayer == player then 
        Config.Aimbot.SelectedPlayer = nil
        SelectedIndicator.Visible = false
        Config.Aimbot.TargetMode = "Nearest Player"
    end
    PlayerSelectDropdown:Refresh(GetPlayerList())
end)

Rayfield:Notify({Title = "🔴 Red Script Loaded", Content = "V3 Advanced Targeting", Duration = 5, Image = 4483362458})