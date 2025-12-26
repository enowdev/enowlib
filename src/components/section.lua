-- EnowLib Section Component

local Section = {}
Section.__index = Section

function Section.new(config, tab, theme, utils)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Section"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Section:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Section"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 30)
    self.Container.Parent = self.Tab.Container
    
    -- Left line
    local leftLine = Instance.new("Frame")
    leftLine.Name = "LeftLine"
    leftLine.BackgroundColor3 = self.Theme.Colors.Border
    leftLine.BorderSizePixel = 0
    leftLine.Size = UDim2.new(0.3, -40, 0, 1)
    leftLine.Position = UDim2.fromOffset(0, 15)
    leftLine.Parent = self.Container
    
    self.Theme.CreateGradient(leftLine, 90)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.fromOffset(0, 30)
    title.Position = UDim2.new(0.5, 0, 0, 0)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Primary
    title.TextSize = self.Theme.Font.Size.Small
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = self.Container
    
    -- Auto-size title
    title.Size = UDim2.fromOffset(title.TextBounds.X + 20, 30)
    
    -- Right line
    local rightLine = Instance.new("Frame")
    rightLine.Name = "RightLine"
    rightLine.BackgroundColor3 = self.Theme.Colors.Border
    rightLine.BorderSizePixel = 0
    rightLine.Size = UDim2.new(0.3, -40, 0, 1)
    rightLine.Position = UDim2.new(1, 0, 0, 15)
    rightLine.AnchorPoint = Vector2.new(1, 0)
    rightLine.Parent = self.Container
    
    self.Theme.CreateGradient(rightLine, 90)
end

return Section
