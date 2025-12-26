-- EnowLib ColorPicker Component

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(config, tab, theme, utils)
    local self = setmetatable({}, ColorPicker)
    
    self.Tab = tab
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        Title = "Color Picker",
        Description = nil,
        Default = Color3.fromRGB(138, 43, 226),
        Callback = function(value) end
    }, config or {})
    
    self.Value = self.Config.Default
    self.Open = false
    self.Hue = 0
    self.Saturation = 1
    self.Value = 1
    
    self:CreateUI()
    self:UpdateFromColor(self.Config.Default)
    
    return self
end

function ColorPicker:CreateUI()
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ColorPicker"
    self.Container.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 0, self.Config.Description and 56 or 40)
    self.Container.Parent = self.Tab.Container
    self.Container.ClipsDescendants = false
    
    self.Theme.CreateCorner(self.Container)
    self.Theme.CreateStroke(self.Container, self.Theme.Colors.Border)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -60, 0, 20)
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
        desc.Size = UDim2.new(1, -60, 0, 16)
        desc.Position = UDim2.fromOffset(12, 28)
        desc.Font = self.Theme.Font.Regular
        desc.Text = self.Config.Description
        desc.TextColor3 = self.Theme.Colors.TextDim
        desc.TextSize = self.Theme.Font.Size.Small
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = self.Container
    end
    
    -- Color preview button
    self.PreviewButton = Instance.new("TextButton")
    self.PreviewButton.Name = "Preview"
    self.PreviewButton.BackgroundColor3 = self.Value
    self.PreviewButton.BorderSizePixel = 0
    self.PreviewButton.Size = UDim2.fromOffset(32, 24)
    self.PreviewButton.Position = UDim2.new(1, -40, 0.5, 0)
    self.PreviewButton.AnchorPoint = Vector2.new(0, 0.5)
    self.PreviewButton.Text = ""
    self.PreviewButton.AutoButtonColor = false
    self.PreviewButton.Parent = self.Container
    
    self.Theme.CreateCorner(self.PreviewButton, 4)
    self.Theme.CreateStroke(self.PreviewButton, self.Theme.Colors.Border)
    
    -- Picker panel
    self.PickerPanel = Instance.new("Frame")
    self.PickerPanel.Name = "PickerPanel"
    self.PickerPanel.BackgroundColor3 = self.Theme.Colors.BackgroundDark
    self.PickerPanel.BorderSizePixel = 0
    self.PickerPanel.Size = UDim2.new(0, 200, 0, 0)
    self.PickerPanel.Position = UDim2.new(1, -208, 1, 8)
    self.PickerPanel.Visible = false
    self.PickerPanel.ZIndex = 100
    self.PickerPanel.Parent = self.Container
    
    self.Theme.CreateCorner(self.PickerPanel)
    self.Theme.CreateStroke(self.PickerPanel, self.Theme.Colors.Primary, 2)
    
    -- SV Picker (Saturation/Value)
    self.SVPicker = Instance.new("ImageButton")
    self.SVPicker.Name = "SVPicker"
    self.SVPicker.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    self.SVPicker.BorderSizePixel = 0
    self.SVPicker.Size = UDim2.new(1, -16, 0, 150)
    self.SVPicker.Position = UDim2.fromOffset(8, 8)
    self.SVPicker.Image = "rbxassetid://4155801252"
    self.SVPicker.AutoButtonColor = false
    self.SVPicker.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.SVPicker, 4)
    
    -- SV Cursor
    self.SVCursor = Instance.new("Frame")
    self.SVCursor.Name = "Cursor"
    self.SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SVCursor.BorderSizePixel = 0
    self.SVCursor.Size = UDim2.fromOffset(8, 8)
    self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SVCursor.Parent = self.SVPicker
    
    self.Theme.CreateCorner(self.SVCursor, 4)
    self.Theme.CreateStroke(self.SVCursor, Color3.fromRGB(0, 0, 0), 2)
    
    -- Hue slider
    self.HueSlider = Instance.new("ImageButton")
    self.HueSlider.Name = "HueSlider"
    self.HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueSlider.BorderSizePixel = 0
    self.HueSlider.Size = UDim2.new(1, -16, 0, 12)
    self.HueSlider.Position = UDim2.fromOffset(8, 166)
    self.HueSlider.Image = "rbxassetid://3641079629"
    self.HueSlider.ImageColor3 = Color3.fromRGB(255, 255, 255)
    self.HueSlider.ScaleType = Enum.ScaleType.Crop
    self.HueSlider.AutoButtonColor = false
    self.HueSlider.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.HueSlider, 6)
    
    -- Hue cursor
    self.HueCursor = Instance.new("Frame")
    self.HueCursor.Name = "Cursor"
    self.HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueCursor.BorderSizePixel = 0
    self.HueCursor.Size = UDim2.fromOffset(4, 16)
    self.HueCursor.Position = UDim2.fromOffset(0, -2)
    self.HueCursor.AnchorPoint = Vector2.new(0.5, 0)
    self.HueCursor.Parent = self.HueSlider
    
    self.Theme.CreateCorner(self.HueCursor, 2)
    self.Theme.CreateStroke(self.HueCursor, Color3.fromRGB(0, 0, 0), 1)
    
    -- RGB inputs
    local rgbContainer = Instance.new("Frame")
    rgbContainer.Name = "RGB"
    rgbContainer.BackgroundTransparency = 1
    rgbContainer.Size = UDim2.new(1, -16, 0, 28)
    rgbContainer.Position = UDim2.fromOffset(8, 186)
    rgbContainer.Parent = self.PickerPanel
    
    local rgbLabels = {"R", "G", "B"}
    for i, label in ipairs(rgbLabels) do
        local input = Instance.new("TextBox")
        input.Name = label
        input.BackgroundColor3 = self.Theme.Colors.BackgroundLight
        input.BorderSizePixel = 0
        input.Size = UDim2.new(0.3, -4, 1, 0)
        input.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
        input.Font = self.Theme.Font.Mono
        input.Text = "255"
        input.TextColor3 = self.Theme.Colors.Text
        input.TextSize = self.Theme.Font.Size.Small
        input.PlaceholderText = label
        input.Parent = rgbContainer
        
        self.Theme.CreateCorner(input, 4)
        
        input.FocusLost:Connect(function()
            self:UpdateFromRGB()
        end)
    end
    
    -- Hex input
    self.HexInput = Instance.new("TextBox")
    self.HexInput.Name = "Hex"
    self.HexInput.BackgroundColor3 = self.Theme.Colors.BackgroundLight
    self.HexInput.BorderSizePixel = 0
    self.HexInput.Size = UDim2.new(1, -16, 0, 28)
    self.HexInput.Position = UDim2.fromOffset(8, 222)
    self.HexInput.Font = self.Theme.Font.Mono
    self.HexInput.Text = "#8A2BE2"
    self.HexInput.TextColor3 = self.Theme.Colors.Text
    self.HexInput.TextSize = self.Theme.Font.Size.Small
    self.HexInput.PlaceholderText = "#RRGGBB"
    self.HexInput.Parent = self.PickerPanel
    
    self.Theme.CreateCorner(self.HexInput, 4)
    
    self.HexInput.FocusLost:Connect(function()
        self:UpdateFromHex()
    end)
    
    -- Event handlers
    local UserInputService = game:GetService("UserInputService")
    local draggingSV = false
    local draggingHue = false
    
    self.SVPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = true
            self:UpdateSVFromInput(input.Position)
        end
    end)
    
    self.SVPicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = false
        end
    end)
    
    self.HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = true
            self:UpdateHueFromInput(input.Position)
        end
    end)
    
    self.HueSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingSV then
                self:UpdateSVFromInput(input.Position)
            elseif draggingHue then
                self:UpdateHueFromInput(input.Position)
            end
        end
    end)
    
    -- Preview button click
    self.PreviewButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    self.PreviewButton.MouseEnter:Connect(function()
        local stroke = self.PreviewButton:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Primary
            }, 0.15)
        end
    end)
    
    self.PreviewButton.MouseLeave:Connect(function()
        local stroke = self.PreviewButton:FindFirstChild("UIStroke")
        if stroke then
            self.Utils.Tween(stroke, {
                Color = self.Theme.Colors.Border
            }, 0.15)
        end
    end)
end

function ColorPicker:UpdateSVFromInput(mousePos)
    local pos = self.SVPicker.AbsolutePosition
    local size = self.SVPicker.AbsoluteSize
    
    local relativeX = math.clamp(mousePos.X - pos.X, 0, size.X)
    local relativeY = math.clamp(mousePos.Y - pos.Y, 0, size.Y)
    
    self.Saturation = relativeX / size.X
    self.Brightness = 1 - (relativeY / size.Y)
    
    self:UpdateColor()
end

function ColorPicker:UpdateHueFromInput(mousePos)
    local pos = self.HueSlider.AbsolutePosition
    local size = self.HueSlider.AbsoluteSize
    
    local relativeX = math.clamp(mousePos.X - pos.X, 0, size.X)
    self.Hue = relativeX / size.X
    
    self:UpdateColor()
end

function ColorPicker:UpdateColor()
    local color = Color3.fromHSV(self.Hue, self.Saturation, self.Brightness)
    self.Value = color
    
    -- Update preview
    self.PreviewButton.BackgroundColor3 = color
    
    -- Update SV picker background
    self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    
    -- Update cursors
    self.SVCursor.Position = UDim2.new(self.Saturation, 0, 1 - self.Brightness, 0)
    self.HueCursor.Position = UDim2.new(self.Hue, 0, 0, -2)
    
    -- Update RGB inputs
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    
    local rgbContainer = self.PickerPanel:FindFirstChild("RGB")
    if rgbContainer then
        rgbContainer.R.Text = tostring(r)
        rgbContainer.G.Text = tostring(g)
        rgbContainer.B.Text = tostring(b)
    end
    
    -- Update hex input
    self.HexInput.Text = string.format("#%02X%02X%02X", r, g, b)
    
    -- Callback
    pcall(self.Config.Callback, color)
end

function ColorPicker:UpdateFromColor(color)
    local h, s, v = color:ToHSV()
    self.Hue = h
    self.Saturation = s
    self.Brightness = v
    self:UpdateColor()
end

function ColorPicker:UpdateFromRGB()
    local rgbContainer = self.PickerPanel:FindFirstChild("RGB")
    if not rgbContainer then return end
    
    local r = tonumber(rgbContainer.R.Text) or 0
    local g = tonumber(rgbContainer.G.Text) or 0
    local b = tonumber(rgbContainer.B.Text) or 0
    
    r = math.clamp(r, 0, 255)
    g = math.clamp(g, 0, 255)
    b = math.clamp(b, 0, 255)
    
    local color = Color3.fromRGB(r, g, b)
    self:UpdateFromColor(color)
end

function ColorPicker:UpdateFromHex()
    local hex = self.HexInput.Text:gsub("#", "")
    
    if #hex ~= 6 then return end
    
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    
    local color = Color3.fromRGB(r, g, b)
    self:UpdateFromColor(color)
end

function ColorPicker:Toggle()
    if self.Open then
        self:Close()
    else
        self:Open()
    end
end

function ColorPicker:Open()
    self.Open = true
    self.PickerPanel.Visible = true
    
    self.Utils.Tween(self.PickerPanel, {
        Size = UDim2.new(0, 200, 0, 258)
    }, 0.2)
end

function ColorPicker:Close()
    self.Open = false
    
    self.Utils.Tween(self.PickerPanel, {
        Size = UDim2.new(0, 200, 0, 0)
    }, 0.2, nil, nil, function()
        self.PickerPanel.Visible = false
    end)
end

function ColorPicker:SetValue(color)
    self:UpdateFromColor(color)
end

return ColorPicker
