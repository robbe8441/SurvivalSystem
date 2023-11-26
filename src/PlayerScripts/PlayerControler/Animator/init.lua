local JointModule = require(script.Joint)
local BoneModule = require(script.Bones)
local Debug = require(script.Debug)
local TentacleModule = require(script.Tentacle)
local classes = require(script.classes)

local IKIgnoredParts = {"HumanoidRooPart", "UpperTorso", "LowerTorso"}

local Animator = {} :: classes.AnimatorClass
Animator.__index = Animator

function Animator.new()
    return setmetatable({
        Tentacles = {}
    }, Animator)
end



local function ConnectJoints(Root: classes.JointClass, RootTable, CurrentTable: {classes.BoneClass}?, IsTentacle: boolean?)
    for _,v in ipairs(Root.Children) do
        IsTentacle = #Root.Children == 1

        local Current = IsTentacle and CurrentTable or {}
        table.insert(Current, v)
        ConnectJoints(v.Connection1, RootTable, Current, IsTentacle)
        if not  IsTentacle then v.Connection0.CanMove = false end

        if not IsTentacle then table.insert(RootTable, Current) end
    end
    return RootTable
end


function Animator:GetTentacleByPartName(Name)
    for _,tent in ipairs(self.Tentacles) do
        for _,v in ipairs(tent.Bones) do
            if v.Connection0.Part.Name == Name or v.Connection1.Part.Name == Name then return tent end
        end
    end
end



function Animator:SetupRigToIK(Character)
    local Hum : Humanoid = Character:WaitForChild("Humanoid")
    Hum.BreakJointsOnDeath = false
    Hum.RequiresNeck=false

    local Joints = {}
    local JointPairs = {}
    local Bones = {}

    for _,v:Motor6D in Character:GetDescendants() do
        if not v:IsA("Motor6D") then continue end

        local Part0 = v.Part0
        local Part1 = v.Part1

        local Joint0 = Joints[Part0] or JointModule.new(Part0)
        Joints[Part0] = Joint0
        local Joint1 = Joints[Part1] or JointModule.new(Part1)
        Joints[Part1] = Joint1

        if table.find(IKIgnoredParts, Part0.Name) then Joint0.CanMove = false end

        local Bone = BoneModule.new(Joint0, Joint1)
        Bone.MinAngles = Vector3.one * -1200
        Bone.MaxAngles = Vector3.one * 1200
        table.insert(Bones, Bone)

        table.insert(JointPairs, {Joint0, Joint1})
        v:Destroy()
    end

    local LowerTorso = Character:WaitForChild("LowerTorso")
    local Joint = Joints[LowerTorso]

    local tab = ConnectJoints(Joint, {})

    for _,tent in tab do
        local Tentacle = TentacleModule.new()

        for _,v in tent do
            Tentacle:AddBone(v)
        end
        Tentacle.RootJoint = Tentacle.Bones[1].Connection0
        table.insert(self.Tentacles, Tentacle)
    end

    self.RightArm = self:GetTentacleByPartName("RightHand")
    self.LeftArm = self:GetTentacleByPartName("LeftHand")
    self.RightLeg = self:GetTentacleByPartName("RightFoot")
    self.LeftLeg = self:GetTentacleByPartName("LeftFoot")
end


function Animator:Update()
    Debug:Update()

    for _,v in ipairs(self.Tentacles) do
        v:Update()
        v.TargetPosition = workspace.TargetPart.CFrame.Position
    end

    if self.LeftArm then self.LeftArm.TargetPosition = workspace.ArmTarget.Position end
end


return Animator