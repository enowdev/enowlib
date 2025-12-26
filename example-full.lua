-- EnowLib Full Component Test
-- Test all components with responsive design

print("Loading EnowLib...")

local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Lucide Icons
local Icons = {
    Folder = "rbxassetid://10723387563",
    FileCode = "rbxassetid://10723356507",
    Settings = "rbxassetid://10734950309"
}

print("Creating window...")

local Window = EnowLib:CreateWindow({
    Title = "EnowHub UI Testing",
    Size = UDim2.fromOffset(900, 600)
})

-- Components Test Category
local ComponentsCategory = Window:AddCategory({
    Title = "Components",
    Icon = Icons.Folder,
    Expanded = true
})

-- All Components Tab
ComponentsCategory:AddItem({
    Title = "AllComponents.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        -- Header
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> All Components Test"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        -- Description
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 60)
        desc.Font = theme.Font.Mono
        desc.Text = "This tab demonstrates all available components in EnowLib.\nTest each component to ensure responsive design works on all devices."
        desc.TextColor3 = theme.Colors.TextDim
        desc.TextSize = 13
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = parent
        
        -- Divider
        local divider1 = Instance.new("Frame")
        divider1.BackgroundColor3 = theme.Colors.Border
        divider1.BorderSizePixel = 0
        divider1.Size = UDim2.new(1, 0, 0, 1)
        divider1.Parent = parent
        
        -- Section Label
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Size = UDim2.new(1, 0, 0, 24)
        sectionLabel.Font = theme.Font.Bold
        sectionLabel.Text = "INPUT COMPONENTS"
        sectionLabel.TextColor3 = theme.Colors.Accent
        sectionLabel.TextSize = 14
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = parent
        
        -- Note: Components will be added via Window methods
        -- This is just a visual demo showing the layout works
    end
})

-- Settings Category
local SettingsCategory = Window:AddCategory({
    Title = "Settings",
    Icon = Icons.Settings,
    Expanded = false
})

SettingsCategory:AddItem({
    Title = "General.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> General Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 40)
        desc.Font = theme.Font.Mono
        desc.Text = "Configure general application settings"
        desc.TextColor3 = theme.Colors.TextDim
        desc.TextSize = 13
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = parent
    end
})

print("EnowLib loaded successfully!")
