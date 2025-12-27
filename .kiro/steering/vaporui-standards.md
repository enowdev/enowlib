---
inclusion: always
---

# Enowlib UI Development Standards

## Code Quality Rules

### CRITICAL RULES (from EnowSploit):
1. NO EMOJI anywhere in code
2. NO markdown summary files for documentation
3. Always check for ineffective/unused code
4. Always check for bugs before committing
5. Use proper error handling with pcall
6. Cache game services
7. Use task.wait() instead of wait()
8. Yield in long loops to prevent UI freeze
9. Don't create separate example (all in one file example)
10. Don't Create summary .md except i ask for it
11. Always Build after you made change on src or main script
12. Always push to github after build

### Naming Conventions:
```lua
-- Variables: camelCase
local playerName = "John"
local isActive = true

-- Functions: camelCase
function calculateDamage(base, multiplier)
    return base * multiplier
end

-- Constants: UPPER_SNAKE_CASE
local MAX_HEALTH = 100
local DEFAULT_SPEED = 16

-- Modules: PascalCase
local PlayerFunctions = {}
```

### Error Handling:
```lua
-- Always use pcall for risky operations
local success, result = pcall(function()
    return game:GetService("ReplicatedStorage"):FindFirstChild("Items")
end)

if success and result then
    -- Use result
else
    warn("[ModuleName] Failed to get Items:", result)
end
```

### Performance:
```lua
-- Cache services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Use task.wait() instead of wait()
task.wait(1)

-- Yield in loops to prevent freeze
for i = 1, 1000 do
    -- Process item
    if i % 20 == 0 then
        task.wait() -- Yield every 20 iterations
    end
end
```

## VaporUI Specific Standards

### Component Structure:
```lua
local Component = {}
Component.__index = Component

function Component.new(config, parent, theme, utils)
    local self = setmetatable({}, Component)
    
    self.Parent = parent
    self.Theme = theme
    self.Utils = utils
    self.Config = utils.Merge({
        -- Default config
    }, config or {})
    
    self:CreateUI()
    
    return self
end

function Component:CreateUI()
    -- Create UI elements
end

return Component
```

### Theme Usage:
```lua
-- Always use theme colors
self.Theme.Colors.Primary
self.Theme.Colors.Background

-- Use theme utilities
self.Theme.CreateCorner(element)
self.Theme.CreateStroke(element, color)
self.Theme.CreateGradient(element)
```

### Animation:
```lua
-- Use Utils.Tween for all animations
self.Utils.Tween(element, {
    BackgroundColor3 = targetColor
}, 0.2)

-- Add callbacks when needed
self.Utils.Tween(element, properties, duration, nil, nil, function()
    -- Callback after animation
end)
```

### Event Handling:
```lua
-- Always wrap callbacks in pcall
button.MouseButton1Click:Connect(function()
    pcall(self.Config.Callback, value)
end)

-- Clean up connections when destroying
function Component:Destroy()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Container:Destroy()
end
```

## Testing Checklist

Before committing:
- [ ] No emoji in code
- [ ] No .md summary files
- [ ] All functions have error handling (pcall)
- [ ] Services are cached
- [ ] Long loops have task.wait()
- [ ] Variables follow naming conventions
- [ ] Code is properly commented
- [ ] No unused code
- [ ] No obvious bugs
- [ ] UI animations are smooth
- [ ] Components are responsive
- [ ] Theme colors are consistent
