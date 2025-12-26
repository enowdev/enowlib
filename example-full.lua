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
    Content = function(window)
        -- Header
        window:AddLabel({
            Text = "> All Components Test",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        -- Description
        window:AddParagraph({
            Title = "Component Testing",
            Content = "This tab demonstrates all available components in EnowLib. Test each component to ensure responsive design works on all devices."
        })
        
        window:AddDivider()
        
        -- Section: Input Components
        local inputSection = window:AddSection({
            Title = "Input Components"
        })
        
        -- Button
        inputSection:AddButton({
            Text = "Test Button",
            Callback = function()
                print("Button clicked!")
            end
        })
        
        -- Toggle
        inputSection:AddToggle({
            Text = "Enable Feature",
            Default = false,
            Callback = function(value)
                print("Toggle:", value)
            end
        })
        
        -- Slider
        inputSection:AddSlider({
            Text = "Speed Multiplier",
            Min = 1,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("Slider:", value)
            end
        })
        
        -- TextBox
        inputSection:AddTextBox({
            Text = "Player Name",
            Placeholder = "Enter name...",
            Default = "",
            Callback = function(value)
                print("TextBox:", value)
            end
        })
        
        -- Dropdown
        inputSection:AddDropdown({
            Text = "Select Mode",
            Options = {"Normal", "Fast", "Extreme"},
            Default = "Normal",
            Callback = function(value)
                print("Dropdown:", value)
            end
        })
        
        -- ColorPicker
        inputSection:AddColorPicker({
            Text = "ESP Color",
            Default = Color3.fromRGB(46, 204, 113),
            Callback = function(color)
                print("ColorPicker:", color)
            end
        })
        
        -- Keybind
        inputSection:AddKeybind({
            Text = "Toggle Menu",
            Default = Enum.KeyCode.RightShift,
            Callback = function(key)
                print("Keybind:", key)
            end
        })
        
        window:AddDivider({Text = "Layout Components"})
        
        -- Paragraph
        window:AddParagraph({
            Title = "About EnowLib",
            Content = "EnowLib is a modern UI library for Roblox with responsive design, smooth animations, and a hacker-style IDE theme. All components are optimized for PC, tablet, and mobile devices."
        })
        
        window:AddDivider()
        
        -- Label
        window:AddLabel({
            Text = "All components are fully responsive and touch-friendly!",
            Color = window.Theme.Colors.Success
        })
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
    Content = function(window)
        window:AddLabel({
            Text = "> General Settings",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "Configuration",
            Content = "Configure general application settings and preferences."
        })
        
        window:AddDivider()
        
        local generalSection = window:AddSection({
            Title = "General Options"
        })
        
        generalSection:AddToggle({
            Text = "Auto Save",
            Default = true,
            Callback = function(value)
                print("Auto Save:", value)
            end
        })
        
        generalSection:AddToggle({
            Text = "Notifications",
            Default = true,
            Callback = function(value)
                print("Notifications:", value)
            end
        })
        
        generalSection:AddSlider({
            Text = "UI Scale",
            Min = 80,
            Max = 120,
            Default = 100,
            Callback = function(value)
                print("UI Scale:", value .. "%")
            end
        })
    end
})

print("EnowLib loaded successfully!")
