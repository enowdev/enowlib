-- EnowLib Tab Component

local Tab = {}
Tab.__index = Tab

function Tab.new(config, window, theme, utils)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Tab"
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
    self.Button.Text = self.Config.Title
    self.Button.TextColor3 = self.Theme.Colors.TextDim
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Window.TabList
    
    self.Theme.CreateCorner(self.Button, 6)
    self.Theme.CreatePadding(self.Button, 12)
    
    -- Tab Content
    self.Container = Instance.new("ScrollingFrame")
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.Container.CanvasSize = UDim2.fromOffset(0, 0)
    self.Container.Visible = false
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
        BackgroundTransparency = self.Theme.Transparency.None,
        TextColor3 = self.Theme.Colors.Text
    }, self.Theme.Animation.Duration)
end

function Tab:Hide()
    self.Visible = false
    self.Container.Visible = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Secondary,
        BackgroundTransparency = self.Theme.Transparency.Subtle,
        TextColor3 = self.Theme.Colors.TextDim
    }, self.Theme.Animation.Duration)
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

return Tab
