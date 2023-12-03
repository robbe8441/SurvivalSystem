local Classes = require(script.Parent.classes)

local Tentacle = {} :: Classes.TentacleClass
Tentacle.__index = Tentacle

function Tentacle.new()
    local Data = {
        length = 0,
        Bones = {},
        RootJoint = nil,
        _weight = 0,
        TargetPosition = Vector3.zero
    }

    return setmetatable(Data, Tentacle)
end

function Tentacle:AddBone(Bone)
    table.insert(self.Bones, Bone)
    self.length += Bone.length
    self.LastJoint = Bone.Connection1
    Bone.Connection1._weight = self._weight
end


function Tentacle:IsBeingRendered()
    local cam = workspace.CurrentCamera
    if not self.RootJoint then return true end
    local RootPos = self.RootJoint:GetCFrame().Position

    local LookV = CFrame.new(RootPos, cam.CFrame.Position).LookVector
    local Dot = cam.CFrame.LookVector:Dot(LookV)
    local dis = (RootPos - cam.CFrame.Position).Magnitude

    if Dot < 0 and dis < 500 then return true end
    if dis < self.length then return true end
    return false
end


function Tentacle:Update()
    local IsBeingRendered = self:IsBeingRendered()
    if not IsBeingRendered then return end
    if self.LastJoint then self.LastJoint:SetCFrame(CFrame.new(self.TargetPosition)) end

    for i=#self.Bones, 1, -1 do
        local v = self.Bones[i]
        if v.Connection0._weight > self._weight then continue end
        v:UpdateP0(self._weight)
    end

    for i=1, #self.Bones do
        local v = self.Bones[i]
        v:UpdateP1(self._weight)
    end
end




return Tentacle