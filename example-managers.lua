-- EnowLib Managers Example
-- Demonstrates InterfaceManager and SaveManager usage

print("=== EnowLib Managers Example ===")

-- Load main library
local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Load managers
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/interfacemanager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/savemanager.lua"))()

print("Libraries loaded!")

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "Managers Demo",
    Size = UDim2.fromOffset(800, 500)
})

-- Initialize managers
InterfaceManager:Initialize(Window)
SaveManager:Initialize(Window)

print("Managers initialized!")

-- Settings Category
local SettingsCategory = Window:AddCategory({
    Title = "Settings",
    Icon = "rbxassetid://10734950309",
    Expanded = true
})

-- Interface Settings Tab
SettingsCategory:AddItem({
    Title = "Interface.lua",
    Icon = "rbxassetid://10723356507",
    Content = function(window)
        window:AddLabel({
            Text = "> Interface Manager",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "About Interface Manager",
            Content = "Manage UI visibility and keybinds. Press the minimize key to toggle UI visibility."
        })
        
        window:AddDivider()
        
        local interfaceSection = window:AddSection({
            Title = "Interface Settings"
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
        
        -- Manual controls
        interfaceSection:AddButton({
            Text = "Hide UI",
            Callback = function()
                InterfaceManager:Hide()
                print("[Interface] UI hidden")
            end
        })
        
        interfaceSection:AddButton({
            Text = "Show UI",
            Callback = function()
                InterfaceManager:Show()
                print("[Interface] UI shown")
            end
        })
        
        interfaceSection:AddButton({
            Text = "Toggle UI",
            Callback = function()
                InterfaceManager:Toggle()
                print("[Interface] UI toggled")
            end
        })
    end
})

-- Save Manager Tab
SettingsCategory:AddItem({
    Title = "SaveManager.lua",
    Icon = "rbxassetid://10723356507",
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

-- Demo Category with saveable components
local DemoCategory = Window:AddCategory({
    Title = "Demo",
    Icon = "rbxassetid://10723387563",
    Expanded = true
})

DemoCategory:AddItem({
    Title = "Components.lua",
    Icon = "rbxassetid://10723356507",
    Content = function(window)
        window:AddLabel({
            Text = "> Saveable Components Demo",
            Size = 18,
            Color = window.Theme.Colors.Accent,
            Font = window.Theme.Font.Bold
        })
        
        window:AddParagraph({
            Title = "Component Registration",
            Content = "These components are registered with SaveManager. Their values will be saved and restored when you save/load configs."
        })
        
        window:AddDivider()
        
        local demoSection = window:AddSection({
            Title = "Demo Settings"
        })
        
        -- Register components with SaveManager
        local toggle1 = demoSection:AddToggle({
            Text = "Enable Feature",
            Default = false,
            Callback = function(value)
                print("[Demo] Feature enabled:", value)
            end
        })
        SaveManager:RegisterComponent("demo_toggle1", toggle1)
        
        local slider1 = demoSection:AddSlider({
            Text = "Speed Value",
            Min = 1,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("[Demo] Speed:", value)
            end
        })
        SaveManager:RegisterComponent("demo_slider1", slider1)
        
        local dropdown1 = demoSection:AddDropdown({
            Text = "Select Mode",
            Options = {"Mode A", "Mode B", "Mode C"},
            Default = "Mode A",
            Callback = function(value)
                print("[Demo] Mode:", value)
            end
        })
        SaveManager:RegisterComponent("demo_dropdown1", dropdown1)
        
        local textbox1 = demoSection:AddTextBox({
            Text = "Player Name",
            Placeholder = "Enter name...",
            Default = "",
            Callback = function(value)
                print("[Demo] Name:", value)
            end
        })
        SaveManager:RegisterComponent("demo_textbox1", textbox1)
        
        window:AddDivider()
        
        window:AddLabel({
            Text = "Try changing values above, then save and load configs!",
            Color = window.Theme.Colors.Success
        })
    end
})

print("=== Managers Demo Ready! ===")
print("Press RightControl to toggle UI visibility")
print("Go to Settings > SaveManager.lua to save/load configs")
