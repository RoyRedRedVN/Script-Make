local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Untitled Sans Battle",
   LoadingTitle = "Untitled Sans Battle Script",
   LoadingSubtitle = "DEV: REDMOB",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "UntitledSansBattle"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled Key System",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Main")

getgenv().SoulsCollected = 0

local SoulsLabel = MainTab:CreateLabel("Souls Collected: 0")

local AutofarmToggle = MainTab:CreateToggle({
   Name = "AutoFarm",
   CurrentValue = false,
   Flag = "AutofarmToggle",
   Callback = function(Value)
      getgenv().AutofarmToggle = Value
      if Value then
         getgenv().SoulsCollected = 0
         SoulsLabel:Set("Souls Collected: 0")
      end
      while getgenv().AutofarmToggle do 
         wait()
         pcall(function()
            for i, v in ipairs(game.Workspace.SoulsStorage:GetDescendants()) do
               if v.Name == "Soul" and v.Parent:IsA("Model") then
                  firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                  firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                  getgenv().SoulsCollected = getgenv().SoulsCollected + 1
                  SoulsLabel:Set("Souls Collected: " .. getgenv().SoulsCollected)
               end
            end
         end)
      end
   end,
})

local GodmodeToggle = MainTab:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Flag = "GodmodeToggle",
   Callback = function(Value)
      getgenv().GodmodeToggle = Value
      while getgenv().GodmodeToggle do 
         task.wait()
         pcall(function()
            for i, creator in ipairs(game.Workspace:GetDescendants()) do
               if creator:IsA("Model") and creator:FindFirstChild("Creator") and creator:FindFirstChild("Creator").Value ~= game.Players.LocalPlayer.Name then
                  for i, v in ipairs(creator:GetDescendants()) do
                     if v:IsA("TouchTransmitter") then
                        v.Parent.CanTouch = false
                     end
                  end
               end
            end
         end)
      end
   end,
})

local BadgeSection = MainTab:CreateSection("Badges")

getgenv().BadgeGiver = "None"

local BadgeDropdown = MainTab:CreateDropdown({
   Name = "Select Badge",
   Options = {"Hamburger Sans", "Gaster", "Super Sans", "Dust Dust"},
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "BadgeDropdown",
   Callback = function(Option)
      getgenv().BadgeGiver = Option[1]
   end,
})

local GetBadgeButton = MainTab:CreateButton({
   Name = "Get Badge",
   Callback = function()
      if getgenv().BadgeGiver == "Hamburger Sans" then 
         firetouchinterest(game.Workspace.Locations.Snowdin["Grillby's"].Model.SnowBurg.Burger, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
         firetouchinterest(game.Workspace.Locations.Snowdin["Grillby's"].Model.SnowBurg.Burger, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
         
      elseif getgenv().BadgeGiver == "Gaster" then 
         firetouchinterest(game.Workspace:FindFirstChild("Secrets/Badges").Gaster_Badge.Model.GasterChest, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
         firetouchinterest(game.Workspace:FindFirstChild("Secrets/Badges").Gaster_Badge.Model.GasterChest, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
         game.Players.LocalPlayer.Character.Humanoid.Health = 0
         game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 0
         
      elseif getgenv().BadgeGiver == "Super Sans" then 
         firetouchinterest(game.Workspace.Locations.Snowdin.SuperSansBadge, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
         firetouchinterest(game.Workspace.Locations.Snowdin.SuperSansBadge, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
         
      elseif getgenv().BadgeGiver == "Dust Dust" then 
         game:GetService("ReplicatedStorage").ShopPurchases.DustDustBought:FireServer()
      end
      
      Rayfield:Notify({
         Title = "Badge System",
         Content = "Attempted to get " .. getgenv().BadgeGiver .. " badge!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

Rayfield:LoadConfiguration()