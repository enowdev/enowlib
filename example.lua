-- EnowLib v2.0.0 - Complete Example
-- Demonstrates all components and managers

print("=== EnowLib Loading ===")

-- Load main library (with cache buster)
local cacheBuster = "?v=" .. os.time()
local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua" .. cacheBuster))()

-- Load managers
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/interfacemanager.lua" .. cacheBuster))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/savemanager.lua" .. cacheBuster))()
local FloatingButtonManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/floatingbuttonmanager.lua" .. cacheBuster))()

print("Library and managers loaded!")

-- Lucide Icons
local Icons = {
    Folder = "rbxassetid://10723387563",
    FileCode = "rbxassetid://10723356507",
    Settings = "rbxassetid://10734950309",
    Play = "rbxassetid://10734923549"
}

print("Creating window...")

-- Window will auto-size based on device:
-- Mobile (< 1024px): 75% of viewport (3/4 of screen)
-- PC (>= 1024px): 900x600 default
local Window = EnowLib:CreateWindow({
    Title = "EnowHub UI Testing"
    -- Size, MinSize, MaxSize are optional - library handles it automatically
})

-- Initialize managers
InterfaceManager:Initialize(Window)
SaveManager:Initialize(Window)

-- Create floating button to toggle UI
local floatingButton = FloatingButtonManager.new({
    Size = UDim2.fromOffset(70, 70),
    Position = UDim2.new(1, -90, 0.5, -35),
    ImageId = "rbxassetid://103844172237114", -- Menu icon
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.3,
    CornerRadius = 35,
    OnClick = function()
        Window:Toggle()
        print("[FloatingButton] UI toggled!")
    end
})

print("Window and managers initialized!")

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

-- Interface Manager Tab
SettingsCategory:AddItem({
    Title = "Interface.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        window:AddLabel({
            Text = "> Interface Manager",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "About Interface Manager",
            Content = "Manage UI visibility, keybinds, and themes. Press the minimize key to toggle UI visibility. Choose from 8 beautiful themes inspired by Kiro IDE. Auto-resize is enabled by default."
        })
        
        window:AddDivider()
        
        local interfaceSection = window:AddSection({
            Title = "Interface Settings"
        })
        
        -- Theme selector
        local themes = InterfaceManager:GetThemeList()
        interfaceSection:AddDropdown({
            Text = "UI Theme",
            Options = themes,
            Default = InterfaceManager.Settings.CurrentTheme,
            Searchable = false,
            Callback = function(value)
                local success = InterfaceManager:SetTheme(value)
                if success then
                    print("[Interface] Theme changed to:", value)
                else
                    warn("[Interface] Failed to change theme")
                end
            end
        })
        
        -- Minimize keybind
        interfaceSection:AddKeybind({
            Text = "Minimize Key",
            Default = "RightControl",
            Callback = function(key)
                local keyCode = Enum.KeyCode[key]
                if keyCode then
                    InterfaceManager:SetMinimizeKey(keyCode)
                    print("[Interface] Minimize key set to:", key)
                end
            end
        })
        
        window:AddDivider()
        
        window:AddLabel({
            Text = "Auto-Resize Feature:",
            Color = window.Theme.Colors.Accent
        })
        
        window:AddLabel({
            Text = "Window automatically scales when screen size changes (PC resize, mobile split-screen, tablet rotation)",
            Color = window.Theme.Colors.TextDim
        })
        
        window:AddLabel({
            Text = "Min: 600x400 | Max: 1400x900 | Scale: 0.5x - 1.2x",
            Color = window.Theme.Colors.TextDim
        })
        
        window:AddDivider()
        
        window:AddLabel({
            Text = "Available Themes:",
            Color = window.Theme.Colors.Accent
        })
        
        window:AddLabel({
            Text = "Hacker (Green), Ocean (Blue), Purple (Violet), Sunset (Pink)",
            Color = window.Theme.Colors.TextDim
        })
        
        window:AddLabel({
            Text = "Midnight (Dark Blue), Forest (Green), Amber (Orange), Crimson (Red)",
            Color = window.Theme.Colors.TextDim
        })
    end
})

-- Save Manager Tab
SettingsCategory:AddItem({
    Title = "SaveManager.lua",
    Icon = Icons.FileCode,
    Content = function(window)
        window:AddLabel({
            Text = "> Save Manager",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "About Save Manager",
            Content = "Save and load your configurations. Register components to automatically save their values."
        })
        
        window:AddDivider()
        
        local saveSection = window:AddSection({
            Title = "Configuration Management"
        })
        
        -- Config name
        local configName = "myconfig"
        
        saveSection:AddTextBox({
            Text = "Config Name",
            Placeholder = "Enter config name...",
            Default = "myconfig",
            Callback = function(value)
                configName = value
                print("[SaveManager] Config name set to:", value)
            end
        })
        
        -- Save button
        saveSection:AddButton({
            Text = "Save Config",
            Callback = function()
                local success = SaveManager:Save(configName)
                if success then
                    print("[SaveManager] Config saved:", configName)
                else
                    warn("[SaveManager] Failed to save config")
                end
            end
        })
        
        -- Load dropdown
        local configs = SaveManager:ListConfigs()
        
        if #configs > 0 then
            saveSection:AddDropdown({
                Text = "Load Config",
                Options = configs,
                Default = configs[1],
                Callback = function(value)
                    local success, count = SaveManager:Load(value)
                    if success then
                        print("[SaveManager] Config loaded:", value, "(" .. count .. " components)")
                    else
                        warn("[SaveManager] Failed to load config")
                    end
                end
            })
            
            -- Delete dropdown
            saveSection:AddDropdown({
                Text = "Delete Config",
                Options = configs,
                Default = configs[1],
                Callback = function(value)
                    local success = SaveManager:Delete(value)
                    if success then
                        print("[SaveManager] Config deleted:", value)
                    else
                        warn("[SaveManager] Failed to delete config")
                    end
                end
            })
        else
            saveSection:AddLabel({
                Text = "No saved configs found",
                Color = window.Theme.Colors.TextDim
            })
        end
        
        -- Auto-save toggle
        saveSection:AddToggle({
            Text = "Auto Save (60s)",
            Default = false,
            Callback = function(value)
                if value then
                    SaveManager:EnableAutoSave(60)
                    print("[SaveManager] Auto-save enabled")
                else
                    SaveManager:DisableAutoSave()
                    print("[SaveManager] Auto-save disabled")
                end
            end
        })
    end
})

-- All Components Test with SaveManager
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
            Content = "This tab demonstrates all available components in EnowLib. Components marked with [SAVED] are registered with SaveManager and will persist their values."
        })
        
        window:AddDivider({Text = "Basic Components"})
        
        -- Label
        window:AddLabel({
            Text = "This is a Label component - used for simple text display"
        })
        
        -- Paragraph
        window:AddParagraph({
            Title = "Paragraph Component",
            Content = "This is a Paragraph component with title and content. It automatically wraps text and adjusts height based on content length. Perfect for descriptions and instructions."
        })
        
        -- Divider
        window:AddDivider()
        
        window:AddDivider({Text = "Input Components (Saveable)"})
        
        -- Button
        window:AddButton({
            Text = "Click Me - Button Component",
            Callback = function()
                print("[Test] Button clicked!")
            end
        })
        
        -- Toggle (Saved)
        local toggle1 = window:AddToggle({
            Text = "[SAVED] Toggle Component",
            Default = false,
            Callback = function(value)
                print("[Test] Toggle:", value)
            end
        })
        SaveManager:RegisterComponent("test_toggle1", toggle1)
        
        -- Slider (Saved)
        local slider1 = window:AddSlider({
            Text = "[SAVED] Slider Component",
            Min = 1,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("[Test] Slider:", value)
            end
        })
        SaveManager:RegisterComponent("test_slider1", slider1)
        
        -- TextBox (Saved)
        local textbox1 = window:AddTextBox({
            Text = "[SAVED] TextBox Component",
            Placeholder = "Type something here...",
            Default = "",
            Callback = function(value)
                print("[Test] TextBox:", value)
            end
        })
        SaveManager:RegisterComponent("test_textbox1", textbox1)
        
        -- Dropdown (Saved)
        local dropdown1 = window:AddDropdown({
            Text = "[SAVED] Dropdown Component",
            Options = {"Option A", "Option B", "Option C", "Option D"},
            Default = "Option A",
            Searchable = false,
            Callback = function(value)
                print("[Test] Dropdown:", value)
            end
        })
        SaveManager:RegisterComponent("test_dropdown1", dropdown1)
        
        -- Dropdown with Search
        window:AddDropdown({
            Text = "Searchable Dropdown",
            Options = {"Apple", "Banana", "Cherry", "Dragon Fruit", "Elderberry", "Fig", "Grape", "Honeydew"},
            Default = "Apple",
            Searchable = true,
            Callback = function(value)
                print("[Test] Searchable Dropdown:", value)
            end
        })
        
        -- MultiSelect (Saved)
        local multiselect1 = window:AddMultiSelect({
            Text = "[SAVED] MultiSelect Component",
            Options = {"Feature 1", "Feature 2", "Feature 3", "Feature 4"},
            Default = {"Feature 1"},
            Callback = function(values)
                print("[Test] MultiSelect:", table.concat(values, ", "))
            end
        })
        SaveManager:RegisterComponent("test_multiselect1", multiselect1)
        
        -- ColorPicker (Saved)
        local colorpicker1 = window:AddColorPicker({
            Text = "[SAVED] ColorPicker Component",
            Default = Color3.fromRGB(46, 204, 113),
            Callback = function(color)
                print("[Test] ColorPicker:", color)
            end
        })
        SaveManager:RegisterComponent("test_colorpicker1", colorpicker1)
        
        -- Keybind (Saved)
        local keybind1 = window:AddKeybind({
            Text = "[SAVED] Keybind Component",
            Default = "None",
            Callback = function(key)
                print("[Test] Keybind:", key)
            end
        })
        SaveManager:RegisterComponent("test_keybind1", keybind1)
        
        window:AddDivider({Text = "Section Component"})
        
        -- Section with nested components
        local testSection = window:AddSection({
            Title = "Section Component Example"
        })
        
        testSection:AddLabel({
            Text = "Components inside a Section are grouped together"
        })
        
        local toggle2 = testSection:AddToggle({
            Text = "[SAVED] Nested Toggle",
            Default = true,
            Callback = function(value)
                print("[Test] Nested Toggle:", value)
            end
        })
        SaveManager:RegisterComponent("test_toggle2", toggle2)
        
        local slider2 = testSection:AddSlider({
            Text = "[SAVED] Nested Slider",
            Min = 0,
            Max = 10,
            Default = 5,
            Callback = function(value)
                print("[Test] Nested Slider:", value)
            end
        })
        SaveManager:RegisterComponent("test_slider2", slider2)
        
        testSection:AddButton({
            Text = "Nested Button",
            Callback = function()
                print("[Test] Nested Button clicked!")
            end
        })
        
        window:AddDivider()
        
        window:AddLabel({
            Text = "All 12 components working! Go to SaveManager.lua to save/load configs.",
            Color = window.Theme.Colors.Success
        })
        
        window:AddLabel({
            Text = "Components: Label, Paragraph, Divider, Button, Toggle, Slider, TextBox, Dropdown, MultiSelect, ColorPicker, Keybind, Section",
            Color = window.Theme.Colors.TextDim
        })
        
        print("[Example] All Components test loaded!")
    end
})

print("=== EnowLib Loaded Successfully! ===")
print("Press RightControl to toggle UI visibility")
print("Go to Settings > SaveManager.lua to save/load configs")
print("Go to Settings > Interface.lua to change themes")
