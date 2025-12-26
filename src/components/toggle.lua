-- EnowLib Toggle Component

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config, tab, theme, utils)
    local self = setmetatable({}, Toggle)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Toggle",
        Description = nil,
        Default = false,
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    self:UpdateVisual()
    
    return self
end

function Toggle:CreateUI()
    -- Container (Radix UI style)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 60 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border, 1)
    self.Theme.CreateCorner(self.Container, 6)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 18)
    title.Position = UDim2.fromOffset(0, self.Config.Description and 4 or 11)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -60, 0, 14)
        desc.Position = UDim2.fromOffset(0, 24)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextSecondary
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Radix UI Switch (rounded pill)
    self.Switch = Instance.new("Frame")
    self.Switch.Name = "Switch"
    self.Switch.BackgroundColor3 = self.Theme.Colors.SecondaryDark
    self.Switch.BorderSizePixel = 0
    self.Switch.Size = UDim2.fromOffset(44, 24)
    self.Switch.Position = UDim2.new(1, 0, 0.5, 0)
    self.Switch.AnchorPoint = Vector2.new(1, 0.5)
    self.Switch.Parent = self.Container
    
    self.Theme.CreateCorner(self.Switch, 12)
    
    -- Toggle knob (circle)
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.BackgroundColor3 = self.Theme.Colors.Panel
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(20, 20)
    self.Knob.Position = UDim2.fromOffset(2, 2)
    self.Knob.Parent = self.Switch
    
    self.Theme.CreateCorner(self.Knob, 10)
    
    -- Click button
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.BackgroundTransparency = 1
    button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects (Radix UI subtle)
    button.MouseEnter:Connect(function()
        if not self.Value then
            self.Utils.Tween(self.Switch, {
                BackgroundColor3 = self.Theme.Colors.Secondary
            }, 0.15)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not self.Value then
            self.Utils.Tween(self.Switch, {
                BackgroundColor3 = self.Theme.Colors.SecondaryDark
            }, 0.15)
        end
    end)
end

function Toggle:Toggle()
    self.Value = not self.Value
    self:UpdateVisual()
    pcall(self.Config.Callback, self.Value)
end

function Toggle:SetValue(value)
    self.Value = value
    self:UpdateVisual()
end

function Toggle:UpdateVisual()
    if self.Value then
        -- On state (Radix UI accent color)
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(22, 2),
            BackgroundColor3 = self.Theme.Colors.Panel
        }, 0.2)
            }, 0.15)
        end
    else
        -- Off state
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
    else
        -- Off state (Radix UI neutral)
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.SecondaryDark
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = self.Theme.Colors.Panel
        }, 0.2)
    end
end

return Toggle
