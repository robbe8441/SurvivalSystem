local Joints = require(script.Parent.Joint)

export type BoneClass = {
    __index : any,
    Connection0 : Joints.JointClass,
    Connection1 : Joints.JointClass,
    lengh : number,
    CF : CFrame,
    MinRotation : Vector3,
    MaxRotation : Vector3,

    new : (Joint0 :Joints.JointClass , Joint1 :Joints.JointClass) -> BoneClass,
    UpdateP0 : (self:BoneClass) -> (),
    UpdateP1 : (self:BoneClass) -> (),
}


local Bone = {} :: BoneClass
Bone.__index = Bone

function Bone.new(Joint0 , Joint1)
    local p1 = Joint0:GetCFrame().Position
    local p2 = Joint1:GetCFrame().Position
    local Vector = (p1 - p2)

    local lengh = Vector.Magnitude
    local CF = CFrame.lookAt(p1,p2)

    local b = {
        Connection0 = Joint0,
        Connection1 = Joint1,
        lengh = lengh,
        CF = CF,
        MinRotation = Vector3.new(-30,-30,-30),
        MaxRotation = Vector3.new(30,30,30),
    }

    return setmetatable(b, Bone)
end

function Bone:UpdateP0()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    local Point1 = CFrame.lookAt(p0.Position, p1.Position)
    local diff = p0:ToObjectSpace(Point1)
    local rx,ry,rz = diff:ToEulerAnglesXYZ()
    local Rotation = CFrame.Angles(
        math.clamp(rx, math.rad(self.MinRotation.X), math.rad(self.MaxRotation.X)),
        math.clamp(ry, math.rad(self.MinRotation.Y), math.rad(self.MaxRotation.Y)),
        math.clamp(rz, math.rad(self.MinRotation.Z), math.rad(self.MaxRotation.Z)))

    self.Connection1:SetCFrame((p0 * Rotation) * CFrame.new(0,0,-self.lengh))
end

function Bone:UpdateP1()
    local p0 = self.Connection0:GetCFrame().Position
    local p1 = self.Connection1:GetCFrame().Position
    local Rotation = CFrame.lookAt(p0,p1).Rotation
    local Point0 = (CFrame.new(p1) * Rotation) * CFrame.new(0,0,self.lengh)

    self.Connection0:SetCFrame(Point0)
end

return Bone