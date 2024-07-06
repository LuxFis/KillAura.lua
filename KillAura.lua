-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")

-- Set GUI properties
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.BackgroundTransparency = 0.5

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Space Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24

FlyButton.Parent = Frame
FlyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FlyButton.BorderSizePixel = 0
FlyButton.Position = UDim2.new(0, 0, 0.2, 0)
FlyButton.Size = UDim2.new(0, 300, 0, 50)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.Text = "Toggle Fly (E)"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 20

KillAuraButton.Parent = Frame
KillAuraButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KillAuraButton.BorderSizePixel = 0
KillAuraButton.Position = UDim2.new(0, 0, 0.4, 0)
KillAuraButton.Size = UDim2.new(0, 300, 0, 50)
KillAuraButton.Font = Enum.Font.SourceSans
KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.TextSize = 20

-- Fly script
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local flying = false
local speed = 50

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        local bodyGyro = Instance.new("BodyGyro", player.Character.HumanoidRootPart)
        local bodyVelocity = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.cframe = player.Character.HumanoidRootPart.CFrame
        bodyVelocity.velocity = Vector3.new(0, 0, 0)
        bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

        repeat wait()
            player.Character.Humanoid.PlatformStand = true
            bodyGyro.cframe = CFrame.new(player.Character.HumanoidRootPart.Position, mouse.Hit.p)
            bodyVelocity.velocity = (player.Character.HumanoidRootPart.CFrame.lookVector * speed)
        until not flying
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        player.Character.Humanoid.PlatformStand = false
    end
end)

-- Kill Aura script
local killAuraEnabled = false
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    while killAuraEnabled do
        for _, enemy in ipairs(game.Players:GetPlayers()) do
            if enemy.Team ~= player.Team and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local magnitude = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).magnitude
                if magnitude <= 15 then -- Adjust the distance as needed
                    game.ReplicatedStorage.Events:FindFirstChild("AttackEvent"):FireServer(enemy.Character)
                end
            end
        end
        wait(0.1)
    end
end)

-- Set background
local Background = Instance.new("ImageLabel", Frame)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Image = "rbxassetid://123456789" -- Replace with your space image asset ID
Background.ZIndex = 0