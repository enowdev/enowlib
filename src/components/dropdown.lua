-- EnowLib Dropdown Component

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(config, parent, theme, utils)
    local self = setmetatable({}, Dropdown)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Dropdown",
        Options = {"Option 1", "Option 2", "Option 3"},
        Default = "Option 1",
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Open = false
    
    self:CreateUI()
    
    return self
end

function Dropdown:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 70)
    self.Container.Parent = self.Parent.Container or self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
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
    option.Parent = self.OptionsList
    
    self.Theme.CreatePadding(option, 10)
    
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

function Dropdown:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        local optionsHeight = math.min(#self.Config.Options * 34, 150)
        self.OptionsList.Size = UDim2.new(1, 0, 0, optionsHeight)
        self.OptionsList.Visible = true
        self.Container.Size = UDim2.new(1, 0, 0, 70 + optionsHeight + 4)
        self.ChevronIcon.Rotation = 180
    else
        self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
        self.OptionsList.Visible = false
        self.Container.Size = UDim2.new(1, 0, 0, 70)
        self.ChevronIcon.Rotation = 0
    end
end

function Dropdown:Select(value)
    self.Value = value
    self.SelectedText.Text = value
    self:Toggle()
    pcall(self.Config.Callback, value)
end

return Dropdown
