-- EnowLib v2.0.0 - IDE Style Example
-- Hacker Terminal Theme with Tree Structure

print("Loading EnowLib IDE...")

local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Lucide Icons
local Icons = {
    Folder = "rbxassetid://10723387563",
    File = "rbxassetid://10723374759",
    FileCode = "rbxassetid://10723356507",
    Play = "rbxassetid://10734923549",
    Settings = "rbxassetid://10734950309"
}

print("Creating IDE window...")

local Window = EnowLib:CreateWindow({
    Title = "EnowHub UI Testing",
    Size = UDim2.fromOffset(900, 600)
})

-- Universal Category
local UniversalCategory = Window:AddCategory({
    Title = "Universal",
    Icon = Icons.Folder,
    Expanded = true
})

-- ESP Tab (styled as .lua file)
UniversalCategory:AddItem({
    Title = "ESP.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        -- Header
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> ESP Features"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        -- Description
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 40)
        desc.Font = theme.Font.Mono
        desc.Text = "Configure ESP (Extra Sensory Perception) settings"
        desc.TextColor3 = theme.Colors.TextDim
        desc.TextSize = 13
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = parent
        
        -- Add components using the library
        local Label = require(script.Parent.Label)
        Label.new({Text = "Display Options"}, {Container = parent}, theme, utils)
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Enable ESP",
            Default = false,
            Callback = function(value)
                print("ESP Enabled:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "Show Names",
            Default = true,
            Callback = function(value)
                print("Show Names:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "Show Distance",
            Default = true,
            Callback = function(value)
                print("Show Distance:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "Show Health",
            Default = false,
            Callback = function(value)
                print("Show Health:", value)
            end
        }, {Container = parent}, theme, utils)
        
        local Slider = require(script.Parent.Slider)
        Slider.new({
            Title = "Max Distance",
            Min = 100,
            Max = 1000,
            Default = 500,
            Callback = function(value)
                print("Max Distance:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

-- Aimbot Tab
UniversalCategory:AddItem({
    Title = "Aimbot.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> Aimbot Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Enable Aimbot",
            Default = false,
            Callback = function(value)
                print("Aimbot:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "Team Check",
            Default = true,
            Callback = function(value)
                print("Team Check:", value)
            end
        }, {Container = parent}, theme, utils)
        
        local Slider = require(script.Parent.Slider)
        Slider.new({
            Title = "FOV Size",
            Min = 50,
            Max = 500,
            Default = 200,
            Callback = function(value)
                print("FOV:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Slider.new({
            Title = "Smoothness",
            Min = 0,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("Smoothness:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

-- WalkSpeed Tab
UniversalCategory:AddItem({
    Title = "WalkSpeed.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> Movement Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local Slider = require(script.Parent.Slider)
        Slider.new({
            Title = "Walk Speed",
            Min = 16,
            Max = 200,
            Default = 16,
            Callback = function(value)
                print("WalkSpeed:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Slider.new({
            Title = "Jump Power",
            Min = 50,
            Max = 200,
            Default = 50,
            Callback = function(value)
                print("JumpPower:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

-- Combat Category
local CombatCategory = Window:AddCategory({
    Title = "Combat",
    Icon = Icons.Folder,
    Expanded = false
})

CombatCategory:AddItem({
    Title = "KillAura.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> KillAura Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Enable KillAura",
            Default = false,
            Callback = function(value)
                print("KillAura:", value)
            end
        }, {Container = parent}, theme, utils)
        
        local Slider = require(script.Parent.Slider)
        Slider.new({
            Title = "Range",
            Min = 5,
            Max = 50,
            Default = 15,
            Callback = function(value)
                print("Range:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

CombatCategory:AddItem({
    Title = "AntiHit.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> AntiHit Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Enable AntiHit",
            Default = false,
            Callback = function(value)
                print("AntiHit:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

-- Visual Category
local VisualCategory = Window:AddCategory({
    Title = "Visual",
    Icon = Icons.Folder,
    Expanded = false
})

VisualCategory:AddItem({
    Title = "FullBright.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local header = Instance.new("TextLabel")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = theme.Font.Bold
        header.Text = "> Visual Settings"
        header.TextColor3 = theme.Colors.Accent
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = parent
        
        local Toggle = require(script.Parent.Toggle)
        Toggle.new({
            Title = "Full Bright",
            Default = false,
            Callback = function(value)
                print("FullBright:", value)
            end
        }, {Container = parent}, theme, utils)
        
        Toggle.new({
            Title = "No Fog",
            Default = false,
            Callback = function(value)
                print("No Fog:", value)
            end
        }, {Container = parent}, theme, utils)
    end
})

print("EnowLib IDE loaded successfully!")

