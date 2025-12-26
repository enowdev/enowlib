-- EnowLib Theme System
-- Radix UI Dark Mode with Transparency

local Theme = {}

-- Radix Icons (minimal set)
Theme.Icons = {
    ChevronDown = "rbxassetid://84943167918420",
    ChevronRight = "rbxassetid://107730842937250",
    Cross = "rbxassetid://103469834740951",
    Check = "rbxassetid://112055175771712"
}

-- Dark Mode Color Palette
Theme.Colors = {
    Background = Color3.fromRGB(10, 10, 10),
    Panel = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    
    Accent = Color3.fromRGB(99, 102, 241),
    AccentHover = Color3.fromRGB(129, 140, 248),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160),
    
    Border = Color3.fromRGB(40, 40, 40),
    
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68)
}

-- Transparency
Theme.Transparency = {
    None = 0,
    Glass = 0.2,
    Subtle = 0.5
}

-- Typography
Theme.Font = {
    Regular = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Size = {
        Small = 12,
        Regular = 14,
        Large = 16
    }
}

-- Spacing
Theme.Spacing = {
    Small = 8,
    Medium = 12,
    Large = 16
}

-- Sizing
Theme.Size = {
    Border = 1,
    Corner = 8,
    Component = 36
}

-- Animation
Theme.Animation = {
    Duration = 0.3,
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out
}

-- Utilities
function Theme.CreateCorner(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or Theme.Size.Corner)
    corner.Parent = element
    return corner
end

function Theme.CreateStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Colors.Border
    stroke.Thickness = thickness or Theme.Size.Border
    stroke.Parent = element
    return stroke
end

function Theme.CreatePadding(element, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, padding)
    pad.PaddingRight = UDim.new(0, padding)
    pad.PaddingTop = UDim.new(0, padding)
    pad.PaddingBottom = UDim.new(0, padding)
    pad.Parent = element
    return pad
end

function Theme.CreateIcon(parent, iconId, size)
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Theme.Colors.Text
    icon.Size = UDim2.fromOffset(size or 16, size or 16)
    icon.Parent = parent
    return icon
end

return Theme
