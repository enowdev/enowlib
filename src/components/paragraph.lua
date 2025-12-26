-- EnowLib Paragraph Component

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(config, parent, theme, utils)
    local self = setmetatable({}, Paragraph)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Paragraph text here..."
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Paragraph:CreateUI()
    self.Container = Instance.new("TextLabel")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.Font = self.Theme.Font.Mono
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = self.Theme.Colors.TextDim
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.TextXAlignment = Enum.TextXAlignment.Left
    self.Container.TextYAlignment = Enum.TextYAlignment.Top
    self.Container.TextWrapped = true
    self.Container.Parent = self.Parent.Container or self.Parent
    
    -- Auto-size based on text
    self.Container.Size = UDim2.new(1, 0, 0, self.Container.TextBounds.Y + 4)
    
    self.Container:GetPropertyChangedSignal("TextBounds"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, self.Container.TextBounds.Y + 4)
    end)
end

return Paragraph
