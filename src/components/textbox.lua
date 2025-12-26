-- EnowLib TextBox Component

local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(config, parent, theme, utils)
    local self = setmetatable({}, TextBox)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "TextBox",
        Placeholder = "Enter text...",
        Default = "",
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    
    return self
end

function TextBox:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 70)
    self.Container.Parent = self.Parent.Container or self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Input Box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.BackgroundColor3 = self.Theme.Colors.Secondary
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Size = UDim2.new(1, 0, 0, 32)
    self.InputBox.Position = UDim2.fromOffset(0, 26)
    self.InputBox.Font = self.Theme.Font.Mono
    self.InputBox.Text = self.Value
    self.InputBox.PlaceholderText = self.Config.Placeholder
    self.InputBox.TextColor3 = self.Theme.Colors.Text
    self.InputBox.PlaceholderColor3 = self.Theme.Colors.TextDim
    self.InputBox.TextSize = self.Theme.Font.Size.Regular
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.Parent = self.Container
    
    self.Theme.CreateCorner(self.InputBox, 6)
    self.Theme.CreatePadding(self.InputBox, 10)
    
    -- Events
    self.InputBox.FocusLost:Connect(function(enterPressed)
        self.Value = self.InputBox.Text
        pcall(self.Config.Callback, self.Value)
    end)
end

return TextBox
