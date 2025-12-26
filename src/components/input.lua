-- VaporUI Input Component

local Input = {}
Input.__index = Input

function Input.new(config, tab, theme, utils)
    local self = setmetatable({}, Input)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Input",
        Description = nil,
        Placeholder = "Enter text...",
        Default = "",
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    
    self:CreateUI()
    
    return self
end

function Input:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Input"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 72 or 56)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Position = UDim2.fromOffset(12, 8)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Description
    if self.Config.Description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, -24, 0, 14)
        desc.Position = UDim2.fromOffset(12, 26)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Input box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "InputBox"
    self.InputBox.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Size = UDim2.new(1, -24, 0, 28)
    self.InputBox.Position = UDim2.fromOffset(12, self.Config.Description and 40 or 24)
    self.InputBox.Font = self.Theme.Font.Regular
    self.InputBox.PlaceholderText = self.Config.Placeholder
    self.InputBox.PlaceholderColor3 = self.Theme.Colors.TextDim
    self.InputBox.Text = self.Value
    self.InputBox.TextColor3 = self.Theme.Colors.Text
    self.InputBox.TextSize = self.Theme.Font.Size.Regular
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.Parent = self.Container
    
    self.Theme.CreateCorner(self.InputBox, 4)
    self.Theme.CreateStroke(self.InputBox, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.InputBox, {8, 8, 0, 0})
    
    -- Focus effects
    self.InputBox.Focused:Connect(function()
        local stroke = self.InputBox:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary,
                Thickness = 2
            }, 0.15)
        end
    end)
    
    self.InputBox.FocusLost:Connect(function(enterPressed)
        local stroke = self.InputBox:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border,
                Thickness = 1
            }, 0.15)
        end
        
        if enterPressed then
            self.Value = self.InputBox.Text
            pcall(self.Config.Callback, self.Value)
        end
    end)
end

function Input:SetValue(value)
    self.Value = value
    self.InputBox.Text = value
end

function Input:GetValue()
    return self.InputBox.Text
end

return Input
