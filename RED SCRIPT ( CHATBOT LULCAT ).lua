-- ZeroGPT Mobile UI - Vertical Style
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utility
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function tween(obj, time, props, style)
    TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad), props):Play()
end

local function addCorner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

-- Main UI
local ScreenGui = create("ScreenGui", {
    Name = "ZeroGPTUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

-- Main Frame - Mobile Vertical
local MainFrame = create("Frame", {
    Size = UDim2.new(0, 340, 0, 600),
    Position = UDim2.new(0.5, -170, 0.5, -300),
    BackgroundColor3 = Color3.fromRGB(10, 10, 15),
    BorderSizePixel = 0,
    Parent = ScreenGui
})
addCorner(MainFrame, 20)

-- Gradient Background
local BGGradient = create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 35))
    },
    Rotation = 135,
    Parent = MainFrame
})

-- Border Glow
local Stroke = create("UIStroke", {
    Color = Color3.fromRGB(138, 43, 226),
    Transparency = 0.6,
    Thickness = 2,
    Parent = MainFrame
})

-- Header
local Header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Logo Circle
local LogoCircle = create("Frame", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0, 10),
    BackgroundColor3 = Color3.fromRGB(138, 43, 226),
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(LogoCircle, 25)

local LogoGradient = create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
    },
    Rotation = 45,
    Parent = LogoCircle
})

local Logo = create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "🤖",
    TextSize = 26,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = LogoCircle
})

-- Title
local Title = create("TextLabel", {
    Size = UDim2.new(0, 150, 0, 30),
    Position = UDim2.new(0, 80, 0, 10),
    BackgroundTransparency = 1,
    Text = "zeroGPT",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

-- Version Badge
local VersionBadge = create("Frame", {
    Size = UDim2.new(0, 50, 0, 22),
    Position = UDim2.new(0, 80, 0, 38),
    BackgroundColor3 = Color3.fromRGB(59, 130, 246),
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(VersionBadge, 11)

create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "v2.5",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    Parent = VersionBadge
})

-- Status Badges
local FlashBadge = create("Frame", {
    Size = UDim2.new(0, 55, 0, 22),
    Position = UDim2.new(1, -125, 0, 24),
    BackgroundColor3 = Color3.fromRGB(168, 85, 247),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(FlashBadge, 11)

create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "⚡ Flash",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    Parent = FlashBadge
})

local ProBadge = create("Frame", {
    Size = UDim2.new(0, 50, 0, 22),
    Position = UDim2.new(1, -65, 0, 24),
    BackgroundColor3 = Color3.fromRGB(234, 179, 8),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(ProBadge, 11)

create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "👑 Pro",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    Parent = ProBadge
})

-- Close Button
local CloseButton = create("TextButton", {
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -45, 0, 17.5),
    BackgroundColor3 = Color3.fromRGB(239, 68, 68),
    BackgroundTransparency = 0.2,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(CloseButton, 17.5)

-- Separator Line
local Separator = create("Frame", {
    Size = UDim2.new(1, -40, 0, 1),
    Position = UDim2.new(0, 20, 0, 75),
    BackgroundColor3 = Color3.fromRGB(138, 43, 226),
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0,
    Parent = MainFrame
})

-- Chat Container
local ChatContainer = create("ScrollingFrame", {
    Size = UDim2.new(1, -30, 1, -170),
    Position = UDim2.new(0, 15, 0, 85),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247),
    ScrollBarImageTransparency = 0.5,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = MainFrame
})

local ChatLayout = create("UIListLayout", {
    Padding = UDim.new(0, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = ChatContainer
})

create("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    Parent = ChatContainer
})

-- Input Container
local InputContainer = create("Frame", {
    Size = UDim2.new(1, -30, 0, 70),
    Position = UDim2.new(0, 15, 1, -80),
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Parent = MainFrame
})
addCorner(InputContainer, 16)

local InputStroke = create("UIStroke", {
    Color = Color3.fromRGB(138, 43, 226),
    Transparency = 0.7,
    Thickness = 1.5,
    Parent = InputContainer
})

-- Input Box
local InputBox = create("TextBox", {
    Size = UDim2.new(1, -80, 1, -20),
    Position = UDim2.new(0, 15, 0, 10),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Ask me anything...",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    ClearTextOnFocus = false,
    Parent = InputContainer
})

-- Send Button
local SendButton = create("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(1, -60, 0.5, -25),
    BackgroundColor3 = Color3.fromRGB(138, 43, 226),
    Text = "➤",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = InputContainer
})
addCorner(SendButton, 25)

local SendGradient = create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
    },
    Rotation = 45,
    Parent = SendButton
})

-- Drag
local dragging, dragStart, startPos = false, nil, nil
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Close
CloseButton.MouseButton1Click:Connect(function()
    tween(MainFrame, 0.4, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, Enum.EasingStyle.Back)
    task.wait(0.4)
    ScreenGui:Destroy()
end)

-- Chat Functions
local messageCount = 0

local function createTypingIndicator()
    local typing = create("Frame", {
        Name = "Typing",
        Size = UDim2.new(0.3, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(30, 30, 45),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = ChatContainer
    })
    addCorner(typing, 14)
    
    for i = 1, 3 do
        local dot = create("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0, 20 + (i-1) * 20, 0.5, -5),
            BackgroundColor3 = Color3.fromRGB(168, 85, 247),
            BorderSizePixel = 0,
            Parent = typing
        })
        addCorner(dot, 5)
        
        task.spawn(function()
            while typing.Parent do
                tween(dot, 0.5, {Position = UDim2.new(0, 20 + (i-1) * 20, 0.5, -10), BackgroundTransparency = 0.3}, Enum.EasingStyle.Sine)
                task.wait(0.15 * i)
                tween(dot, 0.5, {Position = UDim2.new(0, 20 + (i-1) * 20, 0.5, -5), BackgroundTransparency = 0}, Enum.EasingStyle.Sine)
                task.wait(0.5)
            end
        end)
    end
    
    return typing
end

local function createChatMessage(text, isUser)
    messageCount = messageCount + 1
    
    local msgFrame = create("Frame", {
        Name = "Msg" .. messageCount,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = messageCount,
        Parent = ChatContainer
    })
    
    local bubble = create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = isUser and UDim2.new(1, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
        AnchorPoint = isUser and Vector2.new(1, 0) or Vector2.new(0, 0),
        BackgroundColor3 = isUser and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = msgFrame
    })
    addCorner(bubble, 16)
    
    if isUser then
        local gradient = create("UIGradient", {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
            },
            Rotation = 45,
            Parent = bubble
        })
    end
    
    local msgText = create("TextLabel", {
        Size = UDim2.new(1, -24, 1, -20),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = isUser and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextTransparency = 1,
        Parent = bubble
    })
    
    local height = math.max(msgText.TextBounds.Y + 20, 50)
    local width = math.min(msgText.TextBounds.X + 24, 240)
    
    msgFrame.Size = UDim2.new(1, 0, 0, height + 8)
    
    task.wait(0.05)
    ChatContainer.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 20)
    tween(ChatContainer, 0.3, {CanvasPosition = Vector2.new(0, ChatContainer.CanvasSize.Y.Offset)})
    
    tween(bubble, 0.4, {Size = UDim2.new(0, width, 0, height), BackgroundTransparency = 0.2}, Enum.EasingStyle.Back)
    tween(msgText, 0.3, {TextTransparency = 0})
    
    return msgFrame
end

-- API
local function sendToAI(message)
    local success, result = pcall(function()
        if not HttpService.HttpEnabled then
            return "❌ Enable HttpService in Settings!"
        end
        
        local url = "https://api.popcat.xyz/v2/lulcat?text=" .. HttpService:UrlEncode(message)
        local response = HttpService:GetAsync(url, true)
        local data = HttpService:JSONDecode(response)
        
        if data and not data.error and data.message and data.message.text then
            return data.message.text
        end
        
        url = "https://api.simsimi.vn/v1/simtalk"
        response = HttpService:PostAsync(url, HttpService:JSONEncode({text = message, lc = "en"}), Enum.HttpContentType.ApplicationJson)
        data = HttpService:JSONDecode(response)
        
        if data and data.success and data.message then
            return data.message
        end
        
        return "🤖 Can't connect right now"
    end)
    
    return success and result or "❌ Connection error"
end

local function sendMessage()
    local text = InputBox.Text
    if text == "" then return end
    
    tween(SendButton, 0.1, {Size = UDim2.new(0, 45, 0, 45)})
    task.wait(0.1)
    tween(SendButton, 0.1, {Size = UDim2.new(0, 50, 0, 50)})
    
    createChatMessage(text, true)
    InputBox.Text = ""
    
    local typing = createTypingIndicator()
    typing.LayoutOrder = messageCount + 1
    
    task.spawn(function()
        local response = sendToAI(text)
        
        if typing and typing.Parent then
            tween(typing, 0.2, {BackgroundTransparency = 1})
            task.wait(0.2)
            typing:Destroy()
        end
        
        createChatMessage(response, false)
    end)
end

SendButton.MouseButton1Click:Connect(sendMessage)
InputBox.FocusLost:Connect(function(enter) if enter then sendMessage() end end)

InputBox.Focused:Connect(function()
    tween(InputStroke, 0.3, {Transparency = 0.3, Thickness = 2})
end)

InputBox.FocusLost:Connect(function()
    tween(InputStroke, 0.3, {Transparency = 0.7, Thickness = 1.5})
end)

-- Hover
local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function() tween(btn, 0.2, {BackgroundTransparency = hover}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.2, {BackgroundTransparency = normal}) end)
end

addHover(CloseButton, 0.2, 0)
addHover(SendButton, 0, 0.1)

-- Opening
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
tween(MainFrame, 0.5, {Size = UDim2.new(0, 340, 0, 600), Position = UDim2.new(0.5, -170, 0.5, -300)}, Enum.EasingStyle.Back)

task.wait(0.7)
createChatMessage("👋 Hi! I'm ZeroGPT. How can I help you today?", false)

print("✅ ZeroGPT Mobile UI loaded!")