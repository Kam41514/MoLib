
local NovaUI = {}

function NovaUI:CreateWindow(title)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local gui = Instance.new("ScreenGui")
    gui.Name = "NovaUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(420, 280)
    frame.Position = UDim2.new(0.5, -210, 0.5, -140)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -20, 0, 45)
    heading.Position = UDim2.fromOffset(12, 0)
    heading.BackgroundTransparency = 1
    heading.Text = title or "NovaUI"
    heading.TextColor3 = Color3.fromRGB(240, 240, 250)
    heading.Font = Enum.Font.GothamBold
    heading.TextSize = 18
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 38)
    button.Position = UDim2.fromOffset(12, 60)
    button.BackgroundColor3 = Color3.fromRGB(43, 43, 55)
    button.Text = "Test Button"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = frame

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

    button.Activated:Connect(function()
        button.Text = "NovaUI çalışıyor!"
        print("NovaUI: Button clicked")
    end)

    function NovaUI:Destroy()
        gui:Destroy()
    end

    return gui
end

return NovaUI
