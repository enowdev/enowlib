-- EnowLib Label Component

local Label = {}
Label.__index = Label

function Label.new(config, tab, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label",
        Size = "Regular",
        Color = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Label"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 30)
    self.Container.Parent = self.Tab.Container
    
    -- Label text
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Text"
    self.Label.BackgroundTransparency = 1
    self.Label.Size = UDim2.new(1, -24, 1, 0)
    self.Label.Position = UDim2.fromOffset(12, 0)
    self.Label.Font = self.Theme.Font.Regular
    self.Label.Text = self.Config.Text
    self.Label.TextColor3 = self.Config.Color or self.Theme.Colors.TextDim
    self.Label.TextSize = self:GetFontSize()
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.TextYAlignment = Enum.TextYAlignment.Center
    self.Label.TextWrapped = true
    self.Label.Parent = self.Container
    
    -- Auto-resize based on text
    self.Label:GetPropertyChangedSignal("TextBounds"):Connect(function()
        local textHeight = self.Label.TextBounds.Y
        self.Container.Size = UDim2.new(1, 0, 0, math.max(30, textHeight + 10))
    end)
end

function Label:GetFontSize()
    local sizes = {
        Small = self.Theme.Font.Size.Small,
        Regular = self.Theme.Font.Size.Regular,
        Medium = self.Theme.Font.Size.Medium,
        Large = self.Theme.Font.Size.Large,
        Title = self.Theme.Font.Size.Title
    }
    
    return sizes[self.Config.Size] or self.Theme.Font.Size.Regular
end

function Label:SetText(text)
    self.Config.Text = text
    self.Label.Text = text
end

function Label:SetColor(color)
    self.Config.Color = color
    self.Label.TextColor3 = color
end

return Label
