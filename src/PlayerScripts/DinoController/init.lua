local AnimatorModule = require(script.Animator)
local Classes = require(script.Animator.classes)
local Module = {}
local Functions = {}
local CurrentlySpawned = {}


function Module.SpawnDino(name : string)
    local Model = game.ReplicatedStorage.Dinos:WaitForChild(name, 10)
    if not Model then return end
    Model = Model:Clone()

    local Animator = AnimatorModule.new()
    Animator:SetupRigToIK(Model)
    Functions.Default(Animator)

    Model.Parent = workspace
    table.insert(CurrentlySpawned, Animator)
end


function Module.OnUpdate()
    for i,v in ipairs(CurrentlySpawned) do
        v:Update()
    end
end


local function GetTentacles(Animator:Classes.AnimatorClass, input) : {[string|number] : Classes.TentacleClass}
    for i,v in pairs(input) do
        input[i] = Animator:GetTentacleByPartName(v)
    end
    return input
end



local function GetLegPosition(Origin:Vector3, Target : Vector3, LegLength : number)
    if not (Origin and Target and LegLength) then return end
    local direction = (Origin - Target).Unit
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Include
    Params.FilterDescendantsInstances = {workspace.Terrain}

    local Ray = workspace:Spherecast(Origin, 2, direction*LegLength)
    if not Ray then return end
    return Ray.Position
end



function Functions.Default(Animator : Classes.AnimatorClass)
    Animator.StoredValues = GetTentacles(Animator, {
        Neck = "Head",
        FrontRight = "FrontRight",
        FrontLeft = "FrontLeft",
        BackLeft = "BackLeft",
        BackRight = "BackRight"})
    local val = Animator.StoredValues.FrontRight

    Animator.CallOnUpdate = function()
        val.TargetPosition = GetLegPosition(val.RootJoint:GetCFrame().Position, workspace:WaitForChild("LFTarget").Position, val.length)
    end
end 






return Module