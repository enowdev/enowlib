-- EnowLib v2.0.0
-- Radix UI Style - Modern Minimalist Design
-- Built: 2025-12-26 15:47:50
-- Author: EnowHub Development

local EnowLib = {}


-- Module: Theme
local Theme
do
-- EnowLib Theme System
-- Radix UI Dark Mode with Transparency

Theme = {}

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
Theme = Theme
assert(Theme, "Failed to assign Theme module")
end


-- Module: Utils
local Utils
do
-- EnowLib Utility Functions

Utils = {}

-- Tween utility
function Utils.Tween(instance, properties, duration, easingStyle, easingDirection, callback)
    duration = duration or 0.25
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = game:GetService("TweenService"):Create(instance, tweenInfo, properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

-- Create draggable frame (supports mouse and touch)
function Utils.MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Utils.Tween(frame, {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        }, 0.15)
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Ripple effect
function Utils.CreateRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.fromOffset(0, 0)
    ripple.Position = UDim2.fromOffset(position.X, position.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = parent.ZIndex + 100
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    Utils.Tween(ripple, {
        Size = UDim2.fromOffset(maxSize, maxSize),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

-- Clamp value between min and max
function Utils.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Lerp between two values
function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

-- Round number to decimal places
function Utils.Round(number, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(number * mult + 0.5) / mult
end

-- Check if mouse is over element
function Utils.IsMouseOver(element)
    local mouse = game:GetService("UserInputService"):GetMouseLocation()
    local pos = element.AbsolutePosition
    local size = element.AbsoluteSize
    
    return mouse.X >= pos.X and mouse.X <= pos.X + size.X and
           mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y
end

-- Generate unique ID
function Utils.GenerateId()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local id = ""
    
    for i = 1, 16 do
        local rand = math.random(1, #chars)
        id = id .. string.sub(chars, rand, rand)
    end
    
    return id
end

-- Deep copy table
function Utils.DeepCopy(original)
    local copy
    
    if type(original) == "table" then
        copy = {}
        for key, value in pairs(original) do
            copy[Utils.DeepCopy(key)] = Utils.DeepCopy(value)
        end
    else
        copy = original
    end
    
    return copy
end

-- Merge tables
function Utils.Merge(...)
    local result = {}
    
    for _, tbl in ipairs({...}) do
        for key, value in pairs(tbl) do
            result[key] = value
        end
    end
    
    return result
end

-- Create connection manager
function Utils.CreateConnectionManager()
    local connections = {}
    
    return {
        Add = function(connection)
            table.insert(connections, connection)
            return connection
        end,
        
        DisconnectAll = function()
            for _, connection in ipairs(connections) do
                if connection.Connected then
                    connection:Disconnect()
                end
            end
            connections = {}
        end,
        
        GetCount = function()
            return #connections
        end
    }
end

-- Debounce function
function Utils.Debounce(func, delay)
    local timer
    
    return function(...)
        local args = {...}
        
        if timer then
            timer:Cancel()
        end
        
        timer = task.delay(delay, function()
            func(unpack(args))
        end)
    end
end

-- Throttle function
function Utils.Throttle(func, delay)
    local lastRun = 0
    
    return function(...)
        local now = tick()
        
        if now - lastRun >= delay then
            lastRun = now
            func(...)
        end
    end
end

function Utils.ClearChildren(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end
Utils = Utils
assert(Utils, "Failed to assign Utils module")
end


-- Module: Label
local Label
do
-- EnowLib Label Component

Label = {}
Label.__index = Label

function Label.new(config, parent, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label",
        Size = nil,
        Color = nil,
        Font = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    self.Container = Instance.new("TextLabel")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Size and 30 or 24)
    self.Container.Font = self.Config.Font or self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = self.Config.Color or self.Theme.Colors.TextDim
    self.Container.TextSize = self.Config.Size or self.Theme.Font.Size.Regular
    self.Container.TextXAlignment = Enum.TextXAlignment.Left
    self.Container.Parent = self.Parent
end
Label = Label
assert(Label, "Failed to assign Label module")
end


-- Module: Paragraph
local Paragraph
do
-- EnowLib Paragraph Component

Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(config, parent, theme, utils)
    local self = setmetatable({}, Paragraph)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Title",
        Content = "Paragraph text here..."
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Paragraph:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.Parent = self.Parent
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Content
    local content = Instance.new("TextLabel")
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.fromOffset(0, 24)
    content.Font = self.Theme.Font.Mono
    content.Text = self.Config.Content
    content.TextColor3 = self.Theme.Colors.TextDim
    content.TextSize = self.Theme.Font.Size.Regular
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = self.Container
    
    -- Auto-size based on text
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 4)
    self.Container.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 28)
    
    content:GetPropertyChangedSignal("TextBounds"):Connect(function()
        content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 4)
        self.Container.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 28)
    end)
end
Paragraph = Paragraph
assert(Paragraph, "Failed to assign Paragraph module")
end


-- Module: Divider
local Divider
do
-- EnowLib Divider Component

Divider = {}
Divider.__index = Divider

function Divider.new(config, parent, theme, utils)
    local self = setmetatable({}, Divider)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Divider:CreateUI()
    if self.Config.Text then
        -- Divider with text
        self.Container = Instance.new("Frame")
        self.Container.BackgroundTransparency = 1
        self.Container.Size = UDim2.new(1, 0, 0, 30)
        self.Container.Parent = self.Parent
        
        local leftLine = Instance.new("Frame")
        leftLine.BackgroundColor3 = self.Theme.Colors.Border
        leftLine.BorderSizePixel = 0
        leftLine.Size = UDim2.new(0.5, -40, 0, 1)
        leftLine.Position = UDim2.new(0, 0, 0.5, 0)
        leftLine.Parent = self.Container
        
        local text = Instance.new("TextLabel")
        text.BackgroundTransparency = 1
        text.Size = UDim2.fromOffset(70, 30)
        text.Position = UDim2.new(0.5, -35, 0, 0)
        text.Font = self.Theme.Font.Bold
        text.Text = self.Config.Text
        text.TextColor3 = self.Theme.Colors.TextDim
        text.TextSize = self.Theme.Font.Size.Small
        text.Parent = self.Container
        
        local rightLine = Instance.new("Frame")
        rightLine.BackgroundColor3 = self.Theme.Colors.Border
        rightLine.BorderSizePixel = 0
        rightLine.Size = UDim2.new(0.5, -40, 0, 1)
        rightLine.Position = UDim2.new(0.5, 40, 0.5, 0)
        rightLine.Parent = self.Container
    else
        -- Simple line
        self.Container = Instance.new("Frame")
        self.Container.BackgroundColor3 = self.Theme.Colors.Border
        self.Container.BorderSizePixel = 0
        self.Container.Size = UDim2.new(1, 0, 0, 1)
        self.Container.Parent = self.Parent
    end
end
Divider = Divider
assert(Divider, "Failed to assign Divider module")
end


-- Module: Button
local Button
do
-- EnowLib Button Component

Button = {}
Button.__index = Button

function Button.new(config, parent, theme, utils)
    local self = setmetatable({}, Button)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Button",
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Button:CreateUI()
    self.Container = Instance.new("TextButton")
    self.Container.BackgroundColor3 = self.Theme.Colors.Accent
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Theme.Size.Component)
    self.Container.Font = self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = Color3.fromRGB(0, 0, 0)
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.AutoButtonColor = false
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    
    self.Container.MouseButton1Click:Connect(function()
        pcall(self.Config.Callback)
    end)
    
    self.Container.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.AccentHover
        }, self.Theme.Animation.Duration)
    end)
    
    self.Container.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, self.Theme.Animation.Duration)
    end)
end
Button = Button
assert(Button, "Failed to assign Button module")
end


-- Module: Toggle
local Toggle
do
-- EnowLib Toggle Component

Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config, parent, theme, utils)
    local self = setmetatable({}, Toggle)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Toggle",
        Default = false,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function Toggle:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 48)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Switch
    self.Switch = Instance.new("Frame")
    self.Switch.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Switch.BorderSizePixel = 0
    self.Switch.Size = UDim2.fromOffset(44, 24)
    self.Switch.Position = UDim2.new(1, 0, 0.5, 0)
    self.Switch.AnchorPoint = Vector2.new(1, 0.5)
    self.Switch.Parent = self.Container
    
    self.Theme.CreateCorner(self.Switch, 12)
    
    -- Knob
    self.Knob = Instance.new("Frame")
    self.Knob.BackgroundColor3 = self.Theme.Colors.Text
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(20, 20)
    self.Knob.Position = UDim2.fromOffset(2, 2)
    self.Knob.Parent = self.Switch
    
    self.Theme.CreateCorner(self.Knob, 10)
    
    -- Check icon
    self.CheckIcon = Instance.new("ImageLabel")
    self.CheckIcon.BackgroundTransparency = 1
    self.CheckIcon.Size = UDim2.fromOffset(16, 16)
    self.CheckIcon.Position = UDim2.fromScale(0.5, 0.5)
    self.CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    self.CheckIcon.Image = self.Theme.Icons.Check
    self.CheckIcon.ImageColor3 = self.Theme.Colors.Accent
    self.CheckIcon.ImageTransparency = 1
    self.CheckIcon.Parent = self.Knob
    
    -- Button
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = self.Container
    
    button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundTransparency = self.Theme.Transparency.None
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundTransparency = self.Theme.Transparency.Glass
        }, 0.15)
    end)
end

function Toggle:Toggle()
    self.Value = not self.Value
    self:UpdateVisual()
    pcall(self.Config.Callback, self.Value)
end

function Toggle:UpdateVisual()
    if self.Value then
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, self.Theme.Animation.Duration)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(22, 2)
        }, self.Theme.Animation.Duration)
        
        self.Utils.Tween(self.CheckIcon, {
            ImageTransparency = 0
        }, self.Theme.Animation.Duration)
    else
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.Secondary
        }, self.Theme.Animation.Duration)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(2, 2)
        }, self.Theme.Animation.Duration)
        
        self.Utils.Tween(self.CheckIcon, {
            ImageTransparency = 1
        }, self.Theme.Animation.Duration)
    end
end
Toggle = Toggle
assert(Toggle, "Failed to assign Toggle module")
end


-- Module: Slider
local Slider
do
-- EnowLib Slider Component

local UserInputService = game:GetService("UserInputService")

Slider = {}
Slider.__index = Slider

function Slider.new(config, parent, theme, utils)
    local self = setmetatable({}, Slider)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Slider",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Dragging = false
    self.Connections = {}
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function Slider:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 18)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Value
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.fromOffset(50, 18)
    self.ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    self.ValueLabel.Font = self.Theme.Font.Bold
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.TextColor3 = self.Theme.Colors.Accent
    self.ValueLabel.TextSize = self.Theme.Font.Size.Regular
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.Container
    
    -- Track
    self.Track = Instance.new("Frame")
    self.Track.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Track.BorderSizePixel = 0
    self.Track.Size = UDim2.new(1, 0, 0, 6)
    self.Track.Position = UDim2.fromOffset(0, 30)
    self.Track.Parent = self.Container
    
    self.Theme.CreateCorner(self.Track, 3)
    
    -- Fill
    self.Fill = Instance.new("Frame")
    self.Fill.BackgroundColor3 = self.Theme.Colors.Accent
    self.Fill.BorderSizePixel = 0
    self.Fill.Size = UDim2.new(0, 0, 1, 0)
    self.Fill.Parent = self.Track
    
    self.Theme.CreateCorner(self.Fill, 3)
    
    -- Knob
    self.Knob = Instance.new("Frame")
    self.Knob.BackgroundColor3 = self.Theme.Colors.Text
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(16, 16)
    self.Knob.Position = UDim2.new(0, 0, 0.5, 0)
    self.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Knob.Parent = self.Track
    
    self.Theme.CreateCorner(self.Knob, 8)
    self.Theme.CreateStroke(self.Knob, self.Theme.Colors.Accent, 2)
    
    -- Input Button
    local input = Instance.new("TextButton")
    input.BackgroundTransparency = 1
    input.Size = UDim2.new(1, 0, 0, 20)
    input.Position = UDim2.fromOffset(0, 25)
    input.Text = ""
    input.Parent = self.Container
    
    local function updateValue(inputPos)
        local trackPos = self.Track.AbsolutePosition.X
        local trackSize = self.Track.AbsoluteSize.X
        local relativePos = math.clamp((inputPos - trackPos) / trackSize, 0, 1)
        
        self.Value = math.floor(self.Config.Min + (self.Config.Max - self.Config.Min) * relativePos)
        self:UpdateVisual()
        pcall(self.Config.Callback, self.Value)
    end
    
    -- Input began (mouse or touch)
    table.insert(self.Connections, input.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = true
            updateValue(inputObject.Position.X)
        end
    end))
    
    -- Global input release (mouse or touch)
    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
            if self.Dragging then
                self.Dragging = false
                self.Utils.Tween(self.Knob, {
                    Size = UDim2.fromOffset(16, 16)
                }, 0.15)
            end
        end
    end))
    
    -- Global input move (mouse or touch, only when dragging)
    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch then
            if self.Dragging then
                updateValue(inputObject.Position.X)
            end
        end
    end))
    
    -- Hover effect on knob
    table.insert(self.Connections, input.MouseEnter:Connect(function()
        self.Utils.Tween(self.Knob, {
            Size = UDim2.fromOffset(18, 18)
        }, 0.15)
    end))
    
    table.insert(self.Connections, input.MouseLeave:Connect(function()
        if not self.Dragging then
            self.Utils.Tween(self.Knob, {
                Size = UDim2.fromOffset(16, 16)
            }, 0.15)
        end
    end))
end

function Slider:UpdateVisual()
    local percent = (self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min)
    
    self.Fill.Size = UDim2.new(percent, 0, 1, 0)
    self.Knob.Position = UDim2.new(percent, 0, 0.5, 0)
    self.ValueLabel.Text = tostring(self.Value)
end

function Slider:Destroy()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Container:Destroy()
end
Slider = Slider
assert(Slider, "Failed to assign Slider module")
end


-- Module: TextBox
local TextBox
do
-- EnowLib TextBox Component

TextBox = {}
TextBox.__index = TextBox

function TextBox.new(config, parent, theme, utils)
    local self = setmetatable({}, TextBox)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "TextBox",
        Placeholder = "Enter text...",
        Default = "",
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    
    return self
end

function TextBox:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 86)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 20)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Input Box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.BackgroundColor3 = self.Theme.Colors.Secondary
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Size = UDim2.new(1, 0, 0, 32)
    self.InputBox.Position = UDim2.fromOffset(0, 26)
    self.InputBox.Font = self.Theme.Font.Mono
    self.InputBox.Text = self.Value
    self.InputBox.PlaceholderText = self.Config.Placeholder
    self.InputBox.TextColor3 = self.Theme.Colors.Text
    self.InputBox.PlaceholderColor3 = self.Theme.Colors.TextDim
    self.InputBox.TextSize = self.Theme.Font.Size.Regular
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.Parent = self.Container
    
    self.Theme.CreateCorner(self.InputBox, 6)
    self.Theme.CreatePadding(self.InputBox, 10)
    
    -- Events
    self.InputBox.FocusLost:Connect(function(enterPressed)
        self.Value = self.InputBox.Text
        pcall(self.Config.Callback, self.Value)
    end)
end
TextBox = TextBox
assert(TextBox, "Failed to assign TextBox module")
end


-- Module: Dropdown
local Dropdown
do
-- EnowLib Dropdown Component

Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(config, parent, theme, utils)
    local self = setmetatable({}, Dropdown)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Dropdown",
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = "Option 1",
        Searchable = false,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Open = false
    self.AllOptions = {}
    
    self:CreateUI()
    
    return self
end

function Dropdown:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 86)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 20)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Dropdown Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 32)
    self.Button.Position = UDim2.fromOffset(0, 26)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 6)
    self.Theme.CreatePadding(self.Button, 10)
    
    -- Selected Text
    self.SelectedText = Instance.new("TextLabel")
    self.SelectedText.BackgroundTransparency = 1
    self.SelectedText.Size = UDim2.new(1, -30, 1, 0)
    self.SelectedText.Font = self.Theme.Font.Mono
    self.SelectedText.Text = self.Value
    self.SelectedText.TextColor3 = self.Theme.Colors.Text
    self.SelectedText.TextSize = self.Theme.Font.Size.Regular
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.Parent = self.Button
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.new(1, -16, 0.5, -8)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronDown
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Options List - positioned directly below button (no gap)
    self.OptionsList = Instance.new("ScrollingFrame")
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.Secondary
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(0, 58)
    self.OptionsList.ScrollBarThickness = 4
    self.OptionsList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.OptionsList.CanvasSize = UDim2.fromOffset(0, 0)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 5
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 6)
    self.Theme.CreatePadding(self.OptionsList, 4)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = self.OptionsList
    
    -- Search Box (optional) - positioned at top, no extra spacing
    if self.Config.Searchable then
        self.SearchBox = Instance.new("TextBox")
        self.SearchBox.BackgroundColor3 = self.Theme.Colors.Panel
        self.SearchBox.BorderSizePixel = 0
        self.SearchBox.Size = UDim2.new(1, 0, 0, 28)
        self.SearchBox.Font = self.Theme.Font.Mono
        self.SearchBox.PlaceholderText = "Search..."
        self.SearchBox.Text = ""
        self.SearchBox.TextColor3 = self.Theme.Colors.Text
        self.SearchBox.PlaceholderColor3 = self.Theme.Colors.TextDim
        self.SearchBox.TextSize = self.Theme.Font.Size.Regular
        self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        self.SearchBox.ClearTextOnFocus = false
        self.SearchBox.ZIndex = 6
        self.SearchBox.LayoutOrder = -1
        self.SearchBox.Parent = self.OptionsList
        
        self.Theme.CreateCorner(self.SearchBox, 4)
        self.Theme.CreatePadding(self.SearchBox, 8)
        
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            self:FilterOptions(self.SearchBox.Text)
        end)
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local maxHeight = math.min(layout.AbsoluteContentSize.Y, 150)
        self.OptionsList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
    end)
    
    -- Create options
    for _, option in ipairs(self.Config.Options) do
        self:CreateOption(option)
    end
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Dropdown:CreateOption(optionText)
    local option = Instance.new("TextButton")
    option.BackgroundColor3 = self.Theme.Colors.Panel
    option.BackgroundTransparency = 1
    option.BorderSizePixel = 0
    option.Size = UDim2.new(1, 0, 0, 32)
    option.Font = self.Theme.Font.Mono
    option.Text = optionText
    option.TextColor3 = self.Theme.Colors.TextDim
    option.TextSize = self.Theme.Font.Size.Regular
    option.TextXAlignment = Enum.TextXAlignment.Left
    option.AutoButtonColor = false
    option.Visible = true
    option.LayoutOrder = 1
    option.Parent = self.OptionsList
    
    self.Theme.CreatePadding(option, 10)
    
    -- Store reference
    table.insert(self.AllOptions, {
        Button = option,
        Text = optionText
    })
    
    option.MouseButton1Click:Connect(function()
        self:Select(optionText)
    end)
    
    option.MouseEnter:Connect(function()
        option.BackgroundTransparency = 0.9
        option.TextColor3 = self.Theme.Colors.Accent
    end)
    
    option.MouseLeave:Connect(function()
        option.BackgroundTransparency = 1
        option.TextColor3 = self.Theme.Colors.TextDim
    end)
end

function Dropdown:FilterOptions(searchText)
    if searchText == "" then
        -- Show all options
        for _, optionData in ipairs(self.AllOptions) do
            optionData.Button.Visible = true
        end
        
        if self.Open then
            local baseHeight = self.Config.Searchable and 32 or 0
            local optionsHeight = math.min(#self.AllOptions * 34, 150)
            self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
            self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
        end
        return
    end
    
    local lowerSearch = searchText:lower()
    local visibleCount = 0
    
    for _, optionData in ipairs(self.AllOptions) do
        local lowerText = optionData.Text:lower()
        local matches = lowerText:find(lowerSearch, 1, true) ~= nil
        optionData.Button.Visible = matches
        if matches then
            visibleCount = visibleCount + 1
        end
    end
    
    -- Update height based on visible options
    if self.Open then
        local baseHeight = self.Config.Searchable and 32 or 0
        local optionsHeight = visibleCount > 0 and math.min(visibleCount * 34, 150) or 32
        self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
        self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
    end
end

function Dropdown:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        local baseHeight = self.Config.Searchable and 32 or 0
        local optionsHeight = math.min(#self.Config.Options * 34, 150)
        self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
        self.OptionsList.Visible = true
        self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
        self.ChevronIcon.Rotation = 180
        
        -- Focus search box if searchable
        if self.Config.Searchable then
            task.wait(0.1)
            self.SearchBox:CaptureFocus()
        end
    else
        self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
        self.OptionsList.Visible = false
        self.Container.Size = UDim2.new(1, 0, 0, 86)
        self.ChevronIcon.Rotation = 0
        
        -- Clear search
        if self.Config.Searchable then
            self.SearchBox.Text = ""
            self:FilterOptions("")
        end
    end
end

function Dropdown:Select(value)
    self.Value = value
    self.SelectedText.Text = value
    self:Toggle()
    pcall(self.Config.Callback, value)
end
Dropdown = Dropdown
assert(Dropdown, "Failed to assign Dropdown module")
end


-- Module: MultiSelect
local MultiSelect
do
-- EnowLib MultiSelect Component

MultiSelect = {}
MultiSelect.__index = MultiSelect

function MultiSelect.new(config, parent, theme, utils)
    local self = setmetatable({}, MultiSelect)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "MultiSelect",
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = {},
        Callback = function(values) end
    }, config or {})
    
    self.Values = {}
    for _, v in ipairs(self.Config.Default) do
        self.Values[v] = true
    end
    self.Open = false
    
    self:CreateUI()
    self:UpdateDisplay()
    
    return self
end

function MultiSelect:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 86)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 20)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- MultiSelect Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 32)
    self.Button.Position = UDim2.fromOffset(0, 26)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 6)
    self.Theme.CreatePadding(self.Button, 10)
    
    -- Selected Text
    self.SelectedText = Instance.new("TextLabel")
    self.SelectedText.BackgroundTransparency = 1
    self.SelectedText.Size = UDim2.new(1, -30, 1, 0)
    self.SelectedText.Font = self.Theme.Font.Mono
    self.SelectedText.Text = "None selected"
    self.SelectedText.TextColor3 = self.Theme.Colors.TextDim
    self.SelectedText.TextSize = self.Theme.Font.Size.Regular
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.TextTruncate = Enum.TextTruncate.AtEnd
    self.SelectedText.Parent = self.Button
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.new(1, -16, 0.5, -8)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronDown
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Options List
    self.OptionsList = Instance.new("ScrollingFrame")
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.Secondary
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(0, 60)
    self.OptionsList.ScrollBarThickness = 4
    self.OptionsList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.OptionsList.CanvasSize = UDim2.fromOffset(0, 0)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 5
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 6)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = self.OptionsList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.OptionsList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
    end)
    
    -- Create options
    for _, option in ipairs(self.Config.Options) do
        self:CreateOption(option)
    end
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function MultiSelect:CreateOption(optionText)
    local option = Instance.new("TextButton")
    option.BackgroundColor3 = self.Theme.Colors.Panel
    option.BackgroundTransparency = 1
    option.BorderSizePixel = 0
    option.Size = UDim2.new(1, 0, 0, 28)
    option.Font = self.Theme.Font.Mono
    option.Text = ""
    option.AutoButtonColor = false
    option.Parent = self.OptionsList
    
    self.Theme.CreatePadding(option, 8)
    
    -- Option Text
    local optionLabel = Instance.new("TextLabel")
    optionLabel.BackgroundTransparency = 1
    optionLabel.Size = UDim2.new(1, 0, 1, 0)
    optionLabel.Font = self.Theme.Font.Mono
    optionLabel.Text = optionText
    optionLabel.TextColor3 = self.Theme.Colors.TextDim
    optionLabel.TextSize = self.Theme.Font.Size.Regular
    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
    optionLabel.Parent = option
    
    -- Update visual if already selected
    if self.Values[optionText] then
        option.BackgroundColor3 = self.Theme.Colors.Accent
        option.BackgroundTransparency = 0.9
        optionLabel.TextColor3 = self.Theme.Colors.Accent
    end
    
    option.MouseButton1Click:Connect(function()
        self:ToggleOption(optionText, option, optionLabel)
    end)
    
    option.MouseEnter:Connect(function()
        if not self.Values[optionText] then
            option.BackgroundTransparency = 0.95
            optionLabel.TextColor3 = self.Theme.Colors.Accent
        end
    end)
    
    option.MouseLeave:Connect(function()
        if not self.Values[optionText] then
            option.BackgroundTransparency = 1
            optionLabel.TextColor3 = self.Theme.Colors.TextDim
        end
    end)
end

function MultiSelect:ToggleOption(optionText, option, optionLabel)
    self.Values[optionText] = not self.Values[optionText]
    
    if self.Values[optionText] then
        self.Utils.Tween(option, {
            BackgroundColor3 = self.Theme.Colors.Accent,
            BackgroundTransparency = 0.9
        }, 0.15)
        self.Utils.Tween(optionLabel, {
            TextColor3 = self.Theme.Colors.Accent
        }, 0.15)
    else
        self.Utils.Tween(option, {
            BackgroundTransparency = 1
        }, 0.15)
        self.Utils.Tween(optionLabel, {
            TextColor3 = self.Theme.Colors.TextDim
        }, 0.15)
    end
    
    self:UpdateDisplay()
    
    local selectedValues = {}
    for value, selected in pairs(self.Values) do
        if selected then
            table.insert(selectedValues, value)
        end
    end
    
    pcall(self.Config.Callback, selectedValues)
end

function MultiSelect:UpdateDisplay()
    local selectedCount = 0
    local selectedList = {}
    
    for value, selected in pairs(self.Values) do
        if selected then
            selectedCount = selectedCount + 1
            table.insert(selectedList, value)
        end
    end
    
    if selectedCount == 0 then
        self.SelectedText.Text = "None selected"
        self.SelectedText.TextColor3 = self.Theme.Colors.TextDim
    elseif selectedCount == 1 then
        self.SelectedText.Text = selectedList[1]
        self.SelectedText.TextColor3 = self.Theme.Colors.Text
    else
        self.SelectedText.Text = selectedCount .. " items selected"
        self.SelectedText.TextColor3 = self.Theme.Colors.Text
    end
end

function MultiSelect:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        local optionsHeight = math.min(#self.Config.Options * 30, 150)
        self.OptionsList.Size = UDim2.new(1, 0, 0, optionsHeight)
        self.OptionsList.Visible = true
        self.Container.Size = UDim2.new(1, 0, 0, 86 + optionsHeight + 4)
        self.ChevronIcon.Rotation = 180
    else
        self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
        self.OptionsList.Visible = false
        self.Container.Size = UDim2.new(1, 0, 0, 86)
        self.ChevronIcon.Rotation = 0
    end
end
MultiSelect = MultiSelect
assert(MultiSelect, "Failed to assign MultiSelect module")
end


-- Module: ColorPicker
local ColorPicker
do
-- EnowLib ColorPicker Component

ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(config, parent, theme, utils)
    local self = setmetatable({}, ColorPicker)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Color Picker",
        Default = Color3.fromRGB(46, 204, 113),
        Callback = function(color) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    
    return self
end

function ColorPicker:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 48)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Color Display
    self.ColorDisplay = Instance.new("TextButton")
    self.ColorDisplay.BackgroundColor3 = self.Value
    self.ColorDisplay.BorderSizePixel = 0
    self.ColorDisplay.Size = UDim2.fromOffset(44, 24)
    self.ColorDisplay.Position = UDim2.new(1, 0, 0.5, 0)
    self.ColorDisplay.AnchorPoint = Vector2.new(1, 0.5)
    self.ColorDisplay.Text = ""
    self.ColorDisplay.Parent = self.Container
    
    self.Theme.CreateCorner(self.ColorDisplay, 6)
    self.Theme.CreateStroke(self.ColorDisplay, self.Theme.Colors.Border)
    
    -- Simple color picker (click to cycle through preset colors)
    local presetColors = {
        Color3.fromRGB(46, 204, 113),  -- Green
        Color3.fromRGB(52, 152, 219),  -- Blue
        Color3.fromRGB(155, 89, 182),  -- Purple
        Color3.fromRGB(241, 196, 15),  -- Yellow
        Color3.fromRGB(231, 76, 60),   -- Red
        Color3.fromRGB(230, 126, 34),  -- Orange
        Color3.fromRGB(255, 255, 255), -- White
        Color3.fromRGB(149, 165, 166)  -- Gray
    }
    
    local currentIndex = 1
    
    self.ColorDisplay.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #presetColors + 1
        self.Value = presetColors[currentIndex]
        self.ColorDisplay.BackgroundColor3 = self.Value
        pcall(self.Config.Callback, self.Value)
    end)
end
ColorPicker = ColorPicker
assert(ColorPicker, "Failed to assign ColorPicker module")
end


-- Module: Keybind
local Keybind
do
-- EnowLib Keybind Component

Keybind = {}
Keybind.__index = Keybind

function Keybind.new(config, parent, theme, utils)
    local self = setmetatable({}, Keybind)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Keybind",
        Default = "None",
        Callback = function(key) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Listening = false
    
    self:CreateUI()
    
    return self
end

function Keybind:CreateUI()
    local UserInputService = game:GetService("UserInputService")
    
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 48)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Keybind Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.fromOffset(80, 24)
    self.Button.Position = UDim2.new(1, 0, 0.5, 0)
    self.Button.AnchorPoint = Vector2.new(1, 0.5)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = self.Value
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Small
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 6)
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        if not self.Listening then
            self.Listening = true
            self.Button.Text = "..."
            self.Button.BackgroundColor3 = self.Theme.Colors.Accent
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if self.Listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name
                self.Value = key
                self.Button.Text = key
                self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
                self.Listening = false
                pcall(self.Config.Callback, key)
            end
        end
    end)
end
Keybind = Keybind
assert(Keybind, "Failed to assign Keybind module")
end


-- Module: Section
local Section
do
-- EnowLib Section Component

Section = {}
Section.__index = Section

function Section.new(config, parent, theme, utils)
    local self = setmetatable({}, Section)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Section"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Section:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Custom padding: 8px horizontal (match non-box sections), 12px top, 16px bottom
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 16)
    padding.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Accent
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Size = UDim2.new(1, 0, 1, -28)
    self.ContentContainer.Position = UDim2.fromOffset(0, 28)
    self.ContentContainer.Parent = self.Container
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = self.ContentContainer
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 56)
    end)
end

-- Component methods for Section
function Section:AddButton(config)
    return Button.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddToggle(config)
    return Toggle.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddSlider(config)
    return Slider.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddLabel(config)
    return Label.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddTextBox(config)
    return TextBox.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddDropdown(config)
    return Dropdown.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddMultiSelect(config)
    return MultiSelect.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddColorPicker(config)
    return ColorPicker.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddKeybind(config)
    return Keybind.new(config, self.ContentContainer, self.Theme, self.Utils)
end
Section = Section
assert(Section, "Failed to assign Section module")
end


-- Module: Item
local Item
do
-- EnowLib Item Component (File in Tree)

Item = {}
Item.__index = Item

function Item.new(config, category, theme, utils)
    local self = setmetatable({}, Item)
    
    self.Category = category
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Item",
        Icon = nil,
        Content = nil,
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Item:CreateUI()
    -- Item Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 36)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Category.ItemsContainer
    
    -- Icon (optional)
    if self.Config.Icon then
        self.Icon = Instance.new("ImageLabel")
        self.Icon.BackgroundTransparency = 1
        self.Icon.Size = UDim2.fromOffset(16, 16)
        self.Icon.Position = UDim2.fromOffset(56, 10)
        self.Icon.Image = self.Config.Icon
        self.Icon.ImageColor3 = self.Theme.Colors.TextDim
        self.Icon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 78 or 56
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.TextDim
    self.Title.TextSize = self.Theme.Font.Size.Regular
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
        pcall(self.Config.Callback)
    end)
    
    self.Button.MouseEnter:Connect(function()
        -- Don't show hover if this is the active item
        if self.Category.Window.CurrentItem == self then
            return
        end
        
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 0.9
        }, 0.15)
        self.Utils.Tween(self.Title, {
            TextColor3 = self.Theme.Colors.Accent
        }, 0.15)
        if self.Icon then
            self.Utils.Tween(self.Icon, {
                ImageColor3 = self.Theme.Colors.Accent
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        -- Don't reset if this is the active item
        if self.Category.Window.CurrentItem == self then
            return
        end
        
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 1
        }, 0.15)
        self.Utils.Tween(self.Title, {
            TextColor3 = self.Theme.Colors.TextDim
        }, 0.15)
        if self.Icon then
            self.Utils.Tween(self.Icon, {
                ImageColor3 = self.Theme.Colors.TextDim
            }, 0.15)
        end
    end)
end

function Item:Select()
    local window = self.Category.Window
    
    if window.CurrentItem then
        window.CurrentItem:Deselect()
    end
    
    window.CurrentItem = self
    
    -- Active state visual
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Accent,
        BackgroundTransparency = 0.85
    }, 0.15)
    self.Utils.Tween(self.Title, {
        TextColor3 = self.Theme.Colors.Text
    }, 0.15)
    if self.Icon then
        self.Utils.Tween(self.Icon, {
            ImageColor3 = self.Theme.Colors.Text
        }, 0.15)
    end
    
    if self.Config.Content then
        window:ShowContent(self.Config.Content)
    end
end

function Item:Deselect()
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Secondary,
        BackgroundTransparency = 1
    }, 0.15)
    self.Utils.Tween(self.Title, {
        TextColor3 = self.Theme.Colors.TextDim
    }, 0.15)
    if self.Icon then
        self.Utils.Tween(self.Icon, {
            ImageColor3 = self.Theme.Colors.TextDim
        }, 0.15)
    end
end
Item = Item
assert(Item, "Failed to assign Item module")
end


-- Module: Category
local Category
do
-- EnowLib Category Component (Tree Folder)

Category = {}
Category.__index = Category

function Category.new(config, window, theme, utils)
    local self = setmetatable({}, Category)
    
    self.Window = window
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Category",
        Icon = nil,
        Expanded = false
    }, config or {})
    
    self.Items = {}
    self.Expanded = self.Config.Expanded
    
    self:CreateUI()
    
    return self
end

function Category:CreateUI()
    -- Category Container
    self.Container = Instance.new("Frame")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.Parent = self.Window.SidebarList
    
    -- Category Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 40)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.fromOffset(10, 12)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.Accent
    self.ChevronIcon.Rotation = 0
    self.ChevronIcon.Parent = self.Button
    
    -- Folder Icon (optional)
    if self.Config.Icon then
        self.FolderIcon = Instance.new("ImageLabel")
        self.FolderIcon.BackgroundTransparency = 1
        self.FolderIcon.Size = UDim2.fromOffset(18, 18)
        self.FolderIcon.Position = UDim2.fromOffset(32, 11)
        self.FolderIcon.Image = self.Config.Icon
        self.FolderIcon.ImageColor3 = self.Theme.Colors.Accent
        self.FolderIcon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 56 or 32
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.Text
    self.Title.TextSize = self.Theme.Font.Size.Regular
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Items Container
    self.ItemsContainer = Instance.new("Frame")
    self.ItemsContainer.BackgroundTransparency = 1
    self.ItemsContainer.Size = UDim2.new(1, 0, 0, 0)
    self.ItemsContainer.Position = UDim2.fromOffset(0, 40)
    self.ItemsContainer.ClipsDescendants = true
    self.ItemsContainer.Parent = self.Container
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 0)
    layout.Parent = self.ItemsContainer
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 0.9
        }, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 1
        }, 0.15)
    end)
    
    -- Set initial state
    if self.Expanded then
        self:Expand(true)
    end
end

function Category:Toggle()
    if self.Expanded then
        self:Collapse()
    else
        self:Expand()
    end
end

function Category:Expand(instant)
    self.Expanded = true
    
    local duration = instant and 0 or self.Theme.Animation.Duration
    
    -- Rotate chevron
    self.Utils.Tween(self.ChevronIcon, {
        Rotation = 90
    }, duration)
    
    -- Calculate total height
    local totalHeight = 0
    for _, item in ipairs(self.Items) do
        totalHeight = totalHeight + 36
    end
    
    -- Expand container
    self.Utils.Tween(self.ItemsContainer, {
        Size = UDim2.new(1, 0, 0, totalHeight)
    }, duration)
    
    self.Utils.Tween(self.Container, {
        Size = UDim2.new(1, 0, 0, 40 + totalHeight)
    }, duration)
end

function Category:Collapse()
    self.Expanded = false
    
    -- Rotate chevron back
    self.Utils.Tween(self.ChevronIcon, {
        Rotation = 0
    }, self.Theme.Animation.Duration)
    
    -- Collapse container
    self.Utils.Tween(self.ItemsContainer, {
        Size = UDim2.new(1, 0, 0, 0)
    }, self.Theme.Animation.Duration)
    
    self.Utils.Tween(self.Container, {
        Size = UDim2.new(1, 0, 0, 40)
    }, self.Theme.Animation.Duration)
end

function Category:AddItem(config)
    local item = Item.new(config, self, self.Theme, self.Utils)
    table.insert(self.Items, item)
    
    if self.Expanded then
        self:Expand(true)
    end
    
    return item
end
Category = Category
assert(Category, "Failed to assign Category module")
end


-- Module: Tab
local Tab
do
-- EnowLib Tab Component

Tab = {}
Tab.__index = Tab

function Tab.new(config, window, theme, utils)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Tab",
        Icon = nil
    }, config or {})
    
    self.Components = {}
    self.Visible = false
    
    self:CreateUI()
    
    return self
end

function Tab:CreateUI()
    -- Tab Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 36)
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.TextDim
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Window.SidebarList
    
    self.Theme.CreateCorner(self.Button, 6)
    self.Theme.CreatePadding(self.Button, 12)
    
    -- Tab Icon (optional)
    if self.Config.Icon then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Size = UDim2.fromOffset(18, 18)
        self.TabIcon.Position = UDim2.fromOffset(0, 0)
        self.TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        self.TabIcon.Image = self.Config.Icon
        self.TabIcon.ImageColor3 = self.Theme.Colors.TextDim
        self.TabIcon.Parent = self.Button
        
        -- Adjust position to center vertically
        local connection
        connection = self.Button:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            self.TabIcon.Position = UDim2.fromOffset(0, self.Button.AbsoluteSize.Y / 2)
        end)
        self.TabIcon.Position = UDim2.fromOffset(0, self.Button.AbsoluteSize.Y / 2)
    end
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.new(1, -16, 0.5, 0)
    self.ChevronIcon.AnchorPoint = Vector2.new(0, 0.5)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Title
    local titleOffset = self.Config.Icon and 24 or 0
    local titleRightOffset = 24
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -(titleOffset + titleRightOffset), 1, 0)
    title.Position = UDim2.fromOffset(titleOffset, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.TextDim
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Button
    
    self.Title = title
    
    -- Tab Content
    self.Container = Instance.new("ScrollingFrame")
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.Container.CanvasSize = UDim2.fromOffset(0, 0)
    self.Container.Visible = false
    self.Container.ClipsDescendants = true
    self.Container.ZIndex = 1
    self.Container.Parent = self.Window.ContentArea
    
    self.Theme.CreatePadding(self.Container, self.Theme.Spacing.Large)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Medium)
    layout.Parent = self.Container
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 32)
    end)
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    self.Button.MouseEnter:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.Secondary,
                BackgroundTransparency = self.Theme.Transparency.None
            }, self.Theme.Animation.Duration)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundTransparency = self.Theme.Transparency.Subtle
            }, self.Theme.Animation.Duration)
        end
    end)
end

function Tab:Show()
    self.Visible = true
    self.Container.Visible = true
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Accent,
        BackgroundTransparency = self.Theme.Transparency.None
    }, self.Theme.Animation.Duration)
    
    self.Utils.Tween(self.Title, {
        TextColor3 = self.Theme.Colors.Text
    }, self.Theme.Animation.Duration)
    
    if self.TabIcon then
        self.Utils.Tween(self.TabIcon, {
            ImageColor3 = self.Theme.Colors.Text
        }, self.Theme.Animation.Duration)
    end
    
    self.Utils.Tween(self.ChevronIcon, {
        ImageColor3 = self.Theme.Colors.Text
    }, self.Theme.Animation.Duration)
    
    self.ChevronIcon.Image = self.Theme.Icons.ChevronDown
end

function Tab:Hide()
    self.Visible = false
    self.Container.Visible = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Secondary,
        BackgroundTransparency = self.Theme.Transparency.Subtle
    }, self.Theme.Animation.Duration)
    
    self.Utils.Tween(self.Title, {
        TextColor3 = self.Theme.Colors.TextDim
    }, self.Theme.Animation.Duration)
    
    if self.TabIcon then
        self.Utils.Tween(self.TabIcon, {
            ImageColor3 = self.Theme.Colors.TextDim
        }, self.Theme.Animation.Duration)
    end
    
    self.Utils.Tween(self.ChevronIcon, {
        ImageColor3 = self.Theme.Colors.TextDim
    }, self.Theme.Animation.Duration)
    
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
end

function Tab:AddButton(config)
    local button = Button.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, button)
    return button
end

function Tab:AddToggle(config)
    local toggle = Toggle.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, toggle)
    return toggle
end

function Tab:AddSlider(config)
    local slider = Slider.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, slider)
    return slider
end

function Tab:AddLabel(config)
    local label = Label.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, label)
    return label
end
Tab = Tab
assert(Tab, "Failed to assign Tab module")
end


-- Module: Window
local Window
do
-- EnowLib Window Component

Window = {}
Window.__index = Window

function Window.new(config, theme, utils, enowlib)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.EnowLib = enowlib
    self.Config = utils.Merge({
        Title = "EnowLib IDE",
        Size = UDim2.fromOffset(900, 600),
        ShowStatusBar = true
    }, config or {})
    
    self.Categories = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateUI()
    
    return self
end

function Window:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EnowLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main Container (Glass effect)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = 0.15
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    self.Container.Position = UDim2.fromScale(0.5, 0.5)
    self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Container.Parent = self.ScreenGui
    
    self.Theme.CreateCorner(self.Container, 12)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Size = UDim2.new(1, 0, 0, 48)
    self.TitleBar.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = self.Theme.Colors.Secondary
    closeBtn.BackgroundTransparency = self.Theme.Transparency.Subtle
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.fromOffset(32, 32)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
    closeBtn.Text = ""
    closeBtn.Parent = self.TitleBar
    
    self.Theme.CreateCorner(closeBtn, 6)
    
    -- Close Icon
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.BackgroundTransparency = 1
    closeIcon.Size = UDim2.fromOffset(20, 20)
    closeIcon.Position = UDim2.fromScale(0.5, 0.5)
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.Image = self.Theme.Icons.X
    closeIcon.ImageColor3 = self.Theme.Colors.TextDim
    closeIcon.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        self.Utils.Tween(closeBtn, {
            BackgroundColor3 = self.Theme.Colors.Error,
            BackgroundTransparency = self.Theme.Transparency.None
        }, self.Theme.Animation.Duration)
        self.Utils.Tween(closeIcon, {
            ImageColor3 = self.Theme.Colors.Text
        }, self.Theme.Animation.Duration)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        self.Utils.Tween(closeBtn, {
            BackgroundColor3 = self.Theme.Colors.Secondary,
            BackgroundTransparency = self.Theme.Transparency.Subtle
        }, self.Theme.Animation.Duration)
        self.Utils.Tween(closeIcon, {
            ImageColor3 = self.Theme.Colors.TextDim
        }, self.Theme.Animation.Duration)
    end)
    
    -- Separator
    local separator = Instance.new("Frame")
    separator.Name = "HeaderSeparator"
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 48)
    separator.Parent = self.Container
    
    self.HeaderSeparator = separator
    
    -- Tab Bar (Sidebar)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.Panel
    self.Sidebar.BackgroundTransparency = 0.2
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Size = UDim2.new(0, 280, 1, -73)
    self.Sidebar.Position = UDim2.fromOffset(0, 49)
    self.Sidebar.Parent = self.Container
    
    -- Sidebar Header
    self.SidebarHeader = Instance.new("Frame")
    self.SidebarHeader.Name = "SidebarHeader"
    self.SidebarHeader.BackgroundColor3 = self.Theme.Colors.Secondary
    self.SidebarHeader.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.SidebarHeader.BorderSizePixel = 0
    self.SidebarHeader.Size = UDim2.new(1, 0, 0, 32)
    self.SidebarHeader.Parent = self.Sidebar
    
    self.ExplorerLabel = Instance.new("TextLabel")
    self.ExplorerLabel.BackgroundTransparency = 1
    self.ExplorerLabel.Size = UDim2.new(1, -16, 1, 0)
    self.ExplorerLabel.Position = UDim2.fromOffset(12, 0)
    self.ExplorerLabel.Font = self.Theme.Font.Bold
    self.ExplorerLabel.Text = "EXPLORER"
    self.ExplorerLabel.TextColor3 = self.Theme.Colors.TextDim
    self.ExplorerLabel.TextSize = 11
    self.ExplorerLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ExplorerLabel.Parent = self.SidebarHeader
    
    self.SidebarList = Instance.new("ScrollingFrame")
    self.SidebarList.BackgroundTransparency = 1
    self.SidebarList.BorderSizePixel = 0
    self.SidebarList.Size = UDim2.new(1, 0, 1, -32)
    self.SidebarList.Position = UDim2.fromOffset(0, 32)
    self.SidebarList.ScrollBarThickness = 4
    self.SidebarList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.SidebarList.CanvasSize = UDim2.fromOffset(0, 0)
    self.SidebarList.Parent = self.Sidebar
    
    self.Theme.CreatePadding(self.SidebarList, 4)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = self.SidebarList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.SidebarList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)
    
    -- Vertical Separator
    self.VerticalSeparator = Instance.new("Frame")
    self.VerticalSeparator.Name = "VerticalSeparator"
    self.VerticalSeparator.BackgroundColor3 = self.Theme.Colors.Border
    self.VerticalSeparator.BorderSizePixel = 0
    self.VerticalSeparator.Size = UDim2.new(0, 1, 1, -73)
    self.VerticalSeparator.Position = UDim2.fromOffset(280, 49)
    self.VerticalSeparator.Parent = self.Container
    
    -- Content Area
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentArea.BackgroundTransparency = 0.2
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -281, 1, -73)
    self.ContentArea.Position = UDim2.fromOffset(281, 49)
    self.ContentArea.ScrollBarThickness = 6
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.ContentArea.CanvasSize = UDim2.fromOffset(0, 0)
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreatePadding(self.ContentArea, self.Theme.Spacing.Large)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, self.Theme.Spacing.Medium)
    contentLayout.Parent = self.ContentArea
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 32)
    end)
    
    -- Footer Separator
    self.FooterSeparator = Instance.new("Frame")
    self.FooterSeparator.Name = "FooterSeparator"
    self.FooterSeparator.BackgroundColor3 = self.Theme.Colors.Border
    self.FooterSeparator.BorderSizePixel = 0
    self.FooterSeparator.Size = UDim2.new(1, 0, 0, 1)
    self.FooterSeparator.Position = UDim2.new(0, 0, 1, -24)
    self.FooterSeparator.Parent = self.Container
    
    -- Footer
    self.Footer = Instance.new("Frame")
    self.Footer.Name = "Footer"
    self.Footer.BackgroundTransparency = 1
    self.Footer.Size = UDim2.new(1, 0, 0, 24)
    self.Footer.Position = UDim2.new(0, 0, 1, -24)
    self.Footer.Parent = self.Container
    
    -- Footer Text (read-only)
    self.FooterLabel = Instance.new("TextLabel")
    self.FooterLabel.BackgroundTransparency = 1
    self.FooterLabel.Size = UDim2.new(1, -32, 1, 0)
    self.FooterLabel.Position = UDim2.fromOffset(16, 0)
    self.FooterLabel.Font = self.Theme.Font.Mono
    self.FooterLabel.Text = "EnowLib v2.0.0"
    self.FooterLabel.TextColor3 = self.Theme.Colors.TextDim
    self.FooterLabel.TextSize = 11
    self.FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.FooterLabel.Parent = self.Footer
    
    -- Make draggable
    self.Utils.MakeDraggable(self.Container, self.TitleBar)
    
    -- Parent to CoreGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
end

function Window:AddCategory(config)
    local category = Category.new(config, self, self.Theme, self.Utils)
    table.insert(self.Categories, category)
    return category
end

function Window:AddTab(config)
    local tab = Tab.new(config, self, self.Theme, self.Utils)
    table.insert(self.Tabs, tab)
    
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab then
        self.CurrentTab:Hide()
    end
    
    self.CurrentTab = tab
    tab:Show()
end

function Window:ShowContent(contentFunc)
    self.Utils.ClearChildren(self.ContentArea)
    
    if contentFunc then
        local success, err = pcall(contentFunc, self)
        if not success then
            warn("[EnowLib] Content function error:", err)
        end
    end
end

function Window:Toggle()
    self.Container.Visible = not self.Container.Visible
end

-- Component Factory Methods (for use in Content functions)
function Window:AddButton(config)
    return Button.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddToggle(config)
    return Toggle.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddSlider(config)
    return Slider.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddLabel(config)
    return Label.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddTextBox(config)
    return TextBox.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddDropdown(config)
    return Dropdown.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddMultiSelect(config)
    return MultiSelect.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddColorPicker(config)
    return ColorPicker.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddKeybind(config)
    return Keybind.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddSection(config)
    return Section.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddParagraph(config)
    return Paragraph.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddDivider(config)
    return Divider.new(config, self.ContentArea, self.Theme, self.Utils)
end
Window = Window
assert(Window, "Failed to assign Window module")
end


-- Initialize EnowLib
EnowLib.Version = "2.0.0"
EnowLib.Author = "EnowHub Development"

-- Create window
function EnowLib:CreateWindow(config)
    assert(Theme, "Theme module not loaded")
    assert(Utils, "Utils module not loaded")
    assert(Window, "Window module not loaded")
    assert(Tab, "Tab module not loaded")
    
    local window = Window.new(config, Theme, Utils, EnowLib)
    return window
end

return EnowLib
