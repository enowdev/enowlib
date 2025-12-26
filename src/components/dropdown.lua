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
    arrow.Text = "▼"
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

return Dropdown
