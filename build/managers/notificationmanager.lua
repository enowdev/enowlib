-- EnowLib NotificationManager v2.0
-- Modern notification system with queue management

local NotificationManager = {}

-- Cache services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings
NotificationManager.Settings = {
    Enabled = true,
    MaxNotifications = 5,
    DefaultDuration = 3,
    Spacing = 10
}

function NotificationManager:Initialize(window)
    self.Window = window
    self.Initialized = true
    self.Notifications = {}
    
    -- Create notification container
    self:CreateContainer()
    
    return self
end

function NotificationManager:CreateContainer()
    local success = pcall(function()
        self.Container = Instance.new("ScreenGui")
        self.Container.Name = "EnowLibNotifications"
        self.Container.ResetOnSpawn = false
        self.Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.Container.DisplayOrder = 100
        self.Container.Parent = PlayerGui
    end)
    
    if not success then
        warn("[NotificationManager] Failed to create container")
    end
end

function NotificationManager:Notify(config)
    if not self.Settings.Enabled or not self.Initialized then
        return
    end
    
    local success, err = pcall(function()
        -- Create notification inline (since we can't require external component)
        local notification = self:CreateNotification(config)
        
        if not notification then
            warn("[NotificationManager] CreateNotification returned nil")
            return
        end
        
        -- Add to queue
        table.insert(self.Notifications, notification)
        
        -- Remove old notifications if exceeds max
        while #self.Notifications > self.Settings.MaxNotifications do
            local oldest = table.remove(self.Notifications, 1)
            if oldest then
                oldest:Dismiss()
            end
        end
        
        -- Update positions
        self:UpdatePositions()
    end)
    
    if not success then
        warn("[NotificationManager] Failed to create notification:", err)
    end
end

function NotificationManager:CreateNotification(config)
    -- Validate window and theme
    if not self.Window or not self.Window.Theme or not self.Window.Utils then
        warn("[NotificationManager] Window, Theme, or Utils not initialized")
        return nil
    end
    
    local notification = {
        Config = {
            Title = config.Title or "Notification",
            Message = config.Message or "",
            Type = config.Type or "info",
            Duration = config.Duration or self.Settings.DefaultDuration,
            Icon = config.Icon
        },
        Dismissing = false
    }
    
    -- Get type color
    local function getTypeColor()
        if notification.Config.Type == "success" then
            return self.Window.Theme.Colors.Success
        elseif notification.Config.Type == "warning" then
            return self.Window.Theme.Colors.Warning
        elseif notification.Config.Type == "error" then
            return self.Window.Theme.Colors.Error
        else
            return self.Window.Theme.Colors.Accent
        end
    end
    
    -- Create UI
    notification.Container = Instance.new("Frame")
    notification.Container.Name = "Notification"
    notification.Container.Size = UDim2.new(0, 300, 0, 0)
    notification.Container.Position = UDim2.new(1, -320, 1, 20)
    notification.Container.BackgroundColor3 = self.Window.Theme.Colors.Panel
    notification.Container.BorderSizePixel = 0
    notification.Container.ClipsDescendants = true
    notification.Container.Parent = self.Container
    
    self.Window.Theme.CreateCorner(notification.Container, 8)
    self.Window.Theme.CreateStroke(notification.Container, getTypeColor())
    
    -- Icon
    if notification.Config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 12, 0, 12)
        icon.BackgroundTransparency = 1
        icon.Image = notification.Config.Icon
        icon.ImageColor3 = getTypeColor()
        icon.Parent = notification.Container
    end
    
    -- Content container
    local contentX = notification.Config.Icon and 44 or 12
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -(contentX + 12), 0, 16)
    title.Position = UDim2.new(0, contentX, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = notification.Config.Title
    title.TextColor3 = self.Window.Theme.Colors.Text
    title.TextSize = self.Window.Theme.TextSize.Regular or 14
    title.Font = self.Window.Theme.Font.Bold or Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Parent = notification.Container
    
    -- Message
    if notification.Config.Message ~= "" then
        local message = Instance.new("TextLabel")
        message.Name = "Message"
        message.Size = UDim2.new(1, -(contentX + 12), 0, 16)
        message.Position = UDim2.new(0, contentX, 0, 28)
        message.BackgroundTransparency = 1
        message.Text = notification.Config.Message
        message.TextColor3 = self.Window.Theme.Colors.TextDim
        message.TextSize = self.Window.Theme.TextSize.Small or 12
        message.Font = self.Window.Theme.Font.Regular or Enum.Font.Gotham
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.TextYAlignment = Enum.TextYAlignment.Top
        message.TextWrapped = true
        message.Parent = notification.Container
        
        -- Calculate height based on message
        local textBounds = self.Window.Utils.GetTextBounds(
            notification.Config.Message,
            self.Window.Theme.TextSize.Small or 12,
            self.Window.Theme.Font.Regular or Enum.Font.Gotham,
            Vector2.new(300 - contentX - 12, 1000)
        )
        
        message.Size = UDim2.new(1, -(contentX + 12), 0, textBounds.Y)
        notification.Height = math.max(52, 28 + textBounds.Y + 12)
    else
        notification.Height = 44
    end
    
    notification.Container.Size = UDim2.new(0, 300, 0, notification.Height)
    
    -- Animate in
    notification.Container.Position = UDim2.new(1, 20, 1, 20)
    
    self.Window.Utils.Tween(notification.Container, {
        Position = UDim2.new(1, -320, 1, 20)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Auto dismiss
    if notification.Config.Duration > 0 then
        task.delay(notification.Config.Duration, function()
            notification:Dismiss()
        end)
    end
    
    -- Dismiss method
    function notification:Dismiss()
        if self.Dismissing then return end
        self.Dismissing = true
        
        -- Slide out to right
        self.Window.Utils.Tween(self.Container, {
            Position = UDim2.new(1, 20, self.Container.Position.Y.Scale, self.Container.Position.Y.Offset)
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            self:Destroy()
        end)
    end
    
    -- Update position method
    function notification:UpdatePosition(yOffset)
        self.Window.Utils.Tween(self.Container, {
            Position = UDim2.new(1, -320, 1, yOffset)
        }, 0.3)
    end
    
    -- Destroy method
    function notification:Destroy()
        if self.Container then
            self.Container:Destroy()
        end
    end
    
    -- Store window reference
    notification.Window = self.Window
    
    return notification
end

function NotificationManager:UpdatePositions()
    local success = pcall(function()
        local yOffset = -20
        
        -- Update from bottom to top
        for i = #self.Notifications, 1, -1 do
            local notification = self.Notifications[i]
            
            if notification and notification.Container then
                yOffset = yOffset - notification.Height - self.Settings.Spacing
                notification:UpdatePosition(yOffset)
            end
        end
    end)
    
    if not success then
        warn("[NotificationManager] Failed to update positions")
    end
end

function NotificationManager:Success(title, message, duration)
    self:Notify({
        Title = title,
        Message = message or "",
        Type = "success",
        Duration = duration or self.Settings.DefaultDuration,
        Icon = "rbxassetid://10734950309" -- check-circle
    })
end

function NotificationManager:Error(title, message, duration)
    self:Notify({
        Title = title,
        Message = message or "",
        Type = "error",
        Duration = duration or self.Settings.DefaultDuration,
        Icon = "rbxassetid://10734949856" -- x-circle
    })
end

function NotificationManager:Warning(title, message, duration)
    self:Notify({
        Title = title,
        Message = message or "",
        Type = "warning",
        Duration = duration or self.Settings.DefaultDuration,
        Icon = "rbxassetid://10734923549" -- alert-triangle
    })
end

function NotificationManager:Info(title, message, duration)
    self:Notify({
        Title = title,
        Message = message or "",
        Type = "info",
        Duration = duration or self.Settings.DefaultDuration,
        Icon = "rbxassetid://10734950309" -- info
    })
end

function NotificationManager:SetEnabled(enabled)
    self.Settings.Enabled = enabled
end

function NotificationManager:IsEnabled()
    return self.Settings.Enabled
end

function NotificationManager:ClearAll()
    local success = pcall(function()
        for _, notification in ipairs(self.Notifications) do
            if notification then
                notification:Dismiss()
            end
        end
        
        self.Notifications = {}
    end)
    
    if not success then
        warn("[NotificationManager] Failed to clear notifications")
    end
end

function NotificationManager:Destroy()
    self:ClearAll()
    
    if self.Container then
        self.Container:Destroy()
    end
    
    self.Window = nil
    self.Initialized = false
end

return NotificationManager
