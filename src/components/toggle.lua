-- EnowLib Toggle Component

local Toggle = {}
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
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    local titleSizeConstraint = Instance.new("UITextSizeConstraint")
    titleSizeConstraint.MaxTextSize = self.Theme.Font.Size.Regular
    titleSizeConstraint.Parent = title
    
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

return Toggle
