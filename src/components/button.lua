-- EnowLib Button Component

local Button = {}
Button.__index = Button

function Button.new(config, parent, theme, utils)
    local self = setmetatable({}, Button)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Button",
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Button:CreateUI()
    self.Container = Instance.new("TextButton")
    self.Container.BackgroundColor3 = self.Theme.Colors.Accent
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 27)  -- 36 * 0.75 = 27
    self.Container.Font = self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = Color3.fromRGB(0, 0, 0)
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.AutoButtonColor = false
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container, 4)
    self.Theme.CreatePadding(self.Container, 6)
    self.Theme.CreateCorner(self.Container)
    
    self.Container.MouseButton1Click:Connect(function()
        pcall(self.Config.Callback)
    end)
    
    self.Container.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.AccentHover
        }, self.Theme.Animation.Duration)
    end)
    
    self.Container.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, self.Theme.Animation.Duration)
    end)
end

return Button
