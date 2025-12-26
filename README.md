# VaporUI - Vaporwave Tech Dark UI Library

Modern Roblox UI library dengan aesthetic vaporwave tech dark minimal.

## Features

- Modular component system
- Vaporwave tech dark theme
- Smooth animations
- Responsive design
- Single file build output
- Zero dependencies

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
│   └── notification.lua  # Notification system
└── animations/
    ├── fade.lua          # Fade animations
    ├── slide.lua         # Slide animations
    └── glow.lua          # Glow effects

build/
└── vaporui.lua           # Built single file

build.ps1                 # Build script
```

## Usage

```lua
local VaporUI = loadstring(game:HttpGet("your-url/vaporui.lua"))()

local Window = VaporUI:CreateWindow({
    Title = "VaporUI Demo",
    Size = UDim2.fromOffset(500, 400),
    Theme = "Vaporwave"
})

local Tab = Window:AddTab("Main")

Tab:AddButton({
    Title = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Build

```powershell
# Build single file
./build.ps1
```

## Theme

Vaporwave tech dark dengan color palette:
- Primary: Cyan/Pink gradient
- Background: Deep dark blue/purple
- Accent: Neon pink/cyan
- Text: White/light cyan
