-- EnowLib Divider Component

local Divider = {}
Divider.__index = Divider

function Divider.new(config, parent, theme, utils)
    local self = setmetatable({}, Divider)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Divider:CreateUI()
    if self.Config.Text then
        -- Divider with text
        self.Container = Instance.new("Frame")
        self.Container.BackgroundTransparency = 1
        self.Container.Size = UDim2.new(1, 0, 0, 30)
        self.Container.Parent = self.Parent.Container or self.Parent
        
        local leftLine = Instance.new("Frame")
        leftLine.BackgroundColor3 = self.Theme.Colors.Border
        leftLine.BorderSizePixel = 0
        leftLine.Size = UDim2.new(0.5, -40, 0, 1)
        leftLine.Position = UDim2.new(0, 0, 0.5, 0)
        leftLine.Parent = self.Container
        
        local text = Instance.new("TextLabel")
        text.BackgroundTransparency = 1
        text.Size = UDim2.fromOffset(70, 30)
        text.Position = UDim2.new(0.5, -35, 0, 0)
        text.Font = self.Theme.Font.Bold
        text.Text = self.Config.Text
        text.TextColor3 = self.Theme.Colors.TextDim
        text.TextSize = self.Theme.Font.Size.Small
        text.Parent = self.Container
        
        local rightLine = Instance.new("Frame")
        rightLine.BackgroundColor3 = self.Theme.Colors.Border
        rightLine.BorderSizePixel = 0
        rightLine.Size = UDim2.new(0.5, -40, 0, 1)
        rightLine.Position = UDim2.new(0.5, 40, 0.5, 0)
        rightLine.Parent = self.Container
    else
        -- Simple line
        self.Container = Instance.new("Frame")
        self.Container.BackgroundColor3 = self.Theme.Colors.Border
        self.Container.BorderSizePixel = 0
        self.Container.Size = UDim2.new(1, 0, 0, 1)
        self.Container.Parent = self.Parent.Container or self.Parent
    end
end

return Divider
