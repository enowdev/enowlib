-- EnowLib Main Library
-- Vaporwave Tech Dark UI Library for Roblox

local EnowLib = {
    Version = "2.0.0",
    Author = "EnowHub Development"
}

-- Load core modules
local Theme = require(script.Parent.theme)
local Utils = require(script.Parent.utils)

-- Load components
local Window = require(script.Parent.Parent.components.window)
local Notification = require(script.Parent.Parent.components.notification)

-- Load managers
local SaveManager = require(script.Parent.Parent.managers.savemanager)
local InterfaceManager = require(script.Parent.Parent.managers.interfacemanager)

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function EnowLib:CreateWindow(config)
    local window = Window.new(config, Theme, Utils, self)
    
    -- Initialize managers
    SaveManager.Initialize(window)
    InterfaceManager.Initialize(window)
    
    -- Load saved interface settings
    InterfaceManager.LoadSettings()
    
    window.SaveManager = SaveManager
    window.InterfaceManager = InterfaceManager
    
    return window
end

-- Show notification
function EnowLib:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function EnowLib:GetTheme()
    return Theme
end

-- Get utils
function EnowLib:GetUtils()
    return Utils
end

-- Get SaveManager
function EnowLib:GetSaveManager()
    return SaveManager
end

-- Get InterfaceManager
function EnowLib:GetInterfaceManager()
    return InterfaceManager
end

return EnowLib
