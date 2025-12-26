-- EnowLib Theme System
-- Neo Brutalism Pastel Dark Color Scheme

local Theme = {}

-- Color Palette - Neo Brutalism Pastel Dark
Theme.Colors = {
    -- Background colors (Dark pastel base)
    Background = Color3.fromRGB(26, 27, 38),        -- Deep navy blue
    BackgroundDark = Color3.fromRGB(20, 21, 30),    -- Darker navy
    BackgroundLight = Color3.fromRGB(32, 34, 46),   -- Lighter navy
    
    -- Primary colors (Pastel purple/lavender)
    Primary = Color3.fromRGB(159, 122, 234),        -- Soft lavender
    PrimaryLight = Color3.fromRGB(189, 162, 244),   -- Light lavender
    PrimaryDark = Color3.fromRGB(129, 92, 204),     -- Deep lavender
    
    -- Accent colors (Pastel complementary)
    Accent = Color3.fromRGB(130, 204, 221),         -- Soft cyan
    AccentPink = Color3.fromRGB(244, 143, 177),     -- Soft pink
    AccentGreen = Color3.fromRGB(166, 226, 188),    -- Soft mint
    
    -- Text colors
    Text = Color3.fromRGB(226, 232, 240),           -- Soft white
    TextDim = Color3.fromRGB(148, 163, 184),        -- Muted gray
    TextDisabled = Color3.fromRGB(100, 116, 139),   -- Dark gray
    
    -- State colors (Pastel versions)
    Success = Color3.fromRGB(134, 239, 172),        -- Soft green
    Warning = Color3.fromRGB(253, 224, 71),         -- Soft yellow
    Error = Color3.fromRGB(252, 165, 165),          -- Soft red
    
    -- UI Element colors (Neo brutalism style)
    Border = Color3.fromRGB(71, 85, 105),           -- Slate border
    BorderAccent = Color3.fromRGB(159, 122, 234),   -- Primary border
    Shadow = Color3.fromRGB(15, 16, 23),            -- Deep shadow
    Hover = Color3.fromRGB(41, 44, 58),             -- Subtle hover
    Active = Color3.fromRGB(51, 54, 68),            -- Active state
    
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
    Regular = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.RobotoMono,
    Size = {
        Small = 13,
        Regular = 14,
        Medium = 16,
        Large = 18,
        Title = 22
    }
}

-- Spacing and sizing (Neo brutalism - more spacious)
Theme.Spacing = {
    Tiny = 6,
    Small = 10,
    Medium = 14,
    Large = 18,
    XLarge = 28
}

Theme.Size = {
    Border = 2,                    -- Thicker borders for neo brutalism
    BorderThick = 3,               -- Extra thick for emphasis
    CornerRadius = 8,              -- Slightly rounded
    ScrollBarWidth = 6,
    
    -- Component sizes
    ButtonHeight = 38,
    ToggleSize = 22,
    SliderHeight = 8,
    InputHeight = 38,
    DropdownHeight = 38,
    
    -- Container sizes
    WindowMinWidth = 450,
    WindowMinHeight = 350,
    TabWidth = 160,
    SectionHeight = 32,
    
    -- Neo brutalism shadow offset
    ShadowOffset = 4
}

-- Animation settings (Snappier for neo brutalism)
Theme.Animation = {
    Speed = {
        Fast = 0.12,
        Normal = 0.2,
        Slow = 0.35
    },
    Easing = Enum.EasingStyle.Quad,
    Direction = Enum.EasingDirection.Out
}

-- Neo brutalism shadow
Theme.Shadow = {
    Offset = Vector2.new(4, 4),
    Color = Color3.fromRGB(15, 16, 23),
    Transparency = 0.3
}

-- Create gradient (subtle for neo brutalism)
function Theme.CreateGradient(parent, rotation)
    rotation = rotation or 90
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Colors.Primary),
        ColorSequenceKeypoint.new(1, Theme.Colors.PrimaryLight)
    })
    gradient.Rotation = rotation
    gradient.Transparency = NumberSequence.new(0.85) -- Very subtle
    gradient.Parent = parent
    
    return gradient
end

-- Create neo brutalism shadow
function Theme.CreateShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Theme.Shadow.Color
    shadow.BackgroundTransparency = Theme.Shadow.Transparency
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.fromOffset(Theme.Shadow.Offset.X, Theme.Shadow.Offset.Y)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    -- Match corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Size.CornerRadius)
    corner.Parent = shadow
    
    return shadow
end

-- Create corner radius
function Theme.CreateCorner(parent, radius)
    radius = radius or Theme.Size.CornerRadius
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    
    return corner
end

-- Create stroke/border (thicker for neo brutalism)
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
