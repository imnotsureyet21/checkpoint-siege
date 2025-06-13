-- BuilderClient: manages building actions for the player
-- This script provides a minimal implementation for selecting build
-- types and placing them via a remote event.
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local placeEvent = ReplicatedStorage:WaitForChild("PlaceEvent")

-- currently selected build type
local currentBuildType = nil

-- rotation of the ghost object (y-axis)
local rotation = 0
local ghost

local buildKeys = {
    Q = "TypeQ",
    E = "TypeE",
    Z = "TypeZ",
    X = "TypeX",
}

local function createGhost()
    -- basic placeholder ghost creation
    if ghost then
        ghost:Destroy()
    end
    ghost = Instance.new("Part")
    ghost.Size = Vector3.new(4, 1, 4)
    ghost.Transparency = 0.5
    ghost.Anchored = true
    ghost.CanCollide = false
    ghost.CFrame = CFrame.new()
    ghost.Parent = workspace
end

-- handle keyboard input for selecting build types and placing objects
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local key = input.KeyCode.Name
    local buildType = buildKeys[key]
    if buildType then
        currentBuildType = buildType
        rotation = 0
        createGhost()
    elseif key == "R" and ghost then
        rotation += 90
        ghost.CFrame *= CFrame.Angles(0, math.rad(90), 0)
    elseif key == "T" and ghost then
        placeEvent:FireServer(ghost.CFrame, currentBuildType)
    end
end)

return {
    currentBuildType = function()
        return currentBuildType
    end
}
