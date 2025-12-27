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
        Content = nil,
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
    self.Button.Size = UDim2.new(1, 0, 0, 36)
    self.Button.Text = ""
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Category.ItemsContainer
    
    -- Icon (optional)
    if self.Config.Icon then
        self.Icon = Instance.new("ImageLabel")
        self.Icon.BackgroundTransparency = 1
        self.Icon.Size = UDim2.fromOffset(16, 16)
        self.Icon.Position = UDim2.fromOffset(56, 10)
        self.Icon.Image = self.Config.Icon
        self.Icon.ImageColor3 = self.Theme.Colors.TextDim
        self.Icon.Parent = self.Button
    end
    
    -- Title
    local titleOffset = self.Config.Icon and 78 or 56
    self.Title = Instance.new("TextLabel")
    self.Title.BackgroundTransparency = 1
    self.Title.Size = UDim2.new(1, -titleOffset, 1, 0)
    self.Title.Position = UDim2.fromOffset(titleOffset, 0)
    self.Title.Font = self.Theme.Font.Mono
    self.Title.Text = self.Config.Title
    self.Title.TextColor3 = self.Theme.Colors.TextDim
    self.Title.TextSize = self.Theme.Font.Size.Regular
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Button
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
        pcall(self.Config.Callback)
    end)
    
    self.Button.MouseEnter:Connect(function()
        -- Don't show hover if this is the active item
        if self.Category.Window.CurrentItem == self then
            return
        end
        
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
        -- Don't reset if this is the active item
        if self.Category.Window.CurrentItem == self then
            return
        end
        
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

function Item:Select()
    local window = self.Category.Window
    
    if window.CurrentItem then
        window.CurrentItem:Deselect()
    end
    
    window.CurrentItem = self
    
    -- Active state visual
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Accent,
        BackgroundTransparency = 0.85
    }, 0.15)
    self.Utils.Tween(self.Title, {
        TextColor3 = self.Theme.Colors.Text
    }, 0.15)
    if self.Icon then
        self.Utils.Tween(self.Icon, {
            ImageColor3 = self.Theme.Colors.Text
        }, 0.15)
    end
    
    if self.Config.Content then
        window:ShowContent(self.Config.Content)
    end
end

function Item:Deselect()
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Secondary,
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
end

return Item
