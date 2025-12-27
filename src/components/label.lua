-- EnowLib Label Component

local Label = {}
Label.__index = Label

function Label.new(config, parent, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label",
        Size = nil,
        Color = nil,
        Font = nil
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    self.Container = Instance.new("TextLabel")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Size and 30 or 24)
    self.Container.Font = self.Config.Font or self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = self.Config.Color or self.Theme.Colors.TextDim
    self.Container.TextSize = self.Config.Size or self.Theme.Font.Size.Regular
    self.Container.TextXAlignment = Enum.TextXAlignment.Left
    self.Container.Parent = self.Parent
end

return Label
