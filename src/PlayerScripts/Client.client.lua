local Runservice = game:GetService("RunService")
--local Controller = require(script.Parent:WaitForChild("PlayerControler"))
local Animator = script.Parent:WaitForChild("PlayerControler").Animator

local TentacleModule = require(Animator.Tentacle)
local JointsModule = require(Animator.Joint)
local BonesModule = require(Animator.Bones)
local Debugger = require(Animator.Debug)

local Tentacle = TentacleModule.new()
local Joints = {}

for i=1, 3 do
    local p = Instance.new("Part",workspace.IKTest)
    p.Size = Vector3.one * 0.5
    p.CFrame *= CFrame.new(0,65, i * 10)
    p.Anchored = true
    local Joint = JointsModule.new(p)
    table.insert(Joints, Joint)
    if i==1 then Joint.CanMove = false continue end
    Joint.Parent = Joints[1]
end

for i=2, #Joints do
    local Bone = BonesModule.new(Joints[i-1], Joints[i])
    Tentacle:AddBone(Bone)
end



local plr = game.Players.LocalPlayer

Runservice.RenderStepped:Connect(function(DeltaTime)
    Tentacle:Update()
    Debugger:Update()
    Tentacle.TargetPosition = workspace:WaitForChild("TargetPartt").Position

    --Controller.Update(DeltaTime)
    
    local Char = plr.Character or plr.CharacterAdded:Wait()
end)