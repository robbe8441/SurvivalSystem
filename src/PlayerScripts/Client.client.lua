
local Modules = game.ReplicatedStorage.Modules
local GuiHandler = require(Modules.GuiHandler)
local GlobalVals = require(Modules.GlobalValues)

local UpdateEvent : RemoteEvent = game.ReplicatedStorage:WaitForChild("UpdatePlayerDataRemote")

local Runnservice = game:GetService("RunService")
local PlayerData : GlobalVals.PlayerClass = table.clone(GlobalVals.DefaultPlayerData)


function lerp(a, b, t)
    return a + (b - a) * t
end



Runnservice.Heartbeat:Connect(function(DeltaTime)
    for i,v in GuiHandler.Values do
        local stat = PlayerData[i]
        if not stat then continue end
        local max = PlayerData["Max" .. i] or 1

        GuiHandler.Values[i].val = lerp(GuiHandler.Values[i].val, PlayerData[i]/max, DeltaTime)
    end

    local LevlXp = PlayerData.Expirience / (PlayerData.Level * 100) ^ 0.8

    GuiHandler.Values.XP.val = lerp(GuiHandler.Values.XP.val, LevlXp , DeltaTime * 10)
    GuiHandler.UpdateGui()
end)


UpdateEvent.OnClientEvent:Connect(function(data : GlobalVals.PlayerClass)
    PlayerData = data
    GuiHandler.UpdateInv(data.Inventory)
end)