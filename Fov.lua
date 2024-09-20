-- Version Information
local guiVersion = "v1.0.1"  -- Update this for each new version
local patchNotes = [[
Patch Notes for v1.0.1:
- Added version system and patch notes.
- Patch notes and version number now hide when collapsed.
- Added auto-replacement of previous GUI when re-executed.
]]

-- Function to remove old GUI if it exists
local oldGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FOVGui")
if oldGui then
    oldGui:Destroy()
end

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

-- Create a Version Label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(0, 10, 1, -30) -- Bottom-left corner of the frame
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version: " .. guiVersion
versionLabel.TextScaled = true
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.Parent = frame

-- Create a Button to Show Patch Notes
local patchNotesButton = Instance.new("TextButton")
patchNotesButton.Size = UDim2.new(0, 100, 0, 20)
patchNotesButton.Position = UDim2.new(1, -110, 1, -30) -- Bottom-right corner of the frame
patchNotesButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
patchNotesButton.Text = "Patch Notes"
patchNotesButton.TextScaled = true
patchNotesButton.TextColor3 = Color3.new(1, 1, 1)
patchNotesButton.Parent = frame

-- Create Patch Notes Frame (Initially Hidden)
local patchNotesFrame = Instance.new("Frame")
patchNotesFrame.Size = UDim2.new(0, 300, 0, 200)
patchNotesFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
patchNotesFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
patchNotesFrame.Visible = false
patchNotesFrame.Parent = screenGui

-- Create a Scrollable Patch Notes TextLabel
local patchNotesText = Instance.new("TextLabel")
patchNotesText.Size = UDim2.new(1, 0, 1, 0)
patchNotesText.BackgroundTransparency = 1
patchNotesText.Text = patchNotes
patchNotesText.TextWrapped = true
patchNotesText.TextColor3 = Color3.fromRGB(255, 255, 255)
patchNotesText.Parent = patchNotesFrame

-- Create a Button to Close the Patch Notes Frame
local closePatchNotesButton = Instance.new("TextButton")
closePatchNotesButton.Size = UDim2.new(0, 100, 0, 30)
closePatchNotesButton.Position = UDim2.new(0.5, -50, 1, -40)
closePatchNotesButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
closePatchNotesButton.Text = "Close"
closePatchNotesButton.TextColor3 = Color3.new(1, 1, 1)
closePatchNotesButton.Parent = patchNotesFrame

-- FOV adjustment logic
local function updateFOV(value)
    local fov = math.clamp(math.floor(value), 0, 300) -- Using math.floor for integers
    game.Workspace.CurrentCamera.FieldOfView = fov
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
        local deltaX = (input.Position.X - startX) * sensitivity
        startX = input.Position.X -- Update the start position
        local currentX = handle.Position.X.Scale * slider.AbsoluteSize.X
        local newX = math.clamp(currentX + deltaX, 0, slider.AbsoluteSize.X)
        handle.Position = UDim2.new(newX / slider.AbsoluteSize.X, 0, 0, 0)
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

-- Show Patch Notes when button is clicked
patchNotesButton.MouseButton1Click:Connect(function()
    patchNotesFrame.Visible = true
end)

-- Close Patch Notes when button is clicked
closePatchNotesButton.MouseButton1Click:Connect(function()
    patchNotesFrame.Visible = false
end)

-- Function to collapse or expand the frame
local isCollapsed = false

collapseButton.MouseButton1Click:Connect(function()
    if isCollapsed then
        frame:TweenSize(UDim2.new(0, 300, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3)
        slider.Visible = true
        handle.Visible = true
        collapseButton.Text = "-"
        fovLabel.Position = UDim2.new(0, 0, 0, 10)
        versionLabel.Visible = true
        patchNotesButton.Visible = true
    else
        frame:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3)
        slider.Visible = false
        handle.Visible = false
        collapseButton.Text = "+"
        fovLabel.Position = UDim2.new(0, 0, 0, 5)
        versionLabel.Visible = false
        patchNotesButton.Visible = false
    end
    isCollapsed = not isCollapsed
end)
