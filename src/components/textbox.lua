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
    self.Container.Size = UDim2.new(1, 0, 0, 65)  -- 86 * 0.75 = 64.5 ≈ 65
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 15)  -- 20 * 0.75 = 15
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 15)  -- 20 * 0.75 = 15
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    local titleSizeConstraint = Instance.new("UITextSizeConstraint")
    titleSizeConstraint.MaxTextSize = self.Theme.Font.Size.Regular
    titleSizeConstraint.Parent = title
    
    -- Input Box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.BackgroundColor3 = self.Theme.Colors.Secondary
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Size = UDim2.new(1, 0, 0, 24)  -- 32 * 0.75 = 24
    self.InputBox.Position = UDim2.fromOffset(0, 20)  -- 26 * 0.75 = 19.5 ≈ 20
    self.InputBox.Font = self.Theme.Font.Mono
    self.InputBox.Text = self.Value
    self.InputBox.PlaceholderText = self.Config.Placeholder
    self.InputBox.TextColor3 = self.Theme.Colors.Text
    self.InputBox.PlaceholderColor3 = self.Theme.Colors.TextDim
    self.InputBox.TextScaled = true
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.Parent = self.Container
    
    self.Theme.CreateCorner(self.InputBox, 4)
    self.Theme.CreatePadding(self.InputBox, 8)
    
    local inputBoxSizeConstraint = Instance.new("UITextSizeConstraint")
    inputBoxSizeConstraint.MaxTextSize = self.Theme.Font.Size.Regular
    inputBoxSizeConstraint.Parent = self.InputBox
    
    -- Events
    self.InputBox.FocusLost:Connect(function(enterPressed)
        self.Value = self.InputBox.Text
        pcall(self.Config.Callback, self.Value)
    end)
end

return TextBox
