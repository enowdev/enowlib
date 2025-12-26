-- EnowLib Paragraph Component

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(config, parent, theme, utils)
    local self = setmetatable({}, Paragraph)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Title",
        Content = "Paragraph text here..."
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Paragraph:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.Parent = self.Parent
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Content
    local content = Instance.new("TextLabel")
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.fromOffset(0, 24)
    content.Font = self.Theme.Font.Mono
    content.Text = self.Config.Content
    content.TextColor3 = self.Theme.Colors.TextDim
    content.TextSize = self.Theme.Font.Size.Regular
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = self.Container
    
    -- Auto-size based on text
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 4)
    self.Container.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 28)
    
    content:GetPropertyChangedSignal("TextBounds"):Connect(function()
        content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 4)
        self.Container.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 28)
    end)
end

return Paragraph
