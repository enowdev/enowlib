-- EnowLib v2.0.0
-- Vaporwave Tech Dark UI Library
-- Built: 2025-12-26 07:21:00
-- Author: EnowHub Development

local EnowLib = {}


-- Module: Theme
local Theme
do
-- EnowLib Theme System
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
Theme = Theme
end


-- Module: Utils
local Utils
do
-- EnowLib Utility Functions

local Utils = {}

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

-- Create draggable frame
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
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
Utils = Utils
end


-- Module: Section
local Section
do
-- EnowLib Section Component

local Section = {}
Section.__index = Section

function Section.new(config, tab, theme, utils)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Section"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Section:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Section"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 30)
    self.Container.Parent = self.Tab.Container
    
    -- Left line
    local leftLine = Instance.new("Frame")
    leftLine.Name = "LeftLine"
    leftLine.BackgroundColor3 = self.Theme.Colors.Border
    leftLine.BorderSizePixel = 0
    leftLine.Size = UDim2.new(0.3, -40, 0, 1)
    leftLine.Position = UDim2.fromOffset(0, 15)
    leftLine.Parent = self.Container
    
    self.Theme.CreateGradient(leftLine, 90)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.fromOffset(0, 30)
    title.Position = UDim2.new(0.5, 0, 0, 0)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Primary
    title.TextSize = self.Theme.Font.Size.Small
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = self.Container
    
    -- Auto-size title
    title.Size = UDim2.fromOffset(title.TextBounds.X + 20, 30)
    
    -- Right line
    local rightLine = Instance.new("Frame")
    rightLine.Name = "RightLine"
    rightLine.BackgroundColor3 = self.Theme.Colors.Border
    rightLine.BorderSizePixel = 0
    rightLine.Size = UDim2.new(0.3, -40, 0, 1)
    rightLine.Position = UDim2.new(1, 0, 0, 15)
    rightLine.AnchorPoint = Vector2.new(1, 0)
    rightLine.Parent = self.Container
    
    self.Theme.CreateGradient(rightLine, 90)
end
Section = Section
end


-- Module: Label
local Label
do
-- EnowLib Label Component

local Label = {}
Label.__index = Label

function Label.new(config, tab, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label",
        Size = "Regular",
        Color = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Label"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 30)
    self.Container.Parent = self.Tab.Container
    
    -- Label text
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Text"
    self.Label.BackgroundTransparency = 1
    self.Label.Size = UDim2.new(1, -24, 1, 0)
    self.Label.Position = UDim2.fromOffset(12, 0)
    self.Label.Font = self.Theme.Font.Regular
    self.Label.Text = self.Config.Text
    self.Label.TextColor3 = self.Config.Color or self.Theme.Colors.TextDim
    self.Label.TextSize = self:GetFontSize()
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.TextYAlignment = Enum.TextYAlignment.Center
    self.Label.TextWrapped = true
    self.Label.Parent = self.Container
    
    -- Auto-resize based on text
    self.Label:GetPropertyChangedSignal("TextBounds"):Connect(function()
        local textHeight = self.Label.TextBounds.Y
        self.Container.Size = UDim2.new(1, 0, 0, math.max(30, textHeight + 10))
    end)
end

function Label:GetFontSize()
    local sizes = {
        Small = self.Theme.Font.Size.Small,
        Regular = self.Theme.Font.Size.Regular,
        Medium = self.Theme.Font.Size.Medium,
        Large = self.Theme.Font.Size.Large,
        Title = self.Theme.Font.Size.Title
    }
    
    return sizes[self.Config.Size] or self.Theme.Font.Size.Regular
end

function Label:SetText(text)
    self.Config.Text = text
    self.Label.Text = text
end

function Label:SetColor(color)
    self.Config.Color = color
    self.Label.TextColor3 = color
end
Label = Label
end


-- Module: Button
local Button
do
-- EnowLib Button Component

local Button = {}
Button.__index = Button

function Button.new(config, tab, theme, utils)
    local self = setmetatable({}, Button)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Button",
        Description = nil,
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Button:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "ButtonClick"
    self.Button.BackgroundTransparency = 1
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Click handler
    self.Button.MouseButton1Click:Connect(function()
        self.Utils.CreateRipple(self.Container, 
            Vector2.new(self.Button.AbsoluteSize.X / 2, self.Button.AbsoluteSize.Y / 2))
        
        pcall(self.Config.Callback)
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
        
        local stroke = self.Container:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.BackgroundLight
        }, 0.15)
        
        local stroke = self.Container:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border
            }, 0.15)
        end
    end)
end

function Button:SetTitle(title)
    self.Config.Title = title
    self.Container.Title.Text = title
end

function Button:SetCallback(callback)
    self.Config.Callback = callback
end
Button = Button
end


-- Module: Toggle
local Toggle
do
-- EnowLib Toggle Component

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config, tab, theme, utils)
    local self = setmetatable({}, Toggle)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Toggle",
        Description = nil,
        Default = false,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function Toggle:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -60, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Toggle switch background
    self.Switch = Instance.new("Frame")
    self.Switch.Name = "Switch"
    self.Switch.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Switch.BorderSizePixel = 0
    self.Switch.Size = UDim2.fromOffset(40, 20)
    self.Switch.Position = UDim2.new(1, -48, 0.5, 0)
    self.Switch.AnchorPoint = Vector2.new(0, 0.5)
    self.Switch.Parent = self.Container
    
    self.Theme.CreateCorner(self.Switch, 10)
    self.Theme.CreateStroke(self.Switch, self.Theme.Colors.Border)
    
    -- Toggle knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.BackgroundColor3 = self.Theme.Colors.TextDim
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(16, 16)
    self.Knob.Position = UDim2.fromOffset(2, 2)
    self.Knob.Parent = self.Switch
    
    self.Theme.CreateCorner(self.Knob, 8)
    
    -- Click button
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = self.Container
    
    button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.BackgroundLight
        }, 0.15)
    end)
end

function Toggle:Toggle()
    self.Value = not self.Value
    self:UpdateVisual()
    pcall(self.Config.Callback, self.Value)
end

function Toggle:SetValue(value)
    self.Value = value
    self:UpdateVisual()
end

function Toggle:UpdateVisual()
    if self.Value then
        -- On state
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.Primary
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(22, 2),
            BackgroundColor3 = self.Theme.Colors.Text
        }, 0.2)
        
        local stroke = self.Switch:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary
            }, 0.2)
        end
    else
        -- Off state
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = self.Theme.Colors.TextDim
        }, 0.2)
        
        local stroke = self.Switch:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border
            }, 0.2)
        end
    end
end
Toggle = Toggle
end


-- Module: Slider
local Slider
do
-- EnowLib Slider Component

local Slider = {}
Slider.__index = Slider

function Slider.new(config, tab, theme, utils)
    local self = setmetatable({}, Slider)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Slider",
        Description = nil,
        Min = 0,
        Max = 100,
        Default = 50,
        Increment = 1,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Dragging = false
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function Slider:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Slider"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Value display
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.fromOffset(50, 20)
    self.ValueLabel.Position = UDim2.new(1, -58, 0, 8)
    self.ValueLabel.Font = self.Theme.Font.Mono
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.TextColor3 = self.Theme.Colors.Primary
    self.ValueLabel.TextSize = self.Theme.Font.Size.Regular
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.Container
    
    -- Slider track
    self.Track = Instance.new("Frame")
    self.Track.Name = "Track"
    self.Track.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Track.BorderSizePixel = 0
    self.Track.Size = UDim2.new(1, -24, 0, 6)
    self.Track.Position = UDim2.fromOffset(12, 38)
    self.Track.Parent = self.Container
    
    self.Theme.CreateCorner(self.Track, 3)
    
    -- Slider fill
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.BackgroundColor3 = self.Theme.Colors.Primary
    self.Fill.BorderSizePixel = 0
    self.Fill.Size = UDim2.new(0, 0, 1, 0)
    self.Fill.Parent = self.Track
    
    self.Theme.CreateCorner(self.Fill, 3)
    self.Theme.CreateGradient(self.Fill, 0)
    
    -- Slider knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.BackgroundColor3 = self.Theme.Colors.Text
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(14, 14)
    self.Knob.Position = UDim2.new(0, 0, 0.5, 0)
    self.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Knob.Parent = self.Track
    
    self.Theme.CreateCorner(self.Knob, 7)
    self.Theme.CreateStroke(self.Knob, self.Theme.Colors.Primary, 2)
    
    -- Input handling
    local UserInputService = game:GetService("UserInputService")
    
    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            self:UpdateFromInput(input.Position.X)
        end
    end)
    
    self.Track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            self:UpdateFromInput(input.Position.X)
        end
    end)
    
    -- Hover effects
    self.Track.MouseEnter:Connect(function()
        self.Utils.Tween(self.Knob, {
            Size = UDim2.fromOffset(16, 16)
        }, 0.15)
    end)
    
    self.Track.MouseLeave:Connect(function()
        if not self.Dragging then
            self.Utils.Tween(self.Knob, {
                Size = UDim2.fromOffset(14, 14)
            }, 0.15)
        end
    end)
end

function Slider:UpdateFromInput(mouseX)
    local trackPos = self.Track.AbsolutePosition.X
    local trackSize = self.Track.AbsoluteSize.X
    local relativeX = math.clamp(mouseX - trackPos, 0, trackSize)
    local percentage = relativeX / trackSize
    
    local range = self.Config.Max - self.Config.Min
    local rawValue = self.Config.Min + (range * percentage)
    local value = math.floor(rawValue / self.Config.Increment + 0.5) * self.Config.Increment
    
    self:SetValue(value)
    pcall(self.Config.Callback, self.Value)
end

function Slider:SetValue(value)
    self.Value = self.Utils.Clamp(value, self.Config.Min, self.Config.Max)
    self:UpdateVisual()
end

function Slider:UpdateVisual()
    local percentage = (self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min)
    
    self.Fill.Size = UDim2.new(percentage, 0, 1, 0)
    self.Knob.Position = UDim2.new(percentage, 0, 0.5, 0)
    self.ValueLabel.Text = tostring(self.Value)
end
Slider = Slider
end


-- Module: Input
local Input
do
-- EnowLib Input Component

local Input = {}
Input.__index = Input

function Input.new(config, tab, theme, utils)
    local self = setmetatable({}, Input)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Input",
        Description = nil,
        Placeholder = "Enter text...",
        Default = "",
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    
    return self
end

function Input:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Input"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 72 or 56)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 14)
        desc.Position = UDim2.fromOffset(12, 26)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Input box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "InputBox"
    self.InputBox.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Size = UDim2.new(1, -24, 0, 28)
    self.InputBox.Position = UDim2.fromOffset(12, self.Config.Description and 40 or 24)
    self.InputBox.Font = self.Theme.Font.Regular
    self.InputBox.PlaceholderText = self.Config.Placeholder
    self.InputBox.PlaceholderColor3 = self.Theme.Colors.TextDim
    self.InputBox.Text = self.Value
    self.InputBox.TextColor3 = self.Theme.Colors.Text
    self.InputBox.TextSize = self.Theme.Font.Size.Regular
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.Parent = self.Container
    
    self.Theme.CreateCorner(self.InputBox, 4)
    self.Theme.CreateStroke(self.InputBox, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.InputBox, {8, 8, 0, 0})
    
    -- Focus effects
    self.InputBox.Focused:Connect(function()
        local stroke = self.InputBox:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary,
                Thickness = 2
            }, 0.15)
        end
    end)
    
    self.InputBox.FocusLost:Connect(function(enterPressed)
        local stroke = self.InputBox:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border,
                Thickness = 1
            }, 0.15)
        end
        
        if enterPressed then
            self.Value = self.InputBox.Text
            pcall(self.Config.Callback, self.Value)
        end
    end)
end

function Input:SetValue(value)
    self.Value = value
    self.InputBox.Text = value
end

function Input:GetValue()
    return self.InputBox.Text
end
Input = Input
end


-- Module: Dropdown
local Dropdown
do
-- EnowLib Dropdown Component

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(config, tab, theme, utils)
    local self = setmetatable({}, Dropdown)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Dropdown",
        Description = nil,
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = nil,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default or self.Config.Options[1]
    self.Open = false
    
    self:CreateUI()
    
    return self
end

function Dropdown:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Dropdown"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 72 or 56)
    self.Container.Parent = self.Tab.Container
    self.Container.ClipsDescendants = false
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 14)
        desc.Position = UDim2.fromOffset(12, 26)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Dropdown button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "DropdownButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, -24, 0, 28)
    self.Button.Position = UDim2.fromOffset(12, self.Config.Description and 40 or 24)
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreateStroke(self.Button, self.Theme.Colors.Border)
    
    -- Selected value text
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.new(1, -32, 1, 0)
    self.ValueLabel.Position = UDim2.fromOffset(8, 0)
    self.ValueLabel.Font = self.Theme.Font.Regular
    self.ValueLabel.Text = self.Value
    self.ValueLabel.TextColor3 = self.Theme.Colors.Text
    self.ValueLabel.TextSize = self.Theme.Font.Size.Regular
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ValueLabel.Parent = self.Button
    
    -- Arrow icon
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.Position = UDim2.new(1, -24, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0, 0.5)
    arrow.Font = self.Theme.Font.Bold
    arrow.Text = "▼"
    arrow.TextColor3 = self.Theme.Colors.TextDim
    arrow.TextSize = 10
    arrow.Parent = self.Button
    
    self.Arrow = arrow
    
    -- Options list
    self.OptionsList = Instance.new("Frame")
    self.OptionsList.Name = "OptionsList"
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, -24, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(12, self.Config.Description and 72 or 56)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 100
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 4)
    self.Theme.CreateStroke(self.OptionsList, self.Theme.Colors.Primary)
    
    -- Options scroll
    local optionsScroll = Instance.new("ScrollingFrame")
    optionsScroll.Name = "Scroll"
    optionsScroll.BackgroundTransparency = 1
    optionsScroll.BorderSizePixel = 0
    optionsScroll.Size = UDim2.new(1, 0, 1, 0)
    optionsScroll.ScrollBarThickness = 4
    optionsScroll.ScrollBarImageColor3 = self.Theme.Colors.Primary
    optionsScroll.CanvasSize = UDim2.fromOffset(0, 0)
    optionsScroll.Parent = self.OptionsList
    
    -- Options layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = optionsScroll
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsScroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
    end)
    
    -- Create option buttons
    for _, option in ipairs(self.Config.Options) do
        self:CreateOption(option, optionsScroll)
    end
    
    -- Button click
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.15)
    end)
end

function Dropdown:CreateOption(option, parent)
    local optionButton = Instance.new("TextButton")
    optionButton.Name = "Option"
    optionButton.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    optionButton.BorderSizePixel = 0
    optionButton.Size = UDim2.new(1, 0, 0, 28)
    optionButton.Font = self.Theme.Font.Regular
    optionButton.Text = option
    optionButton.TextColor3 = self.Theme.Colors.Text
    optionButton.TextSize = self.Theme.Font.Size.Regular
    optionButton.TextXAlignment = Enum.TextXAlignment.Left
    optionButton.AutoButtonColor = false
    optionButton.Parent = parent
    
    self.Theme.CreatePadding(optionButton, {8, 8, 0, 0})
    
    optionButton.MouseButton1Click:Connect(function()
        self:SetValue(option)
        self:Close()
        pcall(self.Config.Callback, option)
    end)
    
    optionButton.MouseEnter:Connect(function()
        self.Utils.Tween(optionButton, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    optionButton.MouseLeave:Connect(function()
        self.Utils.Tween(optionButton, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.15)
    end)
end

function Dropdown:Toggle()
    if self.Open then
        self:Close()
    else
        self:Open()
    end
end

function Dropdown:Open()
    self.Open = true
    
    local optionCount = math.min(#self.Config.Options, 5)
    local height = optionCount * 28
    
    self.OptionsList.Visible = true
    self.Utils.Tween(self.OptionsList, {
        Size = UDim2.new(1, -24, 0, height)
    }, 0.2)
    
    self.Utils.Tween(self.Arrow, {
        Rotation = 180
    }, 0.2)
end

function Dropdown:Close()
    self.Open = false
    
    self.Utils.Tween(self.OptionsList, {
        Size = UDim2.new(1, -24, 0, 0)
    }, 0.2, nil, nil, function()
        self.OptionsList.Visible = false
    end)
    
    self.Utils.Tween(self.Arrow, {
        Rotation = 0
    }, 0.2)
end

function Dropdown:SetValue(value)
    self.Value = value
    self.ValueLabel.Text = value
end
Dropdown = Dropdown
end


-- Module: Keybind
local Keybind
do
-- EnowLib Keybind Component

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(config, tab, theme, utils)
    local self = setmetatable({}, Keybind)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Keybind",
        Description = nil,
        Default = Enum.KeyCode.E,
        Callback = function(key) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Listening = false
    
    self:CreateUI()
    self:SetupListener()
    
    return self
end

function Keybind:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Keybind"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -100, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Keybind button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "KeybindButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.fromOffset(80, 24)
    self.Button.Position = UDim2.new(1, -88, 0.5, 0)
    self.Button.AnchorPoint = Vector2.new(0, 0.5)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = self:GetKeyName(self.Value)
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Small
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreateStroke(self.Button, self.Theme.Colors.Border)
    
    -- Click handler
    self.Button.MouseButton1Click:Connect(function()
        self:StartListening()
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        if not self.Listening then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.Hover
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Listening then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.BackgroundDark
            }, 0.15)
        end
    end)
end

function Keybind:SetupListener()
    local UserInputService = game:GetService("UserInputService")
    
    self.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if self.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self:SetKey(input.KeyCode)
                self:StopListening()
            end
        else
            if input.KeyCode == self.Value then
                pcall(self.Config.Callback, self.Value)
            end
        end
    end)
end

function Keybind:StartListening()
    self.Listening = true
    self.Button.Text = "..."
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Primary
    }, 0.15)
    
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Primary
        }, 0.15)
    end
end

function Keybind:StopListening()
    self.Listening = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.BackgroundDark
    }, 0.15)
    
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Border
        }, 0.15)
    end
end

function Keybind:SetKey(keyCode)
    self.Value = keyCode
    self.Button.Text = self:GetKeyName(keyCode)
end

function Keybind:GetKeyName(keyCode)
    local name = keyCode.Name
    
    -- Simplify common key names
    name = name:gsub("Key", "")
    
    return name
end

function Keybind:Destroy()
    if self.Connection then
        self.Connection:Disconnect()
    end
    self.Container:Destroy()
end
Keybind = Keybind
end


-- Module: ColorPicker
local ColorPicker
do
-- EnowLib ColorPicker Component

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(config, tab, theme, utils)
    local self = setmetatable({}, ColorPicker)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Color Picker",
        Description = nil,
        Default = Color3.fromRGB(138, 43, 226),
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Open = false
    self.Hue = 0
    self.Saturation = 1
    self.Value = 1
    
    self:CreateUI()
    self:UpdateFromColor(self.Config.Default)
    
    return self
end

function ColorPicker:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ColorPicker"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    self.Container.ClipsDescendants = false
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -60, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Color preview button
    self.PreviewButton = Instance.new("TextButton")
    self.PreviewButton.Name = "Preview"
    self.PreviewButton.BackgroundColor3 = self.Value
    self.PreviewButton.BorderSizePixel = 0
    self.PreviewButton.Size = UDim2.fromOffset(32, 24)
    self.PreviewButton.Position = UDim2.new(1, -40, 0.5, 0)
    self.PreviewButton.AnchorPoint = Vector2.new(0, 0.5)
    self.PreviewButton.Text = ""
    self.PreviewButton.AutoButtonColor = false
    self.PreviewButton.Parent = self.Container
    
    self.Theme.CreateCorner(self.PreviewButton, 4)
    self.Theme.CreateStroke(self.PreviewButton, self.Theme.Colors.Border)
    
    -- Picker panel
    self.PickerPanel = Instance.new("Frame")
    self.PickerPanel.Name = "PickerPanel"
    self.PickerPanel.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.PickerPanel.BorderSizePixel = 0
    self.PickerPanel.Size = UDim2.new(0, 200, 0, 0)
    self.PickerPanel.Position = UDim2.new(1, -208, 1, 8)
    self.PickerPanel.Visible = false
    self.PickerPanel.ZIndex = 100
    self.PickerPanel.Parent = self.Container
    
    self.Theme.CreateCorner(self.PickerPanel)
    self.Theme.CreateStroke(self.PickerPanel, self.Theme.Colors.Primary, 2)
    
    -- SV Picker (Saturation/Value)
    self.SVPicker = Instance.new("ImageButton")
    self.SVPicker.Name = "SVPicker"
    self.SVPicker.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    self.SVPicker.BorderSizePixel = 0
    self.SVPicker.Size = UDim2.new(1, -16, 0, 150)
    self.SVPicker.Position = UDim2.fromOffset(8, 8)
    self.SVPicker.Image = "rbxassetid://4155801252"
    self.SVPicker.AutoButtonColor = false
    self.SVPicker.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.SVPicker, 4)
    
    -- SV Cursor
    self.SVCursor = Instance.new("Frame")
    self.SVCursor.Name = "Cursor"
    self.SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SVCursor.BorderSizePixel = 0
    self.SVCursor.Size = UDim2.fromOffset(8, 8)
    self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SVCursor.Parent = self.SVPicker
    
    self.Theme.CreateCorner(self.SVCursor, 4)
    self.Theme.CreateStroke(self.SVCursor, Color3.fromRGB(0, 0, 0), 2)
    
    -- Hue slider
    self.HueSlider = Instance.new("ImageButton")
    self.HueSlider.Name = "HueSlider"
    self.HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueSlider.BorderSizePixel = 0
    self.HueSlider.Size = UDim2.new(1, -16, 0, 12)
    self.HueSlider.Position = UDim2.fromOffset(8, 166)
    self.HueSlider.Image = "rbxassetid://3641079629"
    self.HueSlider.ImageColor3 = Color3.fromRGB(255, 255, 255)
    self.HueSlider.ScaleType = Enum.ScaleType.Crop
    self.HueSlider.AutoButtonColor = false
    self.HueSlider.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.HueSlider, 6)
    
    -- Hue cursor
    self.HueCursor = Instance.new("Frame")
    self.HueCursor.Name = "Cursor"
    self.HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueCursor.BorderSizePixel = 0
    self.HueCursor.Size = UDim2.fromOffset(4, 16)
    self.HueCursor.Position = UDim2.fromOffset(0, -2)
    self.HueCursor.AnchorPoint = Vector2.new(0.5, 0)
    self.HueCursor.Parent = self.HueSlider
    
    self.Theme.CreateCorner(self.HueCursor, 2)
    self.Theme.CreateStroke(self.HueCursor, Color3.fromRGB(0, 0, 0), 1)
    
    -- RGB inputs
    local rgbContainer = Instance.new("Frame")
    rgbContainer.Name = "RGB"
    rgbContainer.BackgroundTransparency = 1
    rgbContainer.Size = UDim2.new(1, -16, 0, 28)
    rgbContainer.Position = UDim2.fromOffset(8, 186)
    rgbContainer.Parent = self.PickerPanel
    
    local rgbLabels = {"R", "G", "B"}
    for i, label in ipairs(rgbLabels) do
        local input = Instance.new("TextBox")
        input.Name = label
        input.BackgroundColor3 = self.Theme.Colors.BackgroundLight
        input.BorderSizePixel = 0
        input.Size = UDim2.new(0.3, -4, 1, 0)
        input.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
        input.Font = self.Theme.Font.Mono
        input.Text = "255"
        input.TextColor3 = self.Theme.Colors.Text
        input.TextSize = self.Theme.Font.Size.Small
        input.PlaceholderText = label
        input.Parent = rgbContainer
        
        self.Theme.CreateCorner(input, 4)
        
        input.FocusLost:Connect(function()
            self:UpdateFromRGB()
        end)
    end
    
    -- Hex input
    self.HexInput = Instance.new("TextBox")
    self.HexInput.Name = "Hex"
    self.HexInput.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.HexInput.BorderSizePixel = 0
    self.HexInput.Size = UDim2.new(1, -16, 0, 28)
    self.HexInput.Position = UDim2.fromOffset(8, 222)
    self.HexInput.Font = self.Theme.Font.Mono
    self.HexInput.Text = "#8A2BE2"
    self.HexInput.TextColor3 = self.Theme.Colors.Text
    self.HexInput.TextSize = self.Theme.Font.Size.Small
    self.HexInput.PlaceholderText = "#RRGGBB"
    self.HexInput.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.HexInput, 4)
    
    self.HexInput.FocusLost:Connect(function()
        self:UpdateFromHex()
    end)
    
    -- Event handlers
    local UserInputService = game:GetService("UserInputService")
    local draggingSV = false
    local draggingHue = false
    
    self.SVPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = true
            self:UpdateSVFromInput(input.Position)
        end
    end)
    
    self.SVPicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = false
        end
    end)
    
    self.HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = true
            self:UpdateHueFromInput(input.Position)
        end
    end)
    
    self.HueSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingSV then
                self:UpdateSVFromInput(input.Position)
            elseif draggingHue then
                self:UpdateHueFromInput(input.Position)
            end
        end
    end)
    
    -- Preview button click
    self.PreviewButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    self.PreviewButton.MouseEnter:Connect(function()
        local stroke = self.PreviewButton:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary
            }, 0.15)
        end
    end)
    
    self.PreviewButton.MouseLeave:Connect(function()
        local stroke = self.PreviewButton:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border
            }, 0.15)
        end
    end)
end

function ColorPicker:UpdateSVFromInput(mousePos)
    local pos = self.SVPicker.AbsolutePosition
    local size = self.SVPicker.AbsoluteSize
    
    local relativeX = math.clamp(mousePos.X - pos.X, 0, size.X)
    local relativeY = math.clamp(mousePos.Y - pos.Y, 0, size.Y)
    
    self.Saturation = relativeX / size.X
    self.Brightness = 1 - (relativeY / size.Y)
    
    self:UpdateColor()
end

function ColorPicker:UpdateHueFromInput(mousePos)
    local pos = self.HueSlider.AbsolutePosition
    local size = self.HueSlider.AbsoluteSize
    
    local relativeX = math.clamp(mousePos.X - pos.X, 0, size.X)
    self.Hue = relativeX / size.X
    
    self:UpdateColor()
end

function ColorPicker:UpdateColor()
    local color = Color3.fromHSV(self.Hue, self.Saturation, self.Brightness)
    self.Value = color
    
    -- Update preview
    self.PreviewButton.BackgroundColor3 = color
    
    -- Update SV picker background
    self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    
    -- Update cursors
    self.SVCursor.Position = UDim2.new(self.Saturation, 0, 1 - self.Brightness, 0)
    self.HueCursor.Position = UDim2.new(self.Hue, 0, 0, -2)
    
    -- Update RGB inputs
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    
    local rgbContainer = self.PickerPanel:FindFirstChild("RGB")
    if rgbContainer then
        rgbContainer.R.Text = tostring(r)
        rgbContainer.G.Text = tostring(g)
        rgbContainer.B.Text = tostring(b)
    end
    
    -- Update hex input
    self.HexInput.Text = string.format("#%02X%02X%02X", r, g, b)
    
    -- Callback
    pcall(self.Config.Callback, color)
end

function ColorPicker:UpdateFromColor(color)
    local h, s, v = color:ToHSV()
    self.Hue = h
    self.Saturation = s
    self.Brightness = v
    self:UpdateColor()
end

function ColorPicker:UpdateFromRGB()
    local rgbContainer = self.PickerPanel:FindFirstChild("RGB")
    if not rgbContainer then return end
    
    local r = tonumber(rgbContainer.R.Text) or 0
    local g = tonumber(rgbContainer.G.Text) or 0
    local b = tonumber(rgbContainer.B.Text) or 0
    
    r = math.clamp(r, 0, 255)
    g = math.clamp(g, 0, 255)
    b = math.clamp(b, 0, 255)
    
    local color = Color3.fromRGB(r, g, b)
    self:UpdateFromColor(color)
end

function ColorPicker:UpdateFromHex()
    local hex = self.HexInput.Text:gsub("#", "")
    
    if #hex ~= 6 then return end
    
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    
    local color = Color3.fromRGB(r, g, b)
    self:UpdateFromColor(color)
end

function ColorPicker:Toggle()
    if self.Open then
        self:Close()
    else
        self:Open()
    end
end

function ColorPicker:Open()
    self.Open = true
    self.PickerPanel.Visible = true
    
    self.Utils.Tween(self.PickerPanel, {
        Size = UDim2.new(0, 200, 0, 258)
    }, 0.2)
end

function ColorPicker:Close()
    self.Open = false
    
    self.Utils.Tween(self.PickerPanel, {
        Size = UDim2.new(0, 200, 0, 0)
    }, 0.2, nil, nil, function()
        self.PickerPanel.Visible = false
    end)
end

function ColorPicker:SetValue(color)
    self:UpdateFromColor(color)
end
ColorPicker = ColorPicker
end


-- Module: MultiDropdown
local MultiDropdown
do
-- EnowLib MultiDropdown Component (Checkbox List)

local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown

function MultiDropdown.new(config, tab, theme, utils)
    local self = setmetatable({}, MultiDropdown)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Multi Select",
        Description = nil,
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
    
    return self
end

function MultiDropdown:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "MultiDropdown"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 72 or 56)
    self.Container.Parent = self.Tab.Container
    self.Container.ClipsDescendants = false
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 14)
        desc.Position = UDim2.fromOffset(12, 26)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Dropdown button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "DropdownButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, -24, 0, 28)
    self.Button.Position = UDim2.fromOffset(12, self.Config.Description and 40 or 24)
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreateStroke(self.Button, self.Theme.Colors.Border)
    
    -- Selected count text
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.new(1, -32, 1, 0)
    self.ValueLabel.Position = UDim2.fromOffset(8, 0)
    self.ValueLabel.Font = self.Theme.Font.Regular
    self.ValueLabel.Text = self:GetDisplayText()
    self.ValueLabel.TextColor3 = self.Theme.Colors.TextDim
    self.ValueLabel.TextSize = self.Theme.Font.Size.Regular
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ValueLabel.Parent = self.Button
    
    -- Arrow icon
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.Position = UDim2.new(1, -24, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0, 0.5)
    arrow.Font = self.Theme.Font.Bold
    arrow.Text = "▼"
    arrow.TextColor3 = self.Theme.Colors.TextDim
    arrow.TextSize = 10
    arrow.Parent = self.Button
    
    self.Arrow = arrow
    
    -- Options list
    self.OptionsList = Instance.new("Frame")
    self.OptionsList.Name = "OptionsList"
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, -24, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(12, self.Config.Description and 72 or 56)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 100
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 4)
    self.Theme.CreateStroke(self.OptionsList, self.Theme.Colors.Primary)
    
    -- Options scroll
    local optionsScroll = Instance.new("ScrollingFrame")
    optionsScroll.Name = "Scroll"
    optionsScroll.BackgroundTransparency = 1
    optionsScroll.BorderSizePixel = 0
    optionsScroll.Size = UDim2.new(1, 0, 1, 0)
    optionsScroll.ScrollBarThickness = 4
    optionsScroll.ScrollBarImageColor3 = self.Theme.Colors.Primary
    optionsScroll.CanvasSize = UDim2.fromOffset(0, 0)
    optionsScroll.Parent = self.OptionsList
    
    -- Options layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = optionsScroll
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsScroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
    end)
    
    -- Create option checkboxes
    for _, option in ipairs(self.Config.Options) do
        self:CreateOption(option, optionsScroll)
    end
    
    -- Button click
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.15)
    end)
end

function MultiDropdown:CreateOption(option, parent)
    local optionContainer = Instance.new("Frame")
    optionContainer.Name = "Option"
    optionContainer.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    optionContainer.BorderSizePixel = 0
    optionContainer.Size = UDim2.new(1, 0, 0, 32)
    optionContainer.Parent = parent
    
    -- Checkbox
    local checkbox = Instance.new("Frame")
    checkbox.Name = "Checkbox"
    checkbox.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    checkbox.BorderSizePixel = 0
    checkbox.Size = UDim2.fromOffset(18, 18)
    checkbox.Position = UDim2.fromOffset(8, 7)
    checkbox.Parent = optionContainer
    
    self.Theme.CreateCorner(checkbox, 4)
    self.Theme.CreateStroke(checkbox, self.Theme.Colors.Border)
    
    -- Checkmark
    local checkmark = Instance.new("TextLabel")
    checkmark.Name = "Checkmark"
    checkmark.BackgroundTransparency = 1
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.Font = self.Theme.Font.Bold
    checkmark.Text = "✓"
    checkmark.TextColor3 = self.Theme.Colors.Primary
    checkmark.TextSize = 14
    checkmark.Visible = self.Values[option] or false
    checkmark.Parent = checkbox
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -34, 1, 0)
    label.Position = UDim2.fromOffset(30, 0)
    label.Font = self.Theme.Font.Regular
    label.Text = option
    label.TextColor3 = self.Theme.Colors.Text
    label.TextSize = self.Theme.Font.Size.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = optionContainer
    
    -- Click button
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = optionContainer
    
    button.MouseButton1Click:Connect(function()
        self:ToggleOption(option, checkmark)
    end)
    
    button.MouseEnter:Connect(function()
        self.Utils.Tween(optionContainer, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self.Utils.Tween(optionContainer, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.15)
    end)
end

function MultiDropdown:ToggleOption(option, checkmark)
    self.Values[option] = not self.Values[option]
    checkmark.Visible = self.Values[option]
    
    self.ValueLabel.Text = self:GetDisplayText()
    
    local selected = {}
    for opt, enabled in pairs(self.Values) do
        if enabled then
            table.insert(selected, opt)
        end
    end
    
    pcall(self.Config.Callback, selected)
end

function MultiDropdown:GetDisplayText()
    local count = 0
    for _, enabled in pairs(self.Values) do
        if enabled then
            count = count + 1
        end
    end
    
    if count == 0 then
        return "None selected"
    elseif count == 1 then
        for opt, enabled in pairs(self.Values) do
            if enabled then
                return opt
            end
        end
    else
        return string.format("%d selected", count)
    end
end

function MultiDropdown:Toggle()
    if self.Open then
        self:Close()
    else
        self:OpenList()
    end
end

function MultiDropdown:OpenList()
    self.Open = true
    
    local optionCount = math.min(#self.Config.Options, 5)
    local height = optionCount * 32
    
    self.OptionsList.Visible = true
    self.Utils.Tween(self.OptionsList, {
        Size = UDim2.new(1, -24, 0, height)
    }, 0.2)
    
    self.Utils.Tween(self.Arrow, {
        Rotation = 180
    }, 0.2)
end

function MultiDropdown:Close()
    self.Open = false
    
    self.Utils.Tween(self.OptionsList, {
        Size = UDim2.new(1, -24, 0, 0)
    }, 0.2, nil, nil, function()
        self.OptionsList.Visible = false
    end)
    
    self.Utils.Tween(self.Arrow, {
        Rotation = 0
    }, 0.2)
end

function MultiDropdown:SetValues(values)
    self.Values = {}
    for _, v in ipairs(values) do
        self.Values[v] = true
    end
    
    -- Update checkmarks
    local scroll = self.OptionsList:FindFirstChild("Scroll")
    if scroll then
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name == "Option" then
                local label = child:FindFirstChild("Label")
                local checkmark = child:FindFirstChild("Checkbox"):FindFirstChild("Checkmark")
                if label and checkmark then
                    checkmark.Visible = self.Values[label.Text] or false
                end
            end
        end
    end
    
    self.ValueLabel.Text = self:GetDisplayText()
end
MultiDropdown = MultiDropdown
end


-- Module: ProgressBar
local ProgressBar
do
-- EnowLib ProgressBar Component

local ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar.new(config, tab, theme, utils)
    local self = setmetatable({}, ProgressBar)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Progress",
        Description = nil,
        Min = 0,
        Max = 100,
        Value = 0,
        ShowPercentage = true,
        Animated = true
    }, config or {})
    
    self.Value = self.Config.Value
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function ProgressBar:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ProgressBar"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 72 or 56)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Percentage display
    if self.Config.ShowPercentage then
        self.PercentLabel = Instance.new("TextLabel")
        self.PercentLabel.Name = "Percent"
        self.PercentLabel.BackgroundTransparency = 1
        self.PercentLabel.Size = UDim2.fromOffset(50, 20)
        self.PercentLabel.Position = UDim2.new(1, -58, 0, 8)
        self.PercentLabel.Font = self.Theme.Font.Mono
        self.PercentLabel.Text = "0%"
        self.PercentLabel.TextColor3 = self.Theme.Colors.Primary
        self.PercentLabel.TextSize = self.Theme.Font.Size.Regular
        self.PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
        self.PercentLabel.Parent = self.Container
    end
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 14)
        desc.Position = UDim2.fromOffset(12, 26)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Progress track
    self.Track = Instance.new("Frame")
    self.Track.Name = "Track"
    self.Track.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Track.BorderSizePixel = 0
    self.Track.Size = UDim2.new(1, -24, 0, 8)
    self.Track.Position = UDim2.fromOffset(12, self.Config.Description and 48 or 36)
    self.Track.Parent = self.Container
    
    self.Theme.CreateCorner(self.Track, 4)
    
    -- Progress fill
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.BackgroundColor3 = self.Theme.Colors.Primary
    self.Fill.BorderSizePixel = 0
    self.Fill.Size = UDim2.new(0, 0, 1, 0)
    self.Fill.Parent = self.Track
    
    self.Theme.CreateCorner(self.Fill, 4)
    self.Theme.CreateGradient(self.Fill, 0)
    
    -- Glow effect
    if self.Config.Animated then
        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 0.5
        glow.BorderSizePixel = 0
        glow.Size = UDim2.new(0.3, 0, 1, 0)
        glow.Position = UDim2.new(0, 0, 0, 0)
        glow.Parent = self.Fill
        
        self.Theme.CreateCorner(glow, 4)
        
        -- Animate glow
        local function animateGlow()
            while self.Fill and self.Fill.Parent do
                self.Utils.Tween(glow, {
                    Position = UDim2.new(1, 0, 0, 0)
                }, 1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, function()
                    glow.Position = UDim2.new(-0.3, 0, 0, 0)
                end)
                task.wait(1.5)
            end
        end
        
        task.spawn(animateGlow)
    end
end

function ProgressBar:SetValue(value)
    self.Value = self.Utils.Clamp(value, self.Config.Min, self.Config.Max)
    self:UpdateVisual()
end

function ProgressBar:UpdateVisual()
    local percentage = (self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min)
    
    if self.Config.Animated then
        self.Utils.Tween(self.Fill, {
            Size = UDim2.new(percentage, 0, 1, 0)
        }, 0.3)
    else
        self.Fill.Size = UDim2.new(percentage, 0, 1, 0)
    end
    
    if self.PercentLabel then
        self.PercentLabel.Text = string.format("%d%%", math.floor(percentage * 100))
    end
end

function ProgressBar:Increment(amount)
    self:SetValue(self.Value + amount)
end

function ProgressBar:Reset()
    self:SetValue(self.Config.Min)
end
ProgressBar = ProgressBar
end


-- Module: Notification
local Notification
do
-- EnowLib Notification System

local Notification = {}
Notification.Queue = {}
Notification.Active = {}
Notification.Container = nil

function Notification.Initialize(theme, utils)
    if Notification.Container then return end
    
    Notification.Theme = theme
    Notification.Utils = utils
    
    -- Create notification container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EnowLib_Notifications"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    Notification.Container = Instance.new("Frame")
    Notification.Container.Name = "NotificationContainer"
    Notification.Container.BackgroundTransparency = 1
    Notification.Container.Size = UDim2.new(0, 300, 1, -20)
    Notification.Container.Position = UDim2.new(1, -310, 0, 10)
    Notification.Container.Parent = screenGui
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = Notification.Container
end

function Notification.Show(config)
    if not Notification.Container then
        Notification.Initialize(config.Theme, config.Utils)
    end
    
    config = Notification.Utils.Merge({
        Title = "Notification",
        Content = "",
        Duration = 3,
        Type = "Info"
    }, config or {})
    
    local notif = Notification.Create(config)
    table.insert(Notification.Active, notif)
    
    -- Auto dismiss
    task.delay(config.Duration, function()
        Notification.Dismiss(notif)
    end)
    
    return notif
end

function Notification.Create(config)
    local notif = {}
    
    -- Container
    notif.Container = Instance.new("Frame")
    notif.Container.Name = "Notification"
    notif.Container.BackgroundColor3 = Notification.Theme.Colors.BackgroundLight
    notif.Container.BorderSizePixel = 0
    notif.Container.Size = UDim2.new(1, 0, 0, 0)
    notif.Container.Parent = Notification.Container
    
    Notification.Theme.CreateCorner(notif.Container)
    Notification.Theme.CreateStroke(notif.Container, Notification.GetTypeColor(config.Type), 2)
    
    -- Accent bar
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.BackgroundColor3 = Notification.GetTypeColor(config.Type)
    accent.BorderSizePixel = 0
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.Parent = notif.Container
    
    Notification.Theme.CreateGradient(accent, 90)
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, -16, 1, 0)
    content.Position = UDim2.fromOffset(12, 0)
    content.Parent = notif.Container
    
    Notification.Theme.CreatePadding(content, 8)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 18)
    title.Position = UDim2.fromOffset(0, 0)
    title.Font = Notification.Theme.Font.Bold
    title.Text = config.Title
    title.TextColor3 = Notification.Theme.Colors.Text
    title.TextSize = Notification.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Parent = content
    
    -- Content text
    local contentText = Instance.new("TextLabel")
    contentText.Name = "ContentText"
    contentText.BackgroundTransparency = 1
    contentText.Size = UDim2.new(1, -24, 1, -22)
    contentText.Position = UDim2.fromOffset(0, 20)
    contentText.Font = Notification.Theme.Font.Regular
    contentText.Text = config.Content
    contentText.TextColor3 = Notification.Theme.Colors.TextDim
    contentText.TextSize = Notification.Theme.Font.Size.Small
    contentText.TextXAlignment = Enum.TextXAlignment.Left
    contentText.TextYAlignment = Enum.TextYAlignment.Top
    contentText.TextWrapped = true
    contentText.Parent = content
    
    -- Calculate height
    local textHeight = contentText.TextBounds.Y
    local totalHeight = math.max(60, textHeight + 40)
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -20, 0, 4)
    closeBtn.Font = Notification.Theme.Font.Bold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Notification.Theme.Colors.TextDim
    closeBtn.TextSize = 18
    closeBtn.Parent = content
    
    closeBtn.MouseButton1Click:Connect(function()
        Notification.Dismiss(notif)
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Notification.Utils.Tween(closeBtn, {
            TextColor3 = Notification.Theme.Colors.Text
        }, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Notification.Utils.Tween(closeBtn, {
            TextColor3 = Notification.Theme.Colors.TextDim
        }, 0.15)
    end)
    
    -- Animate in
    notif.Container.Size = UDim2.new(1, 0, 0, 0)
    Notification.Utils.Tween(notif.Container, {
        Size = UDim2.new(1, 0, 0, totalHeight)
    }, 0.3, Enum.EasingStyle.Back)
    
    return notif
end

function Notification.Dismiss(notif)
    Notification.Utils.Tween(notif.Container, {
        Size = UDim2.new(1, 0, 0, 0)
    }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
        notif.Container:Destroy()
        
        for i, n in ipairs(Notification.Active) do
            if n == notif then
                table.remove(Notification.Active, i)
                break
            end
        end
    end)
end

function Notification.GetTypeColor(type)
    local colors = {
        Info = Notification.Theme.Colors.Primary,
        Success = Notification.Theme.Colors.Success,
        Warning = Notification.Theme.Colors.Warning,
        Error = Notification.Theme.Colors.Error
    }
    
    return colors[type] or Notification.Theme.Colors.Primary
end
Notification = Notification
end


-- Module: Tab
local Tab
do
-- EnowLib Tab Component

local Tab = {}
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
    -- Tab button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "TabButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 36)
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = self.Config.Title
    self.Button.TextColor3 = self.Theme.Colors.TextDim
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Window.TabList
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreatePadding(self.Button, {12, 12, 0, 0})
    
    -- Tab content container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = "TabContent"
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.Colors.Primary
    self.Container.CanvasSize = UDim2.fromOffset(0, 0)
    self.Container.Visible = false
    self.Container.Parent = self.Window.ContentArea
    
    -- List layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Small)
    layout.Parent = self.Container
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Button click
    self.Button.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.Hover
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.BackgroundLight
            }, 0.15)
        end
    end)
end

function Tab:Show()
    self.Visible = true
    self.Container.Visible = true
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Active,
        TextColor3 = self.Theme.Colors.Text
    }, 0.2)
    
    -- Add glow effect
    if not self.Button:FindFirstChild("Stroke") then
        self.Theme.CreateStroke(self.Button, self.Theme.Colors.Primary, 1)
    end
end

function Tab:Hide()
    self.Visible = false
    self.Container.Visible = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.BackgroundLight,
        TextColor3 = self.Theme.Colors.TextDim
    }, 0.2)
    
    -- Remove glow
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        stroke:Destroy()
    end
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

function Tab:AddDropdown(config)
    
    local dropdown = Dropdown.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, dropdown)
    return dropdown
end

function Tab:AddInput(config)
    
    local input = Input.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, input)
    return input
end

function Tab:AddLabel(config)
    
    local label = Label.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, label)
    return label
end

function Tab:AddSection(config)
    
    local section = Section.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, section)
    return section
end

function Tab:AddKeybind(config)
    
    local keybind = Keybind.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, keybind)
    return keybind
end

function Tab:AddColorPicker(config)
    
    local colorpicker = ColorPicker.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, colorpicker)
    return colorpicker
end

function Tab:AddMultiDropdown(config)
    
    local multidropdown = MultiDropdown.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, multidropdown)
    return multidropdown
end

function Tab:AddProgressBar(config)
    
    local progressbar = ProgressBar.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, progressbar)
    return progressbar
end
Tab = Tab
end


-- Module: Window
local Window
do
-- EnowLib Window Component

local Window = {}
Window.__index = Window

function Window.new(config, theme, utils, enowlib)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.EnowLib = enowlib
    self.Config = utils.Merge({
        Title = "EnowLib",
        Size = UDim2.fromOffset(500, 400),
        MinSize = Vector2.new(400, 300),
        Draggable = true,
        Resizable = false,
        CloseButton = true
    }, config or {})
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    
    self:CreateUI()
    
    return self
end

function Window:CreateUI()
    -- Screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EnowLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.BackgroundColor3 = self.Theme.Colors.Background
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    self.Container.Position = UDim2.fromScale(0.5, 0.5)
    self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Container.Parent = self.ScreenGui
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.BorderGlow, 2)
    self.Theme.CreateGlow(self.Container)
    
    -- Title bar
    self:CreateTitleBar()
    
    -- Tab bar
    self:CreateTabBar()
    
    -- Content area
    self:CreateContentArea()
    
    -- Make draggable
    if self.Config.Draggable then
        self.Utils.MakeDraggable(self.Container, self.TitleBar)
    end
    
    -- Parent to game
    self.ScreenGui.Parent = game:GetService("CoreGui")
end

function Window:CreateTitleBar()
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Parent = self.Container
    
    self.Theme.CreateCorner(self.TitleBar, 6)
    
    -- Title text
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Add gradient to title
    self.Theme.CreateGradient(title, 90)
    
    -- Close button
    if self.Config.CloseButton then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.BackgroundColor3 = self.Theme.Colors.Error
        closeBtn.BorderSizePixel = 0
        closeBtn.Size = UDim2.fromOffset(24, 24)
        closeBtn.Position = UDim2.new(1, -32, 0.5, 0)
        closeBtn.AnchorPoint = Vector2.new(0, 0.5)
        closeBtn.Font = self.Theme.Font.Bold
        closeBtn.Text = "×"
        closeBtn.TextColor3 = self.Theme.Colors.Text
        closeBtn.TextSize = 20
        closeBtn.Parent = self.TitleBar
        
        self.Theme.CreateCorner(closeBtn, 4)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
        
        closeBtn.MouseEnter:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = Color3.fromRGB(255, 70, 120)
            }, 0.15)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = self.Theme.Colors.Error
            }, 0.15)
        end)
    end
end

function Window:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, 140, 1, -40)
    self.TabBar.Position = UDim2.fromOffset(0, 40)
    self.TabBar.Parent = self.Container
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.Size = UDim2.new(1, 0, 1, 0)
    self.TabList.ScrollBarThickness = 4
    self.TabList.ScrollBarImageColor3 = self.Theme.Colors.Primary
    self.TabList.CanvasSize = UDim2.fromOffset(0, 0)
    self.TabList.Parent = self.TabBar
    
    self.Theme.CreatePadding(self.TabList, self.Theme.Spacing.Small)
    
    -- List layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Small)
    layout.Parent = self.TabList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)
end

function Window:CreateContentArea()
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -140, 1, -40)
    self.ContentArea.Position = UDim2.fromOffset(140, 40)
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreatePadding(self.ContentArea, self.Theme.Spacing.Medium)
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

function Window:Toggle()
    self.Visible = not self.Visible
    
    if self.Visible then
        self.Container.Visible = true
        self.Utils.Tween(self.Container, {
            Size = self.Config.Size
        }, 0.25, Enum.EasingStyle.Back)
    else
        self.Utils.Tween(self.Container, {
            Size = UDim2.fromOffset(0, 0)
        }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            self.Container.Visible = false
        end)
    end
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end
Window = Window
end


-- Module: SaveManager
local SaveManager
do
-- EnowLib SaveManager
-- Handles configuration persistence

local SaveManager = {}
SaveManager.Folder = "EnowLib"
SaveManager.FileName = "config.json"
SaveManager.Configs = {}

function SaveManager.Initialize(window)
    SaveManager.Window = window
    
    -- Create folder if not exists
    if not isfolder(SaveManager.Folder) then
        pcall(makefolder, SaveManager.Folder)
    end
    
    -- Load existing configs
    SaveManager.LoadConfigList()
end

function SaveManager.LoadConfigList()
    if not isfolder(SaveManager.Folder) then
        return
    end
    
    local success, files = pcall(listfiles, SaveManager.Folder)
    if not success then return end
    
    SaveManager.Configs = {}
    
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            table.insert(SaveManager.Configs, name)
        end
    end
end

function SaveManager.Save(configName)
    if not writefile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    configName = configName or SaveManager.FileName:gsub("%.json$", "")
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    local data = SaveManager.BuildConfigData()
    local json = game:GetService("HttpService"):JSONEncode(data)
    
    local success, err = pcall(function()
        writefile(filePath, json)
    end)
    
    if success then
        if not table.find(SaveManager.Configs, configName) then
            table.insert(SaveManager.Configs, configName)
        end
        return true
    else
        warn("[SaveManager] Failed to save config:", err)
        return false
    end
end

function SaveManager.Load(configName)
    if not readfile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    configName = configName or SaveManager.FileName:gsub("%.json$", "")
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        warn("[SaveManager] Config file not found:", configName)
        return false
    end
    
    local success, content = pcall(readfile, filePath)
    if not success then
        warn("[SaveManager] Failed to read config:", content)
        return false
    end
    
    local data
    success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    
    if not success then
        warn("[SaveManager] Failed to parse config:", data)
        return false
    end
    
    SaveManager.ApplyConfigData(data)
    return true
end

function SaveManager.Delete(configName)
    if not delfile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        return false
    end
    
    local success = pcall(delfile, filePath)
    
    if success then
        for i, name in ipairs(SaveManager.Configs) do
            if name == configName then
                table.remove(SaveManager.Configs, i)
                break
            end
        end
    end
    
    return success
end

function SaveManager.BuildConfigData()
    local data = {
        version = SaveManager.Window.EnowLib.Version,
        timestamp = os.time(),
        components = {}
    }
    
    -- Iterate through all tabs and components
    for _, tab in ipairs(SaveManager.Window.Tabs) do
        for _, component in ipairs(tab.Components) do
            local componentData = SaveManager.GetComponentData(component)
            if componentData then
                table.insert(data.components, componentData)
            end
        end
    end
    
    return data
end

function SaveManager.GetComponentData(component)
    local componentType = tostring(component):match("table: ")
    
    if not component.Config or not component.Config.Title then
        return nil
    end
    
    local data = {
        type = componentType,
        title = component.Config.Title,
        value = nil
    }
    
    -- Get value based on component type
    if component.Value ~= nil then
        if typeof(component.Value) == "Color3" then
            data.value = {
                R = component.Value.R,
                G = component.Value.G,
                B = component.Value.B
            }
        elseif typeof(component.Value) == "EnumItem" then
            data.value = component.Value.Name
        else
            data.value = component.Value
        end
    elseif component.Values then
        -- MultiDropdown
        local selected = {}
        for opt, enabled in pairs(component.Values) do
            if enabled then
                table.insert(selected, opt)
            end
        end
        data.value = selected
    end
    
    return data
end

function SaveManager.ApplyConfigData(data)
    if not data.components then return end
    
    -- Apply each component's saved value
    for _, savedComponent in ipairs(data.components) do
        SaveManager.ApplyComponentData(savedComponent)
    end
end

function SaveManager.ApplyComponentData(savedData)
    -- Find matching component by title
    for _, tab in ipairs(SaveManager.Window.Tabs) do
        for _, component in ipairs(tab.Components) do
            if component.Config and component.Config.Title == savedData.title then
                SaveManager.SetComponentValue(component, savedData.value)
                break
            end
        end
    end
end

function SaveManager.SetComponentValue(component, value)
    if value == nil then return end
    
    -- Handle different component types
    if component.SetValue then
        -- Color3 reconstruction
        if type(value) == "table" and value.R then
            value = Color3.new(value.R, value.G, value.B)
        end
        
        -- KeyCode reconstruction
        if type(value) == "string" and component.Config.Default and typeof(component.Config.Default) == "EnumItem" then
            value = Enum.KeyCode[value]
        end
        
        component:SetValue(value)
    elseif component.SetValues then
        -- MultiDropdown
        component:SetValues(value)
    elseif component.Toggle then
        -- Toggle component
        if component.Value ~= value then
            component:Toggle()
        end
    end
end

function SaveManager.AutoSave(interval)
    interval = interval or 60
    
    task.spawn(function()
        while SaveManager.Window do
            task.wait(interval)
            SaveManager.Save("autosave")
        end
    end)
end

function SaveManager.CreateUI(tab)
    if not tab then return end
    
    tab:AddSection({Title = "CONFIGURATION"})
    
    -- Config name input
    local configName = "config"
    
    tab:AddInput({
        Title = "Config Name",
        Placeholder = "Enter config name...",
        Default = configName,
        Callback = function(value)
            configName = value
        end
    })
    
    -- Save button
    tab:AddButton({
        Title = "Save Config",
        Description = "Save current settings",
        Callback = function()
            local success = SaveManager.Save(configName)
            if success then
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Saved",
                    Content = "Configuration saved as: " .. configName,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Save Failed",
                    Content = "Failed to save configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Load dropdown
    tab:AddDropdown({
        Title = "Load Config",
        Description = "Select config to load",
        Options = SaveManager.Configs,
        Callback = function(value)
            local success = SaveManager.Load(value)
            if success then
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Loaded",
                    Content = "Configuration loaded: " .. value,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Load Failed",
                    Content = "Failed to load configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Delete dropdown
    tab:AddDropdown({
        Title = "Delete Config",
        Description = "Select config to delete",
        Options = SaveManager.Configs,
        Callback = function(value)
            local success = SaveManager.Delete(value)
            if success then
                SaveManager.LoadConfigList()
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Deleted",
                    Content = "Configuration deleted: " .. value,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Delete Failed",
                    Content = "Failed to delete configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Auto-save toggle
    tab:AddToggle({
        Title = "Auto Save",
        Description = "Automatically save every 60 seconds",
        Default = false,
        Callback = function(value)
            if value then
                SaveManager.AutoSave(60)
            end
        end
    })
end
SaveManager = SaveManager
end


-- Module: InterfaceManager
local InterfaceManager
do
-- EnowLib InterfaceManager
-- Handles UI state and theme management

local InterfaceManager = {}
InterfaceManager.Settings = {
    theme = "Vaporwave",
    transparency = 0,
    acrylic = true,
    minimizeKey = Enum.KeyCode.LeftControl
}

function InterfaceManager.Initialize(window)
    InterfaceManager.Window = window
    InterfaceManager.SetupMinimizeKey()
end

function InterfaceManager.SetupMinimizeKey()
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == InterfaceManager.Settings.minimizeKey then
            InterfaceManager.Window:Toggle()
        end
    end)
end

function InterfaceManager.SetTheme(themeName)
    InterfaceManager.Settings.theme = themeName
    
    -- Apply theme colors
    local themes = {
        Vaporwave = {
            Primary = Color3.fromRGB(138, 43, 226),
            Accent = Color3.fromRGB(0, 255, 255),
            AccentPink = Color3.fromRGB(255, 20, 147)
        },
        Dark = {
            Primary = Color3.fromRGB(100, 100, 100),
            Accent = Color3.fromRGB(150, 150, 150),
            AccentPink = Color3.fromRGB(120, 120, 120)
        },
        Light = {
            Primary = Color3.fromRGB(70, 130, 180),
            Accent = Color3.fromRGB(100, 149, 237),
            AccentPink = Color3.fromRGB(135, 206, 250)
        },
        Cyberpunk = {
            Primary = Color3.fromRGB(255, 0, 255),
            Accent = Color3.fromRGB(0, 255, 255),
            AccentPink = Color3.fromRGB(255, 0, 128)
        },
        Neon = {
            Primary = Color3.fromRGB(57, 255, 20),
            Accent = Color3.fromRGB(255, 20, 147),
            AccentPink = Color3.fromRGB(0, 255, 255)
        }
    }
    
    local theme = themes[themeName]
    if theme then
        for key, color in pairs(theme) do
            InterfaceManager.Window.Theme.Colors[key] = color
        end
        
        InterfaceManager.RefreshUI()
    end
end

function InterfaceManager.SetTransparency(value)
    InterfaceManager.Settings.transparency = value
    
    -- Apply transparency to main container
    if InterfaceManager.Window.Container then
        InterfaceManager.Window.Container.BackgroundTransparency = value
    end
end

function InterfaceManager.SetAcrylic(enabled)
    InterfaceManager.Settings.acrylic = enabled
    
    -- Toggle blur effect
    if InterfaceManager.Window.Container then
        local blur = InterfaceManager.Window.Container:FindFirstChild("BlurEffect")
        
        if enabled and not blur then
            blur = Instance.new("BlurEffect")
            blur.Size = 10
            blur.Parent = InterfaceManager.Window.Container
        elseif not enabled and blur then
            blur:Destroy()
        end
    end
end

function InterfaceManager.SetMinimizeKey(keyCode)
    InterfaceManager.Settings.minimizeKey = keyCode
end

function InterfaceManager.RefreshUI()
    -- Refresh all UI elements with new theme
    if not InterfaceManager.Window then return end
    
    local theme = InterfaceManager.Window.Theme
    
    -- Update window
    if InterfaceManager.Window.Container then
        InterfaceManager.Window.Container.BackgroundColor3 = theme.Colors.Background
        
        local stroke = InterfaceManager.Window.Container:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = theme.Colors.BorderGlow
        end
    end
    
    -- Update all tabs and components
    for _, tab in ipairs(InterfaceManager.Window.Tabs) do
        InterfaceManager.RefreshTab(tab)
    end
end

function InterfaceManager.RefreshTab(tab)
    local theme = InterfaceManager.Window.Theme
    
    -- Update tab button
    if tab.Button then
        if tab.Visible then
            tab.Button.BackgroundColor3 = theme.Colors.Active
            tab.Button.TextColor3 = theme.Colors.Text
        else
            tab.Button.BackgroundColor3 = theme.Colors.BackgroundLight
            tab.Button.TextColor3 = theme.Colors.TextDim
        end
    end
    
    -- Update components
    for _, component in ipairs(tab.Components) do
        InterfaceManager.RefreshComponent(component)
    end
end

function InterfaceManager.RefreshComponent(component)
    local theme = InterfaceManager.Window.Theme
    
    if not component.Container then return end
    
    -- Update container colors
    component.Container.BackgroundColor3 = theme.Colors.BackgroundLight
    
    local stroke = component.Container:FindFirstChild("UIStroke")
    if stroke then
        stroke.Color = theme.Colors.Border
    end
    
    -- Update component-specific elements
    if component.Fill then
        component.Fill.BackgroundColor3 = theme.Colors.Primary
    end
    
    if component.Switch then
        if component.Value then
            component.Switch.BackgroundColor3 = theme.Colors.Primary
        end
    end
end

function InterfaceManager.SaveSettings()
    if not writefile then return end
    
    local data = game:GetService("HttpService"):JSONEncode(InterfaceManager.Settings)
    
    pcall(function()
        if not isfolder("EnowLib") then
            makefolder("EnowLib")
        end
        writefile("EnowLib/interface.json", data)
    end)
end

function InterfaceManager.LoadSettings()
    if not readfile or not isfile("EnowLib/interface.json") then
        return
    end
    
    local success, content = pcall(readfile, "EnowLib/interface.json")
    if not success then return end
    
    local data
    success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    
    if success and data then
        InterfaceManager.Settings = data
        InterfaceManager.ApplySettings()
    end
end

function InterfaceManager.ApplySettings()
    if InterfaceManager.Settings.theme then
        InterfaceManager.SetTheme(InterfaceManager.Settings.theme)
    end
    
    if InterfaceManager.Settings.transparency then
        InterfaceManager.SetTransparency(InterfaceManager.Settings.transparency)
    end
    
    if InterfaceManager.Settings.acrylic ~= nil then
        InterfaceManager.SetAcrylic(InterfaceManager.Settings.acrylic)
    end
    
    if InterfaceManager.Settings.minimizeKey then
        InterfaceManager.SetMinimizeKey(InterfaceManager.Settings.minimizeKey)
    end
end

function InterfaceManager.CreateUI(tab)
    if not tab then return end
    
    tab:AddSection({Title = "INTERFACE"})
    
    -- Theme selector
    tab:AddDropdown({
        Title = "Theme",
        Description = "Select UI theme",
        Options = {"Vaporwave", "Dark", "Light", "Cyberpunk", "Neon"},
        Default = InterfaceManager.Settings.theme,
        Callback = function(value)
            InterfaceManager.SetTheme(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Transparency slider
    tab:AddSlider({
        Title = "Transparency",
        Description = "UI background transparency",
        Min = 0,
        Max = 1,
        Default = InterfaceManager.Settings.transparency,
        Increment = 0.1,
        Callback = function(value)
            InterfaceManager.SetTransparency(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Acrylic toggle
    tab:AddToggle({
        Title = "Acrylic Effect",
        Description = "Enable blur effect",
        Default = InterfaceManager.Settings.acrylic,
        Callback = function(value)
            InterfaceManager.SetAcrylic(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    -- Minimize key
    tab:AddKeybind({
        Title = "Minimize Key",
        Description = "Key to toggle UI visibility",
        Default = InterfaceManager.Settings.minimizeKey,
        Callback = function(value)
            InterfaceManager.SetMinimizeKey(value)
            InterfaceManager.SaveSettings()
        end
    })
    
    tab:AddSection({Title = "ACTIONS"})
    
    -- Refresh UI button
    tab:AddButton({
        Title = "Refresh UI",
        Description = "Reload UI with current theme",
        Callback = function()
            InterfaceManager.RefreshUI()
            InterfaceManager.Window.EnowLib:Notify({
                Title = "UI Refreshed",
                Content = "Interface has been refreshed",
                Duration = 2,
                Type = "Success"
            })
        end
    })
    
    -- Reset settings button
    tab:AddButton({
        Title = "Reset Settings",
        Description = "Reset to default settings",
        Callback = function()
            InterfaceManager.Settings = {
                theme = "Vaporwave",
                transparency = 0,
                acrylic = true,
                minimizeKey = Enum.KeyCode.LeftControl
            }
            InterfaceManager.ApplySettings()
            InterfaceManager.SaveSettings()
            
            InterfaceManager.Window.EnowLib:Notify({
                Title = "Settings Reset",
                Content = "Interface settings have been reset",
                Duration = 2,
                Type = "Success"
            })
        end
    })
end
InterfaceManager = InterfaceManager
end


-- Initialize EnowLib
EnowLib.Version = "2.0.0"
EnowLib.Author = "EnowHub Development"

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function EnowLib:CreateWindow(config)
    local window = Window.new(config, Theme, Utils, EnowLib)
    
    -- Initialize managers
    SaveManager.Initialize(window)
    InterfaceManager.Initialize(window)
    
    -- Load saved interface settings
    InterfaceManager.LoadSettings()
    
    window.SaveManager = SaveManager
    window.InterfaceManager = InterfaceManager
    
    return window
end

-- Show notification
function EnowLib:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function EnowLib:GetTheme()
    return Theme
end

-- Get utils
function EnowLib:GetUtils()
    return Utils
end

-- Get SaveManager
function EnowLib:GetSaveManager()
    return SaveManager
end

-- Get InterfaceManager
function EnowLib:GetInterfaceManager()
    return InterfaceManager
end

return EnowLib
