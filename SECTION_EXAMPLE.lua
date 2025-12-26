-- EnowLib Collapsible Section Example
-- How to use dropdown/collapsible sections

local EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

local Window = EnowLib:CreateWindow({
    Title = "Collapsible Section Demo",
    Size = UDim2.fromOffset(500, 400)
})

local Tab = Window:AddTab({Title = "Sections"})

-- Example 1: Basic Section (expanded by default)
local Section1 = Tab:AddSection({
    Title = "Player Settings",
    Collapsed = false  -- Start expanded
})

-- Add components to section
Section1:AddSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

Section1:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        print("Infinite Jump:", value)
    end
})

-- Example 2: Collapsed Section (starts collapsed)
local Section2 = Tab:AddSection({
    Title = "Combat Features",
    Collapsed = true  -- Start collapsed
})

Section2:AddButton({
    Title = "Kill All",
    Callback = function()
        print("Kill All activated")
    end
})

Section2:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

-- Example 3: Multiple Sections
local Section3 = Tab:AddSection({
    Title = "Visual Settings",
    Collapsed = false
})

Section3:AddToggle({
    Title = "ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

Section3:AddSlider({
    Title = "FOV",
    Min = 70,
    Max = 120,
    Default = 90,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- Example 4: Nested organization
local Section4 = Tab:AddSection({
    Title = "Teleports",
    Collapsed = true
})

Section4:AddButton({
    Title = "Teleport to Spawn",
    Callback = function()
        print("Teleporting to spawn")
    end
})

Section4:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        print("Teleporting to player")
    end
})

print("Collapsible sections created!")
print("Click section headers to expand/collapse")
