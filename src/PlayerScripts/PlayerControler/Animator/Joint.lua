local Classes = require(script.Parent.classes)

local Joint = {} :: Classes.JointClass
Joint.__index = Joint

local Debugger = require(script.Parent.Debug)

function Joint.new(Part)
    local jont = {
        Part = Part,
        Connections = {},
        CanMove = true,
        Position = Part.CFrame,
        Parent = nil,
    }

    
    local res = setmetatable(jont, Joint)
    Debugger:AddJoint(res)
    
    return res
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