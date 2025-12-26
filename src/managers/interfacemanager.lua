-- EnowLib InterfaceManager v2.0
-- Modern UI state, visibility, and theme management

local InterfaceManager = {}

-- Cache services
local UserInputService = game:GetService("UserInputService")

-- Settings
InterfaceManager.Settings = {
    MinimizeKey = Enum.KeyCode.RightControl,
    Visible = true,
    CurrentTheme = "Hacker"
}

-- Theme presets (inspired by Kiro IDE)
InterfaceManager.Themes = {
    Hacker = {
        Name = "Hacker",
        Colors = {
            Background = Color3.fromRGB(13, 17, 23),
            Panel = Color3.fromRGB(22, 27, 34),
            Secondary = Color3.fromRGB(33, 38, 45),
            Accent = Color3.fromRGB(46, 204, 113),
            AccentHover = Color3.fromRGB(39, 174, 96),
            AccentDim = Color3.fromRGB(34, 153, 84),
            Text = Color3.fromRGB(201, 209, 217),
            TextDim = Color3.fromRGB(139, 148, 158),
            Border = Color3.fromRGB(48, 54, 61),
            Success = Color3.fromRGB(46, 204, 113),
            Warning = Color3.fromRGB(241, 196, 15),
            Error = Color3.fromRGB(231, 76, 60)
        }
    },
    
    Ocean = {
        Name = "Ocean",
        Colors = {
            Background = Color3.fromRGB(15, 23, 42),
            Panel = Color3.fromRGB(30, 41, 59),
            Secondary = Color3.fromRGB(51, 65, 85),
            Accent = Color3.fromRGB(56, 189, 248),
            AccentHover = Color3.fromRGB(14, 165, 233),
            AccentDim = Color3.fromRGB(2, 132, 199),
            Text = Color3.fromRGB(226, 232, 240),
            TextDim = Color3.fromRGB(148, 163, 184),
            Border = Color3.fromRGB(71, 85, 105),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Purple = {
        Name = "Purple",
        Colors = {
            Background = Color3.fromRGB(24, 24, 37),
            Panel = Color3.fromRGB(39, 39, 58),
            Secondary = Color3.fromRGB(55, 55, 79),
            Accent = Color3.fromRGB(167, 139, 250),
            AccentHover = Color3.fromRGB(139, 92, 246),
            AccentDim = Color3.fromRGB(124, 58, 237),
            Text = Color3.fromRGB(226, 232, 240),
            TextDim = Color3.fromRGB(148, 163, 184),
            Border = Color3.fromRGB(71, 71, 95),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Sunset = {
        Name = "Sunset",
        Colors = {
            Background = Color3.fromRGB(30, 20, 25),
            Panel = Color3.fromRGB(45, 30, 38),
            Secondary = Color3.fromRGB(60, 40, 50),
            Accent = Color3.fromRGB(251, 113, 133),
            AccentHover = Color3.fromRGB(244, 63, 94),
            AccentDim = Color3.fromRGB(225, 29, 72),
            Text = Color3.fromRGB(254, 226, 226),
            TextDim = Color3.fromRGB(190, 152, 152),
            Border = Color3.fromRGB(75, 50, 63),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Midnight = {
        Name = "Midnight",
        Colors = {
            Background = Color3.fromRGB(10, 10, 15),
            Panel = Color3.fromRGB(20, 20, 30),
            Secondary = Color3.fromRGB(30, 30, 45),
            Accent = Color3.fromRGB(96, 165, 250),
            AccentHover = Color3.fromRGB(59, 130, 246),
            AccentDim = Color3.fromRGB(37, 99, 235),
            Text = Color3.fromRGB(226, 232, 240),
            TextDim = Color3.fromRGB(148, 163, 184),
            Border = Color3.fromRGB(45, 45, 60),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Forest = {
        Name = "Forest",
        Colors = {
            Background = Color3.fromRGB(17, 24, 20),
            Panel = Color3.fromRGB(28, 38, 32),
            Secondary = Color3.fromRGB(39, 52, 44),
            Accent = Color3.fromRGB(74, 222, 128),
            AccentHover = Color3.fromRGB(34, 197, 94),
            AccentDim = Color3.fromRGB(22, 163, 74),
            Text = Color3.fromRGB(220, 252, 231),
            TextDim = Color3.fromRGB(134, 168, 144),
            Border = Color3.fromRGB(54, 67, 59),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Amber = {
        Name = "Amber",
        Colors = {
            Background = Color3.fromRGB(28, 25, 23),
            Panel = Color3.fromRGB(41, 37, 36),
            Secondary = Color3.fromRGB(57, 51, 48),
            Accent = Color3.fromRGB(251, 191, 36),
            AccentHover = Color3.fromRGB(245, 158, 11),
            AccentDim = Color3.fromRGB(217, 119, 6),
            Text = Color3.fromRGB(254, 243, 199),
            TextDim = Color3.fromRGB(180, 160, 130),
            Border = Color3.fromRGB(72, 66, 63),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    },
    
    Crimson = {
        Name = "Crimson",
        Colors = {
            Background = Color3.fromRGB(25, 15, 18),
            Panel = Color3.fromRGB(38, 23, 28),
            Secondary = Color3.fromRGB(51, 31, 38),
            Accent = Color3.fromRGB(239, 68, 68),
            AccentHover = Color3.fromRGB(220, 38, 38),
            AccentDim = Color3.fromRGB(185, 28, 28),
            Text = Color3.fromRGB(254, 226, 226),
            TextDim = Color3.fromRGB(180, 150, 150),
            Border = Color3.fromRGB(66, 41, 48),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        }
    }
}

function InterfaceManager:Initialize(window)
    self.Window = window
    self.Initialized = true
    
    self:SetupKeybind()
    
    return self
end

function InterfaceManager:SetupKeybind()
    if not self.Window then
        warn("[InterfaceManager] Window not initialized")
        return
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self.Settings.MinimizeKey then
            self:Toggle()
        end
    end)
end

function InterfaceManager:Toggle()
    if not self.Window or not self.Window.Container then
        warn("[InterfaceManager] Window container not found")
        return
    end
    
    self.Settings.Visible = not self.Settings.Visible
    self.Window.Container.Visible = self.Settings.Visible
end

function InterfaceManager:Show()
    if not self.Window or not self.Window.Container then return end
    
    self.Settings.Visible = true
    self.Window.Container.Visible = true
end

function InterfaceManager:Hide()
    if not self.Window or not self.Window.Container then return end
    
    self.Settings.Visible = false
    self.Window.Container.Visible = false
end

function InterfaceManager:SetMinimizeKey(keyCode)
    if typeof(keyCode) ~= "EnumItem" then
        warn("[InterfaceManager] Invalid KeyCode")
        return
    end
    
    self.Settings.MinimizeKey = keyCode
end

function InterfaceManager:SetTheme(themeName)
    local theme = self.Themes[themeName]
    
    if not theme then
        warn("[InterfaceManager] Theme not found:", themeName)
        return false
    end
    
    if not self.Window or not self.Window.Theme then
        warn("[InterfaceManager] Window or theme not initialized")
        return false
    end
    
    -- Update theme colors
    for key, color in pairs(theme.Colors) do
        self.Window.Theme.Colors[key] = color
    end
    
    self.Settings.CurrentTheme = themeName
    
    -- Refresh UI with new theme
    self:RefreshUI()
    
    return true
end

function InterfaceManager:RefreshUI()
    if not self.Window then return end
    
    local theme = self.Window.Theme
    
    -- Refresh window container
    if self.Window.Container then
        self.Window.Container.BackgroundColor3 = theme.Colors.Panel
        
        local stroke = self.Window.Container:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = theme.Colors.Border
        end
    end
    
    -- Refresh titlebar
    if self.Window.TitleBar then
        self.Window.TitleBar.BackgroundColor3 = theme.Colors.Panel
        
        local titleLabel = self.Window.TitleBar:FindFirstChildOfClass("TextLabel")
        if titleLabel then
            titleLabel.TextColor3 = theme.Colors.Text
        end
    end
    
    -- Refresh separators
    if self.Window.HeaderSeparator then
        self.Window.HeaderSeparator.BackgroundColor3 = theme.Colors.Border
    end
    
    if self.Window.FooterSeparator then
        self.Window.FooterSeparator.BackgroundColor3 = theme.Colors.Border
    end
    
    if self.Window.VerticalSeparator then
        self.Window.VerticalSeparator.BackgroundColor3 = theme.Colors.Border
    end
    
    -- Refresh sidebar
    if self.Window.Sidebar then
        self.Window.Sidebar.BackgroundColor3 = theme.Colors.Panel
        
        if self.Window.SidebarHeader then
            self.Window.SidebarHeader.BackgroundColor3 = theme.Colors.Secondary
        end
        
        if self.Window.ExplorerLabel then
            self.Window.ExplorerLabel.TextColor3 = theme.Colors.TextDim
        end
        
        if self.Window.SidebarList then
            self.Window.SidebarList.ScrollBarImageColor3 = theme.Colors.Border
        end
    end
    
    -- Refresh content area
    if self.Window.ContentArea then
        self.Window.ContentArea.BackgroundColor3 = theme.Colors.Background
        self.Window.ContentArea.ScrollBarImageColor3 = theme.Colors.Border
    end
    
    -- Refresh footer
    if self.Window.FooterLabel then
        self.Window.FooterLabel.TextColor3 = theme.Colors.TextDim
    end
    
    -- Refresh all categories and items
    self:RefreshCategories()
    
    -- Refresh content area components
    self:RefreshContentComponents()
end

function InterfaceManager:RefreshContentComponents()
    if not self.Window or not self.Window.ContentArea then return end
    
    local theme = self.Window.Theme
    
    -- Recursively refresh all descendants
    for _, child in ipairs(self.Window.ContentArea:GetDescendants()) do
        -- Refresh frames (sections, components)
        if child:IsA("Frame") then
            if child.Name == "Container" or child.Name:match("Section") then
                -- Section/Component containers
                if child.BackgroundTransparency < 1 then
                    child.BackgroundColor3 = theme.Colors.Panel
                end
                
                local stroke = child:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = theme.Colors.Border
                end
            elseif child.Name:match("Button") or child.Name:match("Dropdown") or child.Name:match("TextBox") then
                -- Interactive elements
                if child.BackgroundTransparency < 1 then
                    child.BackgroundColor3 = theme.Colors.Secondary
                end
            end
        end
        
        -- Refresh text labels
        if child:IsA("TextLabel") then
            if child.TextColor3 ~= theme.Colors.Accent and child.TextColor3 ~= Color3.new(0, 0, 0) then
                -- Don't change accent colors or black text (buttons)
                if child.Name:match("Title") or child.Font == theme.Font.Bold then
                    child.TextColor3 = theme.Colors.Accent
                else
                    child.TextColor3 = theme.Colors.Text
                end
            end
        end
        
        -- Refresh text boxes
        if child:IsA("TextBox") then
            child.TextColor3 = theme.Colors.Text
            child.PlaceholderColor3 = theme.Colors.TextDim
            if child.BackgroundTransparency < 1 then
                child.BackgroundColor3 = theme.Colors.Secondary
            end
        end
        
        -- Refresh text buttons
        if child:IsA("TextButton") then
            if child.Name == "Button" then
                -- Main buttons
                child.BackgroundColor3 = theme.Colors.Accent
                child.TextColor3 = Color3.new(0, 0, 0)
            elseif child.BackgroundTransparency < 1 then
                child.BackgroundColor3 = theme.Colors.Secondary
                child.TextColor3 = theme.Colors.Text
            end
        end
        
        -- Refresh image labels (icons)
        if child:IsA("ImageLabel") then
            if child.ImageColor3 ~= theme.Colors.Accent then
                child.ImageColor3 = theme.Colors.TextDim
            end
        end
        
        -- Refresh scrolling frames
        if child:IsA("ScrollingFrame") then
            if child.BackgroundTransparency < 1 then
                child.BackgroundColor3 = theme.Colors.Secondary
            end
            child.ScrollBarImageColor3 = theme.Colors.Border
        end
    end
end

function InterfaceManager:RefreshCategories()
    if not self.Window or not self.Window.Categories then return end
    
    local theme = self.Window.Theme
    
    for _, category in ipairs(self.Window.Categories) do
        if category.Container then
            category.Container.BackgroundColor3 = theme.Colors.Secondary
            
            if category.TitleLabel then
                category.TitleLabel.TextColor3 = theme.Colors.Text
            end
            
            if category.ChevronIcon then
                category.ChevronIcon.ImageColor3 = theme.Colors.TextDim
            end
        end
        
        -- Refresh items in category
        if category.Items then
            for _, item in ipairs(category.Items) do
                if item.Container then
                    if item.Active then
                        item.Container.BackgroundColor3 = theme.Colors.Accent
                        item.Container.BackgroundTransparency = 0.85
                        
                        if item.TitleLabel then
                            item.TitleLabel.TextColor3 = theme.Colors.Text
                        end
                        if item.Icon then
                            item.Icon.ImageColor3 = theme.Colors.Text
                        end
                    else
                        item.Container.BackgroundColor3 = theme.Colors.Secondary
                        item.Container.BackgroundTransparency = 1
                        
                        if item.TitleLabel then
                            item.TitleLabel.TextColor3 = theme.Colors.TextDim
                        end
                        if item.Icon then
                            item.Icon.ImageColor3 = theme.Colors.TextDim
                        end
                    end
                end
            end
        end
    end
end

function InterfaceManager:GetThemeList()
    local themes = {}
    for name, _ in pairs(self.Themes) do
        table.insert(themes, name)
    end
    table.sort(themes)
    return themes
end

function InterfaceManager:Destroy()
    if self.Window then
        self.Window = nil
    end
    
    self.Initialized = false
end

return InterfaceManager
