local Runservice = game:GetService("RunService")
--local Controller = require(script.Parent:WaitForChild("PlayerControler"))
local Animator = script.Parent:WaitForChild("PlayerControler").Animator

local TentacleModule = require(Animator.Tentacle)
local JointsModule = require(Animator.Joint)
local BonesModule = require(Animator.Bones)
local Debugger = require(Animator.Debug)

local Tentacle = TentacleModule.new()
local Joints = {}

workspace:WaitForChild("IKChar")
local TestBone = {workspace.IKChar.Part1, workspace.IKChar.Part2, workspace.IKChar.Part3}

for i,v in TestBone do
    local Joint = JointsModule.new(v)
    if i==1 then Joint.CanMove = false end
    table.insert(Joints, Joint)
end

for i=2, #Joints do
    local Bone = BonesModule.new(Joints[i-1], Joints[i])
    Tentacle:AddBone(Bone)
end

local Upper = Tentacle.Bones[1]
local Down = Tentacle.Bones[2]

Upper.MinAngles = Vector3.new(0,-30,0)
Upper.MaxAngles = Vector3.new(0,120,0)

Down.MinAngles = Vector3.new(0,-150,0)
Down.MaxAngles = Vector3.new(0,-5,0)


local plr = game.Players.LocalPlayer

Runservice.RenderStepped:Connect(function(DeltaTime)
    Tentacle:Update()
    Debugger:Update()
    Tentacle.TargetPosition = workspace:WaitForChild("TargetPartt").Position

    --Controller.Update(DeltaTime)
    
    local Char = plr.Character or plr.CharacterAdded:Wait()
end)