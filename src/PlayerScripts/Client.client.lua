local Runservice = game:GetService("RunService")
local Controller = require(script.Parent:WaitForChild("PlayerControler"))

local plr = game.Players.LocalPlayer


local Joint = Controller.Animator.Joint
local Bones = Controller.Animator.Bones

local JointsList = {}
local BonesList = {}

for i=1, 100 do
    local p = Instance.new("Part", workspace.IKTest)
    p.Anchored = true
    local Joint = Joint.new(p)
    p.CFrame *= CFrame.new(0,60,4 * i)
    if i==1 then Joint.CanMove = false end
    p.Name = tostring(i)

    table.insert(JointsList, Joint)
end

local LastJoint = 1

for i=2, #JointsList do
    local Bone = Bones.new(JointsList[LastJoint], JointsList[i])
    LastJoint = i
    table.insert(BonesList, Bone)
end


Runservice.RenderStepped:Connect(function(DeltaTime)
    Controller.Update(DeltaTime)
    
    local Char = plr.Character or plr.CharacterAdded:Wait()

    for i=#BonesList, 1, -1 do
        local v = BonesList[i]
        v:UpdateP1()
    end

    for i=1, #BonesList do
        local v = BonesList[i]
        v:UpdateP0()
    end
end)