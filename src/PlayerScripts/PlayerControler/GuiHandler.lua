local UIS = game:GetService("UserInputService")
local PromptService = game:GetService("ProximityPromptService")

local Global = require(game.ReplicatedStorage.Modules.GlobalValues)
local Input = require(script.Parent.input)
local ItemTemp : any = game.ReplicatedStorage:WaitForChild("ItemTemp")
local PicupPromptTemp = game.ReplicatedStorage:WaitForChild("PickupPrompt")

local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()
local Camera = workspace.CurrentCamera


local PlayerGui = Plr:WaitForChild("PlayerGui")
local Gui = PlayerGui:WaitForChild("MainGui")
local StatsFrame = Gui:WaitForChild("PlayerStats")
local HurtCam : any = Gui:WaitForChild("HurtCam")
local InventoryFrame : Frame = Gui:WaitForChild("Inventory")
local MyInventory = InventoryFrame:WaitForChild("MyItems")
local TargetInfoFrame : Frame = Gui:WaitForChild("TargetInfoFrame")

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

    local ray = Mouse.UnitRay

    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}

    local InteractRay = workspace:Raycast(ray.Origin, ray.Direction * 10, Params)
    if not InteractRay then return end

    local Target = InteractRay.Instance
    local ItemId = Target:GetAttribute("ItemId")

    if ItemId then
        TargetInfoFrame.Visible = true
        local Template = Global.Items[ItemId]

        local Count = Target:GetAttribute("Count") or 1
        local text = '<font color="rgb(255,125,0)">'.. Count ..'x</font>' .. Template.Name

        local Category : ImageLabel = TargetInfoFrame:WaitForChild("Category")
        Category.ImageRectOffset = Vector2.new(0,(Template.Category - 1) * 101)


        local TextFrame = TargetInfoFrame:WaitForChild("TargetInfo")
        local TitleFrame : TextLabel = TextFrame:WaitForChild("Title")
        local Description : TextLabel = TextFrame:WaitForChild("Description")
        TitleFrame.Text = text
        Description.Text = Template.Description
    else
        TargetInfoFrame.Visible = false
    end

end


return Module