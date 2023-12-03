local Runservice = game:GetService("RunService")
local DinoController = require(script.Parent:WaitForChild("DinoController"))

print("--- Loaded ---")

DinoController.SpawnDino("Default")

Runservice.RenderStepped:Connect(function(DeltaTime)
    DinoController.OnUpdate()
end)