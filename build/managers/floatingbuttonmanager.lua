-- EnowLib Floating Button Manager

local FloatingButtonManager = {}
FloatingButtonManager.__index = FloatingButtonManager

function FloatingButtonManager.new(config)
    local self = setmetatable({}, FloatingButtonManager)
    
    -- Cache services
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    self.UserInputService = UserInputService
    self.TweenService = TweenService
    
    self.Config = {
        Size = config.Size or UDim2.fromOffset(70, 70),
        Position = config.Position or UDim2.new(1, -90, 0.5, -35),
        ImageId = config.ImageId or "rbxassetid://103844172237114",
        BackgroundColor = config.BackgroundColor or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = config.BackgroundTransparency or 0.3,
        CornerRadius = config.CornerRadius or 35,
        OnClick = config.OnClick or function() end
    }
    
    self.Dragging = false
    self.DragStart = nil
    self.StartPos = nil
    self.Connections = {}
    
    self:CreateUI()
    self:SetupDragging()
    
    return self
end

function FloatingButtonManager:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "FloatingButton"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    
    -- Button Container
    self.Button = Instance.new("ImageButton")
    self.Button.Name = "FloatingButton"
    self.Button.BackgroundColor3 = self.Config.BackgroundColor
    self.Button.BackgroundTransparency = self.Config.BackgroundTransparency
    self.Button.BorderSizePixel = 0
    self.Button.Size = self.Config.Size
    self.Button.Position = self.Config.Position
    self.Button.Image = self.Config.ImageId
    self.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    self.Button.ScaleType = Enum.ScaleType.Fit
    self.Button.Parent = self.ScreenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    corner.Parent = self.Button
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.7
    stroke.Parent = self.Button
    
    -- Padding for image
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.Parent = self.Button
    
    -- Parent to CoreGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
end

function FloatingButtonManager:SetupDragging()
    local camera = workspace.CurrentCamera
    local isDragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    -- Function to check boundaries
    local function checkBoundaries(position)
        local viewportSize = camera.ViewportSize
        local buttonSize = self.Button.AbsoluteSize
        
        local x = math.clamp(position.X, 0, viewportSize.X - buttonSize.X)
        local y = math.clamp(position.Y, 0, viewportSize.Y - buttonSize.Y)
        
        return Vector2.new(x, y)
    end
    
    -- Function to update position
    local function updatePosition(input)
        if not isDragging then return end
        
        local delta = input.Position - dragStart
        local newPosition = startPos + Vector2.new(delta.X, delta.Y)
        
        -- Apply boundaries
        local boundedPosition = checkBoundaries(newPosition)
        
        self.Button.Position = UDim2.fromOffset(boundedPosition.X, boundedPosition.Y)
    end
    
    -- Input began (mouse or touch)
    table.insert(self.Connections, self.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragInput = input
            dragStart = input.Position
            startPos = self.Button.AbsolutePosition
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end))
    
    -- Input ended (mouse or touch)
    table.insert(self.Connections, self.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging and dragInput == input then
                isDragging = false
                
                -- Check if it was a click (not drag)
                local delta = input.Position - dragStart
                local dragDistance = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
                
                if dragDistance < 10 then  -- Increased threshold for touch
                    pcall(self.Config.OnClick)
                end
                
                dragInput = nil
            end
        end
    end))
    
    -- Input changed (mouse or touch movement)
    table.insert(self.Connections, self.Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging and dragInput == input then
                updatePosition(input)
            end
        end
    end))
    
    -- Viewport size changed - recheck boundaries
    table.insert(self.Connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if not isDragging then
            local currentPos = self.Button.AbsolutePosition
            local boundedPosition = checkBoundaries(currentPos)
            
            self.Button.Position = UDim2.fromOffset(boundedPosition.X, boundedPosition.Y)
        end
    end))
end

function FloatingButtonManager:SetImage(imageId)
    self.Button.Image = imageId
end

function FloatingButtonManager:SetPosition(position)
    self.Button.Position = position
end

function FloatingButtonManager:Show()
    self.Button.Visible = true
end

function FloatingButtonManager:Hide()
    self.Button.Visible = false
end

function FloatingButtonManager:Toggle()
    self.Button.Visible = not self.Button.Visible
end

function FloatingButtonManager:Destroy()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.ScreenGui:Destroy()
end

return FloatingButtonManager
