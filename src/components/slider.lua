-- EnowLib Slider Component

local UserInputService = game:GetService("UserInputService")

local Slider = {}
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
    self.Container.Size = UDim2.new(1, 0, 0, 45)  -- 60 * 0.75 = 45
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 9)  -- 12 * 0.75 = 9
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -45, 0, 14)  -- 60 * 0.75 = 45, 18 * 0.75 = 13.5 ≈ 14
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    local titleSizeConstraint = Instance.new("UITextSizeConstraint")
    titleSizeConstraint.MaxTextSize = self.Theme.Font.Size.Small
    titleSizeConstraint.Parent = title
    
    -- Value
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.fromOffset(38, 14)  -- 50 * 0.75 = 37.5 ≈ 38, 18 * 0.75 = 13.5 ≈ 14
    self.ValueLabel.Position = UDim2.new(1, -38, 0, 0)
    self.ValueLabel.Font = self.Theme.Font.Bold
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.TextColor3 = self.Theme.Colors.Accent
    self.ValueLabel.TextScaled = true
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.Container
    
    local valueSizeConstraint = Instance.new("UITextSizeConstraint")
    valueSizeConstraint.MaxTextSize = self.Theme.Font.Size.Small
    valueSizeConstraint.Parent = self.ValueLabel
    
    -- Track
    self.Track = Instance.new("Frame")
    self.Track.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Track.BorderSizePixel = 0
    self.Track.Size = UDim2.new(1, 0, 0, 5)  -- 6 * 0.75 = 4.5 ≈ 5
    self.Track.Position = UDim2.fromOffset(0, 23)  -- 30 * 0.75 = 22.5 ≈ 23
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
    self.Knob.Size = UDim2.fromOffset(12, 12)  -- 16 * 0.75 = 12
    self.Knob.Position = UDim2.new(0, 0, 0.5, 0)
    self.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Knob.Parent = self.Track
    
    self.Theme.CreateCorner(self.Knob, 6)
    self.Theme.CreateStroke(self.Knob, self.Theme.Colors.Accent, 2)
    
    -- Input Button
    local input = Instance.new("TextButton")
    input.BackgroundTransparency = 1
    input.Size = UDim2.new(1, 0, 0, 15)  -- 20 * 0.75 = 15
    input.Position = UDim2.fromOffset(0, 19)  -- 25 * 0.75 = 18.75 ≈ 19
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
                    Size = UDim2.fromOffset(12, 12)
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
            Size = UDim2.fromOffset(14, 14)  -- 18 * 0.75 = 13.5 ≈ 14
        }, 0.15)
    end))
    
    table.insert(self.Connections, input.MouseLeave:Connect(function()
        if not self.Dragging then
            self.Utils.Tween(self.Knob, {
                Size = UDim2.fromOffset(12, 12)
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

return Slider
