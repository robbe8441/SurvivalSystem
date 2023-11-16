local Modules = game.ServerStorage.Modules

local PlayerModule = require(Modules.PlayerModule)
local Global = require(game.ReplicatedStorage.Modules.GlobalValues)


function OnPlayerAdded(Plr : Player)
    local Player = PlayerModule.new(Plr)

    Player.Inventory:AddToInventory(1, 20)

    Player.Inventory:RemoveFromInventory(1, 5)
    Player.Inventory:AddToInventory(2, 10)
end


local XPPart = Instance.new("Part", workspace)
XPPart.Position = Vector3.new(0,0,10)


XPPart.Touched:Connect(function(hit)
    local Plr = game.Players:GetPlayerFromCharacter(hit.Parent)
    if not Plr then return end

    local Plr = PlayerModule.FindPlayer(Plr.UserId)
    if not Plr then return end

    Plr:GiveXP(20)
    print(Plr.Expirience, Plr.Level)
end)


function OnUpdate(Dt)
    for i, Plr : Global.PlayerClass in PlayerModule.PlayerList do
        Plr:OnUpdate(1)
        Plr.Inventory:AddToInventory(math.random(1,2), math.random(0,3))
    end
end

game.Players.PlayerAdded:Connect(OnPlayerAdded)

while true do
    local Dt = task.wait(1)
    OnUpdate(Dt)
end


