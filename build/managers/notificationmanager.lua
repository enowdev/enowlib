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
    
    local success = pcall(function()
        -- Load notification component
        local NotificationComponent = require(script.Parent.Parent.components.notification)
        
        -- Create notification
        local notification = NotificationComponent.new(
            config,
            self.Container,
            self.Window.Theme,
            self.Window.Utils
        )
        
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
        warn("[NotificationManager] Failed to create notification")
    end
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
