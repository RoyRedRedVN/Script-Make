--!strict
-- ESP & Aimbot Script with Rayfield UI + Team Check
-- Optimized and cleaned version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = workspace
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuration
local Config = {
    ESP = {
        Enabled = false,
        BoxColor = Color3.new(1, 0.3, 0.3),
        DistanceColor = Color3.new(1, 1, 1),
        SnaplineEnabled = true,
        SnaplinePosition = "Center",
        RainbowEnabled = false,
        ShowDistance = true,
        ShowHealth = true,
        TeamCheck = false,
        TeamColor = true
    },
    Aimbot = {
        Enabled = false,
        FOV = 30,
        MaxDistance = 200,
        ShowFOV = false,
        TargetPart = "Head",
        Smoothness = 0.5,
        TeamCheck = false
    }
}

-- ESP Objects Storage
local ESPObjects = {}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.new(1, 1, 1)

-- Team Check Function
local function IsTeammate(player)
    if not LocalPlayer.Team or not player.Team then
        return false
    end
    return LocalPlayer.Team == player.Team
end

-- Get Team Color
local function GetTeamColor(player)
    if player.Team then
        return player.Team.TeamColor.Color
    end
    return Config.ESP.BoxColor
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "whoamhoam v2.1 | Team Check Edition",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by whoamhoam",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "whoamhoam_config",
        FileName = "config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- ESP Tab
local ESPTab = Window:CreateTab("🎯 ESP", nil)
local ESPSection = ESPTab:CreateSection("ESP Settings")

local ESPToggle = ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(v)
        Config.ESP.Enabled = v
    end
})

local ESPTeamCheck = ESPTab:CreateToggle({
    Name = "Team Check (Hide Teammates)",
    CurrentValue = false,
    Flag = "ESPTeamCheck",
    Callback = function(v)
        Config.ESP.TeamCheck = v
    end
})

local ESPTeamColor = ESPTab:CreateToggle({
    Name = "Use Team Colors",
    CurrentValue = true,
    Flag = "ESPTeamColor",
    Callback = function(v)
        Config.ESP.TeamColor = v
    end
})

local SnaplineToggle = ESPTab:CreateToggle({
    Name = "Show Snaplines",
    CurrentValue = true,
    Flag = "SnaplineEnabled",
    Callback = function(v)
        Config.ESP.SnaplineEnabled = v
    end
})

local RainbowToggle = ESPTab:CreateToggle({
    Name = "Rainbow Mode",
    CurrentValue = false,
    Flag = "RainbowEnabled",
    Callback = function(v)
        Config.ESP.RainbowEnabled = v
    end
})

local SnaplineDropdown = ESPTab:CreateDropdown({
    Name = "Snapline Position",
    Options = {"Center", "Bottom", "Top"},
    CurrentOption = "Center",
    Flag = "SnaplinePosition",
    Callback = function(v)
        Config.ESP.SnaplinePosition = v
    end
})

local ESPColorPicker = ESPTab:CreateColorPicker({
    Name = "ESP Box Color",
    Color = Color3.new(1, 0.3, 0.3),
    Flag = "ESPColor",
    Callback = function(v)
        Config.ESP.BoxColor = v
    end
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("🎮 Aimbot", nil)
local AimbotSection = AimbotTab:CreateSection("Aimbot Settings")

local AimbotToggle = AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(v)
        Config.Aimbot.Enabled = v
    end
})

local AimbotTeamCheck = AimbotTab:CreateToggle({
    Name = "Team Check (Ignore Teammates)",
    CurrentValue = false,
    Flag = "AimbotTeamCheck",
    Callback = function(v)
        Config.Aimbot.TeamCheck = v
    end
})

local FOVToggle = AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(v)
        Config.Aimbot.ShowFOV = v
        FOVCircle.Visible = v
    end
})

local FOVSlider = AimbotTab:CreateSlider({
    Name = "FOV Size",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = 30,
    Flag = "FOV",
    Callback = function(v)
        Config.Aimbot.FOV = v
    end
})

local DistanceSlider = AimbotTab:CreateSlider({
    Name = "Max Distance",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = 200,
    Flag = "MaxDistance",
    Callback = function(v)
        Config.Aimbot.MaxDistance = v
    end
})

local TargetPartDropdown = AimbotTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "TargetPart",
    Callback = function(v)
        Config.Aimbot.TargetPart = v
    end
})

-- Info Tab
local InfoTab = Window:CreateTab("ℹ️ Info", nil)
local InfoSection = InfoTab:CreateSection("Information")

InfoTab:CreateParagraph({
    Title = "Script Info",
    Content = "Red Script - Aim Bot v2.1\n\nFeatures:\n• ESP with team check\n• Aimbot with team check\n• Team color support\n• Rainbow mode\n• FOV circle\n• Customizable settings"
})

InfoTab:CreateParagraph({
    Title = "Team Check",
    Content = "When enabled:\n• ESP: Hides teammates\n• Aimbot: Won't target teammates\n• Team Colors: Shows player's team color"
})

InfoTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
        for _, esp in pairs(ESPObjects) do
            for _, obj in pairs(esp) do
                obj:Remove()
            end
        end
        FOVCircle:Remove()
        print("Script unloaded!")
    end
})

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Distance = Drawing.new("Text"),
        Snapline = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    -- Setup Box
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = Config.ESP.BoxColor
    esp.Box.Visible = false
    
    -- Setup HealthBar
    esp.HealthBar.Thickness = 2
    esp.HealthBar.Filled = true
    esp.HealthBar.Visible = false
    
    -- Setup Distance Text
    esp.Distance.Size = 16
    esp.Distance.Center = true
    esp.Distance.Color = Config.ESP.DistanceColor
    esp.Distance.Visible = false
    
    -- Setup Name Text
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Visible = false
    
    -- Setup Snapline
    esp.Snapline.Thickness = 2
    esp.Snapline.Color = Config.ESP.BoxColor
    esp.Snapline.Visible = false
    
    ESPObjects[player] = esp
end

local function UpdateESP(player, esp)
    -- Team Check
    if Config.ESP.TeamCheck and IsTeammate(player) then
        for _, obj in pairs(esp) do
            obj.Visible = false
        end
        return
    end
    
    if not Config.ESP.Enabled or not player.Character then
        for _, obj in pairs(esp) do
            obj.Visible = false
        end
        return
    end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local head = player.Character:FindFirstChild("Head")
    
    if not humanoid or humanoid.Health <= 0 or not head then
        for _, obj in pairs(esp) do
            obj.Visible = false
        end
        return
    end
    
    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
    
    if not onScreen then
        for _, obj in pairs(esp) do
            obj.Visible = false
        end
        return
    end
    
    local distance = (head.Position - Camera.CFrame.Position).Magnitude
    local scale = 1000 / distance
    
    -- Determine Color
    local boxColor = Config.ESP.BoxColor
    if Config.ESP.RainbowEnabled then
        local hue = (tick() * 0.5) % 1
        boxColor = Color3.fromHSV(hue, 1, 1)
    elseif Config.ESP.TeamColor then
        boxColor = GetTeamColor(player)
    end
    
    -- Update Box
    esp.Box.Size = Vector2.new(scale, scale * 1.5)
    esp.Box.Position = Vector2.new(pos.X - scale/2, pos.Y - scale * 0.75)
    esp.Box.Color = boxColor
    esp.Box.Visible = true
    
    -- Update Health Bar
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    esp.HealthBar.Size = Vector2.new(4, scale * 1.5 * healthPercent)
    esp.HealthBar.Position = Vector2.new(pos.X + scale/2 + 5, (pos.Y - scale * 0.75) + (scale * 1.5 * (1 - healthPercent)))
    esp.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
    esp.HealthBar.Visible = true
    
    -- Update Name
    esp.Name.Text = player.Name
    esp.Name.Position = Vector2.new(pos.X, pos.Y - scale * 0.75 - 15)
    esp.Name.Color = boxColor
    esp.Name.Visible = true
    
    -- Update Distance
    esp.Distance.Text = math.floor(distance) .. "m"
    esp.Distance.Position = Vector2.new(pos.X, pos.Y + scale * 0.75 + 10)
    esp.Distance.Visible = true
    
    -- Update Snapline
    if Config.ESP.SnaplineEnabled then
        esp.Snapline.From = Vector2.new(pos.X, pos.Y + scale * 0.75)
        local snapY = Config.ESP.SnaplinePosition == "Bottom" and Camera.ViewportSize.Y or
                     Config.ESP.SnaplinePosition == "Top" and 0 or
                     Camera.ViewportSize.Y / 2
        esp.Snapline.To = Vector2.new(Camera.ViewportSize.X / 2, snapY)
        esp.Snapline.Color = boxColor
        esp.Snapline.Visible = true
    else
        esp.Snapline.Visible = false
    end
end

-- Aimbot Function
local function GetClosestPlayer()
    local closest = nil
    local minDist = math.huge
    local fov = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        -- Team Check for Aimbot
        if Config.Aimbot.TeamCheck and IsTeammate(player) then
            continue
        end
        
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            local targetPart = player.Character[Config.Aimbot.TargetPart]
            local dir = (targetPart.Position - Camera.CFrame.Position).Unit
            local lookDir = Camera.CFrame.LookVector
            local angle = math.deg(math.acos(dir:Dot(lookDir)))
            
            if angle <= fov / 2 then
                local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if dist <= Config.Aimbot.MaxDistance and dist < minDist then
                    -- Wall Check
                    local ray = Ray.new(Camera.CFrame.Position, dir * dist)
                    local part, _ = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                    
                    if part and part:IsDescendantOf(player.Character) then
                        closest = player
                        minDist = dist
                    end
                end
            end
        end
    end
    
    return closest
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Radius = (Config.Aimbot.FOV / 2) * (Camera.ViewportSize.Y / 90)
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = Config.Aimbot.ShowFOV
    
    if Config.ESP.RainbowEnabled and Config.Aimbot.ShowFOV then
        FOVCircle.Color = Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
    else
        FOVCircle.Color = Color3.new(1, 1, 1)
    end
    
    -- Update ESP
    for player, esp in pairs(ESPObjects) do
        UpdateESP(player, esp)
    end
    
    -- Aimbot
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[Config.Aimbot.TargetPart].Position)
        end
    end
end)

-- Player Events
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end)

-- Notification
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "whoamhoam v2.1 with Team Check loaded!",
    Duration = 5,
    Image = 4483362458
})

print("✅ Script successfully activated with Team Check!")