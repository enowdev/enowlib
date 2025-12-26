-- EnowLib Section Component

local Section = {}
Section.__index = Section

function Section.new(config, parent, theme, utils)
    local self = setmetatable({}, Section)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Section"
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Section:CreateUI()
    self.Container = Instance.new("Frame")
    self.Container.BackgroundColor3 = self.Theme.Colors.Panel
    self.Container.BackgroundTransparency = self.Theme.Transparency.Subtle
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.Parent = self.Parent
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    self.Theme.CreatePadding(self.Container, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Font = self.Theme.Font.Bold
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.Colors.Accent
    title.TextSize = self.Theme.Font.Size.Large
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.Container
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Size = UDim2.new(1, 0, 1, -28)
    self.ContentContainer.Position = UDim2.fromOffset(0, 28)
    self.ContentContainer.Parent = self.Container
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = self.ContentContainer
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 52)
    end)
end

-- Component methods for Section
function Section:AddButton(config)
    return Button.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddToggle(config)
    return Toggle.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddSlider(config)
    return Slider.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddLabel(config)
    return Label.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddTextBox(config)
    return TextBox.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddDropdown(config)
    return Dropdown.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddMultiSelect(config)
    return MultiSelect.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddColorPicker(config)
    return ColorPicker.new(config, self.ContentContainer, self.Theme, self.Utils)
end

function Section:AddKeybind(config)
    return Keybind.new(config, self.ContentContainer, self.Theme, self.Utils)
end

return Section
