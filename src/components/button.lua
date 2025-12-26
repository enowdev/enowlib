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
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button"
    self.Container.BackgroundColor3 = self.Theme.Colors.Primary
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 64 or 44)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.BorderAccent, self.Theme.Size.BorderThick)
    
    -- Button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "ButtonClick"
    self.Button.BackgroundTransparency = 1
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.Font = self.Theme.Font.Bold
    self.Button.Text = ""
    self.Button.TextColor3 = self.Theme.Colors.Background
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -28, 0, 22)
    title.Position = UDim2.fromOffset(14, self.Config.Description and 10 or 11)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Background
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -28, 0, 18)
        desc.Position = UDim2.fromOffset(14, 32)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.BackgroundLight
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Click handler
    self.Button.MouseButton1Click:Connect(function()
        self.Utils.CreateRipple(self.Container, 
            Vector2.new(self.Button.AbsoluteSize.X / 2, self.Button.AbsoluteSize.Y / 2))
        
        pcall(self.Config.Callback)
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.PrimaryLight
        }, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Container, {
            BackgroundColor3 = self.Theme.Colors.Primary
        }, 0.15)
    end)
end

function Button:SetTitle(title)
    self.Config.Title = title
    self.Container.Title.Text = title
end

function Button:SetCallback(callback)
    self.Config.Callback = callback
end

return Button
