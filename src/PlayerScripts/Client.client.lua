local Runservice = game:GetService("RunService")
local Controller = require(script.Parent:WaitForChild("PlayerControler"))
local plr = game.Players.LocalPlayer


Runservice.RenderStepped:Connect(function(DeltaTime)
    Controller.Update(DeltaTime)
    
    local Char = plr.Character or plr.CharacterAdded:Wait()
    Controller.Cam.CameraShakeIntenity = Char.PrimaryPart.AssemblyLinearVelocity.Magnitude / 5
end)