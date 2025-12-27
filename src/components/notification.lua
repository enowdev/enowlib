-- EnowLib Notification Component
-- Toast notification with auto-dismiss

local Notification = {}
Notification.__index = Notification

function Notification.new(config, parent, theme, utils)
    local self = setmetatable({}, Notification)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Notification",
        Message = "",
        Type = "info", -- info, success, warning, error
        Duration = 3,
        Icon = nil
    }, config or {})
    
    self:CreateUI()
    self:Animate()
    
    return self
end

function Notification:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Notification"
    self.Container.Size = UDim2.new(0, 300, 0, 0)
    self.Container.Position = UDim2.new(1, -320, 1, 20)
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BorderSizePixel = 0
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container, 8)
    self.Theme.CreateStroke(self.Container, self:GetTypeColor())
    
    -- Icon
    if self.Config.Icon then
        self.Icon = Instance.new("ImageLabel")
        self.Icon.Name = "Icon"
        self.Icon.Size = UDim2.new(0, 20, 0, 20)
        self.Icon.Position = UDim2.new(0, 12, 0, 12)
        self.Icon.BackgroundTransparency = 1
        self.Icon.Image = self.Config.Icon
        self.Icon.ImageColor3 = self:GetTypeColor()
        self.Icon.Parent = self.Container
    end
    
    -- Content container
    local contentX = self.Config.Icon and 44 or 12
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -(contentX + 12), 0, 16)
    self.Title.Position = UDim2.new(0, contentX, 0, 10)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.Text
    self.Title.TextSize = self.Theme.TextSize.Regular
    self.Title.Font = self.Theme.Font.Bold
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.TextYAlignment = Enum.TextYAlignment.Top
    self.Title.Parent = self.Container
    
    -- Message
    if self.Config.Message ~= "" then
        self.Message = Instance.new("TextLabel")
        self.Message.Name = "Message"
        self.Message.Size = UDim2.new(1, -(contentX + 12), 0, 16)
        self.Message.Position = UDim2.new(0, contentX, 0, 28)
        self.Message.BackgroundTransparency = 1
        self.Message.Text = self.Config.Message
        self.Message.TextColor3 = self.Theme.Colors.TextDim
        self.Message.TextSize = self.Theme.TextSize.Small
        self.Message.Font = self.Theme.Font.Regular
        self.Message.TextXAlignment = Enum.TextXAlignment.Left
        self.Message.TextYAlignment = Enum.TextYAlignment.Top
        self.Message.TextWrapped = true
        self.Message.Parent = self.Container
        
        -- Calculate height based on message
        local textBounds = self.Utils.GetTextBounds(
            self.Config.Message,
            self.Theme.TextSize.Small,
            self.Theme.Font.Regular,
            Vector2.new(300 - contentX - 12, 1000)
        )
        
        self.Message.Size = UDim2.new(1, -(contentX + 12), 0, textBounds.Y)
        self.Height = math.max(52, 28 + textBounds.Y + 12)
    else
        self.Height = 44
    end
    
    self.Container.Size = UDim2.new(0, 300, 0, self.Height)
end

function Notification:GetTypeColor()
    if self.Config.Type == "success" then
        return self.Theme.Colors.Success
    elseif self.Config.Type == "warning" then
        return self.Theme.Colors.Warning
    elseif self.Config.Type == "error" then
        return self.Theme.Colors.Error
    else
        return self.Theme.Colors.Accent
    end
end

function Notification:Animate()
    -- Slide in from right
    self.Container.Position = UDim2.new(1, 20, 1, 20)
    
    self.Utils.Tween(self.Container, {
        Position = UDim2.new(1, -320, 1, 20)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Auto dismiss
    if self.Config.Duration > 0 then
        task.delay(self.Config.Duration, function()
            self:Dismiss()
        end)
    end
end

function Notification:Dismiss()
    if self.Dismissing then return end
    self.Dismissing = true
    
    -- Slide out to right
    self.Utils.Tween(self.Container, {
        Position = UDim2.new(1, 20, self.Container.Position.Y.Scale, self.Container.Position.Y.Offset)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
        self:Destroy()
    end)
end

function Notification:UpdatePosition(yOffset)
    self.Utils.Tween(self.Container, {
        Position = UDim2.new(1, -320, 1, yOffset)
    }, 0.3)
end

function Notification:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Notification
