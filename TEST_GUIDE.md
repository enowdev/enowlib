# EnowLib Test Guide

Quick guide untuk testing EnowLib di Roblox executor.

## Quick Start

### Method 1: Load from GitHub (Recommended)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/example.lua"))()
```

### Method 2: Copy-Paste
1. Copy isi file `example.lua`
2. Paste ke executor
3. Execute

## What's Tested

### Tab 1: Basic Components
- ✅ Buttons (with notifications)
- ✅ Toggles (with state management)
- ✅ Sliders (with live values)
- ✅ Inputs (with validation)
- ✅ Dropdowns (with selection)

### Tab 2: Advanced Components
- ✅ Keybinds (with key detection)
- ✅ Color Picker (full HSV picker)
- ✅ Multi Dropdown (checkbox list)
- ✅ Progress Bars (animated)

### Tab 3: Player Features
- ✅ WalkSpeed control
- ✅ JumpPower control
- ✅ Infinite Jump
- ✅ Teleportation
- ✅ Character color change
- ✅ Character reset

### Tab 4: Config & Settings
- ✅ SaveManager UI
- ✅ InterfaceManager UI
- ✅ Theme switching
- ✅ Config save/load

### Tab 5: Info & Testing
- ✅ Library information
- ✅ System info
- ✅ GitHub links
- ✅ Notification tests
- ✅ UI toggle

## Features Demonstrated

### Notifications
- Info, Success, Warning, Error types
- Queue system
- Auto-dismiss
- Custom duration

### Player Control
```lua
-- WalkSpeed
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value

-- JumpPower
game.Players.LocalPlayer.Character.Humanoid.JumpPower = value

-- Teleport
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe

-- Color Change
for _, part in ipairs(character:GetChildren()) do
    part.Color = color
end
```

### Config Management
```lua
-- Save config
Window.SaveManager.Save("myconfig")

-- Load config
Window.SaveManager.Load("myconfig")

-- Auto-save
Window.SaveManager.AutoSave(60)
```

### Theme Management
```lua
-- Change theme
Window.InterfaceManager.SetTheme("Cyberpunk")

-- Set transparency
Window.InterfaceManager.SetTransparency(0.2)

-- Toggle acrylic
Window.InterfaceManager.SetAcrylic(true)
```

## Keyboard Shortcuts

- **RightControl** - Toggle UI visibility (default)
- **E** - Test keybind trigger (default)

## Testing Checklist

- [ ] Load library from GitHub
- [ ] Test all basic components
- [ ] Test all advanced components
- [ ] Test player features
- [ ] Test config save/load
- [ ] Test theme switching
- [ ] Test notifications
- [ ] Test keyboard shortcuts
- [ ] Test UI toggle
- [ ] Check console output

## Expected Output

Console should show:
```
Loading EnowLib from GitHub...
EnowLib loaded successfully!
========================================
EnowLib v2.0.0 Test Suite Loaded
========================================
Components: 13
Managers: 2
Themes: 5
Status: Ready
========================================
Press RightControl to toggle UI
========================================
```

## Troubleshooting

### Library won't load
- Check internet connection
- Verify executor supports HttpGet
- Try Method 2 (copy-paste)

### Components not working
- Check if game allows script execution
- Verify executor compatibility
- Check console for errors

### Player features not working
- Ensure character is spawned
- Check if game has anti-cheat
- Verify humanoid exists

## Supported Executors

Tested on:
- ✅ Synapse X
- ✅ Script-Ware
- ✅ Krnl
- ✅ Fluxus
- ✅ Electron

Should work on any executor with:
- HttpGet support
- loadstring support
- Basic Roblox API access

## Notes

- All features are safe to test
- No game-breaking exploits
- Respects game mechanics
- Clean code with error handling
- Performance optimized

## Links

- **GitHub**: https://github.com/enowdev/enowlib
- **Raw Library**: https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua
- **Raw Example**: https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/example.lua

## Version

EnowLib v2.0.0
Test Suite v1.0.0
