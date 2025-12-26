-- Local test script for EnowLib
-- Run this in Roblox Studio or executor to test local build

print("Loading EnowLib from local build...")

-- Load from file (for testing)
local EnowLib = loadstring(readfile("build/enowlib.lua"))()

if not EnowLib then
    error("Failed to load EnowLib!")
end

print("EnowLib loaded successfully!")
print("Version:", EnowLib.Version)
print("Author:", EnowLib.Author)

-- Test window creation
print("\nCreating window...")
local Window = EnowLib:CreateWindow({
    Title = "EnowLib Local Test",
    Size = UDim2.fromOffset(500, 400)
})

print("Window created successfully!")

-- Test tab creation
print("\nCreating tab...")
local Tab = Window:AddTab({Title = "Test"})

print("Tab created successfully!")

-- Test button
print("\nAdding button...")
Tab:AddButton({
    Title = "Test Button",
    Callback = function()
        print("Button clicked!")
    end
})

print("Button added successfully!")

-- Test notification
print("\nTesting notification...")
EnowLib:Notify({
    Title = "Test",
    Content = "EnowLib is working!",
    Duration = 3,
    Type = "Success"
})

print("\n========================================")
print("All tests passed!")
print("EnowLib is working correctly")
print("========================================")
