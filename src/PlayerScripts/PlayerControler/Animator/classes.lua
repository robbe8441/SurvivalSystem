export type JointClass = {
    __index : any,
    Part : BasePart,
    CanMove : boolean,
    Position : CFrame,
    Parent : JointClass,

    new : (Part : BasePart) -> JointClass,
    GetCFrame : (self:JointClass) -> CFrame,
    SetCFrame : (self:JointClass, CFrame) -> (),
}

export type BoneClass = {
    __index : any,
    Connection0 : JointClass,
    Connection1 : JointClass,
    length : number,
    CF : CFrame,
    MinRotation : Vector3,
    MaxRotation : Vector3,

    new : (Joint0 :JointClass , Joint1 :JointClass) -> BoneClass,
    UpdateP0 : (self:BoneClass) -> (),
    UpdateP1 : (self:BoneClass) -> (),
    GetCenterCFrame : (self:BoneClass) -> CFrame,
    GetRootCFrame : (self:BoneClass) -> CFrame,
    ApplyMaxAngle : (self:BoneClass, CFrame, CFrame) -> CFrame
}


export type TentacleCalass = {
    __index : any,
    RootJoint : JointClass,
    LastJoint : JointClass,
    length : number,
    Bones : {BoneClass},
    TargetPosition : Vector3,

    new : (Model:Model) -> TentacleCalass,
    Update : (self:TentacleCalass) -> (),
    AddBone : (self:TentacleCalass, BoneClass) -> (),
    IsBeingRendered : (self:TentacleCalass) -> boolean
}


return 0