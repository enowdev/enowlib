-- EnowLib InterfaceManager v2.0
-- Modern UI state and visibility management

local InterfaceManager = {}

-- Cache services
local UserInputService = game:GetService("UserInputService")

-- Settings
InterfaceManager.Settings = {
    MinimizeKey = Enum.KeyCode.RightControl,
    Visible = true
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

function InterfaceManager:Destroy()
    if self.Window then
        self.Window = nil
    end
    
    self.Initialized = false
end

return InterfaceManager
