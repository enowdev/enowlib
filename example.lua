-- EnowLib v2.0.0 - Clean Example
-- Radix UI Dark Mode with Transparency

print("Loading EnowLib...")

local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

print("Creating window...")

local Window = EnowLib:CreateWindow({
    Title = "EnowLib v2.0",
    Size = UDim2.fromOffset(800, 400)
})

-- Main Tab
local MainTab = Window:AddTab({Title = "Main"})

MainTab:AddLabel({Text = "Welcome to EnowLib v2.0"})

MainTab:AddButton({
    Title = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:AddToggle({
    Title = "Toggle Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

MainTab:AddSlider({
    Title = "Slider Value",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider:", value)
    end
})

-- Settings Tab
local SettingsTab = Window:AddTab({Title = "Settings"})

SettingsTab:AddLabel({Text = "Configuration"})

SettingsTab:AddToggle({
    Title = "Enable Feature",
    Default = true,
    Callback = function(value)
        print("Feature enabled:", value)
    end
})

print("EnowLib loaded successfully!")
