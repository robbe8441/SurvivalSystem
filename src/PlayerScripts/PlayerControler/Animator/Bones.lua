local classes = require(script.Parent.classes)

local Bone = {} :: classes.BoneClass
Bone.__index = Bone

local Debugger = require(script.Parent.Debug)

function Bone.new(Joint0 , Joint1)
    local p1 = Joint0:GetCFrame().Position
    local p2 = Joint1:GetCFrame().Position
    local Vector = (p1 - p2)

    local length = Vector.Magnitude
    local CF = CFrame.lookAt(p1,p2)

    local b = {
        Connection0 = Joint0,
        Connection1 = Joint1,
        length = length,
        CF = CF,
        MinRotation = Vector3.new(-180,10,-20),
        MaxRotation = Vector3.new(180,130,20),
    }

    local res = setmetatable(b, Bone)
    Debugger:AddBone(res)
    return res
end

function Bone:UpdateP0()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    local Rotation = CFrame.lookAt(p1.Position,p0.Position).Rotation
    --Rotation = self:ApplyMaxAngle(p0, Rotation)
    
    local Point0 = (CFrame.new(p1.Position) * Rotation) * CFrame.new(0,0,-self.length)
    
    self.Connection0:SetCFrame(Point0)
end

function Bone:UpdateP1()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    local Rotation = CFrame.lookAt(p0.Position,p1.Position).Rotation
    --Rotation = self:ApplyMaxAngle(p0, Rotation)
    
    local Point1 = (CFrame.new(p0.Position) * Rotation) * CFrame.new(0,0,-self.length)
    
    self.Connection1:SetCFrame(Point1)
end

function Bone:GetCenterCFrame()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    return CFrame.lookAt(p0.Position:Lerp(p1.Position, 0.5), p1.Position)
end


function Bone:ApplyMaxAngle(p0, p1)
    local relativeCFrame = p1:ToObjectSpace(p0)

    local maxWinkel = 45

    local rx, ry, rz = relativeCFrame:ToEulerAnglesXYZ()

    local clampedCFrame = CFrame.fromEulerAnglesXYZ(
        math.clamp(rx, math.rad(-maxWinkel), math.rad(maxWinkel)),
        math.clamp(ry, math.rad(-maxWinkel), math.rad(maxWinkel)),
        math.clamp(rz, math.rad(-maxWinkel), math.rad(maxWinkel))
    )

    local resultCFrame = p0 * clampedCFrame * CFrame.new(0, 0, -self.length)
    return resultCFrame
end



return Bone