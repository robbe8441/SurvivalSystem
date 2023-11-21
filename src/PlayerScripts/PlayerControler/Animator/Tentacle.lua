local JointModule = require(script.Parent.Joint)
local BonesModule = require(script.Parent.Bones)

export type TentacleCalass = {
    __index : any,
    RootJoint : JointModule.JointClass,
    lengh : number,
    Bones : {BonesModule.BoneClass},

    new : (Model:Model) -> TentacleCalass,
    Update : (self:TentacleCalass) -> (),
    AddBone : (self:TentacleCalass, BonesModule.BoneClass) -> (),
    IsBeingRendered : (self:TentacleCalass) -> boolean
}

local Tentacle = {} :: TentacleCalass
Tentacle.__index = Tentacle

function Tentacle.new()
    local Data = {
        lengh = 0,
        Bones = {},
        RootJoint = nil
    }

    return setmetatable(Data, Tentacle)
end

function Tentacle:AddBone(Bone)
    table.insert(self.Bones, Bone)
    self.lengh += Bone.lengh
end


function Tentacle:IsBeingRendered()
    local cam = workspace.CurrentCamera
    if not self.RootJoint then return true end
    local RootPos = self.RootJoint:GetCFrame().Position

    local LookV = CFrame.new(RootPos, cam.CFrame.Position).LookVector
    local Dot = cam.CFrame.LookVector:Dot(LookV)
    local dis = (RootPos - cam.CFrame.Position).Magnitude

    if Dot < 0 and dis < 500 then return true end
    if dis < self.lengh then return true end
    return false
end


function Tentacle:Update()
    local IsBeingRendered = self:IsBeingRendered()
    if not IsBeingRendered then return end
    --print(true)

    for i=#self.Bones, 1, -1 do
        local v = self.Bones[i]
        v:UpdateP1()
    end
    
    for i=1, #self.Bones do
        local v = self.Bones[i]
        v:UpdateP0()
    end
end




return Tentacle