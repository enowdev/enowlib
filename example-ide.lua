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
    end
})

print("EnowLib IDE loaded successfully!")

