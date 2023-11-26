local Classes = require(script.Parent.classes)
local Debugger = require(script.Parent.Debug)

local Joint = {} :: Classes.JointClass
Joint.__index = Joint


function Joint.new(Part)
    local joint = {
        Part = Part,
        CanMove = true,
        Position = Part.CFrame,
        Parent = nil,
        Offset = CFrame.new(),
        Children = {},
        Parents = {},
    }

    local res = setmetatable(joint, Joint)
    Debugger:AddJoint(res)

    return res
end


function Joint:GetCFrame()
    return self.Position
end


function Joint:SetCFrame(Cf)
    if not self.CanMove then return end
    self.Position = Cf 
    self.Part.CFrame = self.Position
end

return Joint