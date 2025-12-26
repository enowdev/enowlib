-- EnowLib Dropdown Component

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(config, parent, theme, utils)
    local self = setmetatable({}, Dropdown)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Dropdown",
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = "Option 1",
        Searchable = false,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Open = false
    self.AllOptions = {}
    
    self:CreateUI()
    
    return self
end

function Dropdown:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 86)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 20)
    
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
    
    -- Dropdown Button
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
    self.SelectedText.Text = self.Value
    self.SelectedText.TextColor3 = self.Theme.Colors.Text
    self.SelectedText.TextSize = self.Theme.Font.Size.Regular
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.Parent = self.Button
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.new(1, -16, 0.5, -8)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronDown
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.TextDim
    self.ChevronIcon.Parent = self.Button
    
    -- Options List - positioned below button with gap
    self.OptionsList = Instance.new("ScrollingFrame")
    self.OptionsList.BackgroundColor3 = self.Theme.Colors.Secondary
    self.OptionsList.BorderSizePixel = 0
    self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsList.Position = UDim2.fromOffset(0, 62)
    self.OptionsList.ScrollBarThickness = 4
    self.OptionsList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.OptionsList.CanvasSize = UDim2.fromOffset(0, 0)
    self.OptionsList.Visible = false
    self.OptionsList.ZIndex = 5
    self.OptionsList.Parent = self.Container
    
    self.Theme.CreateCorner(self.OptionsList, 6)
    self.Theme.CreatePadding(self.OptionsList, 4)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = self.OptionsList
    
    -- Search Box (optional) - positioned at top, no extra spacing
    if self.Config.Searchable then
        self.SearchBox = Instance.new("TextBox")
        self.SearchBox.BackgroundColor3 = self.Theme.Colors.Panel
        self.SearchBox.BorderSizePixel = 0
        self.SearchBox.Size = UDim2.new(1, 0, 0, 28)
        self.SearchBox.Font = self.Theme.Font.Mono
        self.SearchBox.PlaceholderText = "Search..."
        self.SearchBox.Text = ""
        self.SearchBox.TextColor3 = self.Theme.Colors.Text
        self.SearchBox.PlaceholderColor3 = self.Theme.Colors.TextDim
        self.SearchBox.TextSize = self.Theme.Font.Size.Regular
        self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        self.SearchBox.ClearTextOnFocus = false
        self.SearchBox.ZIndex = 6
        self.SearchBox.LayoutOrder = -1
        self.SearchBox.Parent = self.OptionsList
        
        self.Theme.CreateCorner(self.SearchBox, 4)
        self.Theme.CreatePadding(self.SearchBox, 8)
        
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            self:FilterOptions(self.SearchBox.Text)
        end)
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local maxHeight = math.min(layout.AbsoluteContentSize.Y, 150)
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

function Dropdown:CreateOption(optionText)
    local option = Instance.new("TextButton")
    option.BackgroundColor3 = self.Theme.Colors.Panel
    option.BackgroundTransparency = 1
    option.BorderSizePixel = 0
    option.Size = UDim2.new(1, 0, 0, 32)
    option.Font = self.Theme.Font.Mono
    option.Text = optionText
    option.TextColor3 = self.Theme.Colors.TextDim
    option.TextSize = self.Theme.Font.Size.Regular
    option.TextXAlignment = Enum.TextXAlignment.Left
    option.AutoButtonColor = false
    option.Visible = true
    option.LayoutOrder = 1
    option.Parent = self.OptionsList
    
    self.Theme.CreatePadding(option, 10)
    
    -- Store reference
    table.insert(self.AllOptions, {
        Button = option,
        Text = optionText
    })
    
    option.MouseButton1Click:Connect(function()
        self:Select(optionText)
    end)
    
    option.MouseEnter:Connect(function()
        option.BackgroundTransparency = 0.9
        option.TextColor3 = self.Theme.Colors.Accent
    end)
    
    option.MouseLeave:Connect(function()
        option.BackgroundTransparency = 1
        option.TextColor3 = self.Theme.Colors.TextDim
    end)
end

function Dropdown:FilterOptions(searchText)
    if searchText == "" then
        -- Show all options
        for _, optionData in ipairs(self.AllOptions) do
            optionData.Button.Visible = true
        end
        
        if self.Open then
            local baseHeight = self.Config.Searchable and 32 or 0
            local optionsHeight = math.min(#self.AllOptions * 34, 150)
            self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
            self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
        end
        return
    end
    
    local lowerSearch = searchText:lower()
    local visibleCount = 0
    
    for _, optionData in ipairs(self.AllOptions) do
        local lowerText = optionData.Text:lower()
        local matches = lowerText:find(lowerSearch, 1, true) ~= nil
        optionData.Button.Visible = matches
        if matches then
            visibleCount = visibleCount + 1
        end
    end
    
    -- Update height based on visible options
    if self.Open then
        local baseHeight = self.Config.Searchable and 32 or 0
        local optionsHeight = visibleCount > 0 and math.min(visibleCount * 34, 150) or 32
        self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
        self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
    end
end

function Dropdown:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        local baseHeight = self.Config.Searchable and 32 or 0
        local optionsHeight = math.min(#self.Config.Options * 34, 150)
        self.OptionsList.Size = UDim2.new(1, 0, 0, baseHeight + optionsHeight + 8)
        self.OptionsList.Visible = true
        self.Container.Size = UDim2.new(1, 0, 0, 86 + baseHeight + optionsHeight + 8)
        self.ChevronIcon.Rotation = 180
        
        -- Focus search box if searchable
        if self.Config.Searchable then
            task.wait(0.1)
            self.SearchBox:CaptureFocus()
        end
    else
        self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
        self.OptionsList.Visible = false
        self.Container.Size = UDim2.new(1, 0, 0, 86)
        self.ChevronIcon.Rotation = 0
        
        -- Clear search
        if self.Config.Searchable then
            self.SearchBox.Text = ""
            self:FilterOptions("")
        end
    end
end

function Dropdown:Select(value)
    self.Value = value
    self.SelectedText.Text = value
    self:Toggle()
    pcall(self.Config.Callback, value)
end

return Dropdown
