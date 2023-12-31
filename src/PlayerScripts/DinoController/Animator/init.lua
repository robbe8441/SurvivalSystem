local JointModule = require(script.Joint)
local BoneModule = require(script.Bones)
local TentacleModule = require(script.Tentacle)
local classes = require(script.classes)


local Animator = {} :: classes.AnimatorClass
Animator.__index = Animator

function Animator.new()
    return setmetatable({
        Tentacles = {}
    }, Animator)
end


local function ConnectJoints(Root: classes.JointClass, RootTable, CurrentTable: {classes.BoneClass}?)
    for _,v in ipairs(Root.Children) do
        local IsTentacle = #Root.Children == 1

        local Current = IsTentacle and CurrentTable or {}
        table.insert(Current, v)
        ConnectJoints(v.Connection1, RootTable, Current)
        if not IsTentacle then 
            --v.Connection0.CanMove = false 
            table.insert(RootTable, Current)
        end
    end
    return RootTable
end


function Animator:GetTentacleByPartName(Name)
    for _,tent in ipairs(self.Tentacles) do
        for _,v in ipairs(tent.Bones) do
            --print(v.Connection0.Part.Name, v.Connection1.Part.Name)
            if v.Connection0.Part.Name == Name or v.Connection1.Part.Name == Name then return tent end
        end
    end
end


function Animator:SetupRigToIK(Character)
    local Joints = {}
    local Bones = {}

    for _,v:Motor6D in Character:GetDescendants() do
        if not v:IsA("Motor6D") then continue end

        local Part0 = v.Part0
        local Part1 = v.Part1

        local Joint0 = Joints[Part0] or JointModule.new(Part0)
        Joints[Part0] = Joint0
        local Joint1 = Joints[Part1] or JointModule.new(Part1)
        Joints[Part1] = Joint1

        local Bone = BoneModule.new(Joint0, Joint1)
        Bone.MinAngles = Vector3.one * -450
        Bone.MaxAngles = Vector3.one * 450
        table.insert(Bones, Bone)

        v:Destroy()
    end

    self.RootPart = Character:WaitForChild("RootPart")
    local tab = ConnectJoints(Joints[self.RootPart], {})
    local len = #tab

    for i,tent in tab do
        local Tentacle = TentacleModule.new()
        Tentacle._weight = len - i
        for _,v in tent do
            Tentacle:AddBone(v)
        end

        Tentacle.TargetPosition = Tentacle.Bones[#Tentacle.Bones].Connection1.Position.Position
        Tentacle.RootJoint = Tentacle.Bones[1].Connection0
        --Tentacle.RootJoint._weight = math.huge
        table.insert(self.Tentacles, Tentacle)
    end

    for i,v in ipairs(self.Tentacles) do
        local Color = BrickColor.random()
        for i,a in ipairs(v.Bones) do
            a.Connection1.Part.BrickColor = Color
        end
    end
end


function Animator:Update()
    if self.CallOnUpdate then self.CallOnUpdate() end
    
    for _,v in ipairs(self.Tentacles) do
        v:Update()
    end
end


return Animator