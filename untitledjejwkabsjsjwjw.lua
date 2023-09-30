-- Create a new ScreenGui instance
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Create a frame that covers the whole screen
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)  -- Size of the frame covers the entire screen
frame.BackgroundTransparency = 0.5  -- Set transparency as desired
frame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Set background color as desired
frame.Parent = screenGui
frame.ZIndex = 101

-- Create a variable to track the visibility state of the frame
local frameVisible = true

-- Create a function to toggle the visibility of the frame
local function toggleFrameVisibility()
    frame.Visible = not frameVisible
    frameVisible = not frameVisible
end

-- Create a TextButton named "Hide n Open"
local hideNOpenButton = Instance.new("TextButton")
hideNOpenButton.Text = "Hide n Open (locatormp)"
hideNOpenButton.Size = UDim2.new(0.1, 0, 0.1, 0)
hideNOpenButton.Position = UDim2.new(0.0, 0, 0.7, 0) -- Adjust position here
hideNOpenButton.Parent = screenGui
hideNOpenButton.ZIndex = 200

-- Bind the "Hide n Open" button click event to toggle frame visibility
hideNOpenButton.MouseButton1Click:Connect(function()
    toggleFrameVisibility()
end)

-- Create an "Update List" TextButton on the left side
local updateListButton = Instance.new("TextButton")
updateListButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
updateListButton.Position = UDim2.new(0.65, 0, 0.85, 0)  -- Position on the left side below the "Goto Model" button
updateListButton.Parent = frame
updateListButton.ZIndex = 102

-- Set text and other properties of the "Update List" TextButton
updateListButton.Text = "Update List"  -- Set button text to "Update List"
updateListButton.TextSize = 18  -- Set text size

-- Handle "Update List" button click event
updateListButton.MouseButton1Click:Connect(function()
    populateScrollFrame()  -- Call the function to populate the scrolling frame
end)


-- Create a TextBox to enter the part or model name
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.6, 0, 0.1, 0)  -- Size of the textbox (60% of the width, 10% of the height)
textBox.Position = UDim2.new(0.2, 0, 0.05, 0)  -- Position in the middle of the frame
textBox.PlaceholderText = "Enter Part/Model Name"  -- Placeholder text
textBox.ClearTextOnFocus = false  -- Prevent text from clearing on focus
textBox.Text = "" -- Set the initial text to empty
textBox.Parent = frame
textBox.ZIndex = 102

-- Create a "Bring Part" TextButton on the left side
local bringPartButton = Instance.new("TextButton")
bringPartButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
bringPartButton.Position = UDim2.new(0.05, 0, 0.35, 0)  -- Position on the left side below the search box
bringPartButton.Parent = frame
bringPartButton.ZIndex = 102

-- Set text and other properties of the "Bring Part" TextButton
bringPartButton.Text = "Bring Part"  -- Set button text to "Bring Part"
bringPartButton.TextSize = 18  -- Set text size

-- Handle "Bring Part" button click event
bringPartButton.MouseButton1Click:Connect(function()
    local partName = textBox.Text
    
    -- Search for the specified part
    local foundParts = {}
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("BasePart") and descendant.Name == partName then
            table.insert(foundParts, descendant)
        end
    end
    
    if #foundParts > 0 then
        -- Bring the found part to the player's position
        for _, part in pairs(foundParts) do
            part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    else
        print("Part not found or not valid.")
    end
end)

-- Create a "Tween to Part" TextButton on the left side
local tweenToPartButton = Instance.new("TextButton")
tweenToPartButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
tweenToPartButton.Position = UDim2.new(0.05, 0, 0.5, 0)  -- Position on the left side below the "Bring Part" button
tweenToPartButton.Parent = frame
tweenToPartButton.ZIndex = 102

-- Set text and other properties of the "Tween to Part" TextButton
tweenToPartButton.Text = "Tween to Part"  -- Set button text to "Tween to Part"
tweenToPartButton.TextSize = 18  -- Set text size

-- Handle "Tween to Part" button click event
tweenToPartButton.MouseButton1Click:Connect(function()
    local partName = textBox.Text
    
    -- Search for the specified parts
    local foundParts = {}
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("BasePart") and descendant.Name == partName then
            table.insert(foundParts, descendant)
        end
    end
    
    if #foundParts > 0 then
        local player = game.Players.LocalPlayer
        local playerPosition = player.Character.HumanoidRootPart.Position
        
        local currentIndex = 1  -- Counter to keep track of the current part to tween to
        
        -- Function to tween to the next part in the found parts list
        local function tweenToNextPart()
            if currentIndex <= #foundParts then
                local part = foundParts[currentIndex]
                local partPosition = part.Position
                local midpoint = (playerPosition + partPosition) / 2
                
                local distance = (playerPosition - partPosition).Magnitude
                local tweenDuration = distance / 5000  -- Adjust speed
                
                -- Tween the player to the part's position
                local tweenInfo = TweenInfo.new(
                    tweenDuration,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                
                local tween = game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(midpoint, partPosition)})
                
                -- Connect a function to play the next tween after this one finishes
                tween.Completed:Connect(function()
                    currentIndex = currentIndex + 1
                    tweenToNextPart()  -- Call the function recursively for the next part
                end)
                
                tween:Play()
            end
        end
        
        -- Start the first tween
        tweenToNextPart()
    else
        print("Part not found or not valid.")
    end
end)

-- Create a "Tween to Model" TextButton on the left side
local tweenToModelButton = Instance.new("TextButton")
tweenToModelButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
tweenToModelButton.Position = UDim2.new(0.65, 0, 0.35, 0)  -- Position on the left side below the "Tween to Part" button
tweenToModelButton.Parent = frame
tweenToModelButton.ZIndex = 102

-- Set text and other properties of the "Tween to Model" TextButton
tweenToModelButton.Text = "Tween to Model"  -- Set button text to "Tween to Model"
tweenToModelButton.TextSize = 18  -- Set text size

-- Handle "Tween to Model" button click event
tweenToModelButton.MouseButton1Click:Connect(function()
    local modelName = textBox.Text
    
    -- Search for the specified models
    local foundModels = {}
    local descendants = game.Workspace:GetDescendants()
    for _, descendant in pairs(descendants) do
        if descendant:IsA("Model") and descendant.Name == modelName then
            table.insert(foundModels, descendant)
        end
    end
    
    if #foundModels > 0 then
        local player = game.Players.LocalPlayer
        local playerPosition = player.Character.HumanoidRootPart.Position
        
        local currentIndex = 1  -- Counter to keep track of the current model to tween to
        
        -- Function to tween to the next part in the found models list
        local function tweenToNextPartInModel(model)
            local parts = {}  -- Parts to tween to
            
            -- Search for Parts and MeshParts inside the model
            local modelDescendants = model:GetDescendants()
            for _, descendant in pairs(modelDescendants) do
                if (descendant:IsA("Part") or descendant:IsA("MeshPart")) then
                    table.insert(parts, descendant)
                end
            end
            
            if #parts > 0 then
                local partIndex = 1  -- Counter to keep track of the current part to tween to
                
                -- Function to tween to the next part in the found parts list
                local function tweenToNextPart()
                    if partIndex <= #parts then
                        local part = parts[partIndex]
                        local partPosition = part.Position
                        local midpoint = (playerPosition + partPosition) / 2
                        
                        local distance = (playerPosition - partPosition).Magnitude
                        local tweenDuration = distance / 5000  -- Adjust speed
                        
                        -- Tween the player to the part's position
                        local tweenInfo = TweenInfo.new(
                            tweenDuration,
                            Enum.EasingStyle.Linear,
                            Enum.EasingDirection.Out
                        )
                        
                        local tween = game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(midpoint, partPosition)})
                        
                        -- Connect a function to play the next tween after this one finishes
                        tween.Completed:Connect(function()
                            partIndex = partIndex + 1
                            tweenToNextPart()  -- Call the function recursively for the next part
                        end)
                        
                        tween:Play()
                    end
                end
                
                -- Start tweening to the first part in the model
                tweenToNextPart()
            else
                print("No valid parts found inside the model.")
            end
        end
        
        -- Start tweening to parts in each found model
        local function tweenToPartsInModels()
            if currentIndex <= #foundModels then
                local model = foundModels[currentIndex]
                tweenToNextPartInModel(model)
                
                -- Connect a function to tween to the next model after parts tweening completes
                model.ChildAdded:Connect(function()
                    tweenToPartsInModels()  -- Call the function recursively for the next model
                end)
            end
        end
        
        -- Start tweening to parts in the first found model
        tweenToPartsInModels()
    else
        print("Model not found or not valid.")
    end
end)

-- Create a "Goto Part" TextButton on the left side
local gotoPartButton = Instance.new("TextButton")
gotoPartButton.Size = UDim2.new(0.3, 0, 0.1, 0)  -- Size of the button (30% of the width, 10% of the height)
gotoPartButton.Position = UDim2.new(0.05, 0, 0.2, 0)  -- Position on the left side below the textbox
gotoPartButton.Parent = frame
gotoPartButton.ZIndex = 102

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
gotoModelButton.ZIndex = 102

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
scrollFrame.Size = UDim2.new(0.25, 0, 0.6, 0)  -- Size of the scrolling frame (40% of the width, 60% of the height)
scrollFrame.Position = UDim2.new(0.375, 0, 0.35, 0)  -- Position within the frame
scrollFrame.Parent = frame
scrollFrame.ZIndex = 102

-- Set the CanvasSize of the scrolling frame to make it very long
scrollFrame.CanvasSize = UDim2.new(0, 0, 200000, 0)  -- 200,000 pixels in height

-- Create a UIListLayout to arrange the text labels vertically in the scrolling frame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to populate the scrolling frame with text buttons for parts and models
function populateScrollFrame()
    -- Clear existing children
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Iterate through workspace descendants and create text buttons
    local function createButton(descendant)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)  -- Set the height of each button
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        button.BackgroundTransparency = 0.5
        button.Text = descendant.Name
        button.Parent = scrollFrame
        button.ZIndex = 103
        
        -- Handle click event on the button
        button.MouseButton1Click:Connect(function()
            textBox.Text = descendant.Name
        end)
    end
    
    -- Create buttons for existing descendants
    local visibleButtonsCount = 0
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Model") then
            createButton(descendant)
            visibleButtonsCount = visibleButtonsCount + 1
        end
    end
    
    -- Set the CanvasSize of the scrolling frame based on the number of visible buttons
    local buttonHeight = 30  -- Height of each button
    local spacing = 5  -- Spacing between buttons
    local totalHeight = (buttonHeight + spacing) * visibleButtonsCount
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    -- Connect a function to create buttons for newly added parts or models
    game.Workspace.ChildAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") or descendant:IsA("Model") then
            createButton(descendant)
            visibleButtonsCount = visibleButtonsCount + 1
            
            -- Update the CanvasSize when a new button is added
            totalHeight = (buttonHeight + spacing) * visibleButtonsCount
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end
    end)
end


-- Create an "X" button in the top-right corner to close the ScreenGui
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)  -- Size of the button (10% of the width, 10% of the height)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)  -- Position in the top-right corner
closeButton.Parent = frame
closeButton.ZIndex = 102

-- Set text and other properties of the "X" button
closeButton.Text = "X"  -- Set button text to "X"
closeButton.TextSize = 18  -- Set text size

-- Handle "X" button click event to destroy the ScreenGui
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Create a TextBox for searching outside the scrolling frame
local searchTextBox = Instance.new("TextBox")
searchTextBox.Size = UDim2.new(0.25, 0, 0.1, 0)  -- Size of the search box (30% of the width, 10% of the height)
searchTextBox.Position = UDim2.new(0.375, 0, 0.2, 0)  -- Position on the left side, aligned with the top of the frame
searchTextBox.PlaceholderText = "Search..."  -- Placeholder text
searchTextBox.Parent = frame
searchTextBox.ZIndex = 102

-- Function to filter the text buttons based on the search input
function filterTextButtons(searchText)
    local textButtons = scrollFrame:GetChildren()
    for _, child in pairs(textButtons) do
        if child:IsA("TextButton") then
            local button = child
            local buttonName = button.Text:lower()
            local searchTerm = searchText:lower()
            button.Visible = string.find(buttonName, searchTerm) ~= nil
        end
    end
end

-- Handle searchTextBox text changed event
searchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchTextBox.Text
    filterTextButtons(searchText)
end)
