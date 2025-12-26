-- VaporUI Theme System
-- Vaporwave Tech Dark Color Scheme

local Theme = {}

-- Color Palette
Theme.Colors = {
    -- Background colors
    Background = Color3.fromRGB(15, 15, 25),
    BackgroundDark = Color3.fromRGB(10, 10, 18),
    BackgroundLight = Color3.fromRGB(20, 20, 30),
    
    -- Primary colors (Vaporwave gradient)
    Primary = Color3.fromRGB(138, 43, 226), -- Purple
    PrimaryLight = Color3.fromRGB(186, 85, 211), -- Light purple
    PrimaryDark = Color3.fromRGB(75, 0, 130), -- Dark purple
    
    -- Accent colors
    Accent = Color3.fromRGB(0, 255, 255), -- Cyan
    AccentPink = Color3.fromRGB(255, 20, 147), -- Deep pink
    AccentGlow = Color3.fromRGB(57, 255, 255), -- Bright cyan
    
    -- Text colors
    Text = Color3.fromRGB(240, 240, 255),
    TextDim = Color3.fromRGB(150, 150, 170),
    TextDisabled = Color3.fromRGB(80, 80, 100),
    
    -- State colors
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 100),
    
    -- UI Element colors
    Border = Color3.fromRGB(100, 50, 150),
    BorderGlow = Color3.fromRGB(138, 43, 226),
    Hover = Color3.fromRGB(25, 25, 40),
    Active = Color3.fromRGB(30, 30, 50),
    
    -- Transparency
    Transparent = Color3.fromRGB(0, 0, 0)
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

-- Font settings
Theme.Font = {
    Regular = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.RobotoMono,
    Size = {
        Small = 12,
        Regular = 14,
        Medium = 16,
        Large = 18,
        Title = 20
    }
}

-- Spacing and sizing
Theme.Spacing = {
    Tiny = 4,
    Small = 8,
    Medium = 12,
    Large = 16,
    XLarge = 24
}

Theme.Size = {
    Border = 1,
    BorderGlow = 2,
    CornerRadius = 6,
    ScrollBarWidth = 4,
    
    -- Component sizes
    ButtonHeight = 32,
    ToggleSize = 20,
    SliderHeight = 6,
    InputHeight = 32,
    DropdownHeight = 32,
    
    -- Container sizes
    WindowMinWidth = 400,
    WindowMinHeight = 300,
    TabWidth = 140,
    SectionHeight = 30
}

-- Animation settings
Theme.Animation = {
    Speed = {
        Fast = 0.15,
        Normal = 0.25,
        Slow = 0.4
    },
    Easing = Enum.EasingStyle.Quad,
    Direction = Enum.EasingDirection.Out
}

-- Glow effect settings
Theme.Glow = {
    Intensity = 0.8,
    Size = 20,
    Color = Color3.fromRGB(138, 43, 226)
}

-- Create gradient for vaporwave effect
function Theme.CreateGradient(parent, rotation)
    rotation = rotation or 45
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Colors.Primary),
        ColorSequenceKeypoint.new(0.5, Theme.Colors.AccentPink),
        ColorSequenceKeypoint.new(1, Theme.Colors.Accent)
    })
    gradient.Rotation = rotation
    gradient.Parent = parent
    
    return gradient
end

-- Create glow effect
function Theme.CreateGlow(parent, color)
    color = color or Theme.Glow.Color
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(128, 128, 128, 128)
    glow.Size = UDim2.new(1, Theme.Glow.Size, 1, Theme.Glow.Size)
    glow.Position = UDim2.fromOffset(-Theme.Glow.Size / 2, -Theme.Glow.Size / 2)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    
    return glow
end

-- Create corner radius
function Theme.CreateCorner(parent, radius)
    radius = radius or Theme.Size.CornerRadius
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    
    return corner
end

-- Create stroke/border
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
