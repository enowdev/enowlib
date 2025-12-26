-- Convert Decal ID to Texture ID
-- Paste Decal ID di Studio ImageLabel property untuk dapat Texture ID

local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")

-- Sample Decal IDs from radix-icon.txt
local decalIds = {
    {name = "ChevronDown", id = 84943167918420},
    {name = "ChevronRight", id = 107730842937250},
    {name = "Cross", id = 103469834740951},
    {name = "Check", id = 112055175771712}
}

print("=== Decal to Texture ID Converter ===")
print("Paste these IDs manually in Studio ImageLabel to get correct Texture ID:")
print("")

for _, icon in ipairs(decalIds) do
    print(string.format("%s: rbxassetid://%d", icon.name, icon.id))
end

print("")
print("Steps:")
print("1. Create ImageLabel in Studio")
print("2. Paste ID above into Image property")
print("3. Copy the converted ID that appears")
print("4. Use that ID in theme.lua")
