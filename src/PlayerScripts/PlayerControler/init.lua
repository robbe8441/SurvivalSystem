local Player = game.Players.LocalPlayer
local Modules = game.ReplicatedStorage.Modules

local Events = require(Modules.Events)
local CameraModule = require(script.Camera)
local GuiHandler = require(script.GuiHandler)
local Networking = require(script.Networking)
local Input = require(script.input)
local Weather = require(script.Weather)
local Animator = require(script.Animator)

local Controller = {}
Controller.Animator = Animator

Controller.Cam = CameraModule.new()
Controller.Cam:SetFirstPerson()

function Controller.Update(DeltaTime : number)

    Controller.Cam:Update(DeltaTime)
    GuiHandler.UpdateInv(Networking.PlayerData.Inventory.Inventory)

    GuiHandler.UpdateGui()
    Weather:Update()
end


Input:AddSub(Enum.KeyCode.C, "Camera", "InputBegan"):Connect(function()
    if Controller.Cam.isFirstPerson then Controller.Cam:SetThirdPerson() return end
    Controller.Cam:SetFirstPerson()
end)


function OnCharacterAdded(Char : Model)
    if not Char then return end

    Char.ChildAdded:Connect(function()
        Controller.Cam:UpdateAnimations()
    end)

    Char.ChildRemoved:Connect(function()
        Controller.Cam:UpdateAnimations()
    end)
end

Player.CharacterAdded:Connect(OnCharacterAdded)
OnCharacterAdded(Player.Character)


return Controller