type CameraType = "Standart" | "RobloxDefault"

export type CameraClass = {
    __index : any,
    Type : CameraType,
    Subject : BasePart,
    MaxZoom : number,
    MinZoom : number,
    Sensitivity : number,

    xPosition : number,
    yPosition : number,
    Zoom : number,
    ZoomSmoothing : number,

    CameraOffset : Vector3,

    new : (Subject : BasePart) -> CameraClass,
    Update : (self:CameraClass, DeltaTime:number) -> (),
}


local Camera = {} :: CameraClass
Camera.__index = Camera
local UIS = game:GetService("UserInputService")
local MouseWheelInput = 0

local cam = workspace.CurrentCamera

--------------------------------- // Functions \\ ---------------------------------


---- Input ----
function GetMouseDelta()
    return UIS:GetMouseDelta()
end


---- Math ----
function lerp(a, b, t)
    return a + (b - a) * t
end


--------------------------------- // Main Camera \\ ---------------------------------

function Camera.new(Subject) : CameraClass
    cam.CameraType = Enum.CameraType.Scriptable

    local res = {
        Type = "Standart",
        Subject = Subject,
        MaxZoom = 20,
        MinZoom = 2,
        Sensitivity = 0.5,

        xPosition  = 0,
        yPosition = 0,
        Zoom = 5,
        ZoomSmoothing = 8,

        CameraOffset = Vector3.new(2,0,0),
    }

    return setmetatable(res, Camera)
end



function Camera:Update(DeltaTime)
    
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    else
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end


    local Input = GetMouseDelta() * math.rad(self.Sensitivity)

    self.xPosition = self.xPosition + Input.X
    self.yPosition = math.clamp(self.yPosition - Input.Y, math.rad(10), math.rad(170))

    local x = math.sin(self.yPosition) * math.cos(self.xPosition)
    local z = math.sin(self.yPosition) * math.sin(self.xPosition)
    local y = math.cos(self.yPosition)

    MouseWheelInput = math.clamp(MouseWheelInput, self.MinZoom, self.MaxZoom)
    self.Zoom = lerp(self.Zoom, MouseWheelInput, DeltaTime * self.ZoomSmoothing)

    local Pos = self.Subject.Position + Vector3.new(x, y, z) * self.Zoom

    cam.CFrame = CFrame.new(Pos, self.Subject.Position) * CFrame.new(self.CameraOffset)
end


UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        MouseWheelInput -= input.Position.Z
    end
end)


return Camera