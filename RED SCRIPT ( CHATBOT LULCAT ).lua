-- Custom Lulcat Chatbot UI - COMPACT VERSION
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LulcatChatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Nhỏ hơn)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header (Nhỏ hơn)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title (Nhỏ hơn)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐱 Lulcat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- History Button (Nhỏ hơn)
local HistoryButton = Instance.new("TextButton")
HistoryButton.Size = UDim2.new(0, 26, 0, 26)
HistoryButton.Position = UDim2.new(1, -60, 0.5, -13)
HistoryButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HistoryButton.BackgroundTransparency = 0.2
HistoryButton.Text = "📜"
HistoryButton.TextSize = 13
HistoryButton.Font = Enum.Font.GothamBold
HistoryButton.BorderSizePixel = 0
HistoryButton.Parent = Header

local HistoryCorner = Instance.new("UICorner")
HistoryCorner.CornerRadius = UDim.new(0, 6)
HistoryCorner.Parent = HistoryButton

-- Close Button (Nhỏ hơn)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -30, 0.5, -13)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 15
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Chat Container (Nhỏ hơn)
local ChatContainer = Instance.new("ScrollingFrame")
ChatContainer.Name = "ChatContainer"
ChatContainer.Size = UDim2.new(1, -16, 1, -90)
ChatContainer.Position = UDim2.new(0, 8, 0, 43)
ChatContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
ChatContainer.BorderSizePixel = 0
ChatContainer.ScrollBarThickness = 4
ChatContainer.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
ChatContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatContainer.Parent = MainFrame

local ChatCorner = Instance.new("UICorner")
ChatCorner.CornerRadius = UDim.new(0, 8)
ChatCorner.Parent = ChatContainer

-- UIListLayout cho messages
local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Padding = UDim.new(0, 6)
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ChatLayout.Parent = ChatContainer

local ChatPadding = Instance.new("UIPadding")
ChatPadding.PaddingTop = UDim.new(0, 8)
ChatPadding.PaddingBottom = UDim.new(0, 8)
ChatPadding.PaddingLeft = UDim.new(0, 8)
ChatPadding.PaddingRight = UDim.new(0, 8)
ChatPadding.Parent = ChatContainer

-- Input Container (Nhỏ hơn)
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, -16, 0, 42)
InputContainer.Position = UDim2.new(0, 8, 1, -50)
InputContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
InputContainer.BorderSizePixel = 0
InputContainer.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputContainer

-- TextBox (Nhỏ hơn)
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -55, 1, -10)
InputBox.Position = UDim2.new(0, 8, 0, 5)
InputBox.BackgroundTransparency = 1
InputBox.Text = ""
InputBox.PlaceholderText = "Nhập tin nhắn..."
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
InputBox.TextSize = 13
InputBox.Font = Enum.Font.Gotham
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputContainer

-- Send Button (Nhỏ hơn)
local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 42, 0, 32)
SendButton.Position = UDim2.new(1, -47, 0.5, -16)
SendButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
SendButton.Text = "▶"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 15
SendButton.Font = Enum.Font.GothamBold
SendButton.BorderSizePixel = 0
SendButton.Parent = InputContainer

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 8)
SendCorner.Parent = SendButton

-- Drag functionality
local dragging = false
local dragInput, mousePos, framePos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Chat History Data
local messageCount = 0
local chatHistoryData = {}

-- Function to create chat message (Nhỏ hơn)
function createChatMessage(text, isUser)
    messageCount = messageCount + 1
    
    table.insert(chatHistoryData, {
        text = text,
        isUser = isUser,
        timestamp = os.date("%H:%M")
    })
    
    local MessageFrame = Instance.new("Frame")
    MessageFrame.Name = "Message" .. messageCount
    MessageFrame.Size = UDim2.new(1, -8, 0, 0)
    MessageFrame.BackgroundTransparency = 1
    MessageFrame.LayoutOrder = messageCount
    MessageFrame.Parent = ChatContainer
    
    local Bubble = Instance.new("Frame")
    Bubble.Name = "Bubble"
    Bubble.Size = UDim2.new(0.8, 0, 0, 0)
    Bubble.BackgroundColor3 = isUser and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(60, 60, 75)
    Bubble.BorderSizePixel = 0
    Bubble.Parent = MessageFrame
    
    if isUser then
        Bubble.Position = UDim2.new(0.2, 0, 0, 0)
    else
        Bubble.Position = UDim2.new(0, 0, 0, 0)
    end
    
    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(0, 10)
    BubbleCorner.Parent = Bubble
    
    local MessageText = Instance.new("TextLabel")
    MessageText.Name = "MessageText"
    MessageText.Size = UDim2.new(1, -16, 1, -12)
    MessageText.Position = UDim2.new(0, 8, 0, 6)
    MessageText.BackgroundTransparency = 1
    MessageText.Text = text
    MessageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageText.TextSize = 12
    MessageText.Font = Enum.Font.Gotham
    MessageText.TextWrapped = true
    MessageText.TextXAlignment = Enum.TextXAlignment.Left
    MessageText.TextYAlignment = Enum.TextYAlignment.Top
    MessageText.Parent = Bubble
    
    -- Calculate height
    local textBounds = MessageText.TextBounds
    local height = math.max(textBounds.Y + 12, 35)
    
    Bubble.Size = UDim2.new(0.8, 0, 0, height)
    MessageFrame.Size = UDim2.new(1, -8, 0, height + 4)
    
    -- Update canvas
    task.wait(0.05)
    ChatContainer.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 16)
    
    -- Auto scroll to bottom
    ChatContainer.CanvasPosition = Vector2.new(0, ChatContainer.CanvasSize.Y.Offset)
    
    -- Animation
    Bubble.Size = UDim2.new(0, 0, 0, height)
    TweenService:Create(Bubble, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0.8, 0, 0, height)
    }):Play()
    
    return MessageFrame
end

-- API Function
function sendToLulcat(message)
    local success, result = pcall(function()
        local encodedMessage = HttpService:UrlEncode(message)
        local url = "https://api.popcat.xyz/v2/lulcat?text=" .. encodedMessage
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.error == false and data.message and data.message.text then
            return data.message.text
        else
            return "⚠️ Không thể nhận phản hồi"
        end
    end)
    
    return success and result or "❌ Lỗi kết nối API"
end

-- Send Message Function
function sendMessage()
    local text = InputBox.Text
    if text == "" or text == nil then return end
    
    createChatMessage(text, true)
    InputBox.Text = ""
    
    local typingMsg = createChatMessage("💭 Đang trả lời...", false)
    
    task.spawn(function()
        local response = sendToLulcat(text)
        
        if typingMsg and typingMsg.Parent then
            typingMsg:Destroy()
            messageCount = messageCount - 1
            table.remove(chatHistoryData, #chatHistoryData)
        end
        
        createChatMessage(response, false)
    end)
end

SendButton.MouseButton1Click:Connect(sendMessage)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendMessage()
    end
end)

-- History Window (Nhỏ hơn)
local HistoryFrame = Instance.new("Frame")
HistoryFrame.Size = UDim2.new(0, 280, 0, 360)
HistoryFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
HistoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
HistoryFrame.BorderSizePixel = 0
HistoryFrame.Visible = false
HistoryFrame.Parent = ScreenGui

local HistoryCornerMain = Instance.new("UICorner")
HistoryCornerMain.CornerRadius = UDim.new(0, 12)
HistoryCornerMain.Parent = HistoryFrame

local HistoryHeader = Instance.new("Frame")
HistoryHeader.Size = UDim2.new(1, 0, 0, 35)
HistoryHeader.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
HistoryHeader.BorderSizePixel = 0
HistoryHeader.Parent = HistoryFrame

local HistoryHeaderCorner = Instance.new("UICorner")
HistoryHeaderCorner.CornerRadius = UDim.new(0, 12)
HistoryHeaderCorner.Parent = HistoryHeader

local HistoryHeaderFix = Instance.new("Frame")
HistoryHeaderFix.Size = UDim2.new(1, 0, 0, 12)
HistoryHeaderFix.Position = UDim2.new(0, 0, 1, -12)
HistoryHeaderFix.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
HistoryHeaderFix.BorderSizePixel = 0
HistoryHeaderFix.Parent = HistoryHeader

local HistoryTitle = Instance.new("TextLabel")
HistoryTitle.Size = UDim2.new(1, -40, 1, 0)
HistoryTitle.Position = UDim2.new(0, 10, 0, 0)
HistoryTitle.BackgroundTransparency = 1
HistoryTitle.Text = "📜 Lịch sử"
HistoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryTitle.TextSize = 15
HistoryTitle.Font = Enum.Font.GothamBold
HistoryTitle.TextXAlignment = Enum.TextXAlignment.Left
HistoryTitle.Parent = HistoryHeader

local CloseHistoryBtn = Instance.new("TextButton")
CloseHistoryBtn.Size = UDim2.new(0, 26, 0, 26)
CloseHistoryBtn.Position = UDim2.new(1, -30, 0.5, -13)
CloseHistoryBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseHistoryBtn.Text = "✕"
CloseHistoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseHistoryBtn.TextSize = 15
CloseHistoryBtn.Font = Enum.Font.GothamBold
CloseHistoryBtn.BorderSizePixel = 0
CloseHistoryBtn.Parent = HistoryHeader

local CloseHistoryCorner = Instance.new("UICorner")
CloseHistoryCorner.CornerRadius = UDim.new(0, 6)
CloseHistoryCorner.Parent = CloseHistoryBtn

local HistoryScroll = Instance.new("ScrollingFrame")
HistoryScroll.Size = UDim2.new(1, -16, 1, -90)
HistoryScroll.Position = UDim2.new(0, 8, 0, 43)
HistoryScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
HistoryScroll.BorderSizePixel = 0
HistoryScroll.ScrollBarThickness = 4
HistoryScroll.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
HistoryScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
HistoryScroll.Parent = HistoryFrame

local HistoryScrollCorner = Instance.new("UICorner")
HistoryScrollCorner.CornerRadius = UDim.new(0, 8)
HistoryScrollCorner.Parent = HistoryScroll

local HistoryText = Instance.new("TextLabel")
HistoryText.Size = UDim2.new(1, -16, 1, 0)
HistoryText.Position = UDim2.new(0, 8, 0, 8)
HistoryText.BackgroundTransparency = 1
HistoryText.Text = "Chưa có lịch sử..."
HistoryText.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryText.TextSize = 12
HistoryText.Font = Enum.Font.Gotham
HistoryText.TextWrapped = true
HistoryText.TextXAlignment = Enum.TextXAlignment.Left
HistoryText.TextYAlignment = Enum.TextYAlignment.Top
HistoryText.Parent = HistoryScroll

local ClearHistoryBtn = Instance.new("TextButton")
ClearHistoryBtn.Size = UDim2.new(1, -16, 0, 35)
ClearHistoryBtn.Position = UDim2.new(0, 8, 1, -43)
ClearHistoryBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ClearHistoryBtn.Text = "🗑️ Xóa lịch sử"
ClearHistoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearHistoryBtn.TextSize = 13
ClearHistoryBtn.Font = Enum.Font.GothamBold
ClearHistoryBtn.BorderSizePixel = 0
ClearHistoryBtn.Parent = HistoryFrame

local ClearHistoryCorner = Instance.new("UICorner")
ClearHistoryCorner.CornerRadius = UDim.new(0, 8)
ClearHistoryCorner.Parent = ClearHistoryBtn

-- Update History Display
function updateHistoryDisplay()
    if #chatHistoryData == 0 then
        HistoryText.Text = "Chưa có lịch sử..."
        HistoryScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    else
        local historyString = ""
        for i, msg in ipairs(chatHistoryData) do
            local prefix = msg.isUser and "👤" or "🐱"
            historyString = historyString .. string.format("[%s] %s: %s\n\n", msg.timestamp, prefix, msg.text)
        end
        HistoryText.Text = historyString
        
        task.wait(0.05)
        local textHeight = HistoryText.TextBounds.Y
        HistoryScroll.CanvasSize = UDim2.new(0, 0, 0, textHeight + 16)
    end
end

-- History Button Click
HistoryButton.MouseButton1Click:Connect(function()
    updateHistoryDisplay()
    HistoryFrame.Visible = true
    HistoryFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(HistoryFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 280, 0, 360)
    }):Play()
end)

CloseHistoryBtn.MouseButton1Click:Connect(function()
    TweenService:Create(HistoryFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    HistoryFrame.Visible = false
end)

ClearHistoryBtn.MouseButton1Click:Connect(function()
    chatHistoryData = {}
    messageCount = 0
    
    for _, child in ipairs(ChatContainer:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("Message") then
            child:Destroy()
        end
    end
    
    updateHistoryDisplay()
    createChatMessage("✅ Đã xóa!", false)
end)

-- Hover Effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
end

addHoverEffect(CloseButton, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 70, 70))
addHoverEffect(SendButton, Color3.fromRGB(88, 101, 242), Color3.fromRGB(108, 121, 255))
addHoverEffect(HistoryButton, Color3.fromRGB(88, 101, 242), Color3.fromRGB(108, 121, 255))
addHoverEffect(CloseHistoryBtn, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 70, 70))
addHoverEffect(ClearHistoryBtn, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 70, 70))

-- Opening Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 380)
}):Play()

-- Welcome Message
task.wait(0.6)
createChatMessage("👋 Xin chào! Tôi là Lulcat 🐱", false)

print("✅ Lulcat Chatbot UI (Compact) loaded!")