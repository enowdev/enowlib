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
    -- Load EnowLib for UI
    local EnowLib = self:GetEnowLib()
    if not EnowLib then
        warn("[KeySystemManager] EnowLib not found")
        return
    end
    
    -- Create blocking window
    self.Window = EnowLib:CreateWindow({
        Title = self.Config.Title,
        Size = UDim2.fromOffset(500, 300)
    })
    
    -- Add content
    self.Window:AddLabel({
        Text = "> " .. self.Config.Title,
        Size = 18,
        Color = self.Window.Theme.Colors.Accent,
        Font = self.Window.Theme.Font.Bold
    })
    
    self.Window:AddParagraph({
        Title = "Information",
        Content = self.Config.Description
    })
    
    self.Window:AddDivider()
    
    -- Key input
    local keyInput = ""
    self.Window:AddTextBox({
        Text = "Enter Key",
        Placeholder = "Paste your key here...",
        Default = "",
        Callback = function(value)
            keyInput = value
        end
    })
    
    -- Status label
    self.StatusLabel = self.Window:AddLabel({
        Text = "Waiting for key...",
        Color = self.Window.Theme.Colors.TextDim
    })
    
    self.Window:AddDivider()
    
    -- Buttons
    local buttonSection = self.Window:AddSection({
        Title = "Actions"
    })
    
    -- Validate button
    buttonSection:AddButton({
        Text = "Validate Key",
        Callback = function()
            if keyInput == "" then
                self:UpdateStatus("Please enter a key", "error")
                return
            end
            
            self:ValidateKey(keyInput, false)
        end
    })
    
    -- Get key button (optional)
    if self.Config.GetKeyUrl then
        buttonSection:AddButton({
            Text = "Get Key",
            Callback = function()
                local success = pcall(function()
                    if setclipboard then
                        setclipboard(self.Config.GetKeyUrl)
                        self:UpdateStatus("Link copied to clipboard!", "success")
                    else
                        self:UpdateStatus("URL: " .. self.Config.GetKeyUrl, "info")
                    end
                end)
                
                if not success then
                    self:UpdateStatus("URL: " .. self.Config.GetKeyUrl, "info")
                end
            end
        })
    end
    
    -- Close button
    buttonSection:AddButton({
        Text = "Close",
        Callback = function()
            self:Close()
        end
    })
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
        info = self.Window.Theme.Colors.TextDim,
        success = self.Window.Theme.Colors.Success,
        warning = self.Window.Theme.Colors.Warning,
        error = self.Window.Theme.Colors.Error
    }
    
    self.StatusLabel.Container:FindFirstChildOfClass("TextLabel").Text = text
    self.StatusLabel.Container:FindFirstChildOfClass("TextLabel").TextColor3 = colors[statusType] or colors.info
end

function KeySystemManager:OnSuccess()
    -- Close key system window
    if self.Window and self.Window.Container then
        self.Window.Container:Destroy()
    end
    
    -- Call success callback
    pcall(self.Config.OnSuccess)
end

function KeySystemManager:Close()
    if self.Window and self.Window.Container then
        self.Window.Container:Destroy()
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

function KeySystemManager:GetEnowLib()
    -- Try to get EnowLib from global
    if _G.EnowLib then
        return _G.EnowLib
    end
    
    -- Try to require from ReplicatedStorage
    local success, enowlib = pcall(function()
        return require(game:GetService("ReplicatedStorage"):WaitForChild("EnowLib"))
    end)
    
    if success then
        return enowlib
    end
    
    return nil
end

function KeySystemManager:Destroy()
    if self.Window and self.Window.Container then
        self.Window.Container:Destroy()
    end
    
    self.Initialized = false
end

return KeySystemManager
