-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame for the entire GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.4, 0, 0.4, 0) -- 40% width, 40% height
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) -- Centered
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0) -- Dark red
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.BackgroundTransparency = 0.1

-- Create a Header Frame
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0.1, 0) -- Full width, 10% height
headerFrame.Position = UDim2.new(0, 0, 0, 0) -- Top of the main frame
headerFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0) -- Slightly lighter red
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

-- Create a ScrollingFrame for script input
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 0.7, 0) -- Full width, 70% height
scrollFrame.Position = UDim2.new(0, 0, 0.1, 0) -- Below the header
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Darker red background
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 10 -- Width of the scrollbar
scrollFrame.Parent = mainFrame
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Adjusted later

-- Create a TextBox for script input
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, 0, 1, 0) -- Full width, full height of scroll frame
textBox.PlaceholderText = "Enter Script Here"
textBox.TextColor3 = Color3.fromRGB(139, 0, 0) -- Dark red text
textBox.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Darker red background
textBox.TextScaled = false -- Do not scale text
textBox.ClearTextOnFocus = false -- Keep text when focusing
textBox.TextWrapped = true -- Wrap text to fit in the box
textBox.TextSize = 18 -- Set a specific text size for better visibility
textBox.TextXAlignment = Enum.TextXAlignment.Left -- Align text to the left
textBox.Parent = scrollFrame

-- Update the CanvasSize of the ScrollingFrame based on the TextBox content
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, textBox.TextBounds.Y + 10) -- Update height based on text
end)

-- Create a TextButton to execute the script
local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(1, 0, 0.2, 0) -- Full width, 20% height
executeButton.Position = UDim2.new(0, 0, 0.8, 0) -- Below the scroll frame
executeButton.Text = "Execute"
executeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black button
executeButton.TextColor3 = Color3.fromRGB(139, 0, 0) -- Dark red text
executeButton.TextScaled = true -- Scale text to fit
executeButton.Parent = mainFrame

-- Draggable function
local dragging
local dragInput
local dragStart
local startPos

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

headerFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Button functionality
executeButton.MouseButton1Click:Connect(function()
    local scriptToExecute = textBox.Text
    if scriptToExecute and scriptToExecute ~= "" then
        local success, result = pcall(loadstring(scriptToExecute))
        if not success then
            warn("Error executing script: " .. tostring(result))
        end
    end
end)

-- Optional: Add a close button to the header
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 1, 0) -- 10% width, full height
closeButton.Position = UDim2.new(0.9, 0, 0, 0) -- Right side of the header
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red close button
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
closeButton.Parent = headerFrame

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy() -- Close the GUI
end)
