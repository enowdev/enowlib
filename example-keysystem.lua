-- EnowLib KeySystem Example
-- Demonstrates flexible key validation

print("=== EnowLib KeySystem Example ===")

-- Load EnowLib first (required for UI)
_G.EnowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/enowlib.lua"))()

-- Load KeySystemManager
local KeySystemManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/enowdev/enowlib/refs/heads/main/build/managers/keysystemmanager.lua"))()

print("Libraries loaded!")

-- Example 1: Simple true/false validation (server-side logic)
local function simpleValidation()
    KeySystemManager:Initialize({
        Title = "Simple Key System",
        Description = "Server handles all validation logic (HWID, expiry, rate limit)",
        
        -- Simple validation - just return true/false
        ValidateKey = function(key)
            -- Make API call to your server
            local success, response = pcall(function()
                return game:HttpGet("https://yourapi.com/validate?key=" .. key)
            end)
            
            if success then
                -- Server returns "true" or "false"
                if response == "true" then
                    return true
                else
                    return false, "Invalid or expired key"
                end
            end
            
            return false, "Connection error"
        end,
        
        GetKeyUrl = "https://yoursite.com/getkey",
        SaveKey = true,
        
        OnSuccess = function()
            print("[KeySystem] Key validated! Loading main script...")
            createMainWindow()
        end,
        
        OnFail = function(reason)
            print("[KeySystem] Validation failed:", reason)
        end,
        
        OnClose = function()
            print("[KeySystem] User closed key system")
        end
    })
end

-- Example 2: Advanced validation with custom logic
local function advancedValidation()
    KeySystemManager:Initialize({
        Title = "Advanced Key System",
        Description = "Custom validation with HWID binding and expiry check",
        
        ValidateKey = function(key)
            -- Get HWID
            local hwid = KeySystemManager:GetHWID()
            
            -- Make API call with HWID
            local success, response = pcall(function()
                local url = string.format(
                    "https://yourapi.com/validate?key=%s&hwid=%s",
                    game:GetService("HttpService"):UrlEncode(key),
                    game:GetService("HttpService"):UrlEncode(hwid)
                )
                return game:HttpGet(url)
            end)
            
            if not success then
                return false, "Connection error"
            end
            
            -- Parse JSON response
            local data
            success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if not success then
                return false, "Invalid response format"
            end
            
            -- Check response
            if data.valid == true then
                return true
            else
                return false, data.message or "Invalid key"
            end
        end,
        
        GetKeyUrl = "https://yoursite.com/getkey",
        SaveKey = true,
        
        OnSuccess = function()
            print("[KeySystem] Access granted!")
            createMainWindow()
        end,
        
        OnFail = function(reason)
            warn("[KeySystem] Access denied:", reason)
        end
    })
end

-- Example 3: Local validation (for testing)
local function localValidation()
    local validKeys = {
        ["TEST-KEY-123"] = true,
        ["DEMO-KEY-456"] = true
    }
    
    KeySystemManager:Initialize({
        Title = "Local Key System (Testing)",
        Description = "For testing purposes only - keys stored locally",
        
        ValidateKey = function(key)
            if validKeys[key] then
                return true
            else
                return false, "Key not found in database"
            end
        end,
        
        SaveKey = true,
        
        OnSuccess = function()
            print("[KeySystem] Local validation passed!")
            createMainWindow()
        end
    })
end

-- Create main window after successful validation
function createMainWindow()
    local Window = _G.EnowLib:CreateWindow({
        Title = "Main Script",
        Size = UDim2.fromOffset(800, 500)
    })
    
    local MainCategory = Window:AddCategory({
        Title = "Main",
        Icon = "rbxassetid://10723387563",
        Expanded = true
    })
    
    MainCategory:AddItem({
        Title = "Home.lua",
        Icon = "rbxassetid://10723356507",
        Content = function(window)
            window:AddLabel({
                Text = "> Welcome!",
                Size = 18,
                Color = window.Theme.Colors.Accent,
                Font = window.Theme.Font.Bold
            })
            
            window:AddParagraph({
                Title = "Key System Passed",
                Content = "You have successfully validated your key. The main script is now loaded and ready to use."
            })
            
            window:AddDivider()
            
            window:AddButton({
                Text = "Test Button",
                Callback = function()
                    print("Button clicked!")
                end
            })
        end
    })
    
    print("=== Main Window Loaded ===")
end

-- Choose validation method
print("Choose validation method:")
print("1. Simple (true/false response)")
print("2. Advanced (JSON response)")
print("3. Local (testing)")

-- For this example, use local validation
localValidation()

print("=== KeySystem Initialized ===")
