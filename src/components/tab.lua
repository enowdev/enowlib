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
    -- Tab Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 24)  -- 32 * 0.75 = 24
    self.Button.Font = self.Theme.Font.Regular
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.TextDim
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Window.SidebarList
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreatePadding(self.Button, 6)
    
    -- Tab Icon (optional)
    if self.Config.Icon then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Size = UDim2.fromOffset(11, 11)  -- 14 * 0.75 = 10.5 ≈ 11
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
    self.ChevronIcon.Size = UDim2.fromOffset(11, 11)  -- 14 * 0.75 = 10.5 ≈ 11
    self.ChevronIcon.Position = UDim2.new(1, -11, 0.5, 0)
    self.ChevronIcon.AnchorPoint = Vector2.new(0, 0.5)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Title
    local titleOffset = self.Config.Icon and 15 or 0  -- 20 * 0.75 = 15
    local titleRightOffset = 15  -- 20 * 0.75 = 15
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -(titleOffset + titleRightOffset), 1, 0)
    title.Position = UDim2.fromOffset(titleOffset, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.TextDim
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Button
    
    local titleSizeConstraint = Instance.new("UITextSizeConstraint")
    titleSizeConstraint.MaxTextSize = self.Theme.Font.Size.Small
    titleSizeConstraint.Parent = title
    
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

return Tab
