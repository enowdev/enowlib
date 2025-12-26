-- VaporUI Main Library
-- Vaporwave Tech Dark UI Library for Roblox

local VaporUI = {
    Version = "1.0.0",
    Author = "EnowHub Development"
}

-- Load core modules
local Theme = require(script.Parent.theme)
local Utils = require(script.Parent.utils)

-- Load components
local Window = require(script.Parent.Parent.components.window)
local Notification = require(script.Parent.Parent.components.notification)

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function VaporUI:CreateWindow(config)
    local window = Window.new(config, Theme, Utils)
    return window
end

-- Show notification
function VaporUI:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function VaporUI:GetTheme()
    return Theme
end

-- Get utils
function VaporUI:GetUtils()
    return Utils
end

return VaporUI
