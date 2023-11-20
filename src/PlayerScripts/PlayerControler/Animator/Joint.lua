export type JointClass = {
    __index : any,
    Part : BasePart,
    CanMove : boolean,

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
        CanMove = true
    }

    return setmetatable(jont, Joint)
end


function Joint:GetCFrame()
    return self.Part.CFrame
end

function Joint:SetCFrame(Cf)
    if not self.CanMove then return end
    self.Part.CFrame = Cf
end


return Joint