local GuiHandler = require(game.ReplicatedStorage.Modules.GuiHandler)
local UpdateEvent : RemoteEvent = game.ReplicatedStorage:WaitForChild("UpdatePlayerDataRemote")




UpdateEvent.OnClientEvent:Connect(function(data)
    print(data.Health)

    for i,v in data do
        local stat = GuiHandler.Values[i]
        if not stat then continue end
        local max = data["Max" .. i] or 1

        GuiHandler.Values[i].val = v / max
    end

    GuiHandler.UpdateGui()
end)