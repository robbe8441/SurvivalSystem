local Player = game.Players.LocalPlayer
local Modules = game.ReplicatedStorage.Modules

local Events = require(Modules.Events)
local CameraModule = require(script.Camera)
local GuiHandler = require(script.GuiHandler)
local Networking = require(script.Networking)
local Input = require(script.input)

local Controller = {}

Controller.Cam = CameraModule.new()

function Controller.Update(DeltaTime : number)
    Controller.Cam:Update(DeltaTime)

    GuiHandler.UpdateGui()
    GuiHandler.UpdateItems()
    GuiHandler.UpdateInv(Networking.PlayerData.Inventory.Inventory)
end



return Controller