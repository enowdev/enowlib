-- EnowLib Button Component

local Button = {}
Button.__index = Button

function Button.new(config, tab, theme, utils)
    local self = setmetatable({}, Button)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Button",
        Description = nil,
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Button:CreateUI()
    -- Container (Radix UI button style)
    self.Container = Instance.new("TextButton")
    self.Container.Name = "Button"
    self.Container.BackgroundColor3 = self.Theme.Colors.Accent
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Theme.Size.ComponentHeight)
    self.Container.Font = self.Theme.Font.Regular
    self.Container.Text = self.Config.Title
    self.Container.TextColor3 = self.Theme.Colors.TextWhite
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.AutoButtonColor = false
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container, 6)
    
    -- Click handler
    self.Container.MouseButton1Click:Connect(function()
        pcall(self.Config.Callback)
    end)
    
    -- Hover effects (Radix UI subtle)
    self.Container.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.AccentHover
        }, 0.15)
    end)
    
    self.Container.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Accent
        }, 0.15)
    end)
end

function Button:SetTitle(title)
    self.Config.Title = title
    self.Container.Text = title
end

function Button:SetCallback(callback)
    self.Config.Callback = callback
end

return Button
