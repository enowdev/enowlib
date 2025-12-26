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

return ProgressBar
