-- Custom Lulcat Chatbot UI (Không dùng Rayfield)
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

-- Main Frame (cửa sổ chính) - NHỎ GỌN HỞN
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Bo góc cho MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Header (thanh tiêu đề) - GIẢM CHIỀU CAO
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix góc dưới của Header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title - GIẢM FONT SIZE
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐱 Lulcat Chat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button - NHỎ HƠN
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -36, 0.5, -14)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Chat List Container - COMPACT
local ChatContainer = Instance.new("ScrollingFrame")
ChatContainer.Name = "ChatContainer"
ChatContainer.Size = UDim2.new(1, -16, 1, -100)
ChatContainer.Position = UDim2.new(0, 8, 0, 48)
ChatContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ChatContainer.BorderSizePixel = 0
ChatContainer.ScrollBarThickness = 4
ChatContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ChatContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatContainer.Parent = MainFrame

local ChatCorner = Instance.new("UICorner")
ChatCorner.CornerRadius = UDim.new(0, 8)
ChatCorner.Parent = ChatContainer

-- UIListLayout cho chat messages - PADDING NHỎ HƠN
local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Padding = UDim.new(0, 6)
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Parent = ChatContainer

-- Input Container - COMPACT
local InputContainer = Instance.new("Frame")
InputContainer.Name = "InputContainer"
InputContainer.Size = UDim2.new(1, -16, 0, 45)
InputContainer.Position = UDim2.new(0, 8, 1, -52)
InputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
InputContainer.BorderSizePixel = 0
InputContainer.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputContainer

-- TextBox (ô nhập) - COMPACT
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -60, 1, -12)
InputBox.Position = UDim2.new(0, 8, 0, 6)
InputBox.BackgroundTransparency = 1
InputBox.Text = ""
InputBox.PlaceholderText = "Nhập tin nhắn..."
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputContainer

-- Send Button - COMPACT
local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Size = UDim2.new(0, 40, 0, 33)
SendButton.Position = UDim2.new(1, -46, 0.5, -16.5)
SendButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
SendButton.Text = "📤"
SendButton.TextSize = 16
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

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Hover effects
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    }):Play()
end)

SendButton.MouseEnter:Connect(function()
    TweenService:Create(SendButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(108, 121, 255)
    }):Play()
end)

SendButton.MouseLeave:Connect(function()
    TweenService:Create(SendButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    }):Play()
end)

-- Hàm tạo chat message
local messageCount = 0
function createChatMessage(text, isUser)
    messageCount = messageCount + 1
    
    local MessageFrame = Instance.new("Frame")
    MessageFrame.Name = "Message" .. messageCount
    MessageFrame.Size = UDim2.new(1, -10, 0, 0)
    MessageFrame.BackgroundTransparency = 1
    MessageFrame.BorderSizePixel = 0
    MessageFrame.LayoutOrder = messageCount
    MessageFrame.Parent = ChatContainer
    
    local Bubble = Instance.new("Frame")
    Bubble.Name = "Bubble"
    Bubble.Size = UDim2.new(0.85, 0, 0, 0)
    Bubble.BackgroundColor3 = isUser and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(45, 45, 60)
    Bubble.BorderSizePixel = 0
    Bubble.Parent = MessageFrame
    
    if isUser then
        Bubble.Position = UDim2.new(0.15, 0, 0, 0)
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
    MessageText.TextSize = 13
    MessageText.Font = Enum.Font.Gotham
    MessageText.TextWrapped = true
    MessageText.TextXAlignment = Enum.TextXAlignment.Left
    MessageText.TextYAlignment = Enum.TextYAlignment.Top
    MessageText.Parent = Bubble
    
    -- Tính toán chiều cao - COMPACT
    local textBounds = MessageText.TextBounds
    local height = math.max(textBounds.Y + 12, 32)
    
    Bubble.Size = UDim2.new(0.85, 0, 0, height)
    MessageFrame.Size = UDim2.new(1, -10, 0, height)
    
    -- Update canvas size
    ChatContainer.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 10)
    ChatContainer.CanvasPosition = Vector2.new(0, ChatContainer.CanvasSize.Y.Offset)
    
    -- Animation
    Bubble.Size = UDim2.new(0, 0, 0, height)
    TweenService:Create(Bubble, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0.85, 0, 0, height)
    }):Play()
end

-- Hàm gửi đến API Lulcat
function sendToLulcat(message)
    local success, result = pcall(function()
        local encodedMessage = HttpService:UrlEncode(message)
        local url = "https://api.popcat.xyz/v2/lulcat?text=" .. encodedMessage
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.error == false and data.message and data.message.text then
            return data.message.text
        else
            return "⚠️ Không thể nhận phản hồi từ API"
        end
    end)
    
    if success then
        return result
    else
        return "❌ Lỗi kết nối: Vui lòng thử lại"
    end
end

-- Hàm xử lý gửi tin nhắn
function sendMessage()
    local text = InputBox.Text
    if text == "" or text == nil then return end
    
    -- Thêm tin nhắn người dùng
    createChatMessage(text, true)
    InputBox.Text = ""
    
    -- Hiển thị typing indicator
    createChatMessage("Lulcat đang trả lời...", false)
    
    -- Gửi đến API
    task.spawn(function()
        local response = sendToLulcat(text)
        
        -- Xóa typing indicator
        if ChatContainer:FindFirstChild("Message" .. messageCount) then
            ChatContainer:FindFirstChild("Message" .. messageCount):Destroy()
            messageCount = messageCount - 1
        end
        
        -- Thêm phản hồi
        createChatMessage(response, false)
    end)
end

-- Send button click
SendButton.MouseButton1Click:Connect(sendMessage)

-- Enter key press
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendMessage()
    end
end)

-- Welcome message
task.wait(0.5)
createChatMessage("👋 Xin chào! Tôi là Lulcat. Hỏi tôi bất cứ điều gì!", false)

-- Opening animation - COMPACT SIZE
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 320, 0, 420)
}):Play()

print("✅ Lulcat Chatbot UI loaded successfully!")