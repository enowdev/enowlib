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
    
    -- Main container (Dark mode with transparency)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Background
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    self.Container.Position = UDim2.fromScale(0.5, 0.5)
    self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Container.Parent = self.ScreenGui
    
    -- Backdrop blur effect for glass morphism
    local blur = Instance.new("ImageLabel")
    blur.Name = "Blur"
    blur.BackgroundTransparency = 1
    blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    blur.ImageColor3 = Color3.fromRGB(0, 0, 0)
    blur.ImageTransparency = 0.5
    blur.ScaleType = Enum.ScaleType.Slice
    blur.SliceCenter = Rect.new(10, 10, 118, 118)
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.ZIndex = 0
    blur.Parent = self.Container
    
    -- Dark border
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border, self.Theme.Size.Border)
    self.Theme.CreateCorner(self.Container, 12)
    
    -- Subtle glow shadow
    self.Theme.CreateShadow(self.Container, 3)
    
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
    self.TitleBar.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.TitleBar.BackgroundTransparency = 0.3
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 48)
    self.TitleBar.Parent = self.Container
    
    -- Bottom border separator
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, -1)
    separator.Parent = self.TitleBar
    
    -- Title text (Dark mode - bright text)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Medium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Close button (Dark mode style)
    if self.Config.CloseButton then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.BackgroundColor3 = self.Theme.Colors.Secondary
        closeBtn.BackgroundTransparency = 0.3
        closeBtn.BorderSizePixel = 0
        closeBtn.Size = UDim2.fromOffset(32, 32)
        closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
        closeBtn.Font = self.Theme.Font.Regular
        closeBtn.Text = ""
        closeBtn.AutoButtonColor = false
        closeBtn.Parent = self.TitleBar
        
        self.Theme.CreateCorner(closeBtn, 6)
        
        -- Close icon (X)
        local icon = self.Theme.CreateIcon(closeBtn, self.Theme.Icons.Cross, 16)
        icon.Position = UDim2.fromScale(0.5, 0.5)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.ImageColor3 = self.Theme.Colors.TextSecondary
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
        
        closeBtn.MouseEnter:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = self.Theme.Colors.Error,
                BackgroundTransparency = 0
            }, self.Theme.Animation.Speed.Fast, self.Theme.Animation.Easing)
            self.Utils.Tween(icon, {
                ImageColor3 = self.Theme.Colors.TextWhite
            }, self.Theme.Animation.Speed.Fast, self.Theme.Animation.Easing)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = self.Theme.Colors.Secondary,
                BackgroundTransparency = 0.3
            }, self.Theme.Animation.Speed.Fast, self.Theme.Animation.Easing)
            self.Utils.Tween(icon, {
                ImageColor3 = self.Theme.Colors.TextSecondary
            }, self.Theme.Animation.Speed.Fast, self.Theme.Animation.Easing)
        end)
    end
end

function Window:CreateTabBar()
    -- Responsive tab bar width
    local tabBarWidth = self.IsMobile and 0 or (self.IsTablet and 120 or 200)
    
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.BackgroundColor3 = self.Theme.Colors.Background
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, tabBarWidth, 1, -48)
    self.TabBar.Position = UDim2.fromOffset(0, 48)
    self.TabBar.Visible = not self.IsMobile
    self.TabBar.Parent = self.Container
    
    -- Right border separator
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(0, 1, 1, 0)
    separator.Position = UDim2.new(1, -1, 0, 0)
    separator.Parent = self.TabBar
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.Size = UDim2.new(1, 0, 1, 0)
    self.TabList.ScrollBarThickness = 4
    self.TabList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.TabList.CanvasSize = UDim2.fromOffset(0, 0)
    self.TabList.Parent = self.TabBar
    
    self.Theme.CreatePadding(self.TabList, self.Theme.Spacing.Small)
    
    -- List layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Tiny)
    layout.Parent = self.TabList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)
end

function Window:CreateContentArea()
    -- Responsive content area
    local contentOffset = self.IsMobile and 0 or (self.IsTablet and 120 or 200)
    
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Panel
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -contentOffset, 1, -48)
    self.ContentArea.Position = UDim2.fromOffset(contentOffset, 48)
    self.ContentArea.ClipsDescendants = false
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
