-- Test syntax of built file
local content = io.open("build/enowlib.lua", "r"):read("*all")
local func, err = loadstring(content)

if func then
    print("SUCCESS: File syntax is valid!")
else
    print("ERROR: " .. tostring(err))
end
