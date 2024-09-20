-- Version Information
local guiVersion = "v1.0.3"  -- Update this for each new version
local patchNotesHistory = {
    "v1.0.3: Patch Notes for v1.0.3:\n- Patch notes now show all updates and are scrollable.",
    "v1.0.2: Patch Notes for v1.0.2:\n- Added delete button to remove GUI while keeping code executed.\n- FOV state and collapsed state are saved and restored upon re-execution.",
    "v1.0.1: Patch Notes for v1.0.1:\n- Added a collapsible frame functionality.\n- FOV is adjustable between 0 and 300 using a slider.",
    "v1.0.0: Initial release of the FOV GUI."
}

-- Function to remove old GUI if it exists
local oldGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FOVGui")
if oldGui then
    oldGui:Destroy()
end

-- Local storage for settings
local settings = {
    fov = 70,
    isCollapsed = false
}

-- Check if settings were saved previously
if _G.FOVSettings then
    settings = _G.FOVSettings  -- Load saved settings
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
collapseButton.Size = UDim2.new(0, 30, 0, 20) -- Smaller size
collapseButton.Position = UDim2.new(1, -50, 0, 5) -- Adjusted position
collapseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
collapseButton.Text = "-"
collapseButton.TextColor3 = Color3.new(1, 1, 1)
collapseButton.Parent = frame

-- Create a Button to Delete the GUI
local deleteButton = Instance.new("TextButton")
deleteButton.Size = UDim2.new(0, 30, 0, 20) -- Smaller size
deleteButton.Position = UDim2.new(1, -90, 0, 5) -- Next to the collapse button
deleteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
deleteButton.Text = "X" -- Changed text to "X"
deleteButton.TextColor3 = Color3.new(1, 1, 1)
deleteButton.Parent = frame

-- Create a TextLabel to display FOV value
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, 0, 0, 30)
fovLabel.Position = UDim2.new(0, 0, 0, 10)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. tostring(settings.fov)
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

-- Create a Scrollable Frame for Patch Notes
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -40) -- Scrollable area with space for close button
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 200 * #patchNotesHistory) -- Adjust CanvasSize based on patch notes count
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = patchNotesFrame

-- Populate the ScrollingFrame with Patch Notes
for i, note in ipairs(patchNotesHistory) do
    local patchNoteLabel = Instance.new("TextLabel")
    patchNoteLabel.Size = UDim2.new(1, -20, 0, 100) -- Each patch note entry is 100px tall
    patchNoteLabel.Position = UDim2.new(0, 10, 0, (i - 1) * 110) -- Vertical stacking
    patchNoteLabel.BackgroundTransparency = 1
    patchNoteLabel.Text = note
    patchNoteLabel.TextWrapped = true
    patchNoteLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    patchNoteLabel.Parent = scrollingFrame
end

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
    settings.fov = fov -- Save the FOV setting
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
        local newX = math.clamp(currentX + deltaX, 0, slider.AbsoluteSize.X - handle.AbsoluteSize.X)
        handle.Position = UDim2.new(newX / slider.AbsoluteSize.X, 0, 0, 0)
        updateFOV(newX / slider.AbsoluteSize.X * 300)
    end
end

-- Connect slider dragging to input events
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

userInputService.InputChanged:Connect(onDrag)

-- Handle Patch Notes Button functionality
patchNotesButton.MouseButton1Click:Connect(function()
    patchNotesFrame.Visible = true
end)

-- Handle Close Button for Patch Notes
closePatchNotesButton.MouseButton1Click:Connect(function()
    patchNotesFrame.Visible = false
end)

-- Handle Collapse Button functionality
local isCollapsed = settings.isCollapsed
collapseButton.MouseButton1Click:Connect(function()
    if isCollapsed then
        frame.Size = UDim2.new(0, 300, 0, 100)
        collapseButton.Text = "-"
        slider.Visible = true
        handle.Visible = true
        versionLabel.Visible = true
        patchNotesButton.Visible = true
    else
        frame.Size = UDim2.new(0, 300, 0, 40)
        slider.Visible = false
        handle.Visible = false
        collapseButton.Text = "+"
        versionLabel.Visible = false
        patchNotesButton.Visible = false
    end
    isCollapsed = not isCollapsed
    settings.isCollapsed = isCollapsed -- Save the collapsed state
end)

-- Handle Delete Button functionality
deleteButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- Remove the GUI but keep the script running
end)

-- Save settings globally so they persist between executions
_G.FOVSettings = settings
