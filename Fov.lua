-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "FOVGui"

-- Create the Frame for the FOV Slider (Draggable)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.5, -50) -- Centered
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Active = true -- Required for draggable functionality
frame.Draggable = true -- Make the frame draggable
frame.Parent = screenGui

-- Create a Button to Collapse the Frame
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 50, 0, 25)
collapseButton.Position = UDim2.new(1, -60, 0, 5) -- Top-right corner of the frame
collapseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
collapseButton.Text = "-"
collapseButton.TextColor3 = Color3.new(1, 1, 1)
collapseButton.Parent = frame

-- Create a TextLabel to display FOV value
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, 0, 0, 30)
fovLabel.Position = UDim2.new(0, 0, 0, 10)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70"
fovLabel.TextScaled = true
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.Parent = frame

-- Create the Slider for FOV
local slider = Instance.new("TextButton")
slider.Size = UDim2.new(0, 200, 0, 20)
slider.Position = UDim2.new(0.5, -100, 0.5, 0)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
slider.Text = ""
slider.Parent = frame

-- Create the Handle for the Slider
local handle = Instance.new("TextButton")
handle.Size = UDim2.new(0, 20, 1, 0)  -- Slightly larger for easier tapping
handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
handle.Text = ""
handle.Parent = slider

-- FOV adjustment logic
local function updateFOV(value)
    -- Clamp FOV between 0 and 300, round to the nearest integer
    local fov = math.clamp(math.floor(value), 0, 300) -- Using math.floor for integers
    
    -- Update the Camera FOV
    game.Workspace.CurrentCamera.FieldOfView = fov
    
    -- Update the label text
    fovLabel.Text = "FOV: " .. tostring(fov)
end

-- Handle slider movement
local userInputService = game:GetService("UserInputService")
local isDragging = false
local startX = 0
local sensitivity = 2 -- Increase sensitivity to make smaller drags more impactful

-- Function to start dragging
local function startDrag(input)
    isDragging = true
    startX = input.Position.X -- Capture starting position
end

-- Function to stop dragging
local function stopDrag(input)
    isDragging = false
end

-- Function to handle dragging
local function onDrag(input)
    if isDragging then
        -- Calculate the drag amount
        local deltaX = (input.Position.X - startX) * sensitivity
        startX = input.Position.X -- Update the start position
        
        -- Calculate the new slider position
        local currentX = handle.Position.X.Scale * slider.AbsoluteSize.X
        local newX = math.clamp(currentX + deltaX, 0, slider.AbsoluteSize.X)
        handle.Position = UDim2.new(newX / slider.AbsoluteSize.X, 0, 0, 0)
        
        -- Map the slider position to a FOV value (0 - 300)
        local fovValue = (newX / slider.AbsoluteSize.X) * 300
        updateFOV(fovValue)
    end
end

-- Bind the touch and mouse events
handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

handle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        stopDrag(input)
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        onDrag(input)
    end
end)

-- Function to collapse or expand the frame
local isCollapsed = false

collapseButton.MouseButton1Click:Connect(function()
    if isCollapsed then
        -- Expand the frame and show the slider/handle
        frame:TweenSize(UDim2.new(0, 300, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3)
        slider.Visible = true
        handle.Visible = true
        collapseButton.Text = "-"
        fovLabel.Position = UDim2.new(0, 0, 0, 10) -- Reset FOV label position when expanded
    else
        -- Collapse the frame and hide the slider/handle
        frame:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3)
        slider.Visible = false
        handle.Visible = false
        collapseButton.Text = "+"
        fovLabel.Position = UDim2.new(0, 0, 0, 0) -- Adjust FOV label to be centered when collapsed
    end
    isCollapsed = not isCollapsed
end)

-- Initial FOV setup
updateFOV(70)
