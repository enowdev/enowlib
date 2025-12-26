-- Get Texture ID from Decal ID
-- Run this in Roblox Studio Command Bar

local decalIds = {
    84943167918420,  -- ChevronDown
    107730842937250, -- ChevronRight
    103469834740951, -- Cross
    112055175771712  -- Check
}

print("=== Getting Texture IDs ===")

for _, decalId in ipairs(decalIds) do
    local success, result = pcall(function()
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://" .. decalId
        
        -- Wait for texture to load
        task.wait(0.5)
        
        -- Get the actual texture ID
        local textureId = decal.Texture
        
        print(string.format("Decal ID: %d -> Texture: %s", decalId, textureId))
        
        decal:Destroy()
        return textureId
    end)
    
    if not success then
        warn(string.format("Failed to get texture for Decal ID: %d - %s", decalId, result))
    end
end

print("=== Done ===")
