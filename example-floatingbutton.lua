-- EnowLib Floating Button Example
-- Load FloatingButtonManager from GitHub

local FloatingButtonManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/main/build/managers/floatingbuttonmanager.lua?v=" .. os.time()))()

-- Create floating button
local floatingButton = FloatingButtonManager.new({
    Size = UDim2.fromOffset(60, 60),
    Position = UDim2.new(1, -80, 0.5, -30), -- Right side, middle
    ImageId = "rbxassetid://7733964719", -- Example icon (settings icon)
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.3,
    CornerRadius = 30,
    OnClick = function()
        print("Floating button clicked!")
        -- Add your action here, e.g., toggle UI
    end
})

-- Optional: Methods you can use
-- floatingButton:SetImage("rbxassetid://YOUR_IMAGE_ID")
-- floatingButton:SetPosition(UDim2.new(0, 20, 0, 20))
-- floatingButton:Show()
-- floatingButton:Hide()
-- floatingButton:Toggle()
-- floatingButton:Destroy()

print("Floating button loaded! Drag it around or click it.")
