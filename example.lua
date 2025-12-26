-- EnowLib v2.0.0 - Complete Example
-- Hacker IDE Theme with All Components

print("=== EnowLib Loading ===")
print("Fetching library from GitHub...")

local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

print("Library loaded successfully!")

-- Lucide Icons
local Icons = {
    Folder = "rbxassetid://10723387563",
    FileCode = "rbxassetid://10723356507",
    Settings = "rbxassetid://10734950309",
    Play = "rbxassetid://10734923549"
}

print("Creating window...")

local Window = EnowLib:CreateWindow({
    Title = "EnowHub UI Testing",
    Size = UDim2.fromOffset(900, 600)
})

print("Window created!")

-- Universal Category
print("Adding Universal category...")
local UniversalCategory = Window:AddCategory({
    Title = "Universal",
    Icon = Icons.Folder,
    Expanded = true
})

-- ESP Tab
UniversalCategory:AddItem({
    Title = "ESP.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading ESP tab content...")
        
        window:AddLabel({
            Text = "> ESP Features",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "About ESP",
            Content = "Extra Sensory Perception allows you to see players, items, and other entities through walls with customizable colors and information."
        })
        
        window:AddDivider()
        
        local espSection = window:AddSection({
            Title = "ESP Settings"
        })
        
        espSection:AddToggle({
            Text = "Enable ESP",
            Default = false,
            Callback = function(value)
                print("[ESP] Enabled:", value)
            end
        })
        
        espSection:AddToggle({
            Text = "Show Names",
            Default = true,
            Callback = function(value)
                print("[ESP] Show Names:", value)
            end
        })
        
        espSection:AddToggle({
            Text = "Show Distance",
            Default = true,
            Callback = function(value)
                print("[ESP] Show Distance:", value)
            end
        })
        
        espSection:AddSlider({
            Text = "Max Distance",
            Min = 100,
            Max = 5000,
            Default = 1000,
            Callback = function(value)
                print("[ESP] Max Distance:", value)
            end
        })
        
        espSection:AddColorPicker({
            Text = "ESP Color",
            Default = Color3.fromRGB(46, 204, 113),
            Callback = function(color)
                print("[ESP] Color changed:", color)
            end
        })
        
        print("[Example] ESP tab loaded!")
    end
})

-- Aimbot Tab
UniversalCategory:AddItem({
    Title = "Aimbot.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading Aimbot tab content...")
        
        window:AddLabel({
            Text = "> Aimbot Settings",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "About Aimbot",
            Content = "Automatically aims at targets with customizable FOV, smoothness, and target selection options."
        })
        
        window:AddDivider()
        
        local aimbotSection = window:AddSection({
            Title = "Aimbot Configuration"
        })
        
        aimbotSection:AddToggle({
            Text = "Enable Aimbot",
            Default = false,
            Callback = function(value)
                print("[Aimbot] Enabled:", value)
            end
        })
        
        aimbotSection:AddSlider({
            Text = "FOV Size",
            Min = 50,
            Max = 500,
            Default = 200,
            Callback = function(value)
                print("[Aimbot] FOV:", value)
            end
        })
        
        aimbotSection:AddSlider({
            Text = "Smoothness",
            Min = 1,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("[Aimbot] Smoothness:", value)
            end
        })
        
        aimbotSection:AddKeybind({
            Text = "Aimbot Key",
            Default = "None",
            Callback = function(key)
                print("[Aimbot] Keybind set to:", key)
            end
        })
        
        print("[Example] Aimbot tab loaded!")
    end
})

-- WalkSpeed Tab
UniversalCategory:AddItem({
    Title = "WalkSpeed.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading WalkSpeed tab content...")
        
        window:AddLabel({
            Text = "> Movement Settings",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddDivider()
        
        local movementSection = window:AddSection({
            Title = "Speed Configuration"
        })
        
        movementSection:AddToggle({
            Text = "Enable Speed Hack",
            Default = false,
            Callback = function(value)
                print("[Movement] Speed Hack:", value)
            end
        })
        
        movementSection:AddSlider({
            Text = "Walk Speed",
            Min = 16,
            Max = 200,
            Default = 16,
            Callback = function(value)
                print("[Movement] WalkSpeed:", value)
            end
        })
        
        movementSection:AddSlider({
            Text = "Jump Power",
            Min = 50,
            Max = 300,
            Default = 50,
            Callback = function(value)
                print("[Movement] JumpPower:", value)
            end
        })
        
        print("[Example] WalkSpeed tab loaded!")
    end
})

-- Combat Category
print("Adding Combat category...")
local CombatCategory = Window:AddCategory({
    Title = "Combat",
    Icon = Icons.Folder,
    Expanded = false
})

CombatCategory:AddItem({
    Title = "KillAura.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading KillAura tab content...")
        
        window:AddLabel({
            Text = "> KillAura Settings",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddDivider()
        
        local killAuraSection = window:AddSection({
            Title = "Attack Configuration"
        })
        
        killAuraSection:AddToggle({
            Text = "Enable KillAura",
            Default = false,
            Callback = function(value)
                print("[KillAura] Enabled:", value)
            end
        })
        
        killAuraSection:AddSlider({
            Text = "Attack Range",
            Min = 5,
            Max = 50,
            Default = 15,
            Callback = function(value)
                print("[KillAura] Range:", value)
            end
        })
        
        killAuraSection:AddSlider({
            Text = "Attack Speed",
            Min = 1,
            Max = 20,
            Default = 10,
            Callback = function(value)
                print("[KillAura] Speed:", value)
            end
        })
        
        print("[Example] KillAura tab loaded!")
    end
})

-- Settings Category
print("Adding Settings category...")
local SettingsCategory = Window:AddCategory({
    Title = "Settings",
    Icon = Icons.Settings,
    Expanded = false
})

SettingsCategory:AddItem({
    Title = "General.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading General settings...")
        
        window:AddLabel({
            Text = "> General Settings",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "Configuration",
            Content = "Configure general application settings and preferences for the best experience."
        })
        
        window:AddDivider()
        
        local generalSection = window:AddSection({
            Title = "General Options"
        })
        
        generalSection:AddToggle({
            Text = "Auto Save",
            Default = true,
            Callback = function(value)
                print("[Settings] Auto Save:", value)
            end
        })
        
        generalSection:AddToggle({
            Text = "Notifications",
            Default = true,
            Callback = function(value)
                print("[Settings] Notifications:", value)
            end
        })
        
        generalSection:AddSlider({
            Text = "UI Scale",
            Min = 80,
            Max = 120,
            Default = 100,
            Callback = function(value)
                print("[Settings] UI Scale:", value .. "%")
            end
        })
        
        generalSection:AddTextBox({
            Text = "Config Name",
            Placeholder = "Enter config name...",
            Default = "default",
            Callback = function(value)
                print("[Settings] Config Name:", value)
            end
        })
        
        generalSection:AddDropdown({
            Text = "Theme",
            Options = {"Dark", "Darker", "Darkest"},
            Default = "Dark",
            Callback = function(value)
                print("[Settings] Theme:", value)
            end
        })
        
        print("[Example] General settings loaded!")
    end
})

-- All Components Test
SettingsCategory:AddItem({
    Title = "Components.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        print("[Example] Loading All Components test...")
        
        window:AddLabel({
            Text = "> All Components Test",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "Component Testing",
            Content = "This tab demonstrates all available components in EnowLib. Test each component to ensure responsive design works on all devices (PC, tablet, mobile)."
        })
        
        window:AddDivider({Text = "Input Components"})
        
        -- Button
        window:AddButton({
            Text = "Test Button",
            Callback = function()
                print("[Test] Button clicked!")
            end
        })
        
        -- Toggle
        window:AddToggle({
            Text = "Test Toggle",
            Default = false,
            Callback = function(value)
                print("[Test] Toggle:", value)
            end
        })
        
        -- Slider
        window:AddSlider({
            Text = "Test Slider",
            Min = 1,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("[Test] Slider:", value)
            end
        })
        
        -- TextBox
        window:AddTextBox({
            Text = "Test TextBox",
            Placeholder = "Type something...",
            Default = "",
            Callback = function(value)
                print("[Test] TextBox:", value)
            end
        })
        
        -- Dropdown
        window:AddDropdown({
            Text = "Test Dropdown",
            Options = {"Option A", "Option B", "Option C"},
            Default = "Option A",
            Callback = function(value)
                print("[Test] Dropdown:", value)
            end
        })
        
        -- ColorPicker
        window:AddColorPicker({
            Text = "Test ColorPicker",
            Default = Color3.fromRGB(46, 204, 113),
            Callback = function(color)
                print("[Test] ColorPicker:", color)
            end
        })
        
        -- Keybind
        window:AddKeybind({
            Text = "Test Keybind",
            Default = "None",
            Callback = function(key)
                print("[Test] Keybind:", key)
            end
        })
        
        window:AddDivider({Text = "Layout Components"})
        
        -- Label
        window:AddLabel({
            Text = "This is a test label component",
            Color = window.Theme.Colors.Success
        })
        
        -- Paragraph
        window:AddParagraph({
            Title = "About EnowLib",
            Content = "EnowLib is a modern UI library for Roblox with responsive design, smooth animations, and a hacker-style IDE theme. All components are optimized for PC, tablet, and mobile devices with touch-friendly sizes."
        })
        
        window:AddDivider()
        
        window:AddLabel({
            Text = "All components are fully responsive!",
            Color = window.Theme.Colors.Accent
        })
        
        print("[Example] All Components test loaded!")
    end
})

print("=== EnowLib Loaded Successfully! ===")
print("Click any tab in the sidebar to test components")
