local Runservice = game:GetService("RunService")
local Controller = require(script.Parent:WaitForChild("PlayerControler"))


Runservice.PreRender:Connect(function(DeltaTime)
    Controller.Update(DeltaTime)
end)