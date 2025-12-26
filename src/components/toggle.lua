-- VaporUI Toggle Component

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
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
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
        desc.Size = UDim2.new(1, -60, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Toggle switch background
    self.Switch = Instance.new("Frame")
    self.Switch.Name = "Switch"
    self.Switch.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Switch.BorderSizePixel = 0
    self.Switch.Size = UDim2.fromOffset(40, 20)
    self.Switch.Position = UDim2.new(1, -48, 0.5, 0)
    self.Switch.AnchorPoint = Vector2.new(0, 0.5)
    self.Switch.Parent = self.Container
    
    self.Theme.CreateCorner(self.Switch, 10)
    self.Theme.CreateStroke(self.Switch, self.Theme.Colors.Border)
    
    -- Toggle knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.BackgroundColor3 = self.Theme.Colors.TextDim
    self.Knob.BorderSizePixel = 0
    self.Knob.Size = UDim2.fromOffset(16, 16)
    self.Knob.Position = UDim2.fromOffset(2, 2)
    self.Knob.Parent = self.Switch
    
    self.Theme.CreateCorner(self.Knob, 8)
    
    -- Click button
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = self.Container
    
    button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Hover
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.BackgroundLight
        }, 0.15)
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
        -- On state
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.Primary
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(22, 2),
            BackgroundColor3 = self.Theme.Colors.Text
        }, 0.2)
        
        local stroke = self.Switch:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary
            }, 0.2)
        end
    else
        -- Off state
        self.Utils.Tween(self.Switch, {
            BackgroundColor3 = self.Theme.Colors.BackgroundDark
        }, 0.2)
        
        self.Utils.Tween(self.Knob, {
            Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = self.Theme.Colors.TextDim
        }, 0.2)
        
        local stroke = self.Switch:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border
            }, 0.2)
        end
    end
end

return Toggle
