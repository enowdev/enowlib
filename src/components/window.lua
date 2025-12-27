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
        ShowStatusBar = true,
        AutoResize = true,
        MinSize = Vector2.new(600, 400),
        MaxSize = Vector2.new(1400, 900)
    }, config or {})
    
    self.Categories = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Auto-resize settings
    self.MinSize = self.Config.MinSize
    self.MaxSize = self.Config.MaxSize
    self.OriginalSize = Vector2.new(
        self.Config.Size.X.Offset,
        self.Config.Size.Y.Offset
    )
    
    -- Responsive scale factor (will be calculated based on window size)
    self.ScaleFactor = 1
    
    self:CreateUI()
    
    if self.Config.AutoResize then
        self:SetupAutoResize()
    end
    
    return self
end

function Window:CalculateScaleFactor()
    -- No longer needed - using proportional sizing instead
    return 1
end

function Window:ApplyResponsiveScaling()
    -- No longer needed - layout is now proportional
    print("[EnowLib] Using proportional layout - no scaling needed")
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
    self.Container.BackgroundTransparency = 0.15
    self.Container.BorderSizePixel = 0
    self.Container.Size = self.Config.Size
    -- Use Offset position for consistency with drag system
    -- Will be centered after ScreenGui is parented
    self.Container.Position = UDim2.fromOffset(0, 0)
    self.Container.Parent = self.ScreenGui
    
    self.Theme.CreateCorner(self.Container, 12)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Size = UDim2.new(1, 0, 0, 28)
    self.TitleBar.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.fromOffset(8, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Small
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.TitleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = self.Theme.Colors.Secondary
    closeBtn.BackgroundTransparency = self.Theme.Transparency.Subtle
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -10)
    closeBtn.Text = ""
    closeBtn.Parent = self.TitleBar
    
    self.Theme.CreateCorner(closeBtn, 4)
    
    -- Close Icon
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.BackgroundTransparency = 1
    closeIcon.Size = UDim2.fromOffset(14, 14)
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
    separator.Name = "HeaderSeparator"
    separator.BackgroundColor3 = self.Theme.Colors.Border
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 28)
    separator.Parent = self.Container
    
    self.HeaderSeparator = separator
    
    -- Tab Bar (Sidebar) - Use proportional width (30% of window)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.Panel
    self.Sidebar.BackgroundTransparency = 0.2
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Size = UDim2.new(0.3, 0, 1, -47)  -- 30% width, proportional
    self.Sidebar.Position = UDim2.fromOffset(0, 29)
    self.Sidebar.Parent = self.Container
    
    -- Sidebar Header
    self.SidebarHeader = Instance.new("Frame")
    self.SidebarHeader.Name = "SidebarHeader"
    self.SidebarHeader.BackgroundColor3 = self.Theme.Colors.Secondary
    self.SidebarHeader.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.SidebarHeader.BorderSizePixel = 0
    self.SidebarHeader.Size = UDim2.new(1, 0, 0, 22)
    self.SidebarHeader.Parent = self.Sidebar
    
    self.ExplorerLabel = Instance.new("TextLabel")
    self.ExplorerLabel.BackgroundTransparency = 1
    self.ExplorerLabel.Size = UDim2.new(1, -8, 1, 0)
    self.ExplorerLabel.Position = UDim2.fromOffset(6, 0)
    self.ExplorerLabel.Font = self.Theme.Font.Bold
    self.ExplorerLabel.Text = "EXPLORER"
    self.ExplorerLabel.TextColor3 = self.Theme.Colors.TextDim
    self.ExplorerLabel.TextSize = 9
    self.ExplorerLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ExplorerLabel.Parent = self.SidebarHeader
    
    self.SidebarList = Instance.new("ScrollingFrame")
    self.SidebarList.BackgroundTransparency = 1
    self.SidebarList.BorderSizePixel = 0
    self.SidebarList.Size = UDim2.new(1, 0, 1, -22)
    self.SidebarList.Position = UDim2.fromOffset(0, 22)
    self.SidebarList.ScrollBarThickness = 3
    self.SidebarList.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.SidebarList.CanvasSize = UDim2.fromOffset(0, 0)
    self.SidebarList.Parent = self.Sidebar
    
    self.Theme.CreatePadding(self.SidebarList, 3)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.Parent = self.SidebarList
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.SidebarList.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 4)
    end)
    
    -- Vertical Separator - Position after sidebar (30%)
    self.VerticalSeparator = Instance.new("Frame")
    self.VerticalSeparator.Name = "VerticalSeparator"
    self.VerticalSeparator.BackgroundColor3 = self.Theme.Colors.Border
    self.VerticalSeparator.BorderSizePixel = 0
    self.VerticalSeparator.Size = UDim2.new(0, 1, 1, -47)
    self.VerticalSeparator.Position = UDim2.new(0.3, 0, 0, 29)  -- At 30% width
    self.VerticalSeparator.Parent = self.Container
    
    -- Content Area - Use remaining 70% width
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentArea.BackgroundTransparency = 0.2
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Size = UDim2.new(0.7, -1, 1, -47)  -- 70% width minus separator
    self.ContentArea.Position = UDim2.new(0.3, 1, 0, 29)  -- Start after separator
    self.ContentArea.ScrollBarThickness = 4
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Colors.Border
    self.ContentArea.CanvasSize = UDim2.fromOffset(0, 0)
    self.ContentArea.Parent = self.Container
    
    self.Theme.CreatePadding(self.ContentArea, 8)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = self.ContentArea
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Footer Separator
    self.FooterSeparator = Instance.new("Frame")
    self.FooterSeparator.Name = "FooterSeparator"
    self.FooterSeparator.BackgroundColor3 = self.Theme.Colors.Border
    self.FooterSeparator.BorderSizePixel = 0
    self.FooterSeparator.Size = UDim2.new(1, 0, 0, 1)
    self.FooterSeparator.Position = UDim2.new(0, 0, 1, -16)
    self.FooterSeparator.Parent = self.Container
    
    -- Footer
    self.Footer = Instance.new("Frame")
    self.Footer.Name = "Footer"
    self.Footer.BackgroundTransparency = 1
    self.Footer.Size = UDim2.new(1, 0, 0, 16)
    self.Footer.Position = UDim2.new(0, 0, 1, -16)
    self.Footer.Parent = self.Container
    
    -- Footer Text (read-only)
    self.FooterLabel = Instance.new("TextLabel")
    self.FooterLabel.BackgroundTransparency = 1
    self.FooterLabel.Size = UDim2.new(1, -16, 1, 0)
    self.FooterLabel.Position = UDim2.fromOffset(8, 0)
    self.FooterLabel.Font = self.Theme.Font.Mono
    self.FooterLabel.Text = "EnowLib v2.0.0"
    self.FooterLabel.TextColor3 = self.Theme.Colors.TextDim
    self.FooterLabel.TextSize = 9
    self.FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.FooterLabel.Parent = self.Footer
    
    -- Make draggable
    self.Utils.MakeDraggable(self.Container, self.TitleBar)
    
    -- Parent to CoreGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Center window if auto-resize is disabled
    if not self.Config.AutoResize then
        task.spawn(function()
            task.wait(0.1)
            local Camera = workspace.CurrentCamera
            local viewportSize = Camera.ViewportSize
            local windowSize = self.Container.AbsoluteSize
            
            local centerX = (viewportSize.X - windowSize.X) / 2
            local centerY = (viewportSize.Y - windowSize.Y) / 2
            
            self.Container.Position = UDim2.fromOffset(centerX, centerY)
        end)
    end
end

function Window:SetupAutoResize()
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    
    -- Function to calculate scaled size
    local function calculateScaledSize()
        local viewportSize = Camera.ViewportSize
        
        -- For mobile/small screens, use direct percentage (no compensation needed)
        if viewportSize.X < 1024 then
            -- Direct: 65% width, 75% height of viewport
            local newWidth = viewportSize.X * 0.65
            local newHeight = viewportSize.Y * 0.75
            
            -- Apply min constraints
            newWidth = math.max(newWidth, 300)
            newHeight = math.max(newHeight, 250)
            
            print("[EnowLib] Mobile mode - Viewport:", viewportSize.X, "x", viewportSize.Y, "Window:", newWidth, "x", newHeight)
            
            return Vector2.new(newWidth, newHeight)
        end
        
        -- For PC/large screens, use original size with margin
        local margin = 80
        local maxWidth = viewportSize.X - margin
        local maxHeight = viewportSize.Y - margin
        
        local newWidth = self.OriginalSize.X
        local newHeight = self.OriginalSize.Y
        
        -- Scale down if too big for viewport
        if newWidth > maxWidth or newHeight > maxHeight then
            local scaleX = maxWidth / newWidth
            local scaleY = maxHeight / newHeight
            local scale = math.min(scaleX, scaleY)
            
            newWidth = newWidth * scale
            newHeight = newHeight * scale
        end
        
        -- Apply constraints for PC
        newWidth = math.clamp(newWidth, self.MinSize.X, self.MaxSize.X)
        newHeight = math.clamp(newHeight, self.MinSize.Y, self.MaxSize.Y)
        
        print("[EnowLib] PC mode - Viewport:", viewportSize.X, "x", viewportSize.Y, "Window:", newWidth, "x", newHeight)
        
        return Vector2.new(newWidth, newHeight)
    end
    
    -- Function to update window size and position
    local function updateWindowSize()
        local newSize = calculateScaledSize()
        local viewportSize = Camera.ViewportSize
        
        -- Get current position
        local currentPos = self.Container.AbsolutePosition
        
        -- Calculate new position ensuring header stays visible
        local minY = 0  -- Minimum Y to keep header visible
        local maxY = viewportSize.Y - 28  -- At least 28px (header height) visible
        local maxX = viewportSize.X - 100  -- At least 100px visible on right
        
        -- Clamp position to keep window within bounds
        local newX = math.clamp(currentPos.X, 0, math.max(0, viewportSize.X - newSize.X))
        local newY = math.clamp(currentPos.Y, minY, math.max(minY, viewportSize.Y - newSize.Y))
        
        -- If window would be too far right or bottom, adjust
        if newX + newSize.X > viewportSize.X then
            newX = viewportSize.X - newSize.X
        end
        if newY + newSize.Y > viewportSize.Y then
            newY = viewportSize.Y - newSize.Y
        end
        
        -- Ensure at least header is visible (28px from top)
        if newY < 0 then
            newY = 0
        end
        
        -- Animate resize and reposition
        self.Utils.Tween(self.Container, {
            Size = UDim2.fromOffset(newSize.X, newSize.Y),
            Position = UDim2.fromOffset(newX, newY)
        }, 0.3)
    end
    
    -- Listen to viewport size changes
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        updateWindowSize()
    end)
    
    -- Run initial scaling and centering
    task.spawn(function()
        task.wait(0.1)
        local viewportSize = Camera.ViewportSize
        local windowSize = self.Container.AbsoluteSize
        
        -- For mobile (< 1024px), always scale to 50% of viewport
        -- For PC, only scale if window is too big
        if viewportSize.X < 1024 then
            -- Mobile: always scale
            updateWindowSize()
        elseif windowSize.X > viewportSize.X - 80 or windowSize.Y > viewportSize.Y - 80 then
            -- PC: scale if too big
            updateWindowSize()
        else
            -- PC: just center
            local centerX = (viewportSize.X - windowSize.X) / 2
            local centerY = (viewportSize.Y - windowSize.Y) / 2
            self.Container.Position = UDim2.fromOffset(centerX, centerY)
        end
    end)
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
        local success, err = pcall(contentFunc, self)
        if not success then
            warn("[EnowLib] Content function error:", err)
        end
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

function Window:AddMultiSelect(config)
    return MultiSelect.new(config, self.ContentArea, self.Theme, self.Utils)
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
