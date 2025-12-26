-- EnowLib MultiSelect Component

local MultiSelect = {}
MultiSelect.__index = MultiSelect

function MultiSelect.new(config, parent, theme, utils)
    local self = setmetatable({}, MultiSelect)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "MultiSelect",
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
    self:UpdateDisplay()
    
    return self
end

function MultiSelect:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 78)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 16)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Text
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- MultiSelect Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 32)
    self.Button.Position = UDim2.fromOffset(0, 26)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 6)
    self.Theme.CreatePadding(self.Button, 10)
    
    -- Selected Text
    self.SelectedText = Instance.new("TextLabel")
    self.SelectedText.BackgroundTransparency = 1
    self.SelectedText.Size = UDim2.new(1, -30, 1, 0)
    self.SelectedText.Font = self.Theme.Font.Mono
    self.SelectedText.Text = "None selected"
    self.SelectedText.TextColor3 = self.Theme.Colors.TextDim
    self.SelectedText.TextSize = self.Theme.Font.Size.Regular
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.TextTruncate = Enum.TextTruncate.AtEnd
    self.SelectedText.Parent = self.Button
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.new(1, -16, 0.5, -8)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronDown
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Options List
    self.OptionsList = Instance.new("ScrollingFrame")
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.Secondary
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(0, 60)
    self.OptionsList.ScrollBarThickness = 4
    self.OptionsList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.OptionsList.CanvasSize = UDim2.fromOffset(0, 0)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 5
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 6)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = self.OptionsList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.OptionsList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
    end)
    
    -- Create options
    for _, option in ipairs(self.Config.Options) do
        self:CreateOption(option)
    end
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function MultiSelect:CreateOption(optionText)
    local option = Instance.new("TextButton")
    option.BackgroundColor3 = self.Theme.Colors.Panel
    option.BackgroundTransparency = 1
    option.BorderSizePixel = 0
    option.Size = UDim2.new(1, 0, 0, 28)
    option.Font = self.Theme.Font.Mono
    option.Text = ""
    option.AutoButtonColor = false
    option.Parent = self.OptionsList
    
    self.Theme.CreatePadding(option, 8)
    
    -- Checkbox
    local checkbox = Instance.new("Frame")
    checkbox.BackgroundColor3 = self.Theme.Colors.Secondary
    checkbox.BorderSizePixel = 0
    checkbox.Size = UDim2.fromOffset(16, 16)
    checkbox.Position = UDim2.fromOffset(0, 6)
    checkbox.Parent = option
    
    self.Theme.CreateCorner(checkbox, 3)
    self.Theme.CreateStroke(checkbox, self.Theme.Colors.Border)
    
    -- Check Icon
    local checkIcon = Instance.new("ImageLabel")
    checkIcon.BackgroundTransparency = 1
    checkIcon.Size = UDim2.fromOffset(12, 12)
    checkIcon.Position = UDim2.fromScale(0.5, 0.5)
    checkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    checkIcon.Image = self.Theme.Icons.Check
    checkIcon.ImageColor3 = self.Theme.Colors.Text
    checkIcon.ImageTransparency = 1
    checkIcon.Parent = checkbox
    
    -- Option Text
    local optionLabel = Instance.new("TextLabel")
    optionLabel.BackgroundTransparency = 1
    optionLabel.Size = UDim2.new(1, -24, 1, 0)
    optionLabel.Position = UDim2.fromOffset(24, 0)
    optionLabel.Font = self.Theme.Font.Mono
    optionLabel.Text = optionText
    optionLabel.TextColor3 = self.Theme.Colors.TextDim
    optionLabel.TextSize = self.Theme.Font.Size.Regular
    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
    optionLabel.Parent = option
    
    -- Update visual if already selected
    if self.Values[optionText] then
        checkbox.BackgroundColor3 = self.Theme.Colors.Accent
        checkIcon.ImageTransparency = 0
        optionLabel.TextColor3 = self.Theme.Colors.Text
    end
    
    option.MouseButton1Click:Connect(function()
        self:ToggleOption(optionText, checkbox, checkIcon, optionLabel)
    end)
    
    option.MouseEnter:Connect(function()
        option.BackgroundTransparency = 0.9
        if not self.Values[optionText] then
            optionLabel.TextColor3 = self.Theme.Colors.Accent
        end
    end)
    
    option.MouseLeave:Connect(function()
        option.BackgroundTransparency = 1
        if not self.Values[optionText] then
            optionLabel.TextColor3 = self.Theme.Colors.TextDim
        end
    end)
end

function MultiSelect:ToggleOption(optionText, checkbox, checkIcon, optionLabel)
    self.Values[optionText] = not self.Values[optionText]
    
    if self.Values[optionText] then
        self.Utils.Tween(checkbox, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, 0.15)
        self.Utils.Tween(checkIcon, {
            ImageTransparency = 0
        }, 0.15)
        self.Utils.Tween(optionLabel, {
            TextColor3 = self.Theme.Colors.Text
        }, 0.15)
    else
        self.Utils.Tween(checkbox, {
            BackgroundColor3 = self.Theme.Colors.Secondary
        }, 0.15)
        self.Utils.Tween(checkIcon, {
            ImageTransparency = 1
        }, 0.15)
        self.Utils.Tween(optionLabel, {
            TextColor3 = self.Theme.Colors.TextDim
        }, 0.15)
    end
    
    self:UpdateDisplay()
    
    local selectedValues = {}
    for value, selected in pairs(self.Values) do
        if selected then
            table.insert(selectedValues, value)
        end
    end
    
    pcall(self.Config.Callback, selectedValues)
end

function MultiSelect:UpdateDisplay()
    local selectedCount = 0
    local selectedList = {}
    
    for value, selected in pairs(self.Values) do
        if selected then
            selectedCount = selectedCount + 1
            table.insert(selectedList, value)
        end
    end
    
    if selectedCount == 0 then
        self.SelectedText.Text = "None selected"
        self.SelectedText.TextColor3 = self.Theme.Colors.TextDim
    elseif selectedCount == 1 then
        self.SelectedText.Text = selectedList[1]
        self.SelectedText.TextColor3 = self.Theme.Colors.Text
    else
        self.SelectedText.Text = selectedCount .. " items selected"
        self.SelectedText.TextColor3 = self.Theme.Colors.Text
    end
end

function MultiSelect:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        local optionsHeight = math.min(#self.Config.Options * 30, 150)
        self.OptionsList.Size = UDim2.new(1, 0, 0, optionsHeight)
        self.OptionsList.Visible = true
        self.Container.Size = UDim2.new(1, 0, 0, 78 + optionsHeight + 4)
        self.ChevronIcon.Rotation = 180
    else
        self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
        self.OptionsList.Visible = false
        self.Container.Size = UDim2.new(1, 0, 0, 78)
        self.ChevronIcon.Rotation = 0
    end
end

return MultiSelect
