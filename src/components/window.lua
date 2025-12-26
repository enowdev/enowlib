-- EnowLib Window Component

local Window = {}
Window.__index = Window

function Window.new(config, theme, utils, enowlib)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.EnowLib = enowlib
    
    -- Get viewport size for responsive
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local isMobile = ViewportSize.X < theme.Responsive.Mobile
    local isTablet = ViewportSize.X < theme.Responsive.Tablet and not isMobile
    
    -- Responsive default size
    local defaultWidth = isMobile and ViewportSize.X * 0.95 or (isTablet and 450 or 520)
    local defaultHeight = isMobile and ViewportSize.Y * 0.85 or (isTablet and 380 or 420)
    
    self.Config = utils.Merge({
        Title = "EnowLib",
        Size = UDim2.fromOffset(defaultWidth, defaultHeight),
        MinSize = Vector2.new(320, 280),
        Draggable = not isMobile,  -- Disable drag on mobile
        Resizable = false,
        CloseButton = true
    }, config or {})
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    self.IsMobile = isMobile
    self.IsTablet = isTablet
    
    self:CreateUI()
    
    return self
end

function Window:CreateUI()
    -- Screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EnowLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.BackgroundColor3 = self.Theme.Colors.Background
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    self.Container.Position = UDim2.fromScale(0.5, 0.5)
    self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Container.Parent = self.ScreenGui
    
    -- Y2K thick black border
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border, self.Theme.Size.Border)
    
    -- Y2K solid shadow
    self.Theme.CreateShadow(self.Container)
    
    -- Title bar
    self:CreateTitleBar()
    
    -- Tab bar
    self:CreateTabBar()
    
    -- Content area
    self:CreateContentArea()
    
    -- Make draggable
    if self.Config.Draggable then
        self.Utils.MakeDraggable(self.Container, self.TitleBar)
    end
    
    -- Parent to game
    self.ScreenGui.Parent = game:GetService("CoreGui")
end

function Window:CreateTitleBar()
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundColor3 = self.Theme.Colors.TitleBar  -- Cyan like Windows 2000
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 32)
    self.TitleBar.Parent = self.Container
    
    -- Add glossy gradient
    self.Theme.CreateGradient(self.TitleBar, 90)
    
    -- Title text
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.fromOffset(8, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 0.8
    title.Parent = self.TitleBar
    
    -- Close button (Y2K style)
    if self.Config.CloseButton then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.BackgroundColor3 = self.Theme.Colors.Error
        closeBtn.BorderSizePixel = 0
        closeBtn.Size = UDim2.fromOffset(24, 24)
        closeBtn.Position = UDim2.new(1, -28, 0, 4)
        closeBtn.Font = self.Theme.Font.Bold
        closeBtn.Text = "X"
        closeBtn.TextColor3 = self.Theme.Colors.Text
        closeBtn.TextSize = 16
        closeBtn.Parent = self.TitleBar
        
        self.Theme.CreateStroke(closeBtn, self.Theme.Colors.Border, 3)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
        
        closeBtn.MouseEnter:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = Color3.fromRGB(255, 150, 150)
            }, 0.1)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = self.Theme.Colors.Error
            }, 0.1)
        end)
    end
end

function Window:CreateTabBar()
    -- Responsive tab bar width
    local tabBarWidth = self.IsMobile and 0 or (self.IsTablet and 120 or 140)
    
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.BackgroundColor3 = self.Theme.Colors.Secondary  -- Purple sidebar
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, tabBarWidth, 1, -32)
    self.TabBar.Position = UDim2.fromOffset(0, 32)
    self.TabBar.Visible = not self.IsMobile
    self.TabBar.Parent = self.Container
    
    self.Theme.CreateStroke(self.TabBar, self.Theme.Colors.Border, 3)
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.Size = UDim2.new(1, 0, 1, 0)
    self.TabList.ScrollBarThickness = 8
    self.TabList.ScrollBarImageColor3 = self.Theme.Colors.Primary
    self.TabList.CanvasSize = UDim2.fromOffset(0, 0)
    self.TabList.Parent = self.TabBar
    
    self.Theme.CreatePadding(self.TabList, self.Theme.Spacing.Small)
    
    -- List layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Small)
    layout.Parent = self.TabList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)
end

function Window:CreateContentArea()
    -- Responsive content area
    local contentOffset = self.IsMobile and 0 or (self.IsTablet and 120 or 140)
    
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -contentOffset, 1, -32)
    self.ContentArea.Position = UDim2.fromOffset(contentOffset, 32)
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreatePadding(self.ContentArea, self.IsMobile and self.Theme.Spacing.Small or self.Theme.Spacing.Medium)
end

function Window:AddTab(config)
    local Tab = require(script.Parent.tab)
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

function Window:Toggle()
    self.Visible = not self.Visible
    
    if self.Visible then
        self.Container.Visible = true
        self.Utils.Tween(self.Container, {
            Size = self.Config.Size
        }, 0.25, Enum.EasingStyle.Back)
    else
        self.Utils.Tween(self.Container, {
            Size = UDim2.fromOffset(0, 0)
        }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            self.Container.Visible = false
        end)
    end
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end

return Window
