-- EnowLib v2.0.0 Complete Example
-- Demonstrates all components and features

local EnowLib = loadstring(game:HttpGet("your-url/EnowLib.lua"))()

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "EnowLib v2.0 Demo",
    Size = UDim2.fromOffset(580, 460)
})

-- Create tabs
local ComponentsTab = Window:AddTab({Title = "Components"})
local AdvancedTab = Window:AddTab({Title = "Advanced"})
local ConfigTab = Window:AddTab({Title = "Config"})

-- COMPONENTS TAB
ComponentsTab:AddLabel({
    Text = "EnowLib v2.0.0 - Complete Component Showcase",
    Size = "Large",
    Color = Color3.fromRGB(138, 43, 226)
})

ComponentsTab:AddSection({Title = "BASIC COMPONENTS"})

ComponentsTab:AddButton({
    Title = "Click Me",
    Description = "Button with ripple effect",
    Callback = function()
        EnowLib:Notify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Duration = 2,
            Type = "Success"
        })
    end
})

ComponentsTab:AddToggle({
    Title = "Enable Feature",
    Description = "Toggle switch with animation",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

ComponentsTab:AddSlider({
    Title = "Speed",
    Description = "Adjust speed value",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})

ComponentsTab:AddInput({
    Title = "Username",
    Description = "Enter your username",
    Placeholder = "Type here...",
    Default = "",
    Callback = function(value)
        print("Input:", value)
    end
})

ComponentsTab:AddDropdown({
    Title = "Select Option",
    Description = "Single selection dropdown",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4"},
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

ComponentsTab:AddSection({Title = "ADVANCED COMPONENTS"})

ComponentsTab:AddKeybind({
    Title = "Toggle Key",
    Description = "Press to set keybind",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Keybind set to:", key.Name)
    end
})

ComponentsTab:AddColorPicker({
    Title = "Theme Color",
    Description = "Pick your favorite color",
    Default = Color3.fromRGB(138, 43, 226),
    Callback = function(color)
        print("Color:", color)
    end
})

ComponentsTab:AddMultiDropdown({
    Title = "Multi Select",
    Description = "Select multiple options",
    Options = {"Feature 1", "Feature 2", "Feature 3", "Feature 4"},
    Default = {"Feature 1"},
    Callback = function(values)
        print("Selected:", table.concat(values, ", "))
    end
})

local progressBar = ComponentsTab:AddProgressBar({
    Title = "Loading Progress",
    Description = "Animated progress bar",
    Min = 0,
    Max = 100,
    Value = 0,
    ShowPercentage = true,
    Animated = true
})

ComponentsTab:AddButton({
    Title = "Simulate Progress",
    Description = "Test progress bar animation",
    Callback = function()
        progressBar:Reset()
        
        task.spawn(function()
            for i = 0, 100, 5 do
                progressBar:SetValue(i)
                task.wait(0.1)
            end
            
            EnowLib:Notify({
                Title = "Complete!",
                Content = "Progress finished",
                Duration = 2,
                Type = "Success"
            })
        end)
    end
})

-- ADVANCED TAB
AdvancedTab:AddLabel({
    Text = "Advanced Features & Notifications",
    Size = "Medium",
    Color = Color3.fromRGB(0, 255, 255)
})

AdvancedTab:AddSection({Title = "NOTIFICATIONS"})

AdvancedTab:AddButton({
    Title = "Info Notification",
    Callback = function()
        EnowLib:Notify({
            Title = "Information",
            Content = "This is an info notification with vaporwave style!",
            Duration = 3,
            Type = "Info"
        })
    end
})

AdvancedTab:AddButton({
    Title = "Success Notification",
    Callback = function()
        EnowLib:Notify({
            Title = "Success!",
            Content = "Operation completed successfully.",
            Duration = 3,
            Type = "Success"
        })
    end
})

AdvancedTab:AddButton({
    Title = "Warning Notification",
    Callback = function()
        EnowLib:Notify({
            Title = "Warning",
            Content = "This is a warning message.",
            Duration = 3,
            Type = "Warning"
        })
    end
})

AdvancedTab:AddButton({
    Title = "Error Notification",
    Callback = function()
        EnowLib:Notify({
            Title = "Error",
            Content = "An error has occurred.",
            Duration = 3,
            Type = "Error"
        })
    end
})

AdvancedTab:AddSection({Title = "WINDOW CONTROLS"})

AdvancedTab:AddButton({
    Title = "Toggle Window",
    Description = "Hide/Show the window",
    Callback = function()
        Window:Toggle()
    end
})

AdvancedTab:AddLabel({
    Text = "Press LeftControl to toggle window visibility",
    Size = "Small",
    Color = Color3.fromRGB(150, 150, 170)
})

-- CONFIG TAB (SaveManager & InterfaceManager)
Window.SaveManager.CreateUI(ConfigTab)
Window.InterfaceManager.CreateUI(ConfigTab)

-- Success message
EnowLib:Notify({
    Title = "EnowLib Loaded",
    Content = "All components initialized successfully!",
    Duration = 3,
    Type = "Success"
})

print("EnowLib v2.0.0 loaded successfully!")
print("Components: Button, Toggle, Slider, Input, Dropdown, Keybind, ColorPicker, MultiDropdown, ProgressBar")
print("Features: SaveManager, InterfaceManager, Theme System, Notifications")
