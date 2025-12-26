-- EnowLib SaveManager v2.0
-- Modern configuration persistence system

local SaveManager = {}

-- Cache services
local HttpService = game:GetService("HttpService")

-- Settings
SaveManager.Folder = "EnowLib"
SaveManager.CurrentConfig = "default"
SaveManager.AutoSaveEnabled = false
SaveManager.AutoSaveInterval = 60

function SaveManager:Initialize(window)
    self.Window = window
    self.Initialized = true
    self.ComponentRegistry = {}
    
    -- Create folder if not exists
    local success = pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)
    
    if not success then
        warn("[SaveManager] Failed to create folder - file operations may not be supported")
    end
    
    return self
end

function SaveManager:RegisterComponent(id, component)
    if not id or not component then
        warn("[SaveManager] Invalid component registration")
        return
    end
    
    self.ComponentRegistry[id] = component
end

function SaveManager:UnregisterComponent(id)
    self.ComponentRegistry[id] = nil
end

function SaveManager:BuildConfig()
    local config = {
        Version = "2.0.0",
        Timestamp = os.time(),
        Components = {}
    }
    
    for id, component in pairs(self.ComponentRegistry) do
        local success, value = pcall(function()
            if component.Value ~= nil then
                -- Handle different value types
                if typeof(component.Value) == "Color3" then
                    return {
                        R = component.Value.R,
                        G = component.Value.G,
                        B = component.Value.B
                    }
                elseif typeof(component.Value) == "EnumItem" then
                    return component.Value.Name
                else
                    return component.Value
                end
            end
            return nil
        end)
        
        if success and value ~= nil then
            config.Components[id] = value
        end
    end
    
    return config
end

function SaveManager:ApplyConfig(config)
    if not config or not config.Components then
        warn("[SaveManager] Invalid config data")
        return false
    end
    
    local appliedCount = 0
    
    for id, value in pairs(config.Components) do
        local component = self.ComponentRegistry[id]
        
        if component then
            local success = pcall(function()
                -- Reconstruct Color3
                if type(value) == "table" and value.R then
                    value = Color3.new(value.R, value.G, value.B)
                end
                
                -- Reconstruct EnumItem
                if type(value) == "string" and component.Config and component.Config.Default then
                    if typeof(component.Config.Default) == "EnumItem" then
                        value = Enum.KeyCode[value]
                    end
                end
                
                -- Apply value
                if component.SetValue then
                    component:SetValue(value)
                elseif component.Select then
                    component:Select(value)
                elseif component.Value ~= nil then
                    component.Value = value
                    if component.Config and component.Config.Callback then
                        pcall(component.Config.Callback, value)
                    end
                end
            end)
            
            if success then
                appliedCount = appliedCount + 1
            end
        end
    end
    
    return true, appliedCount
end

function SaveManager:Save(configName)
    if not writefile then
        warn("[SaveManager] writefile not supported")
        return false
    end
    
    configName = configName or self.CurrentConfig
    local filePath = self.Folder .. "/" .. configName .. ".json"
    
    local config = self:BuildConfig()
    
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(config)
        writefile(filePath, json)
    end)
    
    if success then
        self.CurrentConfig = configName
        return true
    else
        warn("[SaveManager] Failed to save:", result)
        return false
    end
end

function SaveManager:Load(configName)
    if not readfile or not isfile then
        warn("[SaveManager] File operations not supported")
        return false
    end
    
    configName = configName or self.CurrentConfig
    local filePath = self.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        warn("[SaveManager] Config not found:", configName)
        return false
    end
    
    local success, result = pcall(function()
        local json = readfile(filePath)
        local config = HttpService:JSONDecode(json)
        return config
    end)
    
    if not success then
        warn("[SaveManager] Failed to load:", result)
        return false
    end
    
    local applied, count = self:ApplyConfig(result)
    
    if applied then
        self.CurrentConfig = configName
        return true, count
    end
    
    return false
end

function SaveManager:Delete(configName)
    if not delfile or not isfile then
        warn("[SaveManager] File operations not supported")
        return false
    end
    
    local filePath = self.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        warn("[SaveManager] Config not found:", configName)
        return false
    end
    
    local success = pcall(function()
        delfile(filePath)
    end)
    
    return success
end

function SaveManager:ListConfigs()
    if not listfiles or not isfolder then
        warn("[SaveManager] File operations not supported")
        return {}
    end
    
    if not isfolder(self.Folder) then
        return {}
    end
    
    local success, files = pcall(function()
        return listfiles(self.Folder)
    end)
    
    if not success then
        return {}
    end
    
    local configs = {}
    
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            table.insert(configs, name)
        end
    end
    
    return configs
end

function SaveManager:EnableAutoSave(interval)
    self.AutoSaveEnabled = true
    self.AutoSaveInterval = interval or 60
    
    task.spawn(function()
        while self.AutoSaveEnabled and self.Initialized do
            task.wait(self.AutoSaveInterval)
            
            if self.AutoSaveEnabled then
                local success = self:Save("autosave")
                if success then
                    print("[SaveManager] Auto-saved configuration")
                end
            end
        end
    end)
end

function SaveManager:DisableAutoSave()
    self.AutoSaveEnabled = false
end

function SaveManager:Destroy()
    self:DisableAutoSave()
    self.ComponentRegistry = {}
    self.Window = nil
    self.Initialized = false
end

return SaveManager
