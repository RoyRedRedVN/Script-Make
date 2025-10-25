--!strict
-- Red V3 Extreme Compact - Rewritten Version (Full, No Abbreviations)

local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = PlayersService.LocalPlayer

local RayfieldLibrary = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local configurations = {
    esp = {
        enabled = 0,
        color = Color3.fromRGB(138, 43, 226),
        teamCheck = 0,
        snaplines = 1,
        rainbow = 0,
        distance = 1,
        healthPoints = 1,
        npc = 1,
        skeleton = 0,
        chams = 0,
        head = 0,
        look = 0,
        gun = 0,
        style = "Corner",
        fade = 1,
        gradient = 0,
        animation = 0
    },
    aim = {
        enabled = 0,
        fieldOfView = 30,
        maximumDistance = 200,
        showFieldOfView = 0,
        crosshair = 0,
        crosshairType = "Cross",
        crosshairSize = 10,
        crosshairColor = Color3.fromRGB(255, 255, 255),
        part = "Head",
        smooth = 0.5,
        teamCheck = 0,
        mode = "Nearest",
        target = nil,
        behind = 0
    },
    alert = {
        enabled = 0,
        distance = 20,
        time = 1
    }
}

local characters = {}
local overlays = {}
local fieldOfViewCircle = Drawing.new("Circle")
local selectionCircle = Drawing.new("Circle")
local crosshair = {cross = {}, dot = {}, circle = {}, square = {}, tShape = {}, xCross = {}}

fieldOfViewCircle.Thickness = 2
fieldOfViewCircle.NumSides = 100
fieldOfViewCircle.Filled = false
selectionCircle.Thickness = 3
selectionCircle.NumSides = 50
selectionCircle.Filled = false

for index = 1, 4 do
    crosshair.cross[index] = Drawing.new("Line")
    crosshair.cross[index].Thickness = 2
    crosshair.square[index] = Drawing.new("Line")
    crosshair.square[index].Thickness = 2
end

for index = 1, 3 do
    crosshair.tShape[index] = Drawing.new("Line")
    crosshair.tShape[index].Thickness = 2
end

for index = 1, 2 do
    crosshair.xCross[index] = Drawing.new("Line")
    crosshair.xCross[index].Thickness = 3
end

crosshair.dot[1] = Drawing.new("Circle")
crosshair.dot[1].Radius = 2
crosshair.dot[1].Filled = true

crosshair.circle[1] = Drawing.new("Circle")
crosshair.circle[1].Radius = 8
crosshair.circle[1].Thickness = 2

local function isOnSameTeam(player)
    return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
end

local function getTeamColor(player)
    return player.Team and player.Team.TeamColor.Color or configurations.esp.color
end

local function getPlayerNames()
    local names = {}
    for _, player in PlayersService:GetPlayers() do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local function isBehind(position)
    return configurations.aim.behind == 1 and CurrentCamera.CFrame.LookVector:Dot((position - CurrentCamera.CFrame.Position).Unit) < 0
end

local function isNpc(model)
    if not model:IsA("Model") then
        return 0
    end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    if humanoid and rootPart and humanoid.Health > 0 then
        for _, player in PlayersService:GetPlayers() do
            if player.Character == model then
                return 0
            end
        end
        return 1
    end
    return 0
end

local window = RayfieldLibrary:CreateWindow({Name = "💎 Red V3", Theme = "Amethyst"})

local espTab = window:CreateTab("🎯 ESP")
espTab:CreateToggle({Name = "Enable", Callback = function(value) configurations.esp.enabled = value and 1 or 0 end})
espTab:CreateToggle({Name = "NPCs", CurrentValue = true, Callback = function(value) configurations.esp.npc = value and 1 or 0 end})
espTab:CreateToggle({Name = "Skeleton", Callback = function(value) configurations.esp.skeleton = value and 1 or 0 end})
espTab:CreateToggle({Name = "Chams", Callback = function(value) configurations.esp.chams = value and 1 or 0 end})
espTab:CreateToggle({Name = "Head", Callback = function(value) configurations.esp.head = value and 1 or 0 end})
espTab:CreateToggle({Name = "Look", Callback = function(value) configurations.esp.look = value and 1 or 0 end})
espTab:CreateToggle({Name = "Weapon", Callback = function(value) configurations.esp.gun = value and 1 or 0 end})
espTab:CreateToggle({Name = "Tracers", CurrentValue = true, Callback = function(value) configurations.esp.snaplines = value and 1 or 0 end})
espTab:CreateToggle({Name = "Rainbow", Callback = function(value) configurations.esp.rainbow = value and 1 or 0 end})
espTab:CreateDropdown({Name = "Style", Options = {"Corner", "Full"}, CurrentOption = "Corner", Callback = function(value) configurations.esp.style = value end})

local aimTab = window:CreateTab("🎮 Aim")
aimTab:CreateToggle({Name = "Enable", Callback = function(value) configurations.aim.enabled = value and 1 or 0 end})
aimTab:CreateToggle({Name = "FOV", Callback = function(value) configurations.aim.showFieldOfView = value and 1 or 0; fieldOfViewCircle.Visible = value end})
aimTab:CreateToggle({Name = "Crosshair", Callback = function(value) configurations.aim.crosshair = value and 1 or 0 end})
aimTab:CreateDropdown({Name = "Type", Options = {"Cross", "Dot", "Circle", "Square", "T", "X", "Dot+Circle", "Cross+Dot", "All"}, CurrentOption = "Cross", Callback = function(value) configurations.aim.crosshairType = value end})
aimTab:CreateSlider({Name = "Size", Range = {5, 30}, Increment = 1, CurrentValue = 10, Callback = function(value) configurations.aim.crosshairSize = value end})
local modeDropdown = aimTab:CreateDropdown({Name = "Mode", Options = {"Nearest", "Selected", "NPCs"}, CurrentOption = "Nearest", Callback = function(value) configurations.aim.mode = value; if value ~= "Selected" then configurations.aim.target = nil; selectionCircle.Visible = false end end})
local playerDropdown = aimTab:CreateDropdown({Name = "Player", Options = getPlayerNames(), Callback = function(value) local targetPlayer = PlayersService:FindFirstChild(value); if targetPlayer then configurations.aim.target = targetPlayer; configurations.aim.mode = "Selected"; modeDropdown:Set("Selected") end end})
aimTab:CreateButton({Name = "🔄", Callback = function() playerDropdown:Refresh(getPlayerNames()) end})
aimTab:CreateButton({Name = "❌", Callback = function() configurations.aim.target = nil; selectionCircle.Visible = false; configurations.aim.mode = "Nearest"; modeDropdown:Set("Nearest") end})
aimTab:CreateSlider({Name = "FOV", Range = {10, 100}, Increment = 1, CurrentValue = 30, Callback = function(value) configurations.aim.fieldOfView = value end})
aimTab:CreateSlider({Name = "Smooth", Range = {0, 1}, Increment = 0.01, CurrentValue = 0.5, Callback = function(value) configurations.aim.smooth = value end})

local alertTab = window:CreateTab("⚠️")
alertTab:CreateToggle({Name = "Alert", Callback = function(value) configurations.alert.enabled = value and 1 or 0 end})
alertTab:CreateSlider({Name = "Dist", Range = {5, 50}, Increment = 1, CurrentValue = 20, Callback = function(value) configurations.alert.distance = value end})

local function makeOverlay(target, npcFlag)
    if npcFlag == 0 and target == LocalPlayer then
        return
    end
    local entry = {npc = npcFlag}
    for _, part in {"TopLeft", "TopRight", "BottomLeft", "BottomRight", "Top", "Bottom", "Left", "Right"} do
        entry[part] = Drawing.new("Line")
        entry[part].Thickness = 2
    end
    entry.healthBar = Drawing.new("Square")
    entry.healthBarBackground = Drawing.new("Square")
    entry.healthBarBackground.Filled = true
    entry.healthBarBackground.Color = Color3.new(0.1, 0.1, 0.1)
    entry.healthBarBackground.Transparency = 0.5
    entry.healthBar.Filled = true
    for _, textType in {"name", "distance", "healthPoints", "gun"} do
        entry[textType] = Drawing.new("Text")
        entry[textType].Center = true
        entry[textType].Outline = true
        entry[textType].Size = 15
    end
    entry.healthPoints.Center = false
    entry.snapline = Drawing.new("Line")
    entry.snapline.Thickness = 2
    entry.skeleton = {}
    for index = 1, 10 do
        entry.skeleton[index] = Drawing.new("Line")
        entry.skeleton[index].Thickness = 2
    end
    entry.head = Drawing.new("Circle")
    entry.head.Filled = true
    entry.head.NumSides = 20
    entry.look = Drawing.new("Line")
    entry.look.Thickness = 3
    if npcFlag == 0 then
        entry.highlight = Instance.new("Highlight")
        entry.highlight.Enabled = false
    end
    overlays[target] = entry
end

local function updateOverlay(target, entry)
    local character = entry.npc == 1 and target or target.Character
    if configurations.esp.enabled == 0 or not character or (entry.npc == 1 and configurations.esp.npc == 0) or (entry.npc == 0 and configurations.esp.teamCheck == 1 and isOnSameTeam(target)) then
        for _, object in pairs(entry) do
            if typeof(object) == "table" then
                for _, sub in pairs(object) do
                    sub.Visible = false
                end
            elseif typeof(object) ~= "boolean" and object ~= entry.highlight then
                object.Visible = false
            end
        end
        if entry.highlight then
            entry.highlight.Enabled = false
        end
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    local head = character:FindFirstChild("Head")
    if not humanoid or humanoid.Health <= 0 or not rootPart or not head then
        for _, object in pairs(entry) do
            if typeof(object) == "table" then
                for _, sub in pairs(object) do
                    sub.Visible = false
                end
            elseif typeof(object) ~= "boolean" and object ~= entry.highlight then
                object.Visible = false
            end
        end
        if entry.highlight then
            entry.highlight.Enabled = false
        end
        return
    end
    local topPosition = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
    local bottomPosition = rootPart.Position - Vector3.new(0, rootPart.Size.Y / 2 + 2, 0)
    local topScreen, topVisible = CurrentCamera:WorldToViewportPoint(topPosition)
    local bottomScreen, bottomVisible = CurrentCamera:WorldToViewportPoint(bottomPosition)
    local rootScreen, rootVisible = CurrentCamera:WorldToViewportPoint(rootPart.Position)
    if not topVisible and not bottomVisible and not rootVisible then
        for _, object in pairs(entry) do
            if typeof(object) == "table" then
                for _, sub in pairs(object) do
                    sub.Visible = false
                end
            elseif typeof(object) ~= "boolean" and object ~= entry.highlight then
                object.Visible = false
            end
        end
        if entry.highlight then
            entry.highlight.Enabled = false
        end
        return
    end
    local distance = (rootPart.Position - CurrentCamera.CFrame.Position).Magnitude
    local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
    local boxWidth = boxHeight * 0.55
    local boxX = rootScreen.X - boxWidth / 2
    local boxY = topScreen.Y
    local cornerRadius = math.min(boxWidth * 0.15, boxHeight * 0.08)
    local alpha = configurations.esp.fade == 1 and math.clamp(1 - (distance / configurations.aim.maximumDistance), 0.3, 1) or 1
    local color = entry.npc == 1 and Color3.fromRGB(255, 100, 50) or (configurations.esp.rainbow == 1 and Color3.fromHSV((tick() * 0.5) % 1, 1, 1) or getTeamColor(target))
    if entry.npc == 0 and target == configurations.aim.target then
        color = Color3.fromRGB(255, 0, 255)
    end
    if configurations.esp.style == "Corner" then
        entry.TopLeft.From = Vector2.new(boxX + cornerRadius, boxY)
        entry.TopLeft.To = Vector2.new(boxX, boxY + cornerRadius)
        entry.TopRight.From = Vector2.new(boxX + boxWidth - cornerRadius, boxY)
        entry.TopRight.To = Vector2.new(boxX + boxWidth, boxY + cornerRadius)
        entry.BottomLeft.From = Vector2.new(boxX, boxY + boxHeight - cornerRadius)
        entry.BottomLeft.To = Vector2.new(boxX + cornerRadius, boxY + boxHeight)
        entry.BottomRight.From = Vector2.new(boxX + boxWidth - cornerRadius, boxY + boxHeight)
        entry.BottomRight.To = Vector2.new(boxX + boxWidth, boxY + boxHeight - cornerRadius)
        entry.Top.From = Vector2.new(boxX + cornerRadius, boxY)
        entry.Top.To = Vector2.new(boxX + boxWidth - cornerRadius, boxY)
        entry.Bottom.From = Vector2.new(boxX + cornerRadius, boxY + boxHeight)
        entry.Bottom.To = Vector2.new(boxX + boxWidth - cornerRadius, boxY + boxHeight)
        entry.Left.From = Vector2.new(boxX, boxY + cornerRadius)
        entry.Left.To = Vector2.new(boxX, boxY + boxHeight - cornerRadius)
        entry.Right.From = Vector2.new(boxX + boxWidth, boxY + cornerRadius)
        entry.Right.To = Vector2.new(boxX + boxWidth, boxY + boxHeight - cornerRadius)
        for _, part in {"TopLeft", "TopRight", "BottomLeft", "BottomRight", "Top", "Bottom", "Left", "Right"} do
            entry[part].Color = color
            entry[part].Transparency = alpha
            entry[part].Visible = true
        end
    else
        entry.Top.From = Vector2.new(boxX, boxY)
        entry.Top.To = Vector2.new(boxX + boxWidth, boxY)
        entry.Bottom.From = Vector2.new(boxX, boxY + boxHeight)
        entry.Bottom.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
        entry.Left.From = Vector2.new(boxX, boxY)
        entry.Left.To = Vector2.new(boxX, boxY + boxHeight)
        entry.Right.From = Vector2.new(boxX + boxWidth, boxY)
        entry.Right.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
        for _, part in {"Top", "Bottom", "Left", "Right"} do
            entry[part].Color = color
            entry[part].Transparency = alpha
            entry[part].Visible = true
        end
        for _, part in {"TopLeft", "TopRight", "BottomLeft", "BottomRight"} do
            entry[part].Visible = false
        end
    end
    if configurations.esp.skeleton == 1 then
        local bones = {
            {character:FindFirstChild("Head"), character:FindFirstChild("UpperTorso") or rootPart},
            {character:FindFirstChild("UpperTorso") or rootPart, character:FindFirstChild("LeftUpperArm")},
            {character:FindFirstChild("UpperTorso") or rootPart, character:FindFirstChild("RightUpperArm")},
            {character:FindFirstChild("LeftUpperArm"), character:FindFirstChild("LeftHand")},
            {character:FindFirstChild("RightUpperArm"), character:FindFirstChild("RightHand")},
            {character:FindFirstChild("LowerTorso") or rootPart, character:FindFirstChild("LeftUpperLeg")},
            {character:FindFirstChild("LowerTorso") or rootPart, character:FindFirstChild("RightUpperLeg")},
            {character:FindFirstChild("LeftUpperLeg"), character:FindFirstChild("LeftFoot")},
            {character:FindFirstChild("RightUpperLeg"), character:FindFirstChild("RightFoot")},
            {character:FindFirstChild("UpperTorso") or rootPart, character:FindFirstChild("LowerTorso") or rootPart}
        }
        for index, bone in pairs(bones) do
            if bone[1] and bone[2] then
                local position1, visible1 = CurrentCamera:WorldToViewportPoint(bone[1].Position)
                local position2, visible2 = CurrentCamera:WorldToViewportPoint(bone[2].Position)
                if visible1 or visible2 then
                    entry.skeleton[index].From = Vector2.new(position1.X, position1.Y)
                    entry.skeleton[index].To = Vector2.new(position2.X, position2.Y)
                    entry.skeleton[index].Color = color
                    entry.skeleton[index].Transparency = alpha
                    entry.skeleton[index].Visible = true
                else
                    entry.skeleton[index].Visible = false
                end
            else
                entry.skeleton[index].Visible = false
            end
        end
    else
        for _, skeletonLine in pairs(entry.skeleton) do
            skeletonLine.Visible = false
        end
    end
    if configurations.esp.head == 1 then
        local headPosition, headVisible = CurrentCamera:WorldToViewportPoint(head.Position)
        if headVisible then
            entry.head.Position = Vector2.new(headPosition.X, headPosition.Y)
            entry.head.Radius = 3
            entry.head.Color = Color3.fromRGB(255, 0, 0)
            entry.head.Transparency = alpha
            entry.head.Visible = true
        else
            entry.head.Visible = false
        end
    else
        entry.head.Visible = false
    end
    if configurations.esp.look == 1 then
        local lookEnd = head.Position + head.CFrame.LookVector * 50
        local lookScreen, lookVisible = CurrentCamera:WorldToViewportPoint(lookEnd)
        local headScreen, headVisible2 = CurrentCamera:WorldToViewportPoint(head.Position)
        if headVisible2 and lookVisible then
            entry.look.From = Vector2.new(headScreen.X, headScreen.Y)
            entry.look.To = Vector2.new(lookScreen.X, lookScreen.Y)
            entry.look.Color = Color3.fromRGB(255, 255, 0)
            entry.look.Transparency = alpha
            entry.look.Visible = true
        else
            entry.look.Visible = false
        end
    else
        entry.look.Visible = false
    end
    if entry.highlight and configurations.esp.chams == 1 then
        entry.highlight.Parent = character
        entry.highlight.Enabled = true
        entry.highlight.FillColor = color
        entry.highlight.OutlineColor = color
        entry.highlight.FillTransparency = 0.5 * (1 - alpha)
    elseif entry.highlight then
        entry.highlight.Enabled = false
    end
    local healthPercentage = humanoid.Health / humanoid.MaxHealth
    local healthWidth = 4
    local healthX = boxX - 10
    entry.healthBarBackground.Size = Vector2.new(healthWidth, boxHeight)
    entry.healthBarBackground.Position = Vector2.new(healthX, boxY)
    entry.healthBarBackground.Transparency = alpha
    entry.healthBarBackground.Visible = configurations.esp.healthPoints == 1
    local healthHeight = boxHeight * healthPercentage
    entry.healthBar.Size = Vector2.new(healthWidth, healthHeight)
    entry.healthBar.Position = Vector2.new(healthX, boxY + (boxHeight - healthHeight))
    entry.healthBar.Color = healthPercentage > 0.6 and Color3.fromRGB(0, 255, 0) or (healthPercentage > 0.3 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
    entry.healthBar.Transparency = alpha
    entry.healthBar.Visible = configurations.esp.healthPoints == 1
    entry.healthPoints.Text = string.format("%d", math.floor(humanoid.Health))
    entry.healthPoints.Position = Vector2.new(healthX - 2, boxY + boxHeight + 2)
    entry.healthPoints.Color = entry.healthBar.Color
    entry.healthPoints.Transparency = alpha
    entry.healthPoints.Visible = configurations.esp.healthPoints == 1
    local name = entry.npc == 1 and (character.Name .. " [NPC]") or target.Name
    entry.name.Text = name
    entry.name.Position = Vector2.new(rootScreen.X, boxY - 18)
    entry.name.Color = color
    entry.name.Transparency = alpha
    entry.name.Visible = true
    entry.distance.Text = string.format("%dm", math.floor(distance))
    entry.distance.Position = Vector2.new(rootScreen.X, boxY + boxHeight + 5)
    entry.distance.Transparency = alpha
    entry.distance.Visible = configurations.esp.distance == 1
    if configurations.esp.gun == 1 and entry.npc == 0 then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            entry.gun.Text = "🔫 " .. tool.Name
            entry.gun.Position = Vector2.new(rootScreen.X, boxY + boxHeight + 22)
            entry.gun.Color = Color3.fromRGB(255, 200, 0)
            entry.gun.Transparency = alpha
            entry.gun.Visible = true
        else
            entry.gun.Visible = false
        end
    else
        entry.gun.Visible = false
    end
    if configurations.esp.snaplines == 1 then
        local screenY = CurrentCamera.ViewportSize.Y / 2
        entry.snapline.From = Vector2.new(rootScreen.X, boxY + boxHeight)
        entry.snapline.To = Vector2.new(CurrentCamera.ViewportSize.X / 2, screenY)
        entry.snapline.Color = configurations.esp.gradient == 1 and Color3.fromHSV((distance / configurations.aim.maximumDistance) * 0.3, 1, 1) or color
        entry.snapline.Transparency = configurations.esp.animation == 1 and math.abs(math.sin(tick() * 2)) * alpha or alpha
        entry.snapline.Visible = true
    else
        entry.snapline.Visible = false
    end
end

local function getTarget()
    local closest = nil
    local minDistance = math.huge
    if configurations.aim.mode == "Selected" and configurations.aim.target then
        local player = configurations.aim.target
        if player.Character and player.Character:FindFirstChild(configurations.aim.part) then
            local part = player.Character[configurations.aim.part]
            if not isBehind(part.Position) then
                local direction = (part.Position - CurrentCamera.CFrame.Position).Unit
                local angle = math.deg(math.acos(math.clamp(direction:Dot(CurrentCamera.CFrame.LookVector), -1, 1)))
                local distance = (CurrentCamera.CFrame.Position - part.Position).Magnitude
                if angle <= configurations.aim.fieldOfView / 2 and distance <= configurations.aim.maximumDistance then
                    return player.Character
                end
            end
        end
    end
    if configurations.aim.mode == "Nearest" then
        for _, player in PlayersService:GetPlayers() do
            if (configurations.aim.teamCheck == 1 and isOnSameTeam(player)) or player == LocalPlayer then
                continue
            end
            if player.Character and player.Character:FindFirstChild(configurations.aim.part) then
                local part = player.Character[configurations.aim.part]
                if not isBehind(part.Position) then
                    local direction = (part.Position - CurrentCamera.CFrame.Position).Unit
                    local angle = math.deg(math.acos(math.clamp(direction:Dot(CurrentCamera.CFrame.LookVector), -1, 1)))
                    if angle <= configurations.aim.fieldOfView / 2 then
                        local distance = (CurrentCamera.CFrame.Position - part.Position).Magnitude
                        if distance <= configurations.aim.maximumDistance and distance < minDistance then
                            closest = player.Character
                            minDistance = distance
                        end
                    end
                end
            end
        end
    end
    if configurations.aim.mode == "NPCs" then
        for _, model in Workspace:GetDescendants() do
            if model:IsA("Model") and isNpc(model) == 1 then
                local part = model:FindFirstChild(configurations.aim.part) or model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
                if part and not isBehind(part.Position) then
                    local direction = (part.Position - CurrentCamera.CFrame.Position).Unit
                    local angle = math.deg(math.acos(math.clamp(direction:Dot(CurrentCamera.CFrame.LookVector), -1, 1)))
                    if angle <= configurations.aim.fieldOfView / 2 then
                        local distance = (CurrentCamera.CFrame.Position - part.Position).Magnitude
                        if distance <= configurations.aim.maximumDistance and distance < minDistance then
                            closest = model
                            minDistance = distance
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function drawCrosshair(centerX, centerY, size, color)
    for _, group in pairs(crosshair) do
        for _, item in pairs(group) do
            item.Visible = false
        end
    end
    local type = configurations.aim.crosshairType
    if type == "Cross" or type == "Cross+Dot" or type == "All" then
        for _, line in pairs(crosshair.cross) do
            line.Color = color
        end
        crosshair.cross[1].From = Vector2.new(centerX, centerY - 5)
        crosshair.cross[1].To = Vector2.new(centerX, centerY - 5 - size)
        crosshair.cross[2].From = Vector2.new(centerX, centerY + 5)
        crosshair.cross[2].To = Vector2.new(centerX, centerY + 5 + size)
        crosshair.cross[3].From = Vector2.new(centerX - 5, centerY)
        crosshair.cross[3].To = Vector2.new(centerX - 5 - size, centerY)
        crosshair.cross[4].From = Vector2.new(centerX + 5, centerY)
        crosshair.cross[4].To = Vector2.new(centerX + 5 + size, centerY)
        for _, line in pairs(crosshair.cross) do
            line.Visible = true
        end
    end
    if type == "Dot" or type == "Dot+Circle" or type == "Cross+Dot" or type == "All" then
        crosshair.dot[1].Position = Vector2.new(centerX, centerY)
        crosshair.dot[1].Color = color
        crosshair.dot[1].Visible = true
    end
    if type == "Circle" or type == "Dot+Circle" or type == "All" then
        crosshair.circle[1].Position = Vector2.new(centerX, centerY)
        crosshair.circle[1].Radius = size * 0.8
        crosshair.circle[1].Color = color
        crosshair.circle[1].Visible = true
    end
    if type == "Square" or type == "All" then
        local squareSize = size * 0.7
        crosshair.square[1].From = Vector2.new(centerX - squareSize, centerY - squareSize)
        crosshair.square[1].To = Vector2.new(centerX + squareSize, centerY - squareSize)
        crosshair.square[2].From = Vector2.new(centerX + squareSize, centerY - squareSize)
        crosshair.square[2].To = Vector2.new(centerX + squareSize, centerY + squareSize)
        crosshair.square[3].From = Vector2.new(centerX + squareSize, centerY + squareSize)
        crosshair.square[3].To = Vector2.new(centerX - squareSize, centerY + squareSize)
        crosshair.square[4].From = Vector2.new(centerX - squareSize, centerY + squareSize)
        crosshair.square[4].To = Vector2.new(centerX - squareSize, centerY - squareSize)
        for _, line in pairs(crosshair.square) do
            line.Color = color
            line.Visible = true
        end
    end
    if type == "T" or type == "All" then
        crosshair.tShape[1].From = Vector2.new(centerX - size, centerY - size)
        crosshair.tShape[1].To = Vector2.new(centerX + size, centerY - size)
        crosshair.tShape[2].From = Vector2.new(centerX, centerY - size)
        crosshair.tShape[2].To = Vector2.new(centerX, centerY + size)
        crosshair.tShape[3].From = Vector2.new(centerX, centerY)
        crosshair.tShape[3].To = Vector2.new(centerX, centerY + size * 1.5)
        for _, line in pairs(crosshair.tShape) do
            line.Color = color
            line.Visible = true
        end
    end
    if type == "X" or type == "All" then
        crosshair.xCross[1].From = Vector2.new(centerX - size, centerY - size)
        crosshair.xCross[1].To = Vector2.new(centerX + size, centerY + size)
        crosshair.xCross[2].From = Vector2.new(centerX + size, centerY - size)
        crosshair.xCross[2].To = Vector2.new(centerX - size, centerY + size)
        for _, line in pairs(crosshair.xCross) do
            line.Color = color
            line.Visible = true
        end
    end
end

local lastCheck = 0
local npcUpdateCounter = 0
RunService.RenderStepped:Connect(function()
    local centerX = CurrentCamera.ViewportSize.X / 2
    local centerY = CurrentCamera.ViewportSize.Y / 2
    if configurations.alert.enabled == 1 and tick() - lastCheck >= configurations.alert.time then
        lastCheck = tick()
        local cameraPosition = CurrentCamera.CFrame.Position
        local lookVector = CurrentCamera.CFrame.LookVector
        for _, player in PlayersService:GetPlayers() do
            if player ~= LocalPlayer and player.Character then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (cameraPosition - rootPart.Position).Magnitude
                    if distance <= configurations.alert.distance and lookVector:Dot((rootPart.Position - cameraPosition).Unit) < -0.3 then
                        if not characters[player.Name] then
                            characters[player.Name] = true
                            RayfieldLibrary:Notify({Title = "⚠️", Content = player.Name .. " Behind!", Duration = 2})
                            task.delay(3, function() characters[player.Name] = nil end)
                        end
                    end
                end
            end
        end
    end
    fieldOfViewCircle.Radius = (configurations.aim.fieldOfView / 2) * (CurrentCamera.ViewportSize.Y / 90)
    fieldOfViewCircle.Position = Vector2.new(centerX, centerY)
    fieldOfViewCircle.Visible = configurations.aim.showFieldOfView == 1
    fieldOfViewCircle.Color = configurations.esp.rainbow == 1 and Color3.fromHSV((tick() * 0.5) % 1, 1, 1) or Color3.fromRGB(138, 43, 226)
    if configurations.aim.crosshair == 1 then
        drawCrosshair(centerX, centerY, configurations.aim.crosshairSize, configurations.aim.crosshairColor)
    else
        for _, group in pairs(crosshair) do
            for _, item in pairs(group) do
                item.Visible = false
            end
        end
    end
    if configurations.aim.target and configurations.aim.target.Character then
        local head = configurations.aim.target.Character:FindFirstChild("Head")
        if head then
            local position, visible = CurrentCamera:WorldToViewportPoint(head.Position)
            if visible then
                selectionCircle.Position = Vector2.new(position.X, position.Y)
                selectionCircle.Radius = math.clamp(1000 / (head.Position - CurrentCamera.CFrame.Position).Magnitude * 0.8, 20, 80)
                selectionCircle.Color = Color3.fromRGB(255, 0, 255)
                selectionCircle.Visible = true
            else
                selectionCircle.Visible = false
            end
        end
    else
        selectionCircle.Visible = false
    end
    for player, entry in pairs(overlays) do
        if entry.npc == 0 then
            updateOverlay(player, entry)
        end
    end
    npcUpdateCounter = npcUpdateCounter + 1
    if npcUpdateCounter >= 30 and configurations.esp.npc == 1 then
        npcUpdateCounter = 0
        for model, entry in pairs(overlays) do
            if entry.npc == 1 then
                if isNpc(model) == 0 then
                    for _, object in pairs(entry) do
                        if typeof(object) == "table" then
                            for _, sub in pairs(object) do
                                pcall(function() sub:Remove() end)
                            end
                        elseif typeof(object) ~= "boolean" and object ~= entry.highlight then
                            pcall(function() object:Remove() end)
                        end
                    end
                    overlays[model] = nil
                else
                    updateOverlay(model, entry)
                end
            end
        end
        for _, model in Workspace:GetDescendants() do
            if model:IsA("Model") and isNpc(model) == 1 and not overlays[model] then
                makeOverlay(model, 1)
            end
        end
    end
    if configurations.aim.enabled == 1 then
        local target = getTarget()
        if target then
            local part = target:FindFirstChild(configurations.aim.part) or target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
            if part then
                local targetPosition = part.Position
                if configurations.aim.smooth > 0 then
                    local smoothed = CurrentCamera.CFrame.LookVector:Lerp((targetPosition - CurrentCamera.CFrame.Position).Unit, 1 - configurations.aim.smooth)
                    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + smoothed)
                else
                    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, targetPosition)
                end
            end
        end
    end
end)

for _, player in PlayersService:GetPlayers() do
    if player ~= LocalPlayer then
        makeOverlay(player, 0)
    end
end
PlayersService.PlayerAdded:Connect(function(player)
    makeOverlay(player, 0)
    task.wait(1)
    playerDropdown:Refresh(getPlayerNames())
end)
PlayersService.PlayerRemoving:Connect(function(player)
    if overlays[player] then
        for _, object in pairs(overlays[player]) do
            pcall(function()
                if typeof(object) ~= "boolean" and object ~= overlays[player].highlight then
                    object:Remove()
                end
            end)
        end
        overlays[player] = nil
    end
    if configurations.aim.target == player then
        configurations.aim.target = nil
        selectionCircle.Visible = false
        configurations.aim.mode = "Nearest"
    end
    playerDropdown:Refresh(getPlayerNames())
end)
RayfieldLibrary:Notify({Title = "💎 Red V3", Content = "Loaded!", Duration = 3})