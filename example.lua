-- VaporUI Example Usage

local VaporUI = loadstring(game:HttpGet("your-url/vaporui.lua"))()

-- Create window
local Window = VaporUI:CreateWindow({
    Title = "VaporUI Demo",
    Size = UDim2.fromOffset(500, 400)
})

-- Create tabs
local MainTab = Window:AddTab({Title = "Main"})
local SettingsTab = Window:AddTab({Title = "Settings"})

-- Main Tab Components
MainTab:AddSection({Title = "BUTTONS"})

MainTab:AddButton({
    Title = "Click Me",
    Description = "This is a button with description",
    Callback = function()
        VaporUI:Notify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Duration = 2,
            Type = "Success"
        })
    end
})

MainTab:AddSection({Title = "TOGGLES"})

MainTab:AddToggle({
    Title = "Enable Feature",
    Description = "Toggle this feature on/off",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

MainTab:AddSection({Title = "SLIDERS"})

MainTab:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})

MainTab:AddSection({Title = "INPUTS"})

MainTab:AddInput({
    Title = "Username",
    Description = "Enter your username",
    Placeholder = "Type here...",
    Default = "",
    Callback = function(value)
        print("Input:", value)
    end
})

MainTab:AddSection({Title = "DROPDOWNS"})

MainTab:AddDropdown({
    Title = "Select Option",
    Description = "Choose from the list",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4"},
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

-- Settings Tab
SettingsTab:AddLabel({
    Text = "VaporUI v1.0.0",
    Size = "Large",
    Color = Color3.fromRGB(138, 43, 226)
})

SettingsTab:AddLabel({
    Text = "A modern vaporwave tech dark UI library for Roblox.",
    Size = "Regular"
})

SettingsTab:AddSection({Title = "THEME"})

SettingsTab:AddButton({
    Title = "Show Notification",
    Callback = function()
        VaporUI:Notify({
            Title = "Test Notification",
            Content = "This is a test notification with vaporwave style!",
            Duration = 3,
            Type = "Info"
        })
    end
})

SettingsTab:AddButton({
    Title = "Success Notification",
    Callback = function()
        VaporUI:Notify({
            Title = "Success!",
            Content = "Operation completed successfully.",
            Duration = 3,
            Type = "Success"
        })
    end
})

SettingsTab:AddButton({
    Title = "Warning Notification",
    Callback = function()
        VaporUI:Notify({
            Title = "Warning",
            Content = "This is a warning message.",
            Duration = 3,
            Type = "Warning"
        })
    end
})

SettingsTab:AddButton({
    Title = "Error Notification",
    Callback = function()
        VaporUI:Notify({
            Title = "Error",
            Content = "An error has occurred.",
            Duration = 3,
            Type = "Error"
        })
    end
})

print("VaporUI loaded successfully!")
