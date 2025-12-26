-- EnowLib v2.0.0 Complete Test Example
-- Test all components and features
-- Load from GitHub: https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua

print("Loading EnowLib from GitHub...")

-- Add cache buster to force fresh download
local cacheBuster = tostring(os.time())
local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua?" .. cacheBuster))()

if not EnowLib then
    error("Failed to load EnowLib!")
end

print("EnowLib loaded successfully!")
print("Version:", EnowLib.Version)

-- Create window
local Window = EnowLib:CreateWindow({
    Title = "EnowLib v2.0 Test Suite",
    Size = UDim2.fromOffset(580, 460)
})

-- ========================================
-- TAB 1: BASIC COMPONENTS
-- ========================================
local BasicTab = Window:AddTab({Title = "Basic"})

BasicTab:AddLabel({
    Text = "EnowLib v2.0.0 - Complete Component Test",
    Size = "Large",
    Color = Color3.fromRGB(138, 43, 226)
})

BasicTab:AddLabel({
    Text = "Testing all 13 components with live functionality",
    Size = "Regular",
    Color = Color3.fromRGB(150, 150, 170)
})

BasicTab:AddSection({Title = "BUTTONS"})

BasicTab:AddButton({
    Title = "Simple Button",
    Description = "Click to show notification",
    Callback = function()
        EnowLib:Notify({
            Title = "Button Clicked",
            Content = "Simple button works!",
            Duration = 2,
            Type = "Success"
        })
    end
})

BasicTab:AddButton({
    Title = "Test All Notifications",
    Description = "Shows all notification types",
    Callback = function()
        EnowLib:Notify({
            Title = "Info",
            Content = "This is an info notification",
            Duration = 2,
            Type = "Info"
        })
        
        task.wait(0.5)
        
        EnowLib:Notify({
            Title = "Success",
            Content = "This is a success notification",
            Duration = 2,
            Type = "Success"
        })
        
        task.wait(0.5)
        
        EnowLib:Notify({
            Title = "Warning",
            Content = "This is a warning notification",
            Duration = 2,
            Type = "Warning"
        })
        
        task.wait(0.5)
        
        EnowLib:Notify({
            Title = "Error",
            Content = "This is an error notification",
            Duration = 2,
            Type = "Error"
        })
    end
})

BasicTab:AddSection({Title = "TOGGLES"})

local testToggle = BasicTab:AddToggle({
    Title = "Test Toggle",
    Description = "Toggle on/off to test",
    Default = false,
    Callback = function(value)
        print("Toggle state:", value)
        EnowLib:Notify({
            Title = "Toggle Changed",
            Content = "Toggle is now: " .. tostring(value),
            Duration = 2,
            Type = "Info"
        })
    end
})

BasicTab:AddToggle({
    Title = "WalkSpeed Boost",
    Description = "Increase walk speed to 50",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if value then
                player.Character.Humanoid.WalkSpeed = 50
                EnowLib:Notify({
                    Title = "Speed Boost",
                    Content = "WalkSpeed set to 50",
                    Duration = 2,
                    Type = "Success"
                })
            else
                player.Character.Humanoid.WalkSpeed = 16
                EnowLib:Notify({
                    Title = "Speed Normal",
                    Content = "WalkSpeed reset to 16",
                    Duration = 2,
                    Type = "Info"
                })
            end
        end
    end
})

BasicTab:AddSection({Title = "SLIDERS"})

BasicTab:AddSlider({
    Title = "Test Slider",
    Description = "Drag to change value",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Slider value:", value)
    end
})

BasicTab:AddSlider({
    Title = "WalkSpeed Control",
    Description = "Control your walk speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

BasicTab:AddSlider({
    Title = "JumpPower Control",
    Description = "Control your jump power",
    Min = 50,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

BasicTab:AddSection({Title = "INPUTS"})

BasicTab:AddInput({
    Title = "Test Input",
    Description = "Type and press Enter",
    Placeholder = "Enter text here...",
    Default = "",
    Callback = function(value)
        print("Input value:", value)
        EnowLib:Notify({
            Title = "Input Received",
            Content = "You typed: " .. value,
            Duration = 2,
            Type = "Info"
        })
    end
})

BasicTab:AddInput({
    Title = "Player Name",
    Description = "Enter player name to find",
    Placeholder = "Username...",
    Callback = function(value)
        local player = game.Players:FindFirstChild(value)
        if player then
            EnowLib:Notify({
                Title = "Player Found",
                Content = value .. " is in the game!",
                Duration = 2,
                Type = "Success"
            })
        else
            EnowLib:Notify({
                Title = "Player Not Found",
                Content = value .. " is not in the game",
                Duration = 2,
                Type = "Error"
            })
        end
    end
})

BasicTab:AddSection({Title = "DROPDOWNS"})

BasicTab:AddDropdown({
    Title = "Test Dropdown",
    Description = "Select an option",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
    Default = "Option 1",
    Callback = function(value)
        print("Selected:", value)
        EnowLib:Notify({
            Title = "Dropdown Changed",
            Content = "Selected: " .. value,
            Duration = 2,
            Type = "Info"
        })
    end
})

-- ========================================
-- TAB 2: ADVANCED COMPONENTS
-- ========================================
local AdvancedTab = Window:AddTab({Title = "Advanced"})

AdvancedTab:AddLabel({
    Text = "Advanced Components Test",
    Size = "Large",
    Color = Color3.fromRGB(0, 255, 255)
})

AdvancedTab:AddSection({Title = "KEYBIND"})

AdvancedTab:AddKeybind({
    Title = "Test Keybind",
    Description = "Press to trigger action",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Key pressed:", key.Name)
        EnowLib:Notify({
            Title = "Keybind Triggered",
            Content = "You pressed: " .. key.Name,
            Duration = 2,
            Type = "Success"
        })
    end
})

AdvancedTab:AddKeybind({
    Title = "Toggle UI Key",
    Description = "Press to toggle UI visibility",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        Window:Toggle()
    end
})

AdvancedTab:AddSection({Title = "COLOR PICKER"})

AdvancedTab:AddColorPicker({
    Title = "Test Color Picker",
    Description = "Pick any color",
    Default = Color3.fromRGB(138, 43, 226),
    Callback = function(color)
        print("Color selected:", color)
        local r = math.floor(color.R * 255)
        local g = math.floor(color.G * 255)
        local b = math.floor(color.B * 255)
        EnowLib:Notify({
            Title = "Color Changed",
            Content = string.format("RGB(%d, %d, %d)", r, g, b),
            Duration = 2,
            Type = "Info"
        })
    end
})

AdvancedTab:AddColorPicker({
    Title = "Character Color",
    Description = "Change your character color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        local player = game.Players.LocalPlayer
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end
    end
})

AdvancedTab:AddSection({Title = "MULTI DROPDOWN"})

AdvancedTab:AddMultiDropdown({
    Title = "Test Multi Select",
    Description = "Select multiple options",
    Options = {"Feature 1", "Feature 2", "Feature 3", "Feature 4", "Feature 5"},
    Default = {"Feature 1"},
    Callback = function(values)
        print("Selected features:", table.concat(values, ", "))
        EnowLib:Notify({
            Title = "Multi Select Changed",
            Content = string.format("%d items selected", #values),
            Duration = 2,
            Type = "Info"
        })
    end
})

AdvancedTab:AddSection({Title = "PROGRESS BAR"})

local progressBar1 = AdvancedTab:AddProgressBar({
    Title = "Test Progress Bar",
    Description = "Animated progress indicator",
    Min = 0,
    Max = 100,
    Value = 0,
    ShowPercentage = true,
    Animated = true
})

AdvancedTab:AddButton({
    Title = "Start Progress Test",
    Description = "Simulate loading progress",
    Callback = function()
        progressBar1:Reset()
        
        task.spawn(function()
            for i = 0, 100, 5 do
                progressBar1:SetValue(i)
                task.wait(0.1)
            end
            
            EnowLib:Notify({
                Title = "Progress Complete",
                Content = "Progress bar test finished!",
                Duration = 2,
                Type = "Success"
            })
        end)
    end
})

local progressBar2 = AdvancedTab:AddProgressBar({
    Title = "Manual Progress",
    Description = "Use buttons to control",
    Min = 0,
    Max = 100,
    Value = 50,
    ShowPercentage = true,
    Animated = true
})

AdvancedTab:AddButton({
    Title = "Increment +10",
    Callback = function()
        progressBar2:Increment(10)
    end
})

AdvancedTab:AddButton({
    Title = "Reset Progress",
    Callback = function()
        progressBar2:Reset()
    end
})

-- ========================================
-- TAB 3: PLAYER FEATURES
-- ========================================
local PlayerTab = Window:AddTab({Title = "Player"})

PlayerTab:AddLabel({
    Text = "Player Control Features",
    Size = "Large",
    Color = Color3.fromRGB(255, 20, 147)
})

PlayerTab:AddSection({Title = "MOVEMENT"})

PlayerTab:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

PlayerTab:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        getgenv().InfiniteJump = value
        
        if value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if getgenv().InfiniteJump then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    end
})

PlayerTab:AddSection({Title = "TELEPORT"})

local teleportLocations = {
    ["Spawn"] = CFrame.new(0, 10, 0),
    ["Sky"] = CFrame.new(0, 500, 0),
    ["Underground"] = CFrame.new(0, -50, 0)
}

PlayerTab:AddDropdown({
    Title = "Teleport Location",
    Options = {"Spawn", "Sky", "Underground"},
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local cframe = teleportLocations[value]
            if cframe then
                player.Character.HumanoidRootPart.CFrame = cframe
                EnowLib:Notify({
                    Title = "Teleported",
                    Content = "Teleported to: " .. value,
                    Duration = 2,
                    Type = "Success"
                })
            end
        end
    end
})

PlayerTab:AddSection({Title = "APPEARANCE"})

PlayerTab:AddColorPicker({
    Title = "Body Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        local player = game.Players.LocalPlayer
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = color
                end
            end
        end
    end
})

PlayerTab:AddButton({
    Title = "Reset Character",
    Description = "Reset your character",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})

-- ========================================
-- TAB 4: CONFIG & SETTINGS
-- ========================================
local ConfigTab = Window:AddTab({Title = "Config"})

ConfigTab:AddLabel({
    Text = "Configuration Management",
    Size = "Large",
    Color = Color3.fromRGB(0, 255, 150)
})

-- Add SaveManager UI
Window.SaveManager.CreateUI(ConfigTab)

-- Add InterfaceManager UI
Window.InterfaceManager.CreateUI(ConfigTab)

-- ========================================
-- TAB 5: INFO & TESTING
-- ========================================
local InfoTab = Window:AddTab({Title = "Info"})

InfoTab:AddLabel({
    Text = "EnowLib v2.0.0",
    Size = "Title",
    Color = Color3.fromRGB(138, 43, 226)
})

InfoTab:AddLabel({
    Text = "Complete Roblox UI Library",
    Size = "Medium",
    Color = Color3.fromRGB(150, 150, 170)
})

InfoTab:AddSection({Title = "FEATURES"})

InfoTab:AddLabel({
    Text = "13 Components:",
    Size = "Regular"
})

InfoTab:AddLabel({
    Text = "Button, Toggle, Slider, Input, Dropdown, Keybind, ColorPicker, MultiDropdown, ProgressBar, Label, Section, Notification, Tab",
    Size = "Small",
    Color = Color3.fromRGB(150, 150, 170)
})

InfoTab:AddLabel({
    Text = "2 Managers:",
    Size = "Regular"
})

InfoTab:AddLabel({
    Text = "SaveManager (Config Persistence), InterfaceManager (Theme Management)",
    Size = "Small",
    Color = Color3.fromRGB(150, 150, 170)
})

InfoTab:AddLabel({
    Text = "5 Themes:",
    Size = "Regular"
})

InfoTab:AddLabel({
    Text = "Vaporwave, Dark, Light, Cyberpunk, Neon",
    Size = "Small",
    Color = Color3.fromRGB(150, 150, 170)
})

InfoTab:AddSection({Title = "LINKS"})

InfoTab:AddButton({
    Title = "GitHub Repository",
    Description = "Open in browser",
    Callback = function()
        setclipboard("https://github.com/enowdev/enowlib")
        EnowLib:Notify({
            Title = "Link Copied",
            Content = "GitHub link copied to clipboard!",
            Duration = 2,
            Type = "Success"
        })
    end
})

InfoTab:AddButton({
    Title = "Raw Library URL",
    Description = "Copy loadstring URL",
    Callback = function()
        setclipboard("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua")
        EnowLib:Notify({
            Title = "URL Copied",
            Content = "Raw URL copied to clipboard!",
            Duration = 2,
            Type = "Success"
        })
    end
})

InfoTab:AddSection({Title = "SYSTEM INFO"})

InfoTab:AddLabel({
    Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"),
    Size = "Small"
})

InfoTab:AddLabel({
    Text = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Size = "Small"
})

InfoTab:AddLabel({
    Text = "Player: " .. game.Players.LocalPlayer.Name,
    Size = "Small"
})

InfoTab:AddSection({Title = "TEST ACTIONS"})

InfoTab:AddButton({
    Title = "Test All Notifications",
    Callback = function()
        local types = {"Info", "Success", "Warning", "Error"}
        for i, type in ipairs(types) do
            task.wait(0.3)
            EnowLib:Notify({
                Title = type .. " Test",
                Content = "This is a " .. type:lower() .. " notification",
                Duration = 2,
                Type = type
            })
        end
    end
})

InfoTab:AddButton({
    Title = "Spam Notifications",
    Description = "Test notification queue",
    Callback = function()
        for i = 1, 10 do
            EnowLib:Notify({
                Title = "Notification " .. i,
                Content = "Testing notification queue system",
                Duration = 1,
                Type = "Info"
            })
        end
    end
})

InfoTab:AddButton({
    Title = "Toggle Window",
    Description = "Hide/Show UI",
    Callback = function()
        Window:Toggle()
    end
})

-- ========================================
-- INITIALIZATION COMPLETE
-- ========================================

-- Show success notification
EnowLib:Notify({
    Title = "EnowLib Loaded",
    Content = "All components initialized successfully!",
    Duration = 3,
    Type = "Success"
})

-- Print info to console
print("========================================")
print("EnowLib v2.0.0 Test Suite Loaded")
print("========================================")
print("Components: 13")
print("Managers: 2")
print("Themes: 5")
print("Status: Ready")
print("========================================")
print("Press RightControl to toggle UI")
print("========================================")
