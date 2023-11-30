local Runservice = game:GetService("RunService")
--local Controller = require(script.Parent:WaitForChild("PlayerControler"))
local Animator = require(script.Parent:WaitForChild("PlayerControler").Animator).new()

local plr = game.Players.LocalPlayer
local Char = plr.Character or plr.CharacterAdded:Wait()

task.wait(1)

Animator:SetupRigToIK(workspace:WaitForChild("Dino"))
print("--- Loaded ---")

Runservice.RenderStepped:Connect(function(DeltaTime)
    Animator:Update()

    --Controller.Update(DeltaTime)
end)