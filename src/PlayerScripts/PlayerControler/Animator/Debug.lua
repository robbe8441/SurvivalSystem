local classes = require(script.Parent.classes)

local Debugger = {
    Joints = {},
    Bones = {},
    Enabled = true
}


function Debugger:AddJoint(Joint : classes.JointClass)
    if not self.Enabled then return end
    local p = Instance.new("Part", workspace.Terrain)
    p.Anchored = true
    p.Size = Vector3.new(0.2, 0.2, 0.5)
    p.CanCollide = false
    p.Color = Color3.fromRGB(255, 0, 0)

    table.insert(self.Joints, {Joint = Joint, Part = p})
end

function Debugger:AddBone(Bone : classes.BoneClass)
    if not self.Enabled then return end
    local p = Instance.new("Part", workspace.Terrain)
    p.Anchored = true
    p.Size = Vector3.new(0.1, 0.1, Bone.length)
    p.CanCollide = false
    p.Color = Color3.fromRGB(0, 255, 0)

    table.insert(self.Bones, {Bone = Bone, Part = p})
end

function Debugger:Update()
    if not self.Enabled then return end
    for i,v in ipairs(self.Joints) do
        v.Part.CFrame = v.Joint:GetCFrame() * CFrame.new(0,0,-0.5)
    end

    for i,v in ipairs(self.Bones) do
        v.Part.CFrame = v.Bone:GetCenterCFrame()
    end
end



return Debugger