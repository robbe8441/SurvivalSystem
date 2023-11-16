local UIS = game:GetService("UserInputService")
local PromptService = game:GetService("ProximityPromptService")

local Global = require(game.ReplicatedStorage.Modules.GlobalValues)
local Input = require(script.Parent.input)
local ItemTemp : any = game.ReplicatedStorage:WaitForChild("ItemTemp")
local PicupPromptTemp = game.ReplicatedStorage:WaitForChild("PickupPrompt")

local Camera = workspace.CurrentCamera

local Plr = game.Players.LocalPlayer
local PlayerGui = Plr:WaitForChild("PlayerGui")
local Gui = PlayerGui:WaitForChild("MainGui")
local StatsFrame = Gui:WaitForChild("PlayerStats")
local HurtCam : any = Gui:WaitForChild("HurtCam")
local InventoryFrame : Frame = Gui:WaitForChild("Inventory")
local MyInventory = InventoryFrame:WaitForChild("MyItems")

local Module = {}

Module.Values = {
    Health =    {val = 1, name = "6Helath"},
    Water =     {val = 1, name = "5Water"},
    Food =      {val = 1, name = "4Food"},
	Stamina =   {val = 1, name = "3Stamina"},
    Weight =    {val = 1, name = "2Weight"},
    XP =        {val = 1, name = "1Xp"}
}


function Module.UpdateInv(Inventory)
    if not Inventory then warn("No Inventory Given") return end

    for i,v in MyInventory:GetChildren() do
        if v:IsA("ImageLabel") then v:Destroy() end
    end

    for i,v : Global.ItemClass in Inventory do
        local item = ItemTemp:Clone()
        local temp = Global.Items[v.itemId]
        if not temp then warn("Cant find", v) continue end

        item.Parent = MyInventory
        item.Image = "http://www.roblox.com/asset/?id=".. temp.assetId
        item.Count.Text = v.count
    
    end
end

function Module.UpdateGui()
    for i,v in pairs(Module.Values) do
        local Frame = StatsFrame:WaitForChild(v.name)
        Frame:FindFirstChildWhichIsA("UIGradient").Offset = Vector2.new(0,-v.val)
    end

    local HurtCamVal = Module.Values.Health.val + (math.sin(os.clock() * 4) + 1) / 10
    local val = math.clamp(HurtCamVal, 0,1)
    HurtCam.ImageTransparency = val
end


--------------------------- // PickupItems \\ ---------------------------

function lerp(a, b, t)
    return a + (b - a) * t
  end

local SelectionWheel = 0
local PickupPrompts = {}

local RadiusSmoothing = 0
local WheelSmoothing = 0

local Line = Instance.new("Frame", Gui)

function drawPath(start, End)
	local Distance = (start - End).Magnitude
	Line.AnchorPoint = Vector2.new(0.5, 0.5)
	Line.Size = UDim2.new(0, Distance, 0, 5)
	Line.Position = UDim2.new(0, (start.X + End.X) / 2, 0, (start.Y + End.Y) / 2)
	Line.Rotation = math.atan2(End.Y - start.Y, End.X - start.X) * (180 / math.pi)
end





function Module.UpdateItems()
    local TotalItems = #PickupPrompts
    local ButtonRadius = 90
    local U = TotalItems * ButtonRadius
    local Radius = math.max((U / math.pi) / 2, 100)
    Radius = lerp(RadiusSmoothing, Radius , 0.1)
    RadiusSmoothing = Radius

    local NewAngle = (SelectionWheel % 360 * TotalItems)
    if NewAngle ~= NewAngle then NewAngle = 0 end
    --WheelSmoothing = lerp(WheelSmoothing, NewAngle, 0.3)
    WheelSmoothing = NewAngle

    local Selection = {centerDis = 1000, index = 0}

    for i,v in PickupPrompts do
        local Button : TextButton = v.Button
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local Center = workspace.CurrentCamera.ViewportSize

        local Angle = math.rad((360 / TotalItems) * i + WheelSmoothing)
        local XPos, YPos = math.cos(Angle) * Radius , math.sin(Angle) * Radius 

        Button.Position = UDim2.fromOffset(XPos + Center.X/2 - Button.Size.X.Offset / 2, YPos + Center.Y - Button.Size.Y.Offset / 2)
        Button.Rotation = math.deg(Angle) + 90
        if YPos < Selection.centerDis then
            Selection.centerDis = YPos
            Selection.index = i
        end
    end

    local Button= PickupPrompts[Selection.index]
    if not Button then return end
    local Button : TextButton = Button.Button
    Button.BackgroundColor3 = Color3.fromRGB(250, 53, 53)

    local Prompt = PickupPrompts[Selection.index].prompt

    local p1 = Button.AbsolutePosition + Button.AbsoluteSize / 2
    local p2 = workspace.CurrentCamera:WorldToViewportPoint(Prompt.Parent.Position)
    p2 = Vector2.new(p2.X, p2.Y)
    drawPath(p1,p2)

    if UIS:IsKeyDown(Enum.KeyCode.E) then
        Prompt:InputHoldBegin()
        task.wait()
        Prompt:InputHoldEnd()
    end
end



function OnPromptShown(prompt:ProximityPrompt)
    local Button : TextButton = PicupPromptTemp:Clone()
    Button.Parent = Gui

    Button.MouseButton1Down:Connect(function()
        prompt:InputHoldBegin()
    end)
    Button.MouseButton1Up:Connect(function()
        prompt:InputHoldEnd()
    end)

    table.insert(PickupPrompts, {prompt = prompt, Button = Button})
    Module.UpdateItems()
end


function OnPromptHidden(prompt:ProximityPrompt)
    for i,v in PickupPrompts do
       if v.prompt ~= prompt then continue end

       v.Button:Destroy()
       table.remove(PickupPrompts, i)
    end
    Module.UpdateItems()
end


PromptService.PromptShown:Connect(OnPromptShown)
PromptService.PromptHidden:Connect(OnPromptHidden)

Input.AddSub(Enum.KeyCode.I, "Inventory", "InputBegan"):Connect(function()
    InventoryFrame.Visible = not InventoryFrame.Visible
end)

UIS.InputChanged:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        SelectionWheel += input.Position.Z
    end
end)

--[[
--------------------------- // Hud \\ ---------------------------


    
local HudPart = Instance.new("Part", workspace.Terrain)
local HudGui = Instance.new("SurfaceGui", PlayerGui)
HudGui.AlwaysOnTop = true
HudGui.Face = Enum.NormalId.Back
HudGui.Adornee = HudPart

HudPart.Anchored = true
HudPart.CanCollide = false
HudPart.Transparency = 1

local HudCamDis = 4

function Module.UpdateHudPos(DeltaTime:number)
    local VerticalFOV = math.rad(Camera.FieldOfView)
    local HorizontalFOV = math.rad(Camera.MaxAxisFieldOfView)

    local tanVertical = math.tan(VerticalFOV / 2)
    local tanHorizontal = math.tan(HorizontalFOV / 2)

    local width = 2 * HudCamDis * tanHorizontal
    local height = 2 * HudCamDis * tanVertical

    HudPart.Size = Vector3.new(width, height, 0.01)
    HudPart.CFrame = Camera.CFrame * CFrame.new(0, 0, -HudCamDis)
end

]]







return Module