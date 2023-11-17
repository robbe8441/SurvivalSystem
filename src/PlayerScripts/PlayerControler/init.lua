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
    GuiHandler.UpdateInv(Networking.PlayerData.Inventory.Inventory)
    Controller.Cam.zoomLocked = #GuiHandler.PickupPrompts > 0

    GuiHandler.UpdateGui()
    GuiHandler.UpdateItems()
end



local HoldAnim = Instance.new("Animation")
HoldAnim.AnimationId = "rbxassetid://15381985327"



Input.AddSub(Enum.KeyCode.C, "Camera", "InputBegan"):Connect(function()
    if Controller.Cam.Arms then Controller.Cam:DeleteHands() return end
    Controller.Cam:Spawnhands()
    local hum = Controller.Cam.FPVCharacter:WaitForChild("Humanoid")
    local animator : Animator = hum:WaitForChild("Animator")
    animator:LoadAnimation(HoldAnim):Play()
end)



return Controller