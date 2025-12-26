# EnowLib - Vaporwave Tech Dark UI Library

Modern Roblox UI library dengan aesthetic vaporwave tech dark minimal.

## Version 2.0.0

Complete rewrite dengan advanced features, managers, dan 13 komponen.

## Features

- **13 UI Components** - Button, Toggle, Slider, Input, Dropdown, Keybind, ColorPicker, MultiDropdown, ProgressBar, Label, Section, Notification, Tab
- **SaveManager** - Automatic config save/load system
- **InterfaceManager** - Theme switching & UI customization
- **5 Built-in Themes** - Vaporwave, Dark, Light, Cyberpunk, Neon
- **Modular Architecture** - Clean, maintainable code structure
- **Smooth Animations** - Tween-based animations with callbacks
- **Responsive Design** - Auto-sizing and adaptive layouts
- **Single File Build** - One file, zero dependencies
- **Performance Optimized** - Efficient rendering and memory management

## Components

### Basic Components
- **Button** - Interactive button with ripple effect
- **Toggle** - Animated switch component
- **Slider** - Value slider with live preview
- **Input** - Text input with focus effects
- **Dropdown** - Single selection menu
- **Label** - Text display with auto-sizing
- **Section** - Visual divider with gradient

### Advanced Components
- **Keybind** - Key binding with listener
- **ColorPicker** - Full HSV color picker with RGB/Hex input
- **MultiDropdown** - Multi-selection checkbox list
- **ProgressBar** - Animated progress indicator
- **Notification** - Toast notification system
- **Tab** - Tab navigation system

### Managers
- **SaveManager** - Config persistence with JSON
- **InterfaceManager** - Theme & UI state management

## Project Structure

```
src/
├── core/
│   ├── init.lua          # Main library entry
│   ├── theme.lua         # Color scheme & styling
│   └── utils.lua         # Utility functions
├── components/
│   ├── window.lua        # Main window container
│   ├── tab.lua           # Tab system
│   ├── button.lua        # Button component
│   ├── toggle.lua        # Toggle switch
│   ├── slider.lua        # Slider component
│   ├── dropdown.lua      # Dropdown menu
│   ├── input.lua         # Text input
│   ├── label.lua         # Text label
│   ├── section.lua       # Section divider
│   ├── keybind.lua       # Keybind selector
│   ├── colorpicker.lua   # Color picker
│   ├── multidropdown.lua # Multi-select dropdown
│   ├── progressbar.lua   # Progress bar
│   └── notification.lua  # Notification system
└── managers/
    ├── savemanager.lua   # Config save/load
    └── interfacemanager.lua # Theme & UI management

build/
└── enowlib.lua           # Built single file

build.ps1                 # Build script
example.lua               # Complete usage example
```

## Usage

```lua
local EnowLib = loadstring(game:HttpGet("your-url/enowlib.lua"))()

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "EnowLib Demo",
    Size = UDim2.fromOffset(580, 460)
})

-- Create tab
local Tab = Window:AddTab({Title = "Main"})

-- Add components
Tab:AddButton({
    Title = "Click Me",
    Description = "Button with callback",
    Callback = function()
        print("Clicked!")
    end
})

Tab:AddToggle({
    Title = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

Tab:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})

Tab:AddKeybind({
    Title = "Toggle Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Key:", key.Name)
    end
})

Tab:AddColorPicker({
    Title = "Theme Color",
    Default = Color3.fromRGB(138, 43, 226),
    Callback = function(color)
        print("Color:", color)
    end
})

Tab:AddMultiDropdown({
    Title = "Select Features",
    Options = {"Feature 1", "Feature 2", "Feature 3"},
    Default = {"Feature 1"},
    Callback = function(values)
        print("Selected:", values)
    end
})

local progress = Tab:AddProgressBar({
    Title = "Loading",
    Min = 0,
    Max = 100,
    Value = 0
})

-- Update progress
progress:SetValue(50)
progress:Increment(10)

-- Notifications
EnowLib:Notify({
    Title = "Success",
    Content = "Operation completed!",
    Duration = 3,
    Type = "Success"
})

-- SaveManager
local ConfigTab = Window:AddTab({Title = "Config"})
Window.SaveManager.CreateUI(ConfigTab)

-- InterfaceManager
Window.InterfaceManager.CreateUI(ConfigTab)
```

## Build

```powershell
# Build single file
./build.ps1

# Output: build/enowlib.lua (~115KB)
```

## Themes

EnowLib includes 5 built-in themes:

- **Vaporwave** (Default) - Purple/Cyan/Pink gradient
- **Dark** - Monochrome dark theme
- **Light** - Blue-tinted light theme
- **Cyberpunk** - Magenta/Cyan neon
- **Neon** - Green/Pink/Cyan bright

Change theme via InterfaceManager:
```lua
Window.InterfaceManager.SetTheme("Cyberpunk")
```

## Configuration

### SaveManager
Automatically saves component values to JSON files:
```lua
Window.SaveManager.Save("myconfig")
Window.SaveManager.Load("myconfig")
Window.SaveManager.Delete("myconfig")
Window.SaveManager.AutoSave(60) -- Auto-save every 60 seconds
```

### InterfaceManager
Manage UI appearance and behavior:
```lua
Window.InterfaceManager.SetTheme("Dark")
Window.InterfaceManager.SetTransparency(0.2)
Window.InterfaceManager.SetAcrylic(true)
Window.InterfaceManager.SetMinimizeKey(Enum.KeyCode.RightControl)
```

## Development

Built with EnowSploit framework standards:
- No emoji in code
- Proper error handling with pcall
- Cached game services
- Performance optimized
- Clean modular architecture

See `.kiro/steering/vaporui-standards.md` for complete coding standards.

## Version

EnowLib v2.0.0
