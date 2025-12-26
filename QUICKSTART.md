# EnowLib Quick Start Guide

Get started with EnowLib in 5 minutes.

## Installation

```lua
local EnowLib = loadstring(game:HttpGet("your-url/EnowLib.lua"))()
```

## Basic Setup

```lua
-- Create window
local Window = EnowLib:CreateWindow({
    Title = "My Script",
    Size = UDim2.fromOffset(580, 460)
})

-- Create tab
local Tab = Window:AddTab({Title = "Main"})
```

## Common Components

### Button
```lua
Tab:AddButton({
    Title = "Click Me",
    Callback = function()
        print("Clicked!")
    end
})
```

### Toggle
```lua
Tab:AddToggle({
    Title = "Enable Feature",
    Default = false,
    Callback = function(value)
        if value then
            -- Enable feature
        else
            -- Disable feature
        end
    end
})
```

### Slider
```lua
Tab:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

### Input
```lua
Tab:AddInput({
    Title = "Username",
    Placeholder = "Enter username...",
    Callback = function(value)
        print("Username:", value)
    end
})
```

### Dropdown
```lua
Tab:AddDropdown({
    Title = "Select Mode",
    Options = {"Mode 1", "Mode 2", "Mode 3"},
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## Advanced Components

### Keybind
```lua
Tab:AddKeybind({
    Title = "Toggle Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        -- Triggered when key is pressed
        print("Key pressed:", key.Name)
    end
})
```

### Color Picker
```lua
Tab:AddColorPicker({
    Title = "Theme Color",
    Default = Color3.fromRGB(138, 43, 226),
    Callback = function(color)
        -- Use color
        print("Selected color:", color)
    end
})
```

### Multi Dropdown
```lua
Tab:AddMultiDropdown({
    Title = "Select Features",
    Options = {"Feature 1", "Feature 2", "Feature 3"},
    Default = {"Feature 1"},
    Callback = function(values)
        -- values is an array of selected options
        for _, feature in ipairs(values) do
            print("Enabled:", feature)
        end
    end
})
```

### Progress Bar
```lua
local progress = Tab:AddProgressBar({
    Title = "Loading",
    Min = 0,
    Max = 100,
    Value = 0
})

-- Update progress
task.spawn(function()
    for i = 0, 100, 10 do
        progress:SetValue(i)
        task.wait(0.5)
    end
end)
```

## Notifications

```lua
-- Success
EnowLib:Notify({
    Title = "Success",
    Content = "Operation completed!",
    Duration = 3,
    Type = "Success"
})

-- Error
EnowLib:Notify({
    Title = "Error",
    Content = "Something went wrong!",
    Duration = 3,
    Type = "Error"
})

-- Warning
EnowLib:Notify({
    Title = "Warning",
    Content = "Be careful!",
    Duration = 3,
    Type = "Warning"
})

-- Info
EnowLib:Notify({
    Title = "Info",
    Content = "Just letting you know...",
    Duration = 3,
    Type = "Info"
})
```

## Configuration Management

### Save/Load Configs

```lua
-- Create config tab
local ConfigTab = Window:AddTab({Title = "Config"})

-- Add SaveManager UI
Window.SaveManager.CreateUI(ConfigTab)

-- Or use programmatically
Window.SaveManager.Save("myconfig")
Window.SaveManager.Load("myconfig")
Window.SaveManager.Delete("myconfig")

-- Auto-save every 60 seconds
Window.SaveManager.AutoSave(60)
```

## Theme Management

```lua
-- Create settings tab
local SettingsTab = Window:AddTab({Title = "Settings"})

-- Add InterfaceManager UI
Window.InterfaceManager.CreateUI(SettingsTab)

-- Or use programmatically
Window.InterfaceManager.SetTheme("Cyberpunk")
Window.InterfaceManager.SetTransparency(0.2)
Window.InterfaceManager.SetAcrylic(true)
```

## Available Themes

- **Vaporwave** (Default) - Purple/Cyan/Pink
- **Dark** - Monochrome dark
- **Light** - Blue-tinted light
- **Cyberpunk** - Magenta/Cyan neon
- **Neon** - Green/Pink/Cyan bright

## Complete Example

```lua
local EnowLib = loadstring(game:HttpGet("your-url/EnowLib.lua"))()

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "My Script Hub",
    Size = UDim2.fromOffset(580, 460)
})

-- Main tab
local MainTab = Window:AddTab({Title = "Main"})

MainTab:AddSection({Title = "PLAYER"})

MainTab:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MainTab:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

MainTab:AddSection({Title = "FEATURES"})

MainTab:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        getgenv().AutoFarm = value
        
        if value then
            -- Start auto farm
            task.spawn(function()
                while getgenv().AutoFarm do
                    -- Farm logic here
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:AddKeybind({
    Title = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        Window:Toggle()
    end
})

-- Config tab
local ConfigTab = Window:AddTab({Title = "Config"})
Window.SaveManager.CreateUI(ConfigTab)
Window.InterfaceManager.CreateUI(ConfigTab)

-- Success notification
EnowLib:Notify({
    Title = "Loaded",
    Content = "Script loaded successfully!",
    Duration = 3,
    Type = "Success"
})
```

## Tips

1. **Always use pcall** for callbacks to prevent errors
2. **Cache values** that are used frequently
3. **Use sections** to organize components
4. **Add descriptions** to make UI more user-friendly
5. **Test on different executors** for compatibility
6. **Use SaveManager** to persist user settings
7. **Provide keybinds** for important actions
8. **Show notifications** for user feedback

## Common Patterns

### Auto-Farm Toggle
```lua
Tab:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        getgenv().AutoFarmEnabled = value
        
        if value then
            task.spawn(function()
                while getgenv().AutoFarmEnabled do
                    -- Farm logic
                    pcall(function()
                        -- Your code here
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})
```

### ESP Toggle
```lua
Tab:AddToggle({
    Title = "ESP",
    Default = false,
    Callback = function(value)
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                -- ESP logic
            end
        end
    end
})
```

### Teleport Dropdown
```lua
local locations = {
    ["Spawn"] = CFrame.new(0, 10, 0),
    ["Shop"] = CFrame.new(100, 10, 100),
    ["Boss"] = CFrame.new(-100, 10, -100)
}

Tab:AddDropdown({
    Title = "Teleport",
    Options = {"Spawn", "Shop", "Boss"},
    Callback = function(value)
        local cframe = locations[value]
        if cframe then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end
})
```

## Need Help?

- Check `API.md` for complete API reference
- See `example.lua` for comprehensive examples
- Read `README.md` for feature overview

## Version

EnowLib v2.0.0
