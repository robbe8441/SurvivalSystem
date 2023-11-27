export type JointClass = {
    __index : any,
    Part : BasePart,
    CanMove : boolean,
    OnlyRotate : boolean,
    Position : CFrame,
    Parent : JointClass,
    Offset : CFrame,

    Children : {BoneClass},
    Parents : {BoneClass},

    new : (Part : BasePart) -> JointClass,
    GetCFrame : (self:JointClass) -> CFrame,
    SetCFrame : (self:JointClass, CFrame) -> (),
}

export type BoneClass = {
    __index : any,
    Connection0 : JointClass,
    Connection1 : JointClass,
    length : number,

    MinAngles : Vector3,
    MaxAngles : Vector3,

    new : (Joint0 :JointClass , Joint1 :JointClass) -> BoneClass,
    UpdateP0 : (self:BoneClass) -> (),
    UpdateP1 : (self:BoneClass) -> (),
    GetCenterCFrame : (self:BoneClass) -> CFrame,
    GetRootCFrame : (self:BoneClass) -> CFrame,
}


export type TentacleClass = {
    __index : any,
    RootJoint : JointClass,
    LastJoint : JointClass,
    length : number,
    Bones : {BoneClass},
    TargetPosition : Vector3,

    new : (Model:Model) -> TentacleClass,
    Update : (self:TentacleClass) -> (),
    AddBone : (self:TentacleClass, BoneClass) -> (),
    IsBeingRendered : (self:TentacleClass) -> boolean
}


export type AnimatorClass = {
    __index : any,
    Tentacles : {TentacleClass?},

    LeftArm : TentacleClass?,
    RightArm : TentacleClass?,
    LeftLeg : TentacleClass?,
    RightLeg : TentacleClass?,

    new : () -> AnimatorClass,
    SetupRigToIK : (self:AnimatorClass, Model) -> (),
    Update : (self:AnimatorClass) -> (),
    GetTentacleByPartName : (self:AnimatorClass, Name:string) -> TentacleClass?
}




return 0