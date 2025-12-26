-- EnowLib Section Component (Collapsible/Dropdown)

local Section = {}
Section.__index = Section

function Section.new(config, tab, theme, utils)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Section",
        Collapsed = false  -- Start expanded by default
    }, config or {})
    
    self.Collapsed = self.Config.Collapsed
    self.Components = {}
    
    self:CreateUI()
    
    return self
end

function Section:CreateUI()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Section"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 36)
    self.Container.Parent = self.Tab.Container
    
    -- Section header (clickable)
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Header.BorderSizePixel = 0
    self.Header.Size = UDim2.new(1, 0, 0, 32)
    self.Header.Position = UDim2.fromOffset(0, 2)
    self.Header.Font = self.Theme.Font.Bold
    self.Header.Text = ""
    self.Header.AutoButtonColor = false
    self.Header.Parent = self.Container
    
    self.Theme.CreateStroke(self.Header, self.Theme.Colors.Border, self.Theme.Size.Border)
    self.Theme.CreateGradient(self.Header, 90)
    
    -- Arrow indicator
    self.Arrow = Instance.new("TextLabel")
    self.Arrow.Name = "Arrow"
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.Size = UDim2.fromOffset(20, 32)
    self.Arrow.Position = UDim2.fromOffset(8, 0)
    self.Arrow.Font = self.Theme.Font.Bold
    self.Arrow.Text = self.Collapsed and ">" or "v"
    self.Arrow.TextColor3 = self.Theme.Colors.Text
    self.Arrow.TextSize = self.Theme.Font.Size.Regular
    self.Arrow.Parent = self.Header
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -40, 1, 0)
    self.Title.Position = UDim2.fromOffset(32, 0)
    self.Title.Font = self.Theme.Font.Bold
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.Text
    self.Title.TextSize = self.Theme.Font.Size.Regular
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Header
    
    -- Content container (collapsible)
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1, 0, 0, 0)
    self.Content.Position = UDim2.fromOffset(0, 36)
    self.Content.Visible = not self.Collapsed
    self.Content.Parent = self.Container
    
    -- Content layout
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, self.Theme.Spacing.Small)
    self.Layout.Parent = self.Content
    
    -- Update container size when content changes
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self:UpdateSize()
    end)
    
    -- Click to toggle
    self.Header.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effect
    self.Header.MouseEnter:Connect(function()
        self.Utils.Tween(self.Header, {
            BackgroundColor3 = self.Theme.Colors.SecondaryLight
        }, 0.1)
    end)
    
    self.Header.MouseLeave:Connect(function()
        self.Utils.Tween(self.Header, {
            BackgroundColor3 = self.Theme.Colors.Secondary
        }, 0.1)
    end)
end

function Section:Toggle()
    self.Collapsed = not self.Collapsed
    
    -- Animate arrow
    self.Utils.Tween(self.Arrow, {
        Rotation = self.Collapsed and 0 or 90
    }, 0.2)
    self.Arrow.Text = self.Collapsed and ">" or "v"
    
    -- Animate content
    if self.Collapsed then
        -- Collapse
        self.Utils.Tween(self.Content, {
            Size = UDim2.new(1, 0, 0, 0)
        }, 0.2, nil, nil, function()
            self.Content.Visible = false
            self:UpdateSize()
        end)
    else
        -- Expand
        self.Content.Visible = true
        local targetHeight = self.Layout.AbsoluteContentSize.Y
        self.Utils.Tween(self.Content, {
            Size = UDim2.new(1, 0, 0, targetHeight)
        }, 0.2, nil, nil, function()
            self:UpdateSize()
        end)
    end
end

function Section:UpdateSize()
    local contentHeight = self.Collapsed and 0 or self.Layout.AbsoluteContentSize.Y
    local totalHeight = 36 + contentHeight
    self.Container.Size = UDim2.new(1, 0, 0, totalHeight)
end

-- Add component to section (components will be added directly to Content frame)
function Section:AddButton(config)
    -- Components are loaded globally in build, no need to require
    local button = Button.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, button)
    self:UpdateSize()
    return button
end

function Section:AddToggle(config)
    local toggle = Toggle.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, toggle)
    self:UpdateSize()
    return toggle
end

function Section:AddSlider(config)
    local slider = Slider.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, slider)
    self:UpdateSize()
    return slider
end

function Section:AddInput(config)
    local input = Input.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, input)
    self:UpdateSize()
    return input
end

function Section:AddDropdown(config)
    local dropdown = Dropdown.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, dropdown)
    self:UpdateSize()
    return dropdown
end

function Section:AddLabel(config)
    local label = Label.new(config, {Container = self.Content}, self.Theme, self.Utils)
    table.insert(self.Components, label)
    self:UpdateSize()
    return label
end

return Section
