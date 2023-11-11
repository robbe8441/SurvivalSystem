local Modules = game.ServerStorage.Modules

local PlayerModule = require(Modules.PlayerModule)
local Global = require(game.ReplicatedStorage.Modules.GlobalValues)


function OnPlayerAdded(Plr : Player)
    local Player = PlayerModule.new(Plr)

    Player:AddToInventory(1, 500)
    print(Player.Inventory)

    local succ = Player:RemoveFromInventory(1, 5)

    task.wait(5)
    local succ = Player:RemoveFromInventory(1, 400)
    warn(succ)
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
    end
end

game.Players.PlayerAdded:Connect(OnPlayerAdded)

while true do
    local Dt = task.wait(0.3)
    OnUpdate(1)
end


