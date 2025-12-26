-- EnowLib MultiDropdown Component (Checkbox List)

local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown

function MultiDropdown.new(config, tab, theme, utils)
    local self = setmetatable({}, MultiDropdown)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Multi Select",
        Description = nil,
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = {},
        Callback = function(values) end
    }, config or {})
    
    self.Values = {}
    for _, v in ipairs(self.Config.Default) do
        self.Values[v] = true
    end
    
    self.Open = false
    
    self:CreateUI()
    
    return self
end

function MultiDropdown:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "MultiDropdown"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
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
    
    -- Selected count text
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Size = UDim2.new(1, -32, 1, 0)
    self.ValueLabel.Position = UDim2.fromOffset(8, 0)
    self.ValueLabel.Font = self.Theme.Font.Regular
    self.ValueLabel.Text = self:GetDisplayText()
    self.ValueLabel.TextColor3 = self.Theme.Colors.TextDim
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
    
    -- Create option checkboxes
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

function MultiDropdown:CreateOption(option, parent)
    local optionContainer = Instance.new("Frame")
    optionContainer.Name = "Option"
    optionContainer.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    optionContainer.BorderSizePixel = 0
    optionContainer.Size = UDim2.new(1, 0, 0, 32)
    optionContainer.Parent = parent
    
    -- Checkbox
    local checkbox = Instance.new("Frame")
    checkbox.Name = "Checkbox"
    checkbox.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    checkbox.BorderSizePixel = 0
    checkbox.Size = UDim2.fromOffset(18, 18)
    checkbox.Position = UDim2.fromOffset(8, 7)
    checkbox.Parent = optionContainer
    
    self.Theme.CreateCorner(checkbox, 4)
    self.Theme.CreateStroke(checkbox, self.Theme.Colors.Border)
    
    -- Checkmark
    local checkmark = Instance.new("TextLabel")
    checkmark.Name = "Checkmark"
    checkmark.BackgroundTransparency = 1
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.Font = self.Theme.Font.Bold
    checkmark.Text = "✓"
    checkmark.TextColor3 = self.Theme.Colors.Primary
    checkmark.TextSize = 14
    checkmark.Visible = self.Values[option] or false
    checkmark.Parent = checkbox
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -34, 1, 0)
    label.Position = UDim2.fromOffset(30, 0)
    label.Font = self.Theme.Font.Regular
    label.Text = option
    label.TextColor3 = self.Theme.Colors.Text
    label.TextSize = self.Theme.Font.Size.Regular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = optionContainer
    
    -- Click button
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = optionContainer
    
    button.MouseButton1Click:Connect(function()
        self:ToggleOption(option, checkmark)
    end)
    
    button.MouseEnter:Connect(function()
        self.Utils.Tween(optionContainer, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self.Utils.Tween(optionContainer, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.15)
    end)
end

function MultiDropdown:ToggleOption(option, checkmark)
    self.Values[option] = not self.Values[option]
    checkmark.Visible = self.Values[option]
    
    self.ValueLabel.Text = self:GetDisplayText()
    
    local selected = {}
    for opt, enabled in pairs(self.Values) do
        if enabled then
            table.insert(selected, opt)
        end
    end
    
    pcall(self.Config.Callback, selected)
end

function MultiDropdown:GetDisplayText()
    local count = 0
    for _, enabled in pairs(self.Values) do
        if enabled then
            count = count + 1
        end
    end
    
    if count == 0 then
        return "None selected"
    elseif count == 1 then
        for opt, enabled in pairs(self.Values) do
            if enabled then
                return opt
            end
        end
    else
        return string.format("%d selected", count)
    end
end

function MultiDropdown:Toggle()
    if self.Open then
        self:Close()
    else
        self:OpenList()
    end
end

function MultiDropdown:OpenList()
    self.Open = true
    
    local optionCount = math.min(#self.Config.Options, 5)
    local height = optionCount * 32
    
    self.OptionsList.Visible = true
    self.Utils.Tween(self.OptionsList, {
        Size = UDim2.new(1, -24, 0, height)
    }, 0.2)
    
    self.Utils.Tween(self.Arrow, {
        Rotation = 180
    }, 0.2)
end

function MultiDropdown:Close()
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

function MultiDropdown:SetValues(values)
    self.Values = {}
    for _, v in ipairs(values) do
        self.Values[v] = true
    end
    
    -- Update checkmarks
    local scroll = self.OptionsList:FindFirstChild("Scroll")
    if scroll then
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name == "Option" then
                local label = child:FindFirstChild("Label")
                local checkmark = child:FindFirstChild("Checkbox"):FindFirstChild("Checkmark")
                if label and checkmark then
                    checkmark.Visible = self.Values[label.Text] or false
                end
            end
        end
    end
    
    self.ValueLabel.Text = self:GetDisplayText()
end

return MultiDropdown
