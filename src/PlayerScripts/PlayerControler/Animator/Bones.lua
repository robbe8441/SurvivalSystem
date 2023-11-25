local classes = require(script.Parent.classes)
local Debugger = require(script.Parent.Debug)

local Bone = {} :: classes.BoneClass
Bone.__index = Bone

function ApplyMaxAngle(origin:CFrame, goal:CFrame)
    local relativeCFrame = goal:ToObjectSpace(origin)
    local MaxAngle = math.rad(45)

    local rx, ry, rz = relativeCFrame:ToOrientation()

    return CFrame.fromOrientation(
        math.clamp(rx, -MaxAngle, MaxAngle),
        math.clamp(ry, -MaxAngle, MaxAngle),
        math.clamp(rz, -MaxAngle, MaxAngle)
    ) * origin
end


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
    }

    local res = setmetatable(b, Bone)
    Debugger:AddBone(res)
    return res
end


function Bone:UpdateP0()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    local Rotation = CFrame.lookAt(p1.Position,p0.Position).Rotation
    
    local Point0 = (CFrame.new(p1.Position) * Rotation) * CFrame.new(0,0,-self.length)
    
    self.Connection0:SetCFrame(Point0)
end


function Bone:UpdateP1()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    local Rotation = CFrame.lookAt(p0.Position, p1.Position, p0.UpVector).Rotation
    Rotation = ApplyMaxAngle(p0.Rotation, Rotation)
    
    local Point1 = (CFrame.new(p0.Position) * Rotation) * CFrame.new(0,0,-self.length)
    
    self.Connection1:SetCFrame(Point1)
end


function Bone:GetCenterCFrame()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    return CFrame.lookAt(p0.Position:Lerp(p1.Position, 0.5), p1.Position)
end


return Bone