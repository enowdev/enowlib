-- EnowLib Theme System
-- Radix UI Dark Mode with Transparency

local Theme = {}

-- Lucide Icons (IDE set)
Theme.Icons = {
    ChevronDown = "rbxassetid://10709790948",
    ChevronRight = "rbxassetid://10709791437",
    X = "rbxassetid://10747384394",
    Check = "rbxassetid://10709790644",
    Settings = "rbxassetid://10734950309",
    Home = "rbxassetid://10723407389",
    Folder = "rbxassetid://10723387563",
    FolderOpen = "rbxassetid://10723386277",
    File = "rbxassetid://10723374759",
    FileCode = "rbxassetid://10723356507",
    Terminal = "rbxassetid://10734982144",
    Play = "rbxassetid://10734923549"
}

-- Dark Mode Color Palette (Hacker IDE Style)
Theme.Colors = {
    Background = Color3.fromRGB(13, 17, 23),
    Panel = Color3.fromRGB(22, 27, 34),
    Secondary = Color3.fromRGB(33, 38, 45),
    
    Accent = Color3.fromRGB(46, 204, 113),
    AccentHover = Color3.fromRGB(39, 174, 96),
    AccentDim = Color3.fromRGB(34, 153, 84),
    
    Text = Color3.fromRGB(201, 209, 217),
    TextDim = Color3.fromRGB(139, 148, 158),
    
    Border = Color3.fromRGB(48, 54, 61),
    
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Error = Color3.fromRGB(231, 76, 60)
}

-- Transparency
Theme.Transparency = {
    None = 0,
    Glass = 0.1,
    Subtle = 0.2
}

-- Typography
Theme.Font = {
    Regular = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.RobotoMono,
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
