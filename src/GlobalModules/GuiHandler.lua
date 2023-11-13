local UIS = game:GetService("UserInputService")
local PromptService = game:GetService("ProximityPromptService")

local Global = require(game.ReplicatedStorage.Modules.GlobalValues)
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

local PickupListFrame = Gui:WaitForChild("PickupItems"):WaitForChild("Scrolling")

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

    for i,v in MyInventory:GetChildren() do
        if v:IsA("ImageLabel") then v:Destroy() end
    end

    for i,v : Global.ItemClass in Inventory do
        local item = ItemTemp:Clone()
        local temp = Global.Items[v.itemId]

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



UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.I then 
        InventoryFrame.Visible = not InventoryFrame.Visible
    end
end)


--------------------------- // PickupItems \\ ---------------------------

local SelectedItem = 1
local SelectionsItems = {}

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Up then
        SelectedItem -= 1
    end

    if input.KeyCode == Enum.KeyCode.Down then
        SelectedItem += 1
    end

    if input.KeyCode == Enum.KeyCode.E then
        local num = 0

        for i,v in SelectionsItems do
            num +=1 
            if num ~= SelectedItem then continue end

            local prompt = i
            prompt:InputHoldBegin()
            task.wait()
            prompt:InputHoldEnd()
        end
    end
end)




function OnPromptShown(prompt:ProximityPrompt)
    local NewFrame : TextButton = PicupPromptTemp:Clone()
    NewFrame.Parent = PickupListFrame

    local StartConnect = NewFrame.MouseButton1Down:Connect(function()
        prompt:InputHoldBegin()
    end)

    local EndConnect = NewFrame.MouseButton1Up:Connect(function()
        prompt:InputHoldEnd()
    end)

    SelectionsItems[prompt] = {
        StartConnect = StartConnect,
        EndConnect = EndConnect,
        NewFrame = NewFrame,
    }
end


function OnPromptHidden(prompt:ProximityPrompt)
    local data = SelectionsItems[prompt]
    if not data then return end

    data.StartConnect:Disconnect()
    data.EndConnect:Disconnect()
    data.NewFrame:Destroy()
    SelectionsItems[prompt] = nil
end

PromptService.PromptShown:Connect(OnPromptShown)
PromptService.PromptHidden:Connect(OnPromptHidden)










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