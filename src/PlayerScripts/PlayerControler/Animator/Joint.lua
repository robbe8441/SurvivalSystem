local Classes = require(script.Parent.classes)

local Joint = {} :: Classes.JointClass
Joint.__index = Joint

local Debugger = require(script.Parent.Debug)

function Joint.new(Part)
    local jont = {
        Part = Part,
        CanMove = true,
        Position = Part.CFrame,
        Parent = nil,
        Offset = CFrame.new()
    }

    local res = setmetatable(jont, Joint)
    Debugger:AddJoint(res)

    return res
end


function Joint:GetCFrame()
    return self.Position
end


function Joint:SetCFrame(Cf)
    if not self.CanMove then return end
    self.Position = Cf * self.Offset:Inverse()
    self.Part.CFrame = self.Position
end

return Joint