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

local Joint = {} :: JointClass
Joint.__index = Joint


function Joint.new(Part)
    local jont = {
        Part = Part,
        Connections = {},
        CanMove = true,
        Position = Part.CFrame,
        Parent = nil,
    }

    return setmetatable(jont, Joint)
end


function Joint:GetCFrame()
    return self.Part.CFrame
end


function Joint:SetCFrame(Cf)
    if not self.CanMove then return end
    self.Position = Cf
    self.Part.CFrame = self.Position
end

return Joint