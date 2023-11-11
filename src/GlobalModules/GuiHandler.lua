local Module = {}
local Global = require(game.ReplicatedStorage.Modules.GlobalValues)

local Plr = game.Players.LocalPlayer
local Gui = Plr:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local StatsFrame = Gui:WaitForChild("PlayerStats")
local HurtCam : ImageLabel = Gui:WaitForChild("HurtCam")
local InventoryFrame : Frame = Gui:WaitForChild("Inventory")
local ItemTemp : ImageLabel = game.ReplicatedStorage:WaitForChild("ItemTemp")

Module.Values = {
    Health =    {val = 1, name = "6Helath"},
    Water =     {val = 1, name = "5Water"},
    Food =      {val = 1, name = "4Food"},
	Stamina =   {val = 1, name = "3Stamina"},
    Weight =    {val = 1, name = "2Weight"},
    XP =        {val = 1, name = "1Xp"}
}


function Module.UpdateInv(Inventory)
    for i,v in InventoryFrame:GetChildren() do
        if v:IsA("ImageLabel") then v:Destroy() end
    end

    for i,v : Global.ItemClass in Inventory do
        local item = ItemTemp:Clone()
        local temp = Global.Items[v.itemId]

        item.Parent = InventoryFrame
        item.Image = "rbxassetid://".. temp.assetId
        item.Count.Text = v.count
    
    end
end



function Module.UpdateGui()
    for i,v in pairs(Module.Values) do
        local Frame = StatsFrame:WaitForChild(v.name)
        Frame:WaitForChild("UIGradient").Offset = Vector2.new(0,-v.val)
    end

    local HurtCamVal = Module.Values.Health.val + (math.sin(os.clock() * 4) + 1) / 10
    local val = math.clamp(HurtCamVal, 0,1)
    HurtCam.ImageTransparency = val
end



return Module