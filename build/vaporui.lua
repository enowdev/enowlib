-- VaporUI v1.0.0
-- Vaporwave Tech Dark UI Library
-- Built: 2025-12-26 13:51:32
-- Author: EnowHub Development

local VaporUI = {}

-- Module: Theme
do
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


end

-- Module: Utils
do
-- VaporUI Utility Functions

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


end

-- Module: Section
do
-- VaporUI Section Component

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


end

-- Module: Label
do
-- VaporUI Label Component

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


end

-- Module: Button
do
-- VaporUI Button Component

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


end

-- Module: Toggle
do
-- VaporUI Toggle Component

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


end

-- Module: Slider
do
-- VaporUI Slider Component

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


end

-- Module: Input
do
-- VaporUI Input Component

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


end

-- Module: Dropdown
do
-- VaporUI Dropdown Component

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
    arrow.Text = "â–¼"
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


end

-- Module: Notification
do
-- VaporUI Notification System

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
    screenGui.Name = "VaporUI_Notifications"
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
    closeBtn.Text = "Ã—"
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


end

-- Module: Tab
do
-- VaporUI Tab Component

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


end

-- Module: Window
do
-- VaporUI Window Component

local Window = {}
Window.__index = Window

function Window.new(config, theme, utils)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "VaporUI",
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
    self.ScreenGui.Name = "VaporUI"
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
        closeBtn.Text = "Ã—"
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


end

-- Initialize VaporUI
VaporUI.Version = "1.0.0"
VaporUI.Author = "EnowHub Development"

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function VaporUI:CreateWindow(config)
    local window = Window.new(config, Theme, Utils)
    return window
end

-- Show notification
function VaporUI:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function VaporUI:GetTheme()
    return Theme
end

-- Get utils
function VaporUI:GetUtils()
    return Utils
end

return VaporUI
