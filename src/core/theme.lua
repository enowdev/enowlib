-- EnowLib Theme System
-- Radix UI Style - Modern Minimalist Design

local Theme = {}

-- Radix Icons (Load only what we need)
Theme.Icons = {
    ChevronDown = "rbxassetid://84943167918420",
    ChevronUp = "rbxassetid://96782125528789",
    ChevronRight = "rbxassetid://107730842937250",
    ChevronLeft = "rbxassetid://129878891615647",
    Cross = "rbxassetid://103469834740951",
    Check = "rbxassetid://112055175771712",
    Minus = "rbxassetid://136970829842166",
    Plus = "rbxassetid://88749593140179",
    Gear = "rbxassetid://71052135258381",
    Home = "rbxassetid://83776942872883",
    Search = "rbxassetid://76834693226502",
    Bell = "rbxassetid://73091340382838",
    Info = "rbxassetid://93427086753822",
    Warning = "rbxassetid://129272457926822",
    Error = "rbxassetid://132948061195895",
    Success = "rbxassetid://109969715613335",
    Eye = "rbxassetid://73765738340117",
    EyeClosed = "rbxassetid://136306160292883",
    Lock = "rbxassetid://93890239917122",
    Unlock = "rbxassetid://137265616251359"
}

-- Color Palette - Radix UI Dark Mode with Transparency
Theme.Colors = {
    -- Background colors (Dark with transparency)
    Background = Color3.fromRGB(18, 18, 18),         -- Very dark gray
    BackgroundDark = Color3.fromRGB(12, 12, 12),     -- Almost black
    BackgroundLight = Color3.fromRGB(24, 24, 24),    -- Dark gray
    
    -- Panel/Card colors (Dark with slight transparency)
    Panel = Color3.fromRGB(24, 24, 27),              -- Dark panel
    PanelHover = Color3.fromRGB(30, 30, 35),         -- Lighter on hover
    
    -- Primary colors (Bright accent for dark mode)
    Primary = Color3.fromRGB(250, 250, 250),         -- Almost white
    PrimaryLight = Color3.fromRGB(96, 165, 250),     -- Bright blue
    PrimaryDark = Color3.fromRGB(59, 130, 246),      -- Blue
    
    -- Secondary colors (Dark grays)
    Secondary = Color3.fromRGB(39, 39, 42),          -- Medium dark
    SecondaryLight = Color3.fromRGB(50, 50, 55),     -- Lighter dark
    SecondaryDark = Color3.fromRGB(30, 30, 33),      -- Darker
    
    -- Accent colors (Bright for dark mode)
    Accent = Color3.fromRGB(96, 165, 250),           -- Bright blue
    AccentHover = Color3.fromRGB(59, 130, 246),      -- Blue
    AccentLight = Color3.fromRGB(30, 58, 138),       -- Dark blue
    
    -- State colors (Vibrant for dark mode)
    Success = Color3.fromRGB(74, 222, 128),          -- Bright green
    Warning = Color3.fromRGB(251, 191, 36),          -- Bright yellow
    Error = Color3.fromRGB(248, 113, 113),           -- Bright red
    Info = Color3.fromRGB(96, 165, 250),             -- Bright blue
    
    -- Text colors (Light for dark mode)
    Text = Color3.fromRGB(250, 250, 250),            -- Almost white
    TextSecondary = Color3.fromRGB(161, 161, 170),   -- Gray
    TextDisabled = Color3.fromRGB(113, 113, 122),    -- Dark gray
    TextWhite = Color3.fromRGB(255, 255, 255),       -- Pure white
    
    -- Border (Subtle for dark mode)
    Border = Color3.fromRGB(39, 39, 42),             -- Dark border
    BorderHover = Color3.fromRGB(63, 63, 70),        -- Lighter border
    BorderFocus = Color3.fromRGB(96, 165, 250),      -- Blue focus
    
    -- Legacy compatibility
    Yellow = Color3.fromRGB(251, 191, 36),
    Green = Color3.fromRGB(74, 222, 128),
    Orange = Color3.fromRGB(251, 146, 60),
    Pink = Color3.fromRGB(244, 114, 182),
    TextDim = Color3.fromRGB(161, 161, 170),
    Hover = Color3.fromRGB(39, 39, 42),
    Active = Color3.fromRGB(63, 63, 70),
    TitleBar = Color3.fromRGB(24, 24, 27),
    TitleBarInactive = Color3.fromRGB(18, 18, 18),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Transparency values (Dark mode with transparency)
Theme.Transparency = {
    Solid = 0,
    SemiTransparent = 0.1,
    Translucent = 0.2,
    VeryTranslucent = 0.4,
    AlmostTransparent = 0.7,
    Invisible = 1,
    Background = 0.15  -- Background transparency for glass effect
}

-- Font settings (Radix UI - clean and readable)
Theme.Font = {
    Regular = Enum.Font.Gotham,          -- Clean sans-serif
    Bold = Enum.Font.GothamBold,         -- Bold for emphasis
    Mono = Enum.Font.RobotoMono,
    Size = {
        Small = 12,
        Regular = 14,
        Medium = 16,
        Large = 18,
        Title = 20
    }
}

-- Spacing and sizing (Radix UI - consistent spacing scale)
Theme.Spacing = {
    Tiny = 4,
    Small = 8,
    Medium = 12,
    Large = 16,
    XLarge = 24
}

Theme.Size = {
    Border = 1,                    -- Thin subtle borders (Radix style)
    CornerRadius = 6,              -- Soft rounded corners
    IconSize = 16,                 -- Standard icon size
    ComponentHeight = 36,          -- Standard component height
    WindowMinWidth = 400,
    WindowMinHeight = 300,
    ScrollBarWidth = 4
}

-- Responsive breakpoints
Theme.Responsive = {
    Mobile = 600,
    Tablet = 900,
    Desktop = 1200
}

-- Animation settings (Smooth and fluid)
Theme.Animation = {
    Speed = {
        Fast = 0.2,
        Normal = 0.3,
        Slow = 0.4
    },
    Easing = Enum.EasingStyle.Quint,  -- Smoother easing
    Direction = Enum.EasingDirection.Out
}

-- Radix UI subtle shadow
function Theme.CreateShadow(parent, elevation)
    elevation = elevation or 1
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = elevation == 1 and 0.95 or 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, elevation * 4, 1, elevation * 4)
    shadow.Position = UDim2.fromOffset(-elevation * 2, -elevation * 2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    return shadow
end

-- Create corner radius (Radix = soft rounded)
function Theme.CreateCorner(parent, radius)
    radius = radius or Theme.Size.CornerRadius
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    
    return corner
end

-- Create stroke/border (Thin subtle for Radix)
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

-- Create focus ring (Radix accessibility feature)
function Theme.CreateFocusRing(parent)
    local ring = Instance.new("UIStroke")
    ring.Name = "FocusRing"
    ring.Color = Theme.Colors.BorderFocus
    ring.Thickness = 2
    ring.Transparency = 1  -- Hidden by default
    ring.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ring.Parent = parent
    
    return ring
end

-- Create icon (using Radix icons)
function Theme.CreateIcon(parent, iconId, size)
    size = size or Theme.Size.IconSize
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Theme.Colors.Text
    icon.Size = UDim2.fromOffset(size, size)
    icon.Parent = parent
    
    return icon
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
