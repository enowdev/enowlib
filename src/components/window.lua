-- EnowLib Window Component

local Window = {}
Window.__index = Window

function Window.new(config, theme, utils, enowlib)
    local self = setmetatable({}, Window)
    
    self.Theme = theme
    self.Utils = utils
    self.EnowLib = enowlib
    self.Config = utils.Merge({
        Title = "EnowLib",
        Size = UDim2.fromOffset(500, 400),
        MinSize = Vector2.new(400, 300),
        Draggable = true,
        Resizable = false,
        CloseButton = true
    }, config or {})
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    
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
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.BorderAccent, self.Theme.Size.BorderThick)
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
    self.TitleBar.BackgroundColor3 = self.Theme.Colors.Primary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 48)
    self.TitleBar.Parent = self.Container
    
    self.Theme.CreateCorner(self.TitleBar, 8)
    self.Theme.CreateStroke(self.TitleBar, self.Theme.Colors.BorderAccent, self.Theme.Size.Border)
    
    -- Title text
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.fromOffset(18, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Background
    title.TextSize = self.Theme.Font.Size.Title
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Close button
    if self.Config.CloseButton then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.BackgroundColor3 = self.Theme.Colors.Error
        closeBtn.BorderSizePixel = 0
        closeBtn.Size = UDim2.fromOffset(32, 32)
        closeBtn.Position = UDim2.new(1, -40, 0.5, 0)
        closeBtn.AnchorPoint = Vector2.new(0, 0.5)
        closeBtn.Font = self.Theme.Font.Bold
        closeBtn.Text = "×"
        closeBtn.TextColor3 = self.Theme.Colors.Background
        closeBtn.TextSize = 24
        closeBtn.Parent = self.TitleBar
        
        self.Theme.CreateCorner(closeBtn, 6)
        self.Theme.CreateStroke(closeBtn, self.Theme.Colors.Background, self.Theme.Size.Border)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
        
        closeBtn.MouseEnter:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = Color3.fromRGB(239, 68, 68)
            }, 0.15)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            self.Utils.Tween(closeBtn, {
                BackgroundColor3 = self.Theme.Colors.Error
            }, 0.15)
        end)
    end
end

function Window:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Size = UDim2.new(0, 160, 1, -48)
    self.TabBar.Position = UDim2.fromOffset(0, 48)
    self.TabBar.Parent = self.Container
    
    self.Theme.CreateStroke(self.TabBar, self.Theme.Colors.Border, 2)
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.Size = UDim2.new(1, 0, 1, 0)
    self.TabList.ScrollBarThickness = 4
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
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(1, -160, 1, -48)
    self.ContentArea.Position = UDim2.fromOffset(160, 48)
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreatePadding(self.ContentArea, self.Theme.Spacing.Large)
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
