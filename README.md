# EnowLib - Modern Roblox UI Library

Modern Roblox UI library with hacker IDE aesthetic and dark theme.

## Version 2.0.0

Complete rewrite with IDE-style interface, responsive design, and modular managers.

## Features

- **IDE-Style Interface** - VS Code-like tree structure with categories and items
- **12 UI Components** - Button, Toggle, Slider, Label, TextBox, Dropdown, MultiSelect, ColorPicker, Keybind, Section, Paragraph, Divider
- **Modular Managers** - Separate InterfaceManager and SaveManager modules
- **Responsive Design** - Touch and mouse input support for PC, tablet, mobile
- **Hacker Theme** - Green accent (#2ecc71), dark backgrounds, monospace font
- **Smooth Animations** - Quint easing with 0.3s duration
- **Single File Build** - Main library in one file (~84KB)
- **Separate Manager Builds** - Load managers only when needed
- **Performance Optimized** - Cached services, proper error handling

## Components

### Layout Components
- **Window** - Main container with draggable titlebar
- **Category** - Collapsible folder in sidebar tree
- **Item** - Clickable file in sidebar tree
- **Section** - Grouped component container
- **Divider** - Visual separator with optional text

### Input Components
- **Button** - Click action with callback
- **Toggle** - On/off switch with check icon
- **Slider** - Value slider with touch support
- **TextBox** - Text input field
- **Dropdown** - Single selection with optional search
- **MultiSelect** - Multiple selection with highlight
- **ColorPicker** - RGB color selector
- **Keybind** - Key binding selector

### Display Components
- **Label** - Simple text display
- **Paragraph** - Title + content text block

### Managers (Separate Modules)
- **InterfaceManager** - UI visibility and keybind management
- **SaveManager** - Component value persistence with JSON

## Project Structure

```
src/
├── core/
│   ├── init.lua          # Main library entry
│   ├── theme.lua         # Hacker theme with Lucide icons
│   └── utils.lua         # Utility functions (Tween, Merge, etc)
├── components/
│   ├── window.lua        # Main window with titlebar
│   ├── category.lua      # Sidebar folder (collapsible)
│   ├── item.lua          # Sidebar file (clickable tab)
│   ├── tab.lua           # Content area container
│   ├── button.lua        # Button component
│   ├── toggle.lua        # Toggle switch
│   ├── slider.lua        # Slider with touch support
│   ├── label.lua         # Text label
│   ├── textbox.lua       # Text input
│   ├── dropdown.lua      # Dropdown with search
│   ├── multiselect.lua   # Multi-selection
│   ├── colorpicker.lua   # Color picker
│   ├── keybind.lua       # Keybind selector
│   ├── section.lua       # Component grouping
│   ├── paragraph.lua     # Title + content
│   └── divider.lua       # Visual separator
└── managers/
    ├── interfacemanager.lua  # UI visibility management
    └── savemanager.lua       # Config persistence

build/
├── enowlib.lua           # Main library (~84KB)
└── managers/
    ├── interfacemanager.lua  # Interface manager (~2KB)
    └── savemanager.lua       # Save manager (~7KB)

build.js                  # Main build script
build-managers.js         # Managers build script
example.lua               # Main library example
example-managers.lua      # Managers usage example
```

## Usage

### Basic Usage

```lua
-- Load library
local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "My Script Hub",
    Size = UDim2.fromOffset(900, 600)
})

-- Add category (folder in sidebar)
local MainCategory = Window:AddCategory({
    Title = "Main",
    Icon = "rbxassetid://10723387563",
    Expanded = true
})

-- Add item (tab in sidebar)
MainCategory:AddItem({
    Title = "Features.lua",
    Icon = "rbxassetid://10723356507",
    Content = function(window)
        -- Add components to content area
        window:AddButton({
            Text = "Click Me",
            Callback = function()
                print("Button clicked!")
            end
        })
        
        window:AddToggle({
            Text = "Enable Feature",
            Default = false,
            Callback = function(value)
                print("Toggle:", value)
            end
        })
        
        window:AddSlider({
            Text = "Speed",
            Min = 1,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("Speed:", value)
            end
        })
        
        window:AddDropdown({
            Text = "Select Mode",
            Options = {"Mode A", "Mode B", "Mode C"},
            Default = "Mode A",
            Searchable = true,
            Callback = function(value)
                print("Mode:", value)
            end
        })
    end
})
```

### Using Managers

```lua
-- Load main library
local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Load managers (optional)
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/interfacemanager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/savemanager.lua"))()

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "Script Hub",
    Size = UDim2.fromOffset(900, 600)
})

-- Initialize managers
InterfaceManager:Initialize(Window)
SaveManager:Initialize(Window)

-- Interface Manager - Toggle UI visibility
InterfaceManager:SetMinimizeKey(Enum.KeyCode.RightControl)
InterfaceManager:Toggle()  -- Hide/show UI
InterfaceManager:Hide()    -- Hide UI
InterfaceManager:Show()    -- Show UI

-- Save Manager - Register components
local toggle = window:AddToggle({
    Text = "My Setting",
    Default = false,
    Callback = function(value) end
})
SaveManager:RegisterComponent("my_toggle", toggle)

-- Save/Load configs
SaveManager:Save("myconfig")
SaveManager:Load("myconfig")
SaveManager:Delete("myconfig")
SaveManager:ListConfigs()

-- Auto-save every 60 seconds
SaveManager:EnableAutoSave(60)
SaveManager:DisableAutoSave()
```

## Build

```bash
# Build main library
node build.js
# Output: build/enowlib.lua (~84KB)

# Build managers
node build-managers.js
# Output: build/managers/interfacemanager.lua (~2KB)
#         build/managers/savemanager.lua (~7KB)
```

## Theme

EnowLib uses a hacker/terminal aesthetic:

- **Colors**: Green accent (#2ecc71), dark backgrounds
- **Font**: RobotoMono (monospace)
- **Icons**: Lucide icon set
- **Animations**: Quint easing, 0.3s duration
- **Transparency**: Glass morphism effect

## Manager APIs

### InterfaceManager

```lua
InterfaceManager:Initialize(window)
InterfaceManager:Toggle()
InterfaceManager:Show()
InterfaceManager:Hide()
InterfaceManager:SetMinimizeKey(Enum.KeyCode.RightControl)
InterfaceManager:Destroy()
```

### SaveManager

```lua
SaveManager:Initialize(window)
SaveManager:RegisterComponent(id, component)
SaveManager:UnregisterComponent(id)
SaveManager:Save(configName)
SaveManager:Load(configName)
SaveManager:Delete(configName)
SaveManager:ListConfigs()
SaveManager:EnableAutoSave(interval)
SaveManager:DisableAutoSave()
SaveManager:Destroy()
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
