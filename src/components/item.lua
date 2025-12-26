-- EnowLib Item Component (File in Tree)

local Item = {}
Item.__index = Item

function Item.new(config, category, theme, utils)
    local self = setmetatable({}, Item)
    
    self.Category = category
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Item",
        Icon = nil,
        Callback = function() end
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Item:CreateUI()
    -- Item Button
    self.Button = Instance.new("TextButton")
    self.Button.BackgroundColor3 = self.Theme.Colors.Secondary
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 28)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Category.ItemsContainer
    
    -- Icon (optional)
    if self.Config.Icon then
        self.Icon = Instance.new("ImageLabel")
        self.Icon.BackgroundTransparency = 1
        self.Icon.Size = UDim2.fromOffset(14, 14)
        self.Icon.Position = UDim2.fromOffset(50, 7)
        self.Icon.Image = self.Config.Icon
        self.Icon.ImageColor3 = self.Theme.Colors.TextDim
        self.Icon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 70 or 50
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.TextDim
    self.Title.TextSize = self.Theme.Font.Size.Small
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        pcall(self.Config.Callback)
    end)
    
    self.Button.MouseEnter:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 0.9
        }, 0.15)
        self.Utils.Tween(self.Title, {
            TextColor3 = self.Theme.Colors.Accent
        }, 0.15)
        if self.Icon then
            self.Utils.Tween(self.Icon, {
                ImageColor3 = self.Theme.Colors.Accent
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        self.Utils.Tween(self.Button, {
            BackgroundTransparency = 1
        }, 0.15)
        self.Utils.Tween(self.Title, {
            TextColor3 = self.Theme.Colors.TextDim
        }, 0.15)
        if self.Icon then
            self.Utils.Tween(self.Icon, {
                ImageColor3 = self.Theme.Colors.TextDim
            }, 0.15)
        end
    end)
end

return Item
