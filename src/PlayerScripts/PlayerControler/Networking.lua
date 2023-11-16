local DataEvent : RemoteEvent = game.ReplicatedStorage:WaitForChild("UpdatePlayerDataRemote")
local Global = require(game.ReplicatedStorage.Modules.GlobalValues)
DataEvent:FireServer()  -- send Event to request full Player data

local Network = {}
Network.PlayerData = table.clone(Global.DefaultPlayerData)


function Network.OnDataEvent(Data)
    if not Data then warn("No Data Passed") return end

    for i,v in pairs(Data) do
        Network.PlayerData[i] = v
    end
end

DataEvent.OnClientEvent:Connect(Network.OnDataEvent)
return Network