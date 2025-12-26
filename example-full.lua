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
        
        -- Paragraph
        local Paragraph = require(script.Parent.Paragraph)
        Paragraph.new({
            Text = "This tab demonstrates all available components in EnowLib. Test each component to ensure responsive design works on all devices."
        }, {Container = parent}, theme, utils)
        
        -- Divider with text
        local Divider = require(script.Parent.Divider)
        Divider.new({Text = "INPUT COMPONENTS"}, {Container = parent}, theme, utils)
        
        -- TextBox
        local TextBox = require(script.Parent.TextBox)
        TextBox.new({
            Title = "Username",
            Placeholder = "Enter your username...",
            Default = "",
            Callback = function(value)
                print("Username:", value)
            end
        }, {Container = parent}, theme, utils)
        
        -- Dropdown
        local Dropdown = require(script.Parent.Dropdown)
        Dropdown.new({
            Title = "Select Game Mode",
            Options = {"Solo", "Duo", "Squad", "Arena"},
            Default = "Solo",
            Callback = function(value)
                print("Game Mode:", value)
            end
        }, {Container = parent}, theme, utils)
        
        -- ColorPicker
        local ColorPicker = require(script.Parent.ColorPicker)
        ColorPicker.new({
            Title = "Theme Color",
            Default = Color3.fromRGB(46, 204, 113),
            Callback = function(color)
                print("Color:", color)
            end
        }, {Container = parent}, theme, utils)
        
        -- Keybind
        local Keybind = require(script.Parent.Keybind)
        Keybind.new({
            Title = "Toggle Key",
            Default = "None",
            Callback = function(key)
                print("Keybind:", key)
            end
        }, {Container = parent}, theme, utils)
        
        -- Divider
        Divider.new({Text = "CONTROL COMPONENTS"}, {Container = parent}, theme, utils)
        
        -- Button
        local Button = require(script.Parent.Button)
        Button.new({
            Title = "Execute Script",
            Callback = function()
                print("Button clicked!")
            end
        }, {Container = parent}, theme, utils)
        
        -- Toggle
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Enable Feature",
            Default = false,
            Callback = function(value)
                print("Toggle:", value)
            end
        }, {Container = parent}, theme, utils)
        
        -- Slider
        local Slider = require(script.Parent.Slider)
        Slider.new({
            Title = "Speed Multiplier",
            Min = 1,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("Slider:", value)
            end
        }, {Container = parent}, theme, utils)
        
        -- Divider
        Divider.new({}, {Container = parent}, theme, utils)
        
        -- Label
        local Label = require(script.Parent.Label)
        Label.new({
            Text = "All components are responsive and mobile-friendly!"
        }, {Container = parent}, theme, utils)
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
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Auto Save",
            Default = true,
            Callback = function(value)
                print("Auto Save:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "Notifications",
            Default = true,
            Callback = function(value)
                print("Notifications:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

print("EnowLib loaded successfully!")
