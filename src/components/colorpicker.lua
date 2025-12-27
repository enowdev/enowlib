-- EnowLib ColorPicker Component

local ColorPicker = {}
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
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    local titleSizeConstraint = Instance.new("UITextSizeConstraint")
    titleSizeConstraint.MaxTextSize = self.Theme.Font.Size.Regular
    titleSizeConstraint.Parent = title
    
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

return ColorPicker
