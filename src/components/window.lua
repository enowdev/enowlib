-- EnowLib Window Component

local Window = {}
Window.__index = Window

function Window.new(config, theme, utils, enowlib)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.EnowLib = enowlib
    self.Config = utils.Merge({
        Title = "EnowLib IDE",
        Size = UDim2.fromOffset(900, 600),
        ShowStatusBar = true
    }, config or {})
    
    self.Categories = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateUI()
    
    return self
end

function Window:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EnowLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main Container (Glass effect)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    self.Container.Position = UDim2.fromScale(0.5, 0.5)
    self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Container.Parent = self.ScreenGui
    
    self.Theme.CreateCorner(self.Container, 12)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Size = UDim2.new(1, 0, 0, 48)
    self.TitleBar.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = self.Theme.Colors.Secondary
    closeBtn.BackgroundTransparency = self.Theme.Transparency.Subtle
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.fromOffset(32, 32)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
    closeBtn.Text = ""
    closeBtn.Parent = self.TitleBar
    
    self.Theme.CreateCorner(closeBtn, 6)
    
    -- Close Icon
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.BackgroundTransparency = 1
    closeIcon.Size = UDim2.fromOffset(20, 20)
    closeIcon.Position = UDim2.fromScale(0.5, 0.5)
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.Image = self.Theme.Icons.X
    closeIcon.ImageColor3 = self.Theme.Colors.TextDim
    closeIcon.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        self.Utils.Tween(closeBtn, {
            BackgroundColor3 = self.Theme.Colors.Error,
            BackgroundTransparency = self.Theme.Transparency.None
        }, self.Theme.Animation.Duration)
        self.Utils.Tween(closeIcon, {
            ImageColor3 = self.Theme.Colors.Text
        }, self.Theme.Animation.Duration)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        self.Utils.Tween(closeBtn, {
            BackgroundColor3 = self.Theme.Colors.Secondary,
            BackgroundTransparency = self.Theme.Transparency.Subtle
        }, self.Theme.Animation.Duration)
        self.Utils.Tween(closeIcon, {
            ImageColor3 = self.Theme.Colors.TextDim
        }, self.Theme.Animation.Duration)
    end)
    
    -- Separator
    local separator = Instance.new("Frame")
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 48)
    separator.Parent = self.Container
    
    -- Tab Bar
    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = self.Theme.Colors.Panel
    self.TabBar.BackgroundTransparency = self.Theme.Transparency.Glass
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, 280, 1, -49)
    self.TabBar.Position = UDim2.fromOffset(0, 49)
    self.TabBar.ClipsDescendants = true
    self.TabBar.Parent = self.Container
    
    self.Theme.CreateCorner(self.TabBar, 12)
    
    -- Sidebar Header
    local sidebarHeader = Instance.new("Frame")
    sidebarHeader.BackgroundColor3 = self.Theme.Colors.Secondary
    sidebarHeader.BackgroundTransparency = self.Theme.Transparency.Subtle
    sidebarHeader.BorderSizePixel = 0
    sidebarHeader.Size = UDim2.new(1, 0, 0, 32)
    sidebarHeader.Parent = self.TabBar
    
    local explorerLabel = Instance.new("TextLabel")
    explorerLabel.BackgroundTransparency = 1
    explorerLabel.Size = UDim2.new(1, -16, 1, 0)
    explorerLabel.Position = UDim2.fromOffset(12, 0)
    explorerLabel.Font = self.Theme.Font.Bold
    explorerLabel.Text = "EXPLORER"
    explorerLabel.TextColor3 = self.Theme.Colors.TextDim
    explorerLabel.TextSize = 11
    explorerLabel.TextXAlignment = Enum.TextXAlignment.Left
    explorerLabel.Parent = sidebarHeader
    
    self.SidebarList = Instance.new("ScrollingFrame")
    self.SidebarList.BackgroundTransparency = 1
    self.SidebarList.BorderSizePixel = 0
    self.SidebarList.Size = UDim2.new(1, 0, 1, -32)
    self.SidebarList.Position = UDim2.fromOffset(0, 32)
    self.SidebarList.ScrollBarThickness = 4
    self.SidebarList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.SidebarList.CanvasSize = UDim2.fromOffset(0, 0)
    self.SidebarList.Parent = self.TabBar
    
    self.Theme.CreatePadding(self.SidebarList, 4)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = self.SidebarList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.SidebarList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)
    
    -- Vertical Separator
    local vSeparator = Instance.new("Frame")
    vSeparator.BackgroundColor3 = self.Theme.Colors.Border
    vSeparator.BorderSizePixel = 0
    vSeparator.Size = UDim2.new(0, 1, 1, -49)
    vSeparator.Position = UDim2.fromOffset(280, 49)
    vSeparator.Parent = self.Container
    
    -- Content Area
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentArea.BackgroundTransparency = self.Theme.Transparency.Glass
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -281, 1, -49)
    self.ContentArea.Position = UDim2.fromOffset(281, 49)
    self.ContentArea.ScrollBarThickness = 6
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.ContentArea.CanvasSize = UDim2.fromOffset(0, 0)
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreateCorner(self.ContentArea, 12)
    
    self.Theme.CreatePadding(self.ContentArea, self.Theme.Spacing.Large)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, self.Theme.Spacing.Medium)
    contentLayout.Parent = self.ContentArea
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 32)
    end)
    
    -- Make draggable
    self.Utils.MakeDraggable(self.Container, self.TitleBar)
    
    -- Parent to CoreGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
end

function Window:AddCategory(config)
    local category = Category.new(config, self, self.Theme, self.Utils)
    table.insert(self.Categories, category)
    return category
end

function Window:AddTab(config)
    local tab = Tab.new(config, self, self.Theme, self.Utils)
    table.insert(self.Tabs, tab)
    
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab then
        self.CurrentTab:Hide()
    end
    
    self.CurrentTab = tab
    tab:Show()
end

function Window:ShowContent(contentFunc)
    self.Utils.ClearChildren(self.ContentArea)
    
    if contentFunc then
        pcall(contentFunc, self)
    end
end

function Window:Toggle()
    self.Container.Visible = not self.Container.Visible
end

-- Component Factory Methods (for use in Content functions)
function Window:AddButton(config)
    return Button.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddToggle(config)
    return Toggle.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddSlider(config)
    return Slider.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddLabel(config)
    return Label.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddTextBox(config)
    return TextBox.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddDropdown(config)
    return Dropdown.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddColorPicker(config)
    return ColorPicker.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddKeybind(config)
    return Keybind.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddSection(config)
    return Section.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddParagraph(config)
    return Paragraph.new(config, self.ContentArea, self.Theme, self.Utils)
end

function Window:AddDivider(config)
    return Divider.new(config, self.ContentArea, self.Theme, self.Utils)
end

return Window
