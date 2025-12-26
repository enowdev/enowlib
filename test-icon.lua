-- Test Icon Loader
-- Paste Asset ID di Studio untuk dapat Image ID yang benar

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create test GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IconTest"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400, 300)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Test icons
local testIcons = {
    {name = "ChevronDown", id = "rbxassetid://84943167918420"},
    {name = "ChevronRight", id = "rbxassetid://107730842937250"},
    {name = "Cross", id = "rbxassetid://103469834740951"},
    {name = "Check", id = "rbxassetid://112055175771712"}
}

local yPos = 20
for _, iconData in ipairs(testIcons) do
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 0, 50)
    label.Position = UDim2.fromOffset(10, yPos)
    label.BackgroundTransparency = 1
    label.Text = iconData.name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(32, 32)
    icon.Position = UDim2.new(0.5, 10, 0, yPos + 9)
    icon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    icon.Image = iconData.id
    icon.ImageColor3 = Color3.new(1, 1, 1)
    icon.Parent = frame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 4)
    iconCorner.Parent = icon
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(100, 50)
    status.Position = UDim2.new(0.5, 50, 0, yPos)
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(255, 200, 0)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 12
    status.Parent = frame
    
    -- Check if loaded
    task.spawn(function()
        task.wait(2)
        if icon.Image ~= "" and icon.Image == iconData.id then
            status.Text = "✓ Loaded"
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            status.Text = "✗ Failed"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
    
    yPos = yPos + 60
end

print("[IconTest] Test GUI created. Check if icons load.")
