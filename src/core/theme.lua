-- EnowLib Theme System
-- Y2K Aesthetic - Retro 2000s Pastel Style

local Theme = {}

-- Color Palette - Y2K Bright Pastels (Improved Contrast)
Theme.Colors = {
    -- Background colors (Lighter for better contrast)
    Background = Color3.fromRGB(240, 240, 255),      -- Very light lavender
    BackgroundDark = Color3.fromRGB(220, 220, 240),  -- Light lavender
    BackgroundLight = Color3.fromRGB(255, 255, 255), -- Pure white
    
    -- Primary colors (Bright cyan - Y2K signature)
    Primary = Color3.fromRGB(0, 200, 255),           -- Bright cyan
    PrimaryLight = Color3.fromRGB(100, 230, 255),    -- Light cyan
    PrimaryDark = Color3.fromRGB(0, 150, 200),       -- Deep cyan
    
    -- Secondary colors (Bright purple)
    Secondary = Color3.fromRGB(180, 140, 255),       -- Bright purple
    SecondaryLight = Color3.fromRGB(210, 180, 255),  -- Light purple
    SecondaryDark = Color3.fromRGB(140, 80, 255),    -- Deep purple
    
    -- Accent colors (Y2K palette - more vibrant)
    Yellow = Color3.fromRGB(255, 220, 0),            -- Bright yellow
    Green = Color3.fromRGB(100, 255, 150),           -- Bright green
    Orange = Color3.fromRGB(255, 150, 50),           -- Bright orange
    Pink = Color3.fromRGB(255, 150, 200),            -- Bright pink
    
    -- Text colors (Better contrast)
    Text = Color3.fromRGB(20, 20, 40),               -- Dark blue-gray (better than pure black)
    TextDim = Color3.fromRGB(100, 100, 120),         -- Medium gray
    TextDisabled = Color3.fromRGB(160, 160, 180),    -- Light gray
    TextWhite = Color3.fromRGB(255, 255, 255),       -- White text
    
    -- State colors (Bright versions)
    Success = Color3.fromRGB(100, 255, 150),         -- Bright green
    Warning = Color3.fromRGB(255, 220, 0),           -- Bright yellow
    Error = Color3.fromRGB(255, 80, 120),            -- Bright red
    Info = Color3.fromRGB(0, 200, 255),              -- Bright cyan
    
    -- UI Element colors (Y2K style)
    Border = Color3.fromRGB(20, 20, 40),             -- Dark blue-gray borders
    BorderThick = Color3.fromRGB(20, 20, 40),        -- Dark borders
    Shadow = Color3.fromRGB(0, 0, 0),                -- Black shadow
    Hover = Color3.fromRGB(230, 240, 255),           -- Light blue hover
    Active = Color3.fromRGB(200, 220, 255),          -- Light blue active
    
    -- Window chrome colors (like Windows 2000)
    TitleBar = Color3.fromRGB(0, 200, 255),          -- Cyan title bar
    TitleBarInactive = Color3.fromRGB(150, 150, 170) -- Gray inactive
}

-- Transparency values
Theme.Transparency = {
    Solid = 0,
    SemiTransparent = 0.3,
    Translucent = 0.5,
    VeryTranslucent = 0.7,
    AlmostTransparent = 0.9,
    Invisible = 1
}

-- Font settings (Y2K style - bold and playful)
Theme.Font = {
    Regular = Enum.Font.GothamBold,      -- Bold for Y2K
    Bold = Enum.Font.GothamBlack,        -- Extra bold
    Mono = Enum.Font.RobotoMono,
    Size = {
        Small = 13,
        Regular = 15,
        Medium = 17,
        Large = 19,
        Title = 24
    }
}

-- Spacing and sizing (Y2K - better spacing to prevent overflow)
Theme.Spacing = {
    Tiny = 4,
    Small = 8,
    Medium = 12,
    Large = 16,
    XLarge = 24
}

Theme.Size = {
    Border = 3,                    -- THICK black borders (Y2K signature)
    BorderThick = 4,               -- Extra thick
    CornerRadius = 0,              -- NO rounding (pure Y2K)
    ScrollBarWidth = 8,
    
    -- Component sizes (adjusted for better spacing)
    ButtonHeight = 40,
    ToggleSize = 24,
    SliderHeight = 20,
    InputHeight = 40,
    DropdownHeight = 40,
    
    -- Container sizes
    WindowMinWidth = 400,
    WindowMinHeight = 300,
    TabWidth = 140,
    SectionHeight = 32,
    
    -- Y2K shadow offset (thick shadow)
    ShadowOffset = 5,
    ShadowBlur = 0                 -- No blur, solid shadow
}

-- Responsive breakpoints
Theme.Responsive = {
    Mobile = 600,
    Tablet = 900,
    Desktop = 1200
}

-- Animation settings (Snappy Y2K style)
Theme.Animation = {
    Speed = {
        Fast = 0.1,
        Normal = 0.15,
        Slow = 0.25
    },
    Easing = Enum.EasingStyle.Linear,  -- Linear for retro feel
    Direction = Enum.EasingDirection.Out
}

-- Y2K glossy gradient
function Theme.CreateGradient(parent, rotation)
    rotation = rotation or 90
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, parent.BackgroundColor3),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Rotation = rotation
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    gradient.Parent = parent
    
    return gradient
end

-- Y2K thick shadow (solid, no blur) - FIXED: Don't cover entire screen
function Theme.CreateShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Theme.Colors.Shadow
    shadow.BackgroundTransparency = 0.7  -- Semi-transparent so it doesn't block game
    shadow.BorderSizePixel = 0
    shadow.Size = parent.Size  -- Match parent size, not fullscreen
    shadow.Position = UDim2.fromOffset(Theme.Size.ShadowOffset, Theme.Size.ShadowOffset)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    return shadow
end

-- Create corner radius (Y2K = NO rounding)
function Theme.CreateCorner(parent, radius)
    -- Y2K style has NO rounded corners, but keep function for compatibility
    radius = radius or Theme.Size.CornerRadius
    
    if radius > 0 then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = parent
        return corner
    end
    
    return nil
end

-- Create stroke/border (THICK BLACK for Y2K)
function Theme.CreateStroke(parent, color, thickness)
    color = color or Theme.Colors.Border
    thickness = thickness or Theme.Size.Border
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    
    return stroke
end

-- Create padding
function Theme.CreatePadding(parent, padding)
    if type(padding) == "number" then
        padding = {padding, padding, padding, padding}
    end
    
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, padding[1] or padding)
    uiPadding.PaddingRight = UDim.new(0, padding[2] or padding)
    uiPadding.PaddingTop = UDim.new(0, padding[3] or padding)
    uiPadding.PaddingBottom = UDim.new(0, padding[4] or padding)
    uiPadding.Parent = parent
    
    return uiPadding
end

return Theme
