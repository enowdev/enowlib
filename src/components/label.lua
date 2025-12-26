-- EnowLib Label Component

local Label = {}
Label.__index = Label

function Label.new(config, tab, theme, utils)
    local self = setmetatable({}, Label)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Text = "Label"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Label:CreateUI()
    self.Container = Instance.new("TextLabel")
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 0, 24)
    self.Container.Font = self.Theme.Font.Regular
    self.Container.Text = self.Config.Text
    self.Container.TextColor3 = self.Theme.Colors.TextDim
    self.Container.TextSize = self.Theme.Font.Size.Regular
    self.Container.TextXAlignment = Enum.TextXAlignment.Left
    self.Container.Parent = self.Tab.Container
end

return Label
