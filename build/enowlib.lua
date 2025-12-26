-- EnowLib v2.0.0
-- Radix UI Style - Modern Minimalist Design
-- Built: 2025-12-26 13:38:23
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
assert(Utils, "Failed to assign Utils module")
end


-- Module: Label
local Label
do
-- EnowLib Label Component

Label = {}
Label.__index = Label

function Label.new(config, tab, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    self.Container = Instance.new("TextLabel")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 24)
    self.Container.Font = self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = self.Theme.Colors.TextDim
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.TextXAlignment = Enum.TextXAlignment.Left
    self.Container.Parent = self.Tab.Container
end
Label = Label
assert(Label, "Failed to assign Label module")
end


-- Module: Button
local Button
do
-- EnowLib Button Component

Button = {}
Button.__index = Button

function Button.new(config, tab, theme, utils)
    local self = setmetatable({}, Button)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Button",
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
    self.Container.Text = self.Config.Title
    self.Container.TextColor3 = self.Theme.Colors.Text
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.AutoButtonColor = false
    self.Container.Parent = self.Tab.Container
    
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

function Toggle.new(config, tab, theme, utils)
    local self = setmetatable({}, Toggle)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Toggle",
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
    self.Container.Parent = self.Tab.Container
    
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

function Slider.new(config, tab, theme, utils)
    local self = setmetatable({}, Slider)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Slider",
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
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 18)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
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
    
    -- Mouse down on slider
    table.insert(self.Connections, input.MouseButton1Down:Connect(function()
        self.Dragging = true
        local mousePos = UserInputService:GetMouseLocation()
        updateValue(mousePos.X)
    end))
    
    -- Global mouse release
    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.Dragging then
                self.Dragging = false
                self.Utils.Tween(self.Knob, {
                    Size = UDim2.fromOffset(16, 16)
                }, 0.15)
            end
        end
    end))
    
    -- Global mouse move (only when dragging)
    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if self.Dragging then
                local mousePos = UserInputService:GetMouseLocation()
                updateValue(mousePos.X)
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
    self.Button.Size = UDim2.new(1, 0, 0, 28)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Category.ItemsContainer
    
    -- Icon (optional)
    if self.Config.Icon then
        self.Icon = Instance.new("ImageLabel")
        self.Icon.BackgroundTransparency = 1
        self.Icon.Size = UDim2.fromOffset(14, 14)
        self.Icon.Position = UDim2.fromOffset(50, 7)
        self.Icon.Image = self.Config.Icon
        self.Icon.ImageColor3 = self.Theme.Colors.TextDim
        self.Icon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 70 or 50
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.TextDim
    self.Title.TextSize = self.Theme.Font.Size.Small
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        pcall(self.Config.Callback)
    end)
    
    self.Button.MouseEnter:Connect(function()
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
    self.Container.Size = UDim2.new(1, 0, 0, 32)
    self.Container.Parent = self.Window.SidebarList
    
    -- Category Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 32)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(14, 14)
    self.ChevronIcon.Position = UDim2.fromOffset(8, 9)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.Accent
    self.ChevronIcon.Rotation = 0
    self.ChevronIcon.Parent = self.Button
    
    -- Folder Icon (optional)
    if self.Config.Icon then
        self.FolderIcon = Instance.new("ImageLabel")
        self.FolderIcon.BackgroundTransparency = 1
        self.FolderIcon.Size = UDim2.fromOffset(16, 16)
        self.FolderIcon.Position = UDim2.fromOffset(28, 8)
        self.FolderIcon.Image = self.Config.Icon
        self.FolderIcon.ImageColor3 = self.Theme.Colors.Accent
        self.FolderIcon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 50 or 28
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
    self.ItemsContainer.Position = UDim2.fromOffset(0, 32)
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
        totalHeight = totalHeight + 28
    end
    
    -- Expand container
    self.Utils.Tween(self.ItemsContainer, {
        Size = UDim2.new(1, 0, 0, totalHeight)
    }, duration)
    
    self.Utils.Tween(self.Container, {
        Size = UDim2.new(1, 0, 0, 32 + totalHeight)
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
        Size = UDim2.new(1, 0, 0, 32)
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
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
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
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 48)
    separator.Parent = self.Container
    
    -- Tab Bar
    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = self.Theme.Colors.Panel
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, 240, 1, -49)
    self.TabBar.Position = UDim2.fromOffset(0, 49)
    self.TabBar.Parent = self.Container
    
    -- Sidebar Header
    local sidebarHeader = Instance.new("Frame")
    sidebarHeader.BackgroundColor3 = self.Theme.Colors.Secondary
    sidebarHeader.BorderSizePixel = 0
    sidebarHeader.Size = UDim2.new(1, 0, 0, 32)
    sidebarHeader.Parent = self.TabBar
    
    local explorerLabel = Instance.new("TextLabel")
    explorerLabel.BackgroundTransparency = 1
    explorerLabel.Size = UDim2.new(1, -16, 1, 0)
    explorerLabel.Position = UDim2.fromOffset(12, 0)
    explorerLabel.Font = self.Theme.Font.Bold
    explorerLabel.Text = "EXPLORER"
    explorerLabel.TextColor3 = self.Theme.Colors.TextDim
    explorerLabel.TextSize = 11
    explorerLabel.TextXAlignment = Enum.TextXAlignment.Left
    explorerLabel.Parent = sidebarHeader
    
    self.SidebarList = Instance.new("ScrollingFrame")
    self.SidebarList.BackgroundTransparency = 1
    self.SidebarList.BorderSizePixel = 0
    self.SidebarList.Size = UDim2.new(1, 0, 1, -32)
    self.SidebarList.Position = UDim2.fromOffset(0, 32)
    self.SidebarList.ScrollBarThickness = 4
    self.SidebarList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.SidebarList.CanvasSize = UDim2.fromOffset(0, 0)
    self.SidebarList.Parent = self.TabBar
    
    self.Theme.CreatePadding(self.SidebarList, 4)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = self.SidebarList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.SidebarList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)
    
    -- Vertical Separator
    local vSeparator = Instance.new("Frame")
    vSeparator.BackgroundColor3 = self.Theme.Colors.Border
    vSeparator.BorderSizePixel = 0
    vSeparator.Size = UDim2.new(0, 1, 1, -49)
    vSeparator.Position = UDim2.fromOffset(240, 49)
    vSeparator.Parent = self.Container
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Size = UDim2.new(1, -241, 1, -49)
    self.ContentArea.Position = UDim2.fromOffset(241, 49)
    self.ContentArea.Parent = self.Container
    
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

function Window:Toggle()
    self.Container.Visible = not self.Container.Visible
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
