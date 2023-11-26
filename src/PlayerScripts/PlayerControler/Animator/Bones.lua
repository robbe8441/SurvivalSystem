local classes = require(script.Parent.classes)
local Debugger = require(script.Parent.Debug)

local Bone = {} :: classes.BoneClass
Bone.__index = Bone

function ApplyMaxAngle(origin:CFrame, goal:CFrame, minAngles:Vector3, maxAngles:Vector3)
    local relativeCFrame = origin:ToObjectSpace(goal)
    local rx, ry, rz = relativeCFrame:ToOrientation()

    return origin * CFrame.fromOrientation(
        math.clamp(rx,math.rad(minAngles.X), math.rad(maxAngles.X)),
        math.clamp(ry,math.rad(minAngles.Y), math.rad(maxAngles.Y)),
        math.clamp(rz,math.rad(minAngles.Z), math.rad(maxAngles.Z)))
end


function Bone.new(Joint0:classes.JointClass, Joint1:classes.JointClass)
    local p0 = Joint0:GetCFrame()
    local p1 = Joint1:GetCFrame().Position

    local length = (p0.Position - p1).Magnitude
    local DefaultRotation = p0:ToObjectSpace(CFrame.lookAt(p0.Position,p1)).Rotation

    local b = {
        Connection0 = Joint0,
        Connection1 = Joint1,
        length = length,

        MinAngles = Vector3.new(0,-45,0),
        MaxAngles = Vector3.new(0,45,0),

        DefaultRotation = CFrame.new(),
    }

    local res = setmetatable(b, Bone)
    table.insert(Joint0.Children, res)
    table.insert(Joint1.Parents, res)
    
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
    local Rotation = p0 * CFrame.lookAt(p0.Position, p1.Position)
    Rotation = ApplyMaxAngle(p0.Rotation, Rotation.Rotation, self.MinAngles, self.MaxAngles)

    local Point1 = (CFrame.new(p0.Position) * Rotation) * CFrame.new(0,0,-self.length)

    self.Connection1:SetCFrame(Point1)
end


function Bone:GetCenterCFrame()
    local p0 = self.Connection0:GetCFrame()
    local p1 = self.Connection1:GetCFrame()
    return CFrame.lookAt(p0.Position:Lerp(p1.Position, 0.5), p1.Position)
end


return Bone