-- EnowLib Keybind Component

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(config, tab, theme, utils)
    local self = setmetatable({}, Keybind)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Keybind",
        Description = nil,
        Default = Enum.KeyCode.E,
        Callback = function(key) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Listening = false
    
    self:CreateUI()
    self:SetupListener()
    
    return self
end

function Keybind:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Keybind"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 0, 20)
    title.Position = UDim2.fromOffset(12, self.Config.Description and 8 or 10)
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
        desc.Size = UDim2.new(1, -100, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Keybind button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "KeybindButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.fromOffset(80, 24)
    self.Button.Position = UDim2.new(1, -88, 0.5, 0)
    self.Button.AnchorPoint = Vector2.new(0, 0.5)
    self.Button.Font = self.Theme.Font.Mono
    self.Button.Text = self:GetKeyName(self.Value)
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Small
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Container
    
    self.Theme.CreateCorner(self.Button, 4)
    self.Theme.CreateStroke(self.Button, self.Theme.Colors.Border)
    
    -- Click handler
    self.Button.MouseButton1Click:Connect(function()
        self:StartListening()
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        if not self.Listening then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.Hover
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Listening then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.BackgroundDark
            }, 0.15)
        end
    end)
end

function Keybind:SetupListener()
    local UserInputService = game:GetService("UserInputService")
    
    self.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if self.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self:SetKey(input.KeyCode)
                self:StopListening()
            end
        else
            if input.KeyCode == self.Value then
                pcall(self.Config.Callback, self.Value)
            end
        end
    end)
end

function Keybind:StartListening()
    self.Listening = true
    self.Button.Text = "..."
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Primary
    }, 0.15)
    
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Primary
        }, 0.15)
    end
end

function Keybind:StopListening()
    self.Listening = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.BackgroundDark
    }, 0.15)
    
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Border
        }, 0.15)
    end
end

function Keybind:SetKey(keyCode)
    self.Value = keyCode
    self.Button.Text = self:GetKeyName(keyCode)
end

function Keybind:GetKeyName(keyCode)
    local name = keyCode.Name
    
    -- Simplify common key names
    name = name:gsub("Key", "")
    
    return name
end

function Keybind:Destroy()
    if self.Connection then
        self.Connection:Disconnect()
    end
    self.Container:Destroy()
end

return Keybind
