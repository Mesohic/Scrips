local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- // Configuration & State // --
local State = {
    Enabled = false,
    TeamCheck = false,
    TargetPart = "Head", 
    Size = 10,
    Minimized = false,
    Running = true
}

local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    Element = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(0, 140, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Stroke = Color3.fromRGB(60, 60, 65)
}

-- // UI Helpers //
local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function AnimateHover(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.Name == "ToggleBtn" and State.Enabled then return end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Text}):Play()
    end)
end

-- // GUI //
local ScreenGui = Instance.new("ScreenGui")
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ModernHitboxExpander"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 240)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -120)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MakeCorner(MainFrame, 12)
MakeStroke(MainFrame, Theme.Stroke, 1.5)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
Header.BorderSizePixel = 0

local HeaderPad = Instance.new("UIPadding", Header)
HeaderPad.PaddingLeft = UDim.new(0, 12)
HeaderPad.PaddingRight = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox <font color=\"rgb(0,140,255)\">Expander</font>"
Title.TextColor3 = Theme.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.RichText = true

local MinimizeBtn = Instance.new("TextButton", Header)
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
MinimizeBtn.Position = UDim2.new(1, 0, 0.5, 0)
MinimizeBtn.BackgroundColor3 = Theme.Element
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MakeCorner(MinimizeBtn, 6)

local Separator = Instance.new("Frame", MainFrame)
Separator.Size = UDim2.new(1, -2, 0, 1)
Separator.Position = UDim2.new(0, 1, 0, 35)
Separator.BackgroundColor3 = Theme.Stroke
Separator.BorderSizePixel = 0

local Content = Instance.new("Frame", MainFrame)
Content.Name = "ContentFrame"
Content.Size = UDim2.new(1, 0, 1, -36)
Content.Position = UDim2.new(0, 0, 0, 36)
Content.BackgroundTransparency = 1

local ContentPad = Instance.new("UIPadding", Content)
ContentPad.PaddingTop = UDim.new(0, 10)
ContentPad.PaddingLeft = UDim.new(0, 12)
ContentPad.PaddingRight = UDim.new(0, 12)
ContentPad.PaddingBottom = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0, 10)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Size Input
local InputContainer = Instance.new("Frame", Content)
InputContainer.Size = UDim2.new(1, 0, 0, 40)
InputContainer.BackgroundTransparency = 1
InputContainer.LayoutOrder = 1

local InputLabel = Instance.new("TextLabel", InputContainer)
InputLabel.Size = UDim2.new(1, 0, 0, 15)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "HITBOX SIZE"
InputLabel.TextColor3 = Theme.TextDark
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 11
InputLabel.TextXAlignment = Enum.TextXAlignment.Left

local SizeBox = Instance.new("TextBox", InputContainer)
SizeBox.Size = UDim2.new(1, 0, 0, 24)
SizeBox.Position = UDim2.new(0, 0, 0, 16)
SizeBox.BackgroundColor3 = Theme.Element
SizeBox.Text = tostring(State.Size)
SizeBox.TextColor3 = Theme.Text
SizeBox.PlaceholderText = "Amount..."
SizeBox.Font = Enum.Font.Gotham
SizeBox.TextSize = 14
MakeCorner(SizeBox, 6)
MakeStroke(SizeBox, Theme.Stroke, 1)

-- Target Part Selector
local PartContainer = Instance.new("Frame", Content)
PartContainer.Size = UDim2.new(1, 0, 0, 40)
PartContainer.BackgroundTransparency = 1
PartContainer.LayoutOrder = 2

local PartLabel = Instance.new("TextLabel", PartContainer)
PartLabel.Size = UDim2.new(1, 0, 0, 15)
PartLabel.BackgroundTransparency = 1
PartLabel.Text = "TARGET PART"
PartLabel.TextColor3 = Theme.TextDark
PartLabel.Font = Enum.Font.GothamBold
PartLabel.TextSize = 11
PartLabel.TextXAlignment = Enum.TextXAlignment.Left

local PartBtn = Instance.new("TextButton", PartContainer)
PartBtn.Size = UDim2.new(1, 0, 0, 24)
PartBtn.Position = UDim2.new(0, 0, 0, 16)
PartBtn.BackgroundColor3 = Theme.Element
PartBtn.Text = "HEAD"
PartBtn.TextColor3 = Theme.Text
PartBtn.Font = Enum.Font.GothamBold
PartBtn.TextSize = 12
MakeCorner(PartBtn, 6)
MakeStroke(PartBtn, Theme.Stroke, 1)

-- Team Check
local TeamCheckContainer = Instance.new("Frame", Content)
TeamCheckContainer.Size = UDim2.new(1, 0, 0, 24)
TeamCheckContainer.BackgroundTransparency = 1
TeamCheckContainer.LayoutOrder = 3

local TeamLabel = Instance.new("TextLabel", TeamCheckContainer)
TeamLabel.Size = UDim2.new(0.6, 0, 1, 0)
TeamLabel.BackgroundTransparency = 1
TeamLabel.Text = "TEAM CHECK"
TeamLabel.TextColor3 = Theme.TextDark
TeamLabel.Font = Enum.Font.GothamBold
TeamLabel.TextSize = 11
TeamLabel.TextXAlignment = Enum.TextXAlignment.Left

local TeamSwitch = Instance.new("TextButton", TeamCheckContainer)
TeamSwitch.Size = UDim2.new(0, 44, 0, 24)
TeamSwitch.Position = UDim2.new(1, 0, 0.5, 0)
TeamSwitch.AnchorPoint = Vector2.new(1, 0.5)
TeamSwitch.BackgroundColor3 = Theme.Element
TeamSwitch.Text = ""
TeamSwitch.AutoButtonColor = false
MakeCorner(TeamSwitch, 12)
MakeStroke(TeamSwitch, Theme.Stroke, 1)

local SwitchCircle = Instance.new("Frame", TeamSwitch)
SwitchCircle.Size = UDim2.new(0, 18, 0, 18)
SwitchCircle.Position = UDim2.new(0, 3, 0.5, 0)
SwitchCircle.AnchorPoint = Vector2.new(0, 0.5)
SwitchCircle.BackgroundColor3 = Theme.TextDark
MakeCorner(SwitchCircle, 9)

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", Content)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(1, 0, 0, 32)
ToggleBtn.BackgroundColor3 = Theme.Element
ToggleBtn.Text = "Enable"
ToggleBtn.TextColor3 = Theme.Text
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.LayoutOrder = 4
ToggleBtn.AutoButtonColor = false
MakeCorner(ToggleBtn, 6)
MakeStroke(ToggleBtn, Theme.Stroke, 1)

-- // Logic //
AnimateHover(ToggleBtn)
AnimateHover(MinimizeBtn)
AnimateHover(PartBtn)

SizeBox.FocusLost:Connect(function()
    local num = tonumber(SizeBox.Text)
    if num then
        State.Size = num
    else
        SizeBox.Text = tostring(State.Size)
    end
end)

-- Character hitbox application
local function ApplyHitbox(plr)
    if plr.Character then
        local part = plr.Character:FindFirstChild(State.TargetPart)
        if part then
            part.Size = Vector3.new(State.Size, State.Size, State.Size)
            part.Transparency = 0.7
            part.CanCollide = false
            part.Material = Enum.Material.ForceField
            part.Color = Theme.Accent
        end
    end
end

-- Update all existing players
local function UpdateAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            ApplyHitbox(plr)
        end
    end
end

-- Target Part Button
PartBtn.MouseButton1Click:Connect(function()
    if State.TargetPart == "Head" then
        State.TargetPart = "HumanoidRootPart"
        PartBtn.Text = "TORSO"
    else
        State.TargetPart = "Head"
        PartBtn.Text = "HEAD"
    end
    UpdateAllPlayers()
end)

-- Team Check
TeamSwitch.MouseButton1Click:Connect(function()
    State.TeamCheck = not State.TeamCheck
    local targetPos = State.TeamCheck and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetBg = State.TeamCheck and Theme.Accent or Theme.Element
    local targetCircle = State.TeamCheck and Color3.fromRGB(255,255,255) or Theme.TextDark
    TweenService:Create(TeamSwitch, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
    TweenService:Create(SwitchCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetCircle}):Play()
end)

-- Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    State.Enabled = not State.Enabled
    if State.Enabled then
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
        ToggleBtn.Text = "Enabled"
    else
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Text}):Play()
        ToggleBtn.Text = "Enable"
    end
end)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    State.Minimized = not State.Minimized
    Content.Visible = not State.Minimized
    local targetSize = State.Minimized and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 240)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    MinimizeBtn.Text = State.Minimized and "+" or "-"
end)

-- Apply hitbox continuously
RunService.RenderStepped:Connect(function()
    if State.Enabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and (not State.TeamCheck or plr.Team ~= LocalPlayer.Team) then
                ApplyHitbox(plr)
            end
        end
    end
end)

-- Handle respawns
local function SetupPlayer(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.1)
        ApplyHitbox(plr)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        SetupPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        SetupPlayer(plr)
    end
end)

ScreenGui.Destroying:Connect(function()
    State.Running = false
end)
