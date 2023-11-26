local JointModule = require(script.Joint)
local BoneModule = require(script.Bones)
local Debug = require(script.Debug)
local Tentacle = require(script.Tentacle)
local classes = require(script.classes)

local Animator = {} :: classes.AnimatorClass
Animator.__index = Animator

function Animator.new()
    return setmetatable({}, Animator)
end


function Animator:SetupRigToIK(Character)
    local Joints = {}
    local JointPairs = {}

    for i,v:Motor6D in Character:GetDescendants() do
        if not v:IsA("Motor6D") then continue end
        
        local Part0 = v.Part0
        local Part1 = v.Part1

        local Joint0 = Joints[Part0] or JointModule.new(Part0)
        Joints[Part0] = Joint0
        local Joint1 = Joints[Part1] or JointModule.new(Part1)
        Joints[Part1] = Joint1

        --Joint1.Offset = v.C0
        --Joint0.Offset = v.C1

        table.insert(JointPairs, {Joint0, Joint1})
        v:Destroy()
    end

    for i,v in ipairs(JointPairs) do
        local Bone = BoneModule.new(v[1], v[2])
    end
end


function Animator:Update()
    Debug:Update()
end


return Animator