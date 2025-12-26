-- Debug Icon Loading
-- Test if Lucide icons load properly

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create test GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IconDebug"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(500, 400)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Lucide Icon Test"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Test icons
local testIcons = {
    {name = "ChevronDown", id = "rbxassetid://10709790948"},
    {name = "ChevronRight", id = "rbxassetid://10709791437"},
    {name = "X", id = "rbxassetid://10747384394"},
    {name = "Check", id = "rbxassetid://10709790644"},
    {name = "Settings", id = "rbxassetid://10734950309"},
    {name = "Home", id = "rbxassetid://10723407389"}
}

local yPos = 50
for i, iconData in ipairs(testIcons) do
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0, 50)
    label.Position = UDim2.fromOffset(10, yPos)
    label.BackgroundTransparency = 1
    label.Text = iconData.name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    -- Icon container
    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(40, 40)
    iconBg.Position = UDim2.new(0.5, 0, 0, yPos + 5)
    iconBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    iconBg.Parent = frame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = iconBg
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(24, 24)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = iconData.id
    icon.ImageColor3 = Color3.new(1, 1, 1)
    icon.Parent = iconBg
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(100, 50)
    status.Position = UDim2.new(0.7, 0, 0, yPos)
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(255, 200, 0)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 12
    status.Parent = frame
    
    -- Check if loaded
    task.spawn(function()
        task.wait(3)
        if icon.Image ~= "" then
            -- Check if image actually loaded by checking IsLoaded
            local success = pcall(function()
                return icon.IsLoaded
            end)
            
            if success then
                status.Text = "OK"
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                status.Text = "Failed"
                status.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            status.Text = "No Image"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
    
    yPos = yPos + 55
end

print("[IconDebug] Test GUI created")
