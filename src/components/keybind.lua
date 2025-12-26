-- EnowLib Keybind Component

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(config, parent, theme, utils)
    local self = setmetatable({}, Keybind)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Keybind",
        Default = "None",
        Callback = function(key) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Listening = false
    
    self:CreateUI()
    
    return self
end

function Keybind:CreateUI()
    local UserInputService = game:GetService("UserInputService")
    
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Glass
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 48)
    self.Container.Parent = self.Parent.Container or self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Font = self.Theme.Font.Regular
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Text
    title.TextSize = self.Theme.Font.Size.Regular
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Keybind Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.fromOffset(80, 24)
    self.Button.Position = UDim2.new(1, 0, 0.5, 0)
    self.Button.AnchorPoint = Vector2.new(1, 0.5)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = self.Value
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Small
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 6)
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        if not self.Listening then
            self.Listening = true
            self.Button.Text = "..."
            self.Button.BackgroundColor3 = self.Theme.Colors.Accent
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if self.Listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name
                self.Value = key
                self.Button.Text = key
                self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
                self.Listening = false
                pcall(self.Config.Callback, key)
            end
        end
    end)
end

return Keybind
