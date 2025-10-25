-- ZeroGPT Chatbot UI - TikTok Style
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
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

local function addStroke(parent, trans, color)
    return create("UIStroke", {
        Color = color or Color3.fromRGB(255, 255, 255),
        Transparency = trans or 0.9,
        Thickness = 1.5,
        Parent = parent
    })
end

-- Main UI
local ScreenGui = create("ScreenGui", {
    Name = "ZeroGPTUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

-- Main Frame - Dark Modern Style
local MainFrame = create("Frame", {
    Size = UDim2.new(0, 320, 0, 420),
    Position = UDim2.new(0.5, -160, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
addCorner(MainFrame, 18)
addStroke(MainFrame, 0.8, Color3.fromRGB(50, 50, 60))

-- Header với Gradient TikTok style
local Header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    BorderSizePixel = 0,
    Parent = MainFrame
})
addCorner(Header, 18)

local HeaderFix = create("Frame", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 1, -18),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    BorderSizePixel = 0,
    Parent = Header
})

-- Logo & Title
local Logo = create("TextLabel", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 12, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(255, 59, 92),
    Text = "🤖",
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(Logo, 10)

local Title = create("TextLabel", {
    Size = UDim2.new(1, -140, 1, 0),
    Position = UDim2.new(0, 60, 0, 0),
    BackgroundTransparency = 1,
    Text = "zeroGPT",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

local Version = create("TextLabel", {
    Size = UDim2.new(0, 45, 0, 20),
    Position = UDim2.new(0, 128, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(59, 130, 246),
    BackgroundTransparency = 0.2,
    Text = "v2.5",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(Version, 6)

-- Badges
local FlashBadge = create("TextLabel", {
    Size = UDim2.new(0, 42, 0, 20),
    Position = UDim2.new(1, -90, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(168, 85, 247),
    BackgroundTransparency = 0.2,
    Text = "Flash",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(FlashBadge, 6)

local ProBadge = create("TextLabel", {
    Size = UDim2.new(0, 35, 0, 20),
    Position = UDim2.new(1, -44, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(234, 179, 8),
    BackgroundTransparency = 0.2,
    Text = "Pro",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = Header
})
addCorner(ProBadge, 6)

-- Close Button
local CloseButton = create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -8, 0, 8),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundColor3 = Color3.fromRGB(220, 50, 50),
    BackgroundTransparency = 0.3,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = MainFrame
})
addCorner(CloseButton, 8)

-- Chat Container
local ChatContainer = create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -120),
    Position = UDim2.new(0, 10, 0, 60),
    BackgroundColor3 = Color3.fromRGB(18, 18, 23),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Color3.fromRGB(255, 59, 92),
    ScrollBarImageTransparency = 0.6,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = MainFrame
})
addCorner(ChatContainer, 14)
addStroke(ChatContainer, 0.9, Color3.fromRGB(40, 40, 50))

local ChatLayout = create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = ChatContainer
})

create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
    Parent = ChatContainer
})

-- Input Container - TikTok Style
local InputContainer = create("Frame", {
    Size = UDim2.new(1, -20, 0, 50),
    Position = UDim2.new(0, 10, 1, -60),
    BackgroundColor3 = Color3.fromRGB(25, 25, 32),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = MainFrame
})
addCorner(InputContainer, 14)
local InputStroke = addStroke(InputContainer, 0.85, Color3.fromRGB(60, 60, 70))

local InputBox = create("TextBox", {
    Size = UDim2.new(1, -70, 1, -12),
    Position = UDim2.new(0, 12, 0, 6),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Ask me anything...",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    PlaceholderColor3 = Color3.fromRGB(130, 130, 145),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = InputContainer
})

-- Send Button - TikTok Style
local SendButton = create("TextButton", {
    Size = UDim2.new(0, 50, 0, 38),
    Position = UDim2.new(1, -56, 0.5, -19),
    BackgroundColor3 = Color3.fromRGB(255, 59, 92),
    BackgroundTransparency = 0.1,
    Text = "▶",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    Parent = InputContainer
})
addCorner(SendButton, 12)

local SendGradient = create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 59, 92)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 120))
    },
    Rotation = 45,
    Parent = SendButton
})

-- Drag
local dragging, dragStart, startPos = false, nil, nil
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close
CloseButton.MouseButton1Click:Connect(function()
    tween(CloseButton, 0.2, {Rotation = 90, BackgroundTransparency = 0.6})
    tween(MainFrame, 0.4, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back)
    task.wait(0.4)
    ScreenGui:Destroy()
end)

-- Chat
local messageCount = 0

local function createTypingIndicator()
    local typing = create("Frame", {
        Name = "Typing",
        Size = UDim2.new(0.35, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = ChatContainer
    })
    addCorner(typing, 12)
    addStroke(typing, 0.9, Color3.fromRGB(60, 60, 70))
    
    for i = 1, 3 do
        local dot = create("Frame", {
            Size = UDim2.new(0, 9, 0, 9),
            Position = UDim2.new(0, 18 + (i-1) * 18, 0.5, -4.5),
            BackgroundColor3 = Color3.fromRGB(255, 59, 92),
            BorderSizePixel = 0,
            Parent = typing
        })
        addCorner(dot, 100)
        
        task.spawn(function()
            while typing.Parent do
                tween(dot, 0.6, {Position = UDim2.new(0, 18 + (i-1) * 18, 0.5, -9), BackgroundTransparency = 0.3}, Enum.EasingStyle.Sine)
                task.wait(0.2 * i)
                tween(dot, 0.6, {Position = UDim2.new(0, 18 + (i-1) * 18, 0.5, -4.5), BackgroundTransparency = 0}, Enum.EasingStyle.Sine)
                task.wait(0.6)
            end
        end)
    end
    
    return typing
end

local function createChatMessage(text, isUser)
    messageCount = messageCount + 1
    
    local msgFrame = create("Frame", {
        Name = "Msg" .. messageCount,
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = messageCount,
        Parent = ChatContainer
    })
    
    local bubble = create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = isUser and UDim2.new(0.35, 0, 0, 0) or UDim2.new(-0.15, 0, 0, 0),
        BackgroundColor3 = isUser and Color3.fromRGB(255, 59, 92) or Color3.fromRGB(35, 35, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = msgFrame
    })
    addCorner(bubble, 14)
    addStroke(bubble, isUser and 0.7 or 0.9, isUser and Color3.fromRGB(255, 100, 120) or Color3.fromRGB(60, 60, 70))
    
    if isUser then
        local gradient = create("UIGradient", {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 59, 92)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 120))
            },
            Rotation = 45,
            Parent = bubble
        })
    end
    
    local msgText = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, -16),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextTransparency = 1,
        Parent = bubble
    })
    
    local height = math.max(msgText.TextBounds.Y + 16, 40)
    msgFrame.Size = UDim2.new(1, -10, 0, height + 6)
    
    task.wait(0.05)
    ChatContainer.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 20)
    tween(ChatContainer, 0.35, {CanvasPosition = Vector2.new(0, ChatContainer.CanvasSize.Y.Offset)})
    
    local targetPos = isUser and UDim2.new(0.25, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    tween(bubble, 0.45, {Size = UDim2.new(0.75, 0, 0, height), Position = targetPos}, Enum.EasingStyle.Back)
    tween(bubble, 0.35, {BackgroundTransparency = isUser and 0.15 or 0.25})
    tween(msgText, 0.35, {TextTransparency = 0})
    
    return msgFrame
end

-- API
local function sendToAI(message)
    local success, result = pcall(function()
        if not HttpService.HttpEnabled then
            return "❌ Enable HttpService in Game Settings!"
        end
        
        -- Try Lulcat API
        local url = "https://api.popcat.xyz/v2/lulcat?text=" .. HttpService:UrlEncode(message)
        local response = HttpService:GetAsync(url, true)
        local data = HttpService:JSONDecode(response)
        
        if data and not data.error and data.message and data.message.text then
            return data.message.text
        end
        
        -- Backup: SimSimi
        url = "https://api.simsimi.vn/v1/simtalk"
        response = HttpService:PostAsync(url, HttpService:JSONEncode({text = message, lc = "en"}), Enum.HttpContentType.ApplicationJson)
        data = HttpService:JSONDecode(response)
        
        if data and data.success and data.message then
            return data.message
        end
        
        return "🤖 Unable to connect to AI right now"
    end)
    
    return success and result or "❌ Connection error"
end

local function sendMessage()
    local text = InputBox.Text
    if text == "" then return end
    
    -- Pulse animation
    tween(SendButton, 0.12, {Size = UDim2.new(0, 45, 0, 33)})
    task.wait(0.12)
    tween(SendButton, 0.12, {Size = UDim2.new(0, 50, 0, 38)})
    
    createChatMessage(text, true)
    InputBox.Text = ""
    
    local typing = createTypingIndicator()
    typing.LayoutOrder = messageCount + 1
    
    task.spawn(function()
        local response = sendToAI(text)
        
        if typing and typing.Parent then
            tween(typing, 0.25, {BackgroundTransparency = 1})
            task.wait(0.25)
            typing:Destroy()
        end
        
        createChatMessage(response, false)
    end)
end

SendButton.MouseButton1Click:Connect(sendMessage)
InputBox.FocusLost:Connect(function(enter) if enter then sendMessage() end end)

-- Input Focus Effects
InputBox.Focused:Connect(function()
    tween(InputStroke, 0.3, {Transparency = 0.5, Color = Color3.fromRGB(255, 59, 92)})
    tween(InputContainer, 0.3, {BackgroundTransparency = 0.1})
end)

InputBox.FocusLost:Connect(function()
    tween(InputStroke, 0.3, {Transparency = 0.85, Color = Color3.fromRGB(60, 60, 70)})
    tween(InputContainer, 0.3, {BackgroundTransparency = 0.2})
end)

-- Hover Effects
local function addHover(btn, normalTrans, hoverTrans)
    btn.MouseEnter:Connect(function() tween(btn, 0.2, {BackgroundTransparency = hoverTrans}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.2, {BackgroundTransparency = normalTrans}) end)
end

addHover(CloseButton, 0.3, 0.1)
addHover(SendButton, 0.1, 0)

-- Opening Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
tween(MainFrame, 0.5, {Size = UDim2.new(0, 320, 0, 420), BackgroundTransparency = 0.05}, Enum.EasingStyle.Back)

task.wait(0.7)
createChatMessage("👋 Hi! I'm ZeroGPT. Ask me anything!", false)

print("✅ ZeroGPT UI loaded!")