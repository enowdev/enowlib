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
    self.Container.Size = UDim2.new(1, 0, 0, 68)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border, self.Theme.Size.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -70, 0, 22)
    title.Position = UDim2.fromOffset(14, 10)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Value display
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.fromOffset(60, 22)
    self.ValueLabel.Position = UDim2.new(1, -68, 0, 10)
    self.ValueLabel.Font = self.Theme.Font.Bold
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.TextColor3 = self.Theme.Colors.Primary
    self.ValueLabel.TextSize = self.Theme.Font.Size.Regular
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.Container
    
    -- Slider track (SQUARE)
    self.Track = Instance.new("Frame")
    self.Track.Name = "Track"
    self.Track.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Track.BorderSizePixel = 0
    self.Track.Size = UDim2.new(1, -28, 0, self.Theme.Size.SliderHeight)
    self.Track.Position = UDim2.fromOffset(14, 44)
    self.Track.Parent = self.Container
    
    self.Theme.CreateCorner(self.Track, 4)
    self.Theme.CreateStroke(self.Track, self.Theme.Colors.Border, self.Theme.Size.Border)
    
    -- Slider fill (SQUARE)
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.BackgroundColor3 = self.Theme.Colors.Primary
    self.Fill.BorderSizePixel = 0
    self.Fill.Size = UDim2.new(0, 0, 1, 0)
    self.Fill.Parent = self.Track
    
    self.Theme.CreateCorner(self.Fill, 2)
    
    -- Slider knob (SQUARE)
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.BackgroundColor3 = self.Theme.Colors.Text
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(self.Theme.Size.SliderHeight, self.Theme.Size.SliderHeight)
    self.Knob.Position = UDim2.new(0, 0, 0.5, 0)
    self.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Knob.Parent = self.Track
    
    self.Theme.CreateCorner(self.Knob, 2)
    self.Theme.CreateStroke(self.Knob, self.Theme.Colors.Primary, self.Theme.Size.BorderThick)
    
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
            Size = UDim2.fromOffset(22, 22)
        }, 0.15)
    end)
    
    self.Track.MouseLeave:Connect(function()
        if not self.Dragging then
            self.Utils.Tween(self.Knob, {
                Size = UDim2.fromOffset(18, 18)
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

return Slider
