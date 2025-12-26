-- EnowLib Notification System

local Notification = {}
Notification.Queue = {}
Notification.Active = {}
Notification.Container = nil

function Notification.Initialize(theme, utils)
    if Notification.Container then return end
    
    Notification.Theme = theme
    Notification.Utils = utils
    
    -- Create notification container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EnowLib_Notifications"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    Notification.Container = Instance.new("Frame")
    Notification.Container.Name = "NotificationContainer"
    Notification.Container.BackgroundTransparency = 1
    Notification.Container.Size = UDim2.new(0, 300, 1, -20)
    Notification.Container.Position = UDim2.new(1, -310, 0, 10)
    Notification.Container.Parent = screenGui
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = Notification.Container
end

function Notification.Show(config)
    if not Notification.Container then
        Notification.Initialize(config.Theme, config.Utils)
    end
    
    config = Notification.Utils.Merge({
        Title = "Notification",
        Content = "",
        Duration = 3,
        Type = "Info"
    }, config or {})
    
    local notif = Notification.Create(config)
    table.insert(Notification.Active, notif)
    
    -- Auto dismiss
    task.delay(config.Duration, function()
        Notification.Dismiss(notif)
    end)
    
    return notif
end

function Notification.Create(config)
    local notif = {}
    
    -- Container
    notif.Container = Instance.new("Frame")
    notif.Container.Name = "Notification"
    notif.Container.BackgroundColor3 = Notification.Theme.Colors.BackgroundLight
    notif.Container.BorderSizePixel = 0
    notif.Container.Size = UDim2.new(1, 0, 0, 0)
    notif.Container.Parent = Notification.Container
    
    Notification.Theme.CreateCorner(notif.Container)
    Notification.Theme.CreateStroke(notif.Container, Notification.GetTypeColor(config.Type), 2)
    
    -- Accent bar
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.BackgroundColor3 = Notification.GetTypeColor(config.Type)
    accent.BorderSizePixel = 0
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.Parent = notif.Container
    
    Notification.Theme.CreateGradient(accent, 90)
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, -16, 1, 0)
    content.Position = UDim2.fromOffset(12, 0)
    content.Parent = notif.Container
    
    Notification.Theme.CreatePadding(content, 8)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 18)
    title.Position = UDim2.fromOffset(0, 0)
    title.Font = Notification.Theme.Font.Bold
    title.Text = config.Title
    title.TextColor3 = Notification.Theme.Colors.Text
    title.TextSize = Notification.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Parent = content
    
    -- Content text
    local contentText = Instance.new("TextLabel")
    contentText.Name = "ContentText"
    contentText.BackgroundTransparency = 1
    contentText.Size = UDim2.new(1, -24, 1, -22)
    contentText.Position = UDim2.fromOffset(0, 20)
    contentText.Font = Notification.Theme.Font.Regular
    contentText.Text = config.Content
    contentText.TextColor3 = Notification.Theme.Colors.TextDim
    contentText.TextSize = Notification.Theme.Font.Size.Small
    contentText.TextXAlignment = Enum.TextXAlignment.Left
    contentText.TextYAlignment = Enum.TextYAlignment.Top
    contentText.TextWrapped = true
    contentText.Parent = content
    
    -- Calculate height
    local textHeight = contentText.TextBounds.Y
    local totalHeight = math.max(60, textHeight + 40)
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -20, 0, 4)
    closeBtn.Font = Notification.Theme.Font.Bold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Notification.Theme.Colors.TextDim
    closeBtn.TextSize = 18
    closeBtn.Parent = content
    
    closeBtn.MouseButton1Click:Connect(function()
        Notification.Dismiss(notif)
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Notification.Utils.Tween(closeBtn, {
            TextColor3 = Notification.Theme.Colors.Text
        }, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Notification.Utils.Tween(closeBtn, {
            TextColor3 = Notification.Theme.Colors.TextDim
        }, 0.15)
    end)
    
    -- Animate in
    notif.Container.Size = UDim2.new(1, 0, 0, 0)
    Notification.Utils.Tween(notif.Container, {
        Size = UDim2.new(1, 0, 0, totalHeight)
    }, 0.3, Enum.EasingStyle.Back)
    
    return notif
end

function Notification.Dismiss(notif)
    Notification.Utils.Tween(notif.Container, {
        Size = UDim2.new(1, 0, 0, 0)
    }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
        notif.Container:Destroy()
        
        for i, n in ipairs(Notification.Active) do
            if n == notif then
                table.remove(Notification.Active, i)
                break
            end
        end
    end)
end

function Notification.GetTypeColor(type)
    local colors = {
        Info = Notification.Theme.Colors.Primary,
        Success = Notification.Theme.Colors.Success,
        Warning = Notification.Theme.Colors.Warning,
        Error = Notification.Theme.Colors.Error
    }
    
    return colors[type] or Notification.Theme.Colors.Primary
end

return Notification
