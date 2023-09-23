-- Create a new ScreenGui instance
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Create a frame that covers the whole screen
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)  -- Size of the frame covers the entire screen
frame.BackgroundTransparency = 0.5  -- Set transparency as desired
frame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Set background color as desired
frame.Parent = screenGui

-- Create a TextBox to enter the part or model name
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.6, 0, 0.1, 0)  -- Size of the textbox (60% of the width, 10% of the height)
textBox.Position = UDim2.new(0.2, 0, 0.05, 0)  -- Position in the middle of the frame
textBox.PlaceholderText = "Enter Part/Model Name"  -- Placeholder text
textBox.ClearTextOnFocus = false  -- Prevent text from clearing on focus
textBox.Text = "" -- Set the initial text to empty
textBox.Parent = frame

-- Create a "Goto Part" TextButton on the left side
local gotoPartButton = Instance.new("TextButton")
gotoPartButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
gotoPartButton.Position = UDim2.new(0.05, 0, 0.2, 0)  -- Position on the left side below the textbox
gotoPartButton.Parent = frame

-- Set text and other properties of the "Goto Part" TextButton
gotoPartButton.Text = "Goto Part"  -- Set button text to "Goto Part"
gotoPartButton.TextSize = 18  -- Set text size

-- Handle "Goto Part" button click event
gotoPartButton.MouseButton1Click:Connect(function()
    local partName = textBox.Text
    
    -- Search for all parts with the same name even inside folders using GetDescendants()
    local foundParts = {}
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("BasePart") and descendant.Name == partName then
            table.insert(foundParts, descendant)
        end
    end
    
    if #foundParts > 0 then
        for _, part in pairs(foundParts) do
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(part.CFrame)
            wait(0.05)  -- Wait for a brief moment before teleporting again (adjust as needed)
        end
    else
        print("Part not found or not valid.")
    end
end)

-- Create a "Goto Model" TextButton on the right side
local gotoModelButton = Instance.new("TextButton")
gotoModelButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
gotoModelButton.Position = UDim2.new(0.65, 0, 0.2, 0)  -- Position on the right side below the textbox
gotoModelButton.Parent = frame

-- Set text and other properties of the "Goto Model" TextButton
gotoModelButton.Text = "Goto Model"  -- Set button text to "Goto Model"
gotoModelButton.TextSize = 18  -- Set text size

-- Handle "Goto Model" button click event
gotoModelButton.MouseButton1Click:Connect(function()
    local modelName = textBox.Text
    
    -- Search for all models with the same name even inside folders using GetDescendants()
    local foundModels = {}
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("Model") and descendant.Name == modelName then
            table.insert(foundModels, descendant)
        end
    end
    
    if #foundModels > 0 then
        for _, model in pairs(foundModels) do
            -- Find a MeshPart within the model
            local meshPart = model:FindFirstChildWhichIsA("MeshPart")
            
            if meshPart then
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(meshPart.Position))
                wait(0.05)  -- Wait for a brief moment before teleporting again (adjust as needed)
            else
                print("Model does not contain a MeshPart.")
            end
        end
    else
        print("Model not found or not valid.")
    end
end)

-- Create a ScrollFrame to contain the list of parts and models
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.4, 0, 0.6, 0)  -- Size of the scrolling frame (40% of the width, 60% of the height)
scrollFrame.Position = UDim2.new(0.3, 0, 0.35, 0)  -- Position within the frame
scrollFrame.Parent = frame

-- Set the CanvasSize of the scrolling frame to make it very long
scrollFrame.CanvasSize = UDim2.new(0, 0, 200000, 0)  -- 200,000 pixels in height

-- Create a UIListLayout to arrange the text labels vertically in the scrolling frame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to populate the scrolling frame with text labels for parts and models
function populateScrollFrame()
    -- Clear existing children
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Iterate through workspace descendants and create text labels
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("BasePart") or descendant:IsA("Model") then
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 30)  -- Set the height of each label
            nameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            nameLabel.BackgroundTransparency = 0.5
            nameLabel.Text = descendant.Name
            nameLabel.Parent = scrollFrame
        end
    end
end

-- Populate the scrolling frame initially
populateScrollFrame()

-- Create an "X" button in the top-right corner to close the ScreenGui
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)  -- Size of the button (10% of the width, 10% of the height)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)  -- Position in the top-right corner
closeButton.Parent = frame

-- Set text and other properties of the "X" button
closeButton.Text = "X"  -- Set button text to "X"
closeButton.TextSize = 18  -- Set text size

-- Handle "X" button click event to destroy the ScreenGui
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Create a TextBox for searching
local searchTextBox = Instance.new("TextBox")
searchTextBox.Size = UDim2.new(0.25, 0, 0.1, 0)  -- Size of the search box (30% of the width, 10% of the height)
searchTextBox.Position = UDim2.new(0.375, 0, 0.2, 0)  -- Position on the left side, aligned with the top of the frame
searchTextBox.PlaceholderText = "Search..."  -- Placeholder text
searchTextBox.Parent = frame

-- Function to filter the text labels based on the search input
function filterTextLabels(searchText)
    local textLabels = scrollFrame:GetChildren()
    for _, child in pairs(textLabels) do
        if child:IsA("TextLabel") then
            local label = child
            local labelName = label.Text:lower()
            local searchTerm = searchText:lower()
            label.Visible = string.find(labelName, searchTerm) ~= nil
        end
    end
end

-- Handle searchTextBox text changed event
searchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchTextBox.Text
    filterTextLabels(searchText)
end)
