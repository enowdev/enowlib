-- EnowLib InterfaceManager
-- Handles UI state and theme management

local InterfaceManager = {}
InterfaceManager.Settings = {
    theme = "Vaporwave",
    transparency = 0,
    acrylic = true,
    minimizeKey = Enum.KeyCode.LeftControl
}

function InterfaceManager.Initialize(window)
    InterfaceManager.Window = window
    InterfaceManager.SetupMinimizeKey()
end

function InterfaceManager.SetupMinimizeKey()
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == InterfaceManager.Settings.minimizeKey then
            InterfaceManager.Window:Toggle()
        end
    end)
end

function InterfaceManager.SetTheme(themeName)
    InterfaceManager.Settings.theme = themeName
    
    -- Apply theme colors
    local themes = {
        Vaporwave = {
            Primary = Color3.fromRGB(138, 43, 226),
            Accent = Color3.fromRGB(0, 255, 255),
            AccentPink = Color3.fromRGB(255, 20, 147)
        },
        Dark = {
            Primary = Color3.fromRGB(100, 100, 100),
            Accent = Color3.fromRGB(150, 150, 150),
            AccentPink = Color3.fromRGB(120, 120, 120)
        },
        Light = {
            Primary = Color3.fromRGB(70, 130, 180),
            Accent = Color3.fromRGB(100, 149, 237),
            AccentPink = Color3.fromRGB(135, 206, 250)
        },
        Cyberpunk = {
            Primary = Color3.fromRGB(255, 0, 255),
            Accent = Color3.fromRGB(0, 255, 255),
            AccentPink = Color3.fromRGB(255, 0, 128)
        },
        Neon = {
            Primary = Color3.fromRGB(57, 255, 20),
            Accent = Color3.fromRGB(255, 20, 147),
            AccentPink = Color3.fromRGB(0, 255, 255)
        }
    }
    
    local theme = themes[themeName]
    if theme then
        for key, color in pairs(theme) do
            InterfaceManager.Window.Theme.Colors[key] = color
        end
        
        InterfaceManager.RefreshUI()
    end
end

function InterfaceManager.SetTransparency(value)
    InterfaceManager.Settings.transparency = value
    
    -- Apply transparency to main container
    if InterfaceManager.Window.Container then
        InterfaceManager.Window.Container.BackgroundTransparency = value
    end
end

function InterfaceManager.SetAcrylic(enabled)
    InterfaceManager.Settings.acrylic = enabled
    
    -- Toggle blur effect
    if InterfaceManager.Window.Container then
        local blur = InterfaceManager.Window.Container:FindFirstChild("BlurEffect")
        
        if enabled and not blur then
            blur = Instance.new("BlurEffect")
            blur.Size = 10
            blur.Parent = InterfaceManager.Window.Container
        elseif not enabled and blur then
            blur:Destroy()
        end
    end
end

function InterfaceManager.SetMinimizeKey(keyCode)
    InterfaceManager.Settings.minimizeKey = keyCode
end

function InterfaceManager.RefreshUI()
    -- Refresh all UI elements with new theme
    if not InterfaceManager.Window then return end
    
    local theme = InterfaceManager.Window.Theme
    
    -- Update window
    if InterfaceManager.Window.Container then
        InterfaceManager.Window.Container.BackgroundColor3 = theme.Colors.Background
        
        local stroke = InterfaceManager.Window.Container:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = theme.Colors.BorderGlow
        end
    end
    
    -- Update all tabs and components
    for _, tab in ipairs(InterfaceManager.Window.Tabs) do
        InterfaceManager.RefreshTab(tab)
    end
end

function InterfaceManager.RefreshTab(tab)
    local theme = InterfaceManager.Window.Theme
    
    -- Update tab button
    if tab.Button then
        if tab.Visible then
            tab.Button.BackgroundColor3 = theme.Colors.Active
            tab.Button.TextColor3 = theme.Colors.Text
        else
            tab.Button.BackgroundColor3 = theme.Colors.BackgroundLight
            tab.Button.TextColor3 = theme.Colors.TextDim
        end
    end
    
    -- Update components
    for _, component in ipairs(tab.Components) do
        InterfaceManager.RefreshComponent(component)
    end
end

function InterfaceManager.RefreshComponent(component)
    local theme = InterfaceManager.Window.Theme
    
    if not component.Container then return end
    
    -- Update container colors
    component.Container.BackgroundColor3 = theme.Colors.BackgroundLight
    
    local stroke = component.Container:FindFirstChild("UIStroke")
    if stroke then
        stroke.Color = theme.Colors.Border
    end
    
    -- Update component-specific elements
    if component.Fill then
        component.Fill.BackgroundColor3 = theme.Colors.Primary
    end
    
    if component.Switch then
        if component.Value then
            component.Switch.BackgroundColor3 = theme.Colors.Primary
        end
    end
end

function InterfaceManager.SaveSettings()
    if not writefile then return end
    
    local data = game:GetService("HttpService"):JSONEncode(InterfaceManager.Settings)
    
    pcall(function()
        if not isfolder("EnowLib") then
            makefolder("EnowLib")
        end
        writefile("EnowLib/interface.json", data)
    end)
end

function InterfaceManager.LoadSettings()
    if not readfile or not isfile("EnowLib/interface.json") then
        return
    end
    
    local success, content = pcall(readfile, "EnowLib/interface.json")
    if not success then return end
    
    local data
    success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    
    if success and data then
        InterfaceManager.Settings = data
        InterfaceManager.ApplySettings()
    end
end

function InterfaceManager.ApplySettings()
    if InterfaceManager.Settings.theme then
        InterfaceManager.SetTheme(InterfaceManager.Settings.theme)
    end
    
    if InterfaceManager.Settings.transparency then
        InterfaceManager.SetTransparency(InterfaceManager.Settings.transparency)
    end
    
    if InterfaceManager.Settings.acrylic ~= nil then
        InterfaceManager.SetAcrylic(InterfaceManager.Settings.acrylic)
    end
    
    if InterfaceManager.Settings.minimizeKey then
        InterfaceManager.SetMinimizeKey(InterfaceManager.Settings.minimizeKey)
    end
end

function InterfaceManager.CreateUI(tab)
    if not tab then return end
    
    tab:AddSection({Title = "INTERFACE"})
    
    -- Theme selector
    tab:AddDropdown({
        Title = "Theme",
        Description = "Select UI theme",
        Options = {"Vaporwave", "Dark", "Light", "Cyberpunk", "Neon"},
        Default = InterfaceManager.Settings.theme,
        Callback = function(value)
            InterfaceManager.SetTheme(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Transparency slider
    tab:AddSlider({
        Title = "Transparency",
        Description = "UI background transparency",
        Min = 0,
        Max = 1,
        Default = InterfaceManager.Settings.transparency,
        Increment = 0.1,
        Callback = function(value)
            InterfaceManager.SetTransparency(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Acrylic toggle
    tab:AddToggle({
        Title = "Acrylic Effect",
        Description = "Enable blur effect",
        Default = InterfaceManager.Settings.acrylic,
        Callback = function(value)
            InterfaceManager.SetAcrylic(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Minimize key
    tab:AddKeybind({
        Title = "Minimize Key",
        Description = "Key to toggle UI visibility",
        Default = InterfaceManager.Settings.minimizeKey,
        Callback = function(value)
            InterfaceManager.SetMinimizeKey(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    tab:AddSection({Title = "ACTIONS"})
    
    -- Refresh UI button
    tab:AddButton({
        Title = "Refresh UI",
        Description = "Reload UI with current theme",
        Callback = function()
            InterfaceManager.RefreshUI()
            InterfaceManager.Window.EnowLib:Notify({
                Title = "UI Refreshed",
                Content = "Interface has been refreshed",
                Duration = 2,
                Type = "Success"
            })
        end
    })
    
    -- Reset settings button
    tab:AddButton({
        Title = "Reset Settings",
        Description = "Reset to default settings",
        Callback = function()
            InterfaceManager.Settings = {
                theme = "Vaporwave",
                transparency = 0,
                acrylic = true,
                minimizeKey = Enum.KeyCode.LeftControl
            }
            InterfaceManager.ApplySettings()
            InterfaceManager.SaveSettings()
            
            InterfaceManager.Window.EnowLib:Notify({
                Title = "Settings Reset",
                Content = "Interface settings have been reset",
                Duration = 2,
                Type = "Success"
            })
        end
    })
end

return InterfaceManager
