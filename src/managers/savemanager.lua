-- EnowLib SaveManager
-- Handles configuration persistence

local SaveManager = {}
SaveManager.Folder = "EnowLib"
SaveManager.FileName = "config.json"
SaveManager.Configs = {}

function SaveManager.Initialize(window)
    SaveManager.Window = window
    
    -- Create folder if not exists
    if not isfolder(SaveManager.Folder) then
        pcall(makefolder, SaveManager.Folder)
    end
    
    -- Load existing configs
    SaveManager.LoadConfigList()
end

function SaveManager.LoadConfigList()
    if not isfolder(SaveManager.Folder) then
        return
    end
    
    local success, files = pcall(listfiles, SaveManager.Folder)
    if not success then return end
    
    SaveManager.Configs = {}
    
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            table.insert(SaveManager.Configs, name)
        end
    end
end

function SaveManager.Save(configName)
    if not writefile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    configName = configName or SaveManager.FileName:gsub("%.json$", "")
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    local data = SaveManager.BuildConfigData()
    local json = game:GetService("HttpService"):JSONEncode(data)
    
    local success, err = pcall(function()
        writefile(filePath, json)
    end)
    
    if success then
        if not table.find(SaveManager.Configs, configName) then
            table.insert(SaveManager.Configs, configName)
        end
        return true
    else
        warn("[SaveManager] Failed to save config:", err)
        return false
    end
end

function SaveManager.Load(configName)
    if not readfile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    configName = configName or SaveManager.FileName:gsub("%.json$", "")
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        warn("[SaveManager] Config file not found:", configName)
        return false
    end
    
    local success, content = pcall(readfile, filePath)
    if not success then
        warn("[SaveManager] Failed to read config:", content)
        return false
    end
    
    local data
    success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    
    if not success then
        warn("[SaveManager] Failed to parse config:", data)
        return false
    end
    
    SaveManager.ApplyConfigData(data)
    return true
end

function SaveManager.Delete(configName)
    if not delfile then
        warn("[SaveManager] Executor does not support file operations")
        return false
    end
    
    local filePath = SaveManager.Folder .. "/" .. configName .. ".json"
    
    if not isfile(filePath) then
        return false
    end
    
    local success = pcall(delfile, filePath)
    
    if success then
        for i, name in ipairs(SaveManager.Configs) do
            if name == configName then
                table.remove(SaveManager.Configs, i)
                break
            end
        end
    end
    
    return success
end

function SaveManager.BuildConfigData()
    local data = {
        version = SaveManager.Window.EnowLib.Version,
        timestamp = os.time(),
        components = {}
    }
    
    -- Iterate through all tabs and components
    for _, tab in ipairs(SaveManager.Window.Tabs) do
        for _, component in ipairs(tab.Components) do
            local componentData = SaveManager.GetComponentData(component)
            if componentData then
                table.insert(data.components, componentData)
            end
        end
    end
    
    return data
end

function SaveManager.GetComponentData(component)
    local componentType = tostring(component):match("table: ")
    
    if not component.Config or not component.Config.Title then
        return nil
    end
    
    local data = {
        type = componentType,
        title = component.Config.Title,
        value = nil
    }
    
    -- Get value based on component type
    if component.Value ~= nil then
        if typeof(component.Value) == "Color3" then
            data.value = {
                R = component.Value.R,
                G = component.Value.G,
                B = component.Value.B
            }
        elseif typeof(component.Value) == "EnumItem" then
            data.value = component.Value.Name
        else
            data.value = component.Value
        end
    elseif component.Values then
        -- MultiDropdown
        local selected = {}
        for opt, enabled in pairs(component.Values) do
            if enabled then
                table.insert(selected, opt)
            end
        end
        data.value = selected
    end
    
    return data
end

function SaveManager.ApplyConfigData(data)
    if not data.components then return end
    
    -- Apply each component's saved value
    for _, savedComponent in ipairs(data.components) do
        SaveManager.ApplyComponentData(savedComponent)
    end
end

function SaveManager.ApplyComponentData(savedData)
    -- Find matching component by title
    for _, tab in ipairs(SaveManager.Window.Tabs) do
        for _, component in ipairs(tab.Components) do
            if component.Config and component.Config.Title == savedData.title then
                SaveManager.SetComponentValue(component, savedData.value)
                break
            end
        end
    end
end

function SaveManager.SetComponentValue(component, value)
    if value == nil then return end
    
    -- Handle different component types
    if component.SetValue then
        -- Color3 reconstruction
        if type(value) == "table" and value.R then
            value = Color3.new(value.R, value.G, value.B)
        end
        
        -- KeyCode reconstruction
        if type(value) == "string" and component.Config.Default and typeof(component.Config.Default) == "EnumItem" then
            value = Enum.KeyCode[value]
        end
        
        component:SetValue(value)
    elseif component.SetValues then
        -- MultiDropdown
        component:SetValues(value)
    elseif component.Toggle then
        -- Toggle component
        if component.Value ~= value then
            component:Toggle()
        end
    end
end

function SaveManager.AutoSave(interval)
    interval = interval or 60
    
    task.spawn(function()
        while SaveManager.Window do
            task.wait(interval)
            SaveManager.Save("autosave")
        end
    end)
end

function SaveManager.CreateUI(tab)
    if not tab then return end
    
    tab:AddSection({Title = "CONFIGURATION"})
    
    -- Config name input
    local configName = "config"
    
    tab:AddInput({
        Title = "Config Name",
        Placeholder = "Enter config name...",
        Default = configName,
        Callback = function(value)
            configName = value
        end
    })
    
    -- Save button
    tab:AddButton({
        Title = "Save Config",
        Description = "Save current settings",
        Callback = function()
            local success = SaveManager.Save(configName)
            if success then
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Saved",
                    Content = "Configuration saved as: " .. configName,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Save Failed",
                    Content = "Failed to save configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Load dropdown
    tab:AddDropdown({
        Title = "Load Config",
        Description = "Select config to load",
        Options = SaveManager.Configs,
        Callback = function(value)
            local success = SaveManager.Load(value)
            if success then
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Loaded",
                    Content = "Configuration loaded: " .. value,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Load Failed",
                    Content = "Failed to load configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Delete dropdown
    tab:AddDropdown({
        Title = "Delete Config",
        Description = "Select config to delete",
        Options = SaveManager.Configs,
        Callback = function(value)
            local success = SaveManager.Delete(value)
            if success then
                SaveManager.LoadConfigList()
                SaveManager.Window.EnowLib:Notify({
                    Title = "Config Deleted",
                    Content = "Configuration deleted: " .. value,
                    Duration = 2,
                    Type = "Success"
                })
            else
                SaveManager.Window.EnowLib:Notify({
                    Title = "Delete Failed",
                    Content = "Failed to delete configuration",
                    Duration = 2,
                    Type = "Error"
                })
            end
        end
    })
    
    -- Auto-save toggle
    tab:AddToggle({
        Title = "Auto Save",
        Description = "Automatically save every 60 seconds",
        Default = false,
        Callback = function(value)
            if value then
                SaveManager.AutoSave(60)
            end
        end
    })
end

return SaveManager
