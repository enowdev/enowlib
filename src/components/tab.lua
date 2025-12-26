-- EnowLib Tab Component

local Tab = {}
Tab.__index = Tab

function Tab.new(config, window, theme, utils)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Tab",
        Icon = nil
    }, config or {})
    
    self.Components = {}
    self.Visible = false
    
    self:CreateUI()
    
    return self
end

function Tab:CreateUI()
    -- Tab button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "TabButton"
    self.Button.BackgroundColor3 = self.Theme.Colors.SecondaryLight
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 32)
    self.Button.Font = self.Theme.Font.Bold
    self.Button.Text = self.Config.Title
    self.Button.TextColor3 = self.Theme.Colors.Text
    self.Button.TextSize = self.Theme.Font.Size.Regular
    self.Button.TextXAlignment = Enum.TextXAlignment.Center
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.Window.TabList
    
    self.Theme.CreateStroke(self.Button, self.Theme.Colors.Border, 3)
    self.Theme.CreatePadding(self.Button, {8, 8, 0, 0})
    
    -- Tab content container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = "TabContent"
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.Colors.Primary
    self.Container.CanvasSize = UDim2.fromOffset(0, 0)
    self.Container.Visible = false
    self.Container.Parent = self.Window.ContentArea
    
    -- List layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Small)
    layout.Parent = self.Container
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Button click
    self.Button.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.Hover
            }, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Visible then
            self.Utils.Tween(self.Button, {
                BackgroundColor3 = self.Theme.Colors.BackgroundLight
            }, 0.15)
        end
    end)
end

function Tab:Show()
    self.Visible = true
    self.Container.Visible = true
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.Primary,  -- Cyan when active
        TextColor3 = self.Theme.Colors.Text
    }, 0.15)
    
    -- Update stroke
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Border,
            Thickness = 4
        }, 0.15)
    end
end

function Tab:Hide()
    self.Visible = false
    self.Container.Visible = false
    
    self.Utils.Tween(self.Button, {
        BackgroundColor3 = self.Theme.Colors.SecondaryLight,
        TextColor3 = self.Theme.Colors.Text
    }, 0.15)
    
    -- Reset stroke
    local stroke = self.Button:FindFirstChild("UIStroke")
    if stroke then
        self.Utils.Tween(stroke, {
            Color = self.Theme.Colors.Border,
            Thickness = 3
        }, 0.15)
    end
end

function Tab:AddButton(config)
    local Button = require(script.Parent.button)
    local button = Button.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, button)
    return button
end

function Tab:AddToggle(config)
    local Toggle = require(script.Parent.toggle)
    local toggle = Toggle.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, toggle)
    return toggle
end

function Tab:AddSlider(config)
    local Slider = require(script.Parent.slider)
    local slider = Slider.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, slider)
    return slider
end

function Tab:AddDropdown(config)
    local Dropdown = require(script.Parent.dropdown)
    local dropdown = Dropdown.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, dropdown)
    return dropdown
end

function Tab:AddInput(config)
    local Input = require(script.Parent.input)
    local input = Input.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, input)
    return input
end

function Tab:AddLabel(config)
    local Label = require(script.Parent.label)
    local label = Label.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, label)
    return label
end

function Tab:AddSection(config)
    local Section = require(script.Parent.section)
    local section = Section.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, section)
    return section
end

function Tab:AddKeybind(config)
    local Keybind = require(script.Parent.keybind)
    local keybind = Keybind.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, keybind)
    return keybind
end

function Tab:AddColorPicker(config)
    local ColorPicker = require(script.Parent.colorpicker)
    local colorpicker = ColorPicker.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, colorpicker)
    return colorpicker
end

function Tab:AddMultiDropdown(config)
    local MultiDropdown = require(script.Parent.multidropdown)
    local multidropdown = MultiDropdown.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, multidropdown)
    return multidropdown
end

function Tab:AddProgressBar(config)
    local ProgressBar = require(script.Parent.progressbar)
    local progressbar = ProgressBar.new(config, self, self.Theme, self.Utils)
    table.insert(self.Components, progressbar)
    return progressbar
end

return Tab
