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
    Title = "ScriptHub IDE",
    Size = UDim2.fromOffset(900, 600)
})

-- Universal Category
local UniversalCategory = Window:AddCategory({
    Title = "Universal",
    Icon = Icons.Folder,
    Expanded = true
})

UniversalCategory:AddItem({
    Title = "ESP.lua",
    Icon = Icons.FileCode,
    Content = function(parent, theme, utils)
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Font = theme.Font.Bold
        label.Text = "> ESP.lua"
        label.TextColor3 = theme.Colors.Accent
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 60)
        desc.Font = theme.Font.Mono
        desc.Text = "Displays player information through walls.\nShows name, distance, and health."
        desc.TextColor3 = theme.Colors.TextDim
        desc.TextSize = 14
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = parent
        
        local Button = require(script.Parent.Button)
        Button.new({
            Title = "Execute ESP",
            Callback = function()
                print("[Execute] ESP.lua")
            end
        }, {Container = parent}, theme, utils)
        
        local Toggle = require(script.Parent.Toggle)
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
    end,
    Callback = function()
        print("[Selected] ESP.lua")
    end
})

UniversalCategory:AddItem({
    Title = "Aimbot.lua",
    Icon = Icons.FileCode,
    Callback = function()
        print("[Execute] Aimbot.lua")
    end
})

UniversalCategory:AddItem({
    Title = "WalkSpeed.lua",
    Icon = Icons.FileCode,
    Callback = function()
        print("[Execute] WalkSpeed.lua")
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
    Callback = function()
        print("[Execute] KillAura.lua")
    end
})

CombatCategory:AddItem({
    Title = "AntiHit.lua",
    Icon = Icons.FileCode,
    Callback = function()
        print("[Execute] AntiHit.lua")
    end
})

-- Visual Category
local VisualCategory = Window:AddCategory({
    Title = "Visual",
    Icon = Icons.Folder,
    Expanded = false
})

VisualCategory:AddItem({
    Title = "NightMode.lua",
    Icon = Icons.FileCode,
    Callback = function()
        print("[Execute] NightMode.lua")
    end
})

VisualCategory:AddItem({
    Title = "FullBright.lua",
    Icon = Icons.FileCode,
    Callback = function()
        print("[Execute] FullBright.lua")
    end
})

print("EnowLib IDE loaded successfully!")
