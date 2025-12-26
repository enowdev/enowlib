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
    self.Container.Size = UDim2.new(1, 0, 0, 36)
    self.Container.Parent = self.Tab.Container
    
    -- Section header with background
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, 32)
    header.Position = UDim2.fromOffset(0, 2)
    header.Parent = self.Container
    
    self.Theme.CreateCorner(header, 4)
    self.Theme.CreateStroke(header, self.Theme.Colors.Border, self.Theme.Size.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -28, 1, 0)
    title.Position = UDim2.fromOffset(14, 0)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Primary
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
end

return Section
