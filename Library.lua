
local MoLib = {}

local COLORS = {
    Background = Color3.fromRGB(20, 20, 27),
    Element = Color3.fromRGB(43, 43, 55),
    Hover = Color3.fromRGB(55, 55, 70),
    Accent = Color3.fromRGB(120, 85, 220),
    Text = Color3.fromRGB(240, 240, 250),
    Muted = Color3.fromRGB(155, 155, 170),
}

local function create(className, properties, parent)
    local object = Instance.new(className)

    for key, value in pairs(properties or {}) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function round(object, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 7)
    }, object)
end

local function makeLabel(parent, text, position, size, fontSize, bold)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Text = text,
        TextColor3 = COLORS.Text,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = fontSize or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
end

function MoLib:CreateWindow(title)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local previous = playerGui:FindFirstChild("MoLib")
    if previous then
        previous:Destroy()
    end

    local gui = create("ScreenGui", {
        Name = "MoLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, playerGui)

    local frame = create("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(430, 310),
        Position = UDim2.new(0.5, -215, 0.5, -155),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, gui)

    round(frame, 10)

    create("UIStroke", {
        Color = Color3.fromRGB(52, 52, 66),
        Thickness = 1,
    }, frame)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Color3.fromRGB(25, 25, 33),
        BorderSizePixel = 0,
    }, frame)

    makeLabel(
        header,
        title or "MoLib",
        UDim2.fromOffset(16, 7),
        UDim2.new(1, -60, 0, 25),
        17,
        true
    )

    local subtitle = makeLabel(
        header,
        "Minimal dark UI Library",
        UDim2.fromOffset(17, 32),
        UDim2.new(1, -60, 0, 16),
        10,
        false
    )
    subtitle.TextColor3 = COLORS.Muted

    local closeButton = create("TextButton", {
        Name = "Close",
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -40, 0, 14),
        BackgroundColor3 = COLORS.Element,
        Text = "×",
        TextColor3 = COLORS.Text,
        Font = Enum.Font.Gotham,
        TextSize = 21,
        BorderSizePixel = 0,
    }, header)

    round(closeButton, 7)

    closeButton.Activated:Connect(function()
        gui:Destroy()
    end)

    local content = create("ScrollingFrame", {
        Name = "Content",
        Position = UDim2.fromOffset(12, 70),
        Size = UDim2.new(1, -24, 1, -82),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
    }, frame)

    create("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 2),
    }, content)

    create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)

    -- Dragging
    local dragging = false
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local Window = {
        Gui = gui,
        Main = frame,
        Content = content,
    }

    function Window:CreateButton(options)
        options = options or {}

        local button = create("TextButton", {
            Name = options.Name or "Button",
            Size = UDim2.new(1, -4, 0, 38),
            BackgroundColor3 = COLORS.Element,
            BorderSizePixel = 0,
            Text = options.Name or "Button",
            TextColor3 = COLORS.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
        }, content)

        round(button, 7)

        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = COLORS.Hover
        end)

        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = COLORS.Element
        end)

        button.Activated:Connect(function()
            if options.Callback then
                options.Callback()
            end
        end)

        return button
    end

    function Window:CreateToggle(options)
        options = options or {}

        local enabled = options.Default == true

        local row = create("Frame", {
            Name = options.Name or "Toggle",
            Size = UDim2.new(1, -4, 0, 42),
            BackgroundColor3 = COLORS.Element,
            BorderSizePixel = 0,
        }, content)

        round(row, 7)

        makeLabel(
            row,
            options.Name or "Toggle",
            UDim2.fromOffset(12, 0),
            UDim2.new(1, -75, 1, 0),
            13,
            false
        )

        local toggle = create("TextButton", {
            Size = UDim2.fromOffset(48, 25),
            Position = UDim2.new(1, -59, 0.5, -12),
            BackgroundColor3 = enabled and COLORS.Accent or COLORS.Background,
            BorderSizePixel = 0,
            Text = enabled and "ON" or "OFF",
            TextColor3 = COLORS.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
        }, row)

        round(toggle, 7)

        local function setValue(value, silent)
            enabled = value == true
            toggle.Text = enabled and "ON" or "OFF"
            toggle.BackgroundColor3 = enabled
                and COLORS.Accent or COLORS.Background

            if not silent and options.Callback then
                options.Callback(enabled)
            end
        end

        toggle.Activated:Connect(function()
            setValue(not enabled)
        end)

        return {
            GetValue = function()
                return enabled
            end,
            SetValue = setValue,
        }
    end

    function Window:Destroy()
        gui:Destroy()
    end

    return Window
end

return MoLib
