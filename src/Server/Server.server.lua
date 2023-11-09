local Modules = game.ServerStorage.Modules

local PlayerModule = require(Modules.PlayerModule)


function OnPlayerAdded(Plr : Player)
    local Player = PlayerModule.new(Plr)
end


local XPPart = Instance.new("Part", workspace)


XPPart.Touched:Connect(function(hit)

    local Plr = game.Players:GetPlayerFromCharacter(hit.Parent)
    if not Plr then return end

    local Plr = PlayerModule.FindPlayer(Plr.UserId)
    if not Plr then return end

    Plr:GiveXP(20)
    print(Plr.Expirience, Plr.Level)
end)


game.Players.PlayerAdded:Connect(OnPlayerAdded)