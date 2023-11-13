local Runnservice = game:GetService("RunService")


local Modules = game.ReplicatedStorage.Modules
local GuiHandler = require(Modules.GuiHandler)
local GlobalVals = require(Modules.GlobalValues)
local Camera = require(Modules.Camera)

local plr = game.Players.LocalPlayer
local Char = plr.Character or plr.CharacterAdded:Wait()

local cam = Camera.new(Char.PrimaryPart)
cam.CameraOffset = Vector3.new(0,0,0)

local UpdateEvent : RemoteEvent = game.ReplicatedStorage:WaitForChild("UpdatePlayerDataRemote")
local PlayerData : GlobalVals.PlayerClass = table.clone(GlobalVals.DefaultPlayerData)



function lerp(a, b, t)
    return a + (b - a) * t
end



Runnservice.PreRender:Connect(function(DeltaTime)
    cam:Update(DeltaTime)
    --GuiHandler.UpdateHudPos(DeltaTime)
    --GuiHandler.UpdateGuiLines()

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
    GuiHandler.UpdateInv(data.Inventory.Inventory)
end)