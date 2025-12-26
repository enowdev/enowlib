-- EnowLib Category Component (Tree Folder)

local Category = {}
Category.__index = Category

function Category.new(config, window, theme, utils)
    local self = setmetatable({}, Category)
    
    self.Window = window
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Category",
        Icon = nil,
        Expanded = false
    }, config or {})
    
    self.Items = {}
    self.Expanded = self.Config.Expanded
    
    self:CreateUI()
    
    return self
end

function Category:CreateUI()
    -- Category Container
    self.Container = Instance.new("Frame")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.Parent = self.Window.SidebarList
    
    -- Category Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 40)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    -- Chevron Icon
    self.ChevronIcon = Instance.new("ImageLabel")
    self.ChevronIcon.BackgroundTransparency = 1
    self.ChevronIcon.Size = UDim2.fromOffset(16, 16)
    self.ChevronIcon.Position = UDim2.fromOffset(10, 12)
    self.ChevronIcon.Image = self.Theme.Icons.ChevronRight
    self.ChevronIcon.ImageColor3 = self.Theme.Colors.Accent
    self.ChevronIcon.Rotation = 0
    self.ChevronIcon.Parent = self.Button
    
    -- Folder Icon (optional)
    if self.Config.Icon then
        self.FolderIcon = Instance.new("ImageLabel")
        self.FolderIcon.BackgroundTransparency = 1
        self.FolderIcon.Size = UDim2.fromOffset(18, 18)
        self.FolderIcon.Position = UDim2.fromOffset(32, 11)
        self.FolderIcon.Image = self.Config.Icon
        self.FolderIcon.ImageColor3 = self.Theme.Colors.Accent
        self.FolderIcon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 56 or 32
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.Text
    self.Title.TextSize = self.Theme.Font.Size.Regular
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Items Container
    self.ItemsContainer = Instance.new("Frame")
    self.ItemsContainer.BackgroundTransparency = 1
    self.ItemsContainer.Size = UDim2.new(1, 0, 0, 0)
    self.ItemsContainer.Position = UDim2.fromOffset(0, 40)
    self.ItemsContainer.ClipsDescendants = true
    self.ItemsContainer.Parent = self.Container
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 0)
    layout.Parent = self.ItemsContainer
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 0.9
        }, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 1
        }, 0.15)
    end)
    
    -- Set initial state
    if self.Expanded then
        self:Expand(true)
    end
end

function Category:Toggle()
    if self.Expanded then
        self:Collapse()
    else
        self:Expand()
    end
end

function Category:Expand(instant)
    self.Expanded = true
    
    local duration = instant and 0 or self.Theme.Animation.Duration
    
    -- Rotate chevron
    self.Utils.Tween(self.ChevronIcon, {
        Rotation = 90
    }, duration)
    
    -- Calculate total height
    local totalHeight = 0
    for _, item in ipairs(self.Items) do
        totalHeight = totalHeight + 36
    end
    
    -- Expand container
    self.Utils.Tween(self.ItemsContainer, {
        Size = UDim2.new(1, 0, 0, totalHeight)
    }, duration)
    
    self.Utils.Tween(self.Container, {
        Size = UDim2.new(1, 0, 0, 40 + totalHeight)
    }, duration)
end

function Category:Collapse()
    self.Expanded = false
    
    -- Rotate chevron back
    self.Utils.Tween(self.ChevronIcon, {
        Rotation = 0
    }, self.Theme.Animation.Duration)
    
    -- Collapse container
    self.Utils.Tween(self.ItemsContainer, {
        Size = UDim2.new(1, 0, 0, 0)
    }, self.Theme.Animation.Duration)
    
    self.Utils.Tween(self.Container, {
        Size = UDim2.new(1, 0, 0, 40)
    }, self.Theme.Animation.Duration)
end

function Category:AddItem(config)
    local item = Item.new(config, self, self.Theme, self.Utils)
    table.insert(self.Items, item)
    
    if self.Expanded then
        self:Expand(true)
    end
    
    return item
end

return Category
