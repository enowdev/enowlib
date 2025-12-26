-- EnowLib KeySystemManager v2.0
-- Flexible key validation system with blocking UI

local KeySystemManager = {}

-- Cache services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Settings
KeySystemManager.Settings = {
    SaveKey = true,
    EncryptionKey = "EnowLib_KeySystem_v2",
    Folder = "EnowLib"
}

function KeySystemManager:Initialize(config)
    self.Config = {
        Title = config.Title or "Key System",
        Description = config.Description or "Enter your key to continue",
        ValidateKey = config.ValidateKey or function(key) return false, "No validation function provided" end,
        GetKeyUrl = config.GetKeyUrl or nil,
        SaveKey = config.SaveKey ~= nil and config.SaveKey or true,
        OnSuccess = config.OnSuccess or function() end,
        OnFail = config.OnFail or function(reason) warn("[KeySystem] Failed:", reason) end,
        OnClose = config.OnClose or function() end
    }
    
    self.Initialized = true
    self.Validating = false
    
    -- Try to load saved key
    if self.Config.SaveKey then
        local savedKey = self:LoadKey()
        if savedKey then
            self:ValidateKey(savedKey, true)
            return
        end
    end
    
    -- Show key system UI
    self:CreateUI()
    
    return self
end

function KeySystemManager:CreateUI()
    -- Cache services
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    
    -- Get theme colors (use default hacker theme)
    local theme = {
        Background = Color3.fromRGB(13, 17, 23),
        Panel = Color3.fromRGB(22, 27, 34),
        Secondary = Color3.fromRGB(33, 38, 45),
        Accent = Color3.fromRGB(46, 204, 113),
        AccentHover = Color3.fromRGB(39, 174, 96),
        Text = Color3.fromRGB(201, 209, 217),
        TextDim = Color3.fromRGB(139, 148, 158),
        Border = Color3.fromRGB(48, 54, 61),
        Error = Color3.fromRGB(231, 76, 60),
        Success = Color3.fromRGB(46, 204, 113)
    }
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EnowLibKeySystem"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Background blur
    local blur = Instance.new("Frame")
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.3
    blur.BorderSizePixel = 0
    blur.Size = UDim2.fromScale(1, 1)
    blur.Parent = self.ScreenGui
    
    -- Login Container
    local container = Instance.new("Frame")
    container.BackgroundColor3 = theme.Panel
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.Size = UDim2.fromOffset(400, 400)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Parent = self.ScreenGui
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = container
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = theme.Border
    containerStroke.Thickness = 1
    containerStroke.Parent = container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.fromOffset(20, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = self.Config.Title
    title.TextColor3 = theme.Accent
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Description
    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(1, -40, 0, 40)
    desc.Position = UDim2.fromOffset(20, 60)
    desc.Font = Enum.Font.Gotham
    desc.Text = self.Config.Description
    desc.TextColor3 = theme.TextDim
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = container
    
    -- Username Field (read-only, decorative)
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Size = UDim2.new(1, -40, 0, 16)
    usernameLabel.Position = UDim2.fromOffset(20, 120)
    usernameLabel.Font = Enum.Font.RobotoMono
    usernameLabel.Text = "USERNAME"
    usernameLabel.TextColor3 = theme.TextDim
    usernameLabel.TextSize = 11
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = container
    
    local usernameBox = Instance.new("Frame")
    usernameBox.BackgroundColor3 = theme.Secondary
    usernameBox.BorderSizePixel = 0
    usernameBox.Size = UDim2.new(1, -40, 0, 40)
    usernameBox.Position = UDim2.fromOffset(20, 140)
    usernameBox.Parent = container
    
    local usernameCorner = Instance.new("UICorner")
    usernameCorner.CornerRadius = UDim.new(0, 6)
    usernameCorner.Parent = usernameBox
    
    local usernameText = Instance.new("TextLabel")
    usernameText.BackgroundTransparency = 1
    usernameText.Size = UDim2.new(1, -20, 1, 0)
    usernameText.Position = UDim2.fromOffset(10, 0)
    usernameText.Font = Enum.Font.RobotoMono
    usernameText.Text = self.Config.Username or "enowhub"
    usernameText.TextColor3 = theme.Text
    usernameText.TextSize = 14
    usernameText.TextXAlignment = Enum.TextXAlignment.Left
    usernameText.Parent = usernameBox
    
    -- Key Field (input)
    local keyLabel = Instance.new("TextLabel")
    keyLabel.BackgroundTransparency = 1
    keyLabel.Size = UDim2.new(1, -40, 0, 16)
    keyLabel.Position = UDim2.fromOffset(20, 190)
    keyLabel.Font = Enum.Font.RobotoMono
    keyLabel.Text = "KEY"
    keyLabel.TextColor3 = theme.TextDim
    keyLabel.TextSize = 11
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = container
    
    local keyBox = Instance.new("TextBox")
    keyBox.BackgroundColor3 = theme.Secondary
    keyBox.BorderSizePixel = 0
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.fromOffset(20, 210)
    keyBox.Font = Enum.Font.RobotoMono
    keyBox.PlaceholderText = "Enter your key..."
    keyBox.Text = ""
    keyBox.TextColor3 = theme.Text
    keyBox.PlaceholderColor3 = theme.TextDim
    keyBox.TextSize = 14
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = container
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keyBox
    
    local keyPadding = Instance.new("UIPadding")
    keyPadding.PaddingLeft = UDim.new(0, 10)
    keyPadding.PaddingRight = UDim.new(0, 10)
    keyPadding.Parent = keyBox
    
    -- Status Label
    self.StatusLabel = Instance.new("TextLabel")
    self.StatusLabel.BackgroundTransparency = 1
    self.StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    self.StatusLabel.Position = UDim2.fromOffset(20, 260)
    self.StatusLabel.Font = Enum.Font.RobotoMono
    self.StatusLabel.Text = "Waiting for key..."
    self.StatusLabel.TextColor3 = theme.TextDim
    self.StatusLabel.TextSize = 11
    self.StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.StatusLabel.Parent = container
    
    -- Login Button
    local loginBtn = Instance.new("TextButton")
    loginBtn.BackgroundColor3 = theme.Accent
    loginBtn.BorderSizePixel = 0
    loginBtn.Size = UDim2.new(1, -40, 0, 40)
    loginBtn.Position = UDim2.fromOffset(20, 290)
    loginBtn.Font = Enum.Font.GothamBold
    loginBtn.Text = "LOGIN"
    loginBtn.TextColor3 = Color3.new(0, 0, 0)
    loginBtn.TextSize = 14
    loginBtn.AutoButtonColor = false
    loginBtn.Parent = container
    
    local loginCorner = Instance.new("UICorner")
    loginCorner.CornerRadius = UDim.new(0, 6)
    loginCorner.Parent = loginBtn
    
    -- Button hover effect
    loginBtn.MouseEnter:Connect(function()
        TweenService:Create(loginBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.AccentHover
        }):Play()
    end)
    
    loginBtn.MouseLeave:Connect(function()
        TweenService:Create(loginBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.Accent
        }):Play()
    end)
    
    -- Login button click
    loginBtn.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        
        if key == "" then
            self:UpdateStatus("Please enter a key", "error")
            return
        end
        
        self:ValidateKey(key, false)
    end)
    
    -- Bottom links container
    local linksContainer = Instance.new("Frame")
    linksContainer.BackgroundTransparency = 1
    linksContainer.Size = UDim2.new(1, -40, 0, 70)
    linksContainer.Position = UDim2.fromOffset(20, 340)
    linksContainer.Parent = container
    
    -- "Don't have a key?" text
    local noKeyText = Instance.new("TextLabel")
    noKeyText.BackgroundTransparency = 1
    noKeyText.Size = UDim2.new(1, 0, 0, 20)
    noKeyText.Position = UDim2.fromOffset(0, 0)
    noKeyText.Font = Enum.Font.RobotoMono
    noKeyText.Text = "Don't have a key?"
    noKeyText.TextColor3 = theme.TextDim
    noKeyText.TextSize = 11
    noKeyText.TextXAlignment = Enum.TextXAlignment.Center
    noKeyText.Parent = linksContainer
    
    -- Links row container
    local linksRow = Instance.new("Frame")
    linksRow.BackgroundTransparency = 1
    linksRow.Size = UDim2.new(1, 0, 0, 20)
    linksRow.Position = UDim2.fromOffset(0, 25)
    linksRow.Parent = linksContainer
    
    -- Get Key button
    if self.Config.GetKeyUrl then
        local getKeyBtn = Instance.new("TextButton")
        getKeyBtn.BackgroundTransparency = 1
        getKeyBtn.Size = UDim2.new(0.5, -10, 1, 0)
        getKeyBtn.Position = UDim2.fromOffset(0, 0)
        getKeyBtn.Font = Enum.Font.RobotoMono
        getKeyBtn.Text = "Get Key Here"
        getKeyBtn.TextColor3 = theme.Accent
        getKeyBtn.TextSize = 11
        getKeyBtn.Parent = linksRow
        
        getKeyBtn.MouseButton1Click:Connect(function()
            local success = pcall(function()
                if setclipboard then
                    setclipboard(self.Config.GetKeyUrl)
                    self:UpdateStatus("Link copied to clipboard!", "success")
                end
            end)
        end)
        
        getKeyBtn.MouseEnter:Connect(function()
            getKeyBtn.TextColor3 = theme.AccentHover
        end)
        
        getKeyBtn.MouseLeave:Connect(function()
            getKeyBtn.TextColor3 = theme.Accent
        end)
    end
    
    -- Discord button
    if self.Config.DiscordUrl then
        local discordBtn = Instance.new("TextButton")
        discordBtn.BackgroundTransparency = 1
        discordBtn.Size = UDim2.new(0.5, -10, 1, 0)
        discordBtn.Position = UDim2.new(0.5, 10, 0, 0)
        discordBtn.Font = Enum.Font.RobotoMono
        discordBtn.Text = "Join Discord"
        discordBtn.TextColor3 = theme.Accent
        discordBtn.TextSize = 11
        discordBtn.Parent = linksRow
        
        discordBtn.MouseButton1Click:Connect(function()
            local success = pcall(function()
                if setclipboard then
                    setclipboard(self.Config.DiscordUrl)
                    self:UpdateStatus("Discord link copied!", "success")
                end
            end)
        end)
        
        discordBtn.MouseEnter:Connect(function()
            discordBtn.TextColor3 = theme.AccentHover
        end)
        
        discordBtn.MouseLeave:Connect(function()
            discordBtn.TextColor3 = theme.Accent
        end)
    end
    
    -- Store references
    self.Container = container
    self.Theme = theme
    
    -- Parent to CoreGui
    self.ScreenGui.Parent = CoreGui
end

function KeySystemManager:ValidateKey(key, silent)
    if self.Validating then
        if not silent then
            self:UpdateStatus("Already validating...", "warning")
        end
        return
    end
    
    self.Validating = true
    
    if not silent then
        self:UpdateStatus("Validating key...", "info")
    end
    
    -- Call user's validation function
    task.spawn(function()
        local success, result, message = pcall(function()
            return self.Config.ValidateKey(key)
        end)
        
        self.Validating = false
        
        if not success then
            -- Error in validation function
            if not silent then
                self:UpdateStatus("Validation error: " .. tostring(result), "error")
            end
            pcall(self.Config.OnFail, "Validation error: " .. tostring(result))
            return
        end
        
        -- Check result
        local isValid = result
        local errorMessage = message or "Invalid key"
        
        if isValid == true then
            -- Key is valid
            if self.Config.SaveKey then
                self:SaveKey(key)
            end
            
            if not silent then
                self:UpdateStatus("Key validated successfully!", "success")
                task.wait(1)
            end
            
            self:OnSuccess()
        else
            -- Key is invalid
            if not silent then
                self:UpdateStatus(errorMessage, "error")
            end
            pcall(self.Config.OnFail, errorMessage)
        end
    end)
end

function KeySystemManager:UpdateStatus(text, statusType)
    if not self.StatusLabel then return end
    
    local colors = {
        info = self.Theme.TextDim,
        success = self.Theme.Success,
        warning = Color3.fromRGB(241, 196, 15),
        error = self.Theme.Error
    }
    
    self.StatusLabel.Text = text
    self.StatusLabel.TextColor3 = colors[statusType] or colors.info
end

function KeySystemManager:OnSuccess()
    -- Close key system UI
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Call success callback
    pcall(self.Config.OnSuccess)
end

function KeySystemManager:Close()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    pcall(self.Config.OnClose)
end

function KeySystemManager:SaveKey(key)
    if not writefile then
        warn("[KeySystemManager] writefile not supported")
        return false
    end
    
    local success = pcall(function()
        if not isfolder(self.Settings.Folder) then
            makefolder(self.Settings.Folder)
        end
        
        -- Simple XOR encryption
        local encrypted = self:EncryptKey(key)
        writefile(self.Settings.Folder .. "/key.dat", encrypted)
    end)
    
    return success
end

function KeySystemManager:LoadKey()
    if not readfile or not isfile then
        return nil
    end
    
    local filePath = self.Settings.Folder .. "/key.dat"
    
    if not isfile(filePath) then
        return nil
    end
    
    local success, result = pcall(function()
        local encrypted = readfile(filePath)
        return self:DecryptKey(encrypted)
    end)
    
    if success then
        return result
    end
    
    return nil
end

function KeySystemManager:EncryptKey(key)
    local encrypted = {}
    local encKey = self.Settings.EncryptionKey
    
    for i = 1, #key do
        local keyChar = string.byte(key, i)
        local encChar = string.byte(encKey, (i - 1) % #encKey + 1)
        table.insert(encrypted, string.char(bit32.bxor(keyChar, encChar)))
    end
    
    return table.concat(encrypted)
end

function KeySystemManager:DecryptKey(encrypted)
    -- XOR is symmetric, so decrypt = encrypt
    return self:EncryptKey(encrypted)
end

function KeySystemManager:GetHWID()
    local success, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    
    if success and hwid then
        return hwid
    end
    
    -- Fallback HWID
    return tostring(Players.LocalPlayer.UserId)
end

function KeySystemManager:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Initialized = false
end

return KeySystemManager
