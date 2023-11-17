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
    
    CameraShakeSpeed : number,
    CameraShakeIntenity : number,
    
    CameraShakeDamping : number,
    Arms : Model?,
    
    zoomLocked : boolean,
    
    new : (Subject : BasePart) -> CameraClass,
    Update : (self:CameraClass, DeltaTime:number) -> (),
    Spawnhands : (self:CameraClass) -> (),
    DeleteHands : (self:CameraClass) ->  (),
    UpdateTool : (self:CameraClass) -> (),
    FPVCharacter : Model,
}


local Camera = {} :: CameraClass
Camera.__index = Camera
local MouseWheelInput = 0
local Input = require(script.Parent.input)
local UIS = game:GetService("UserInputService")
local Plr = game.Players.LocalPlayer

local cam = workspace.CurrentCamera

--------------------------------- // Functions \\ ---------------------------------

function lerp(a, b, t)
    return a + (b - a) * t
end


local FPVCharacter : Model = game.ReplicatedStorage:WaitForChild("Dummy"):Clone()
FPVCharacter.Parent = workspace.Terrain
local hum : Humanoid = FPVCharacter:WaitForChild("Humanoid")

local Description = game.Players:GetHumanoidDescriptionFromUserId(Plr.UserId)
hum:ApplyDescription(Description)

for i,v in FPVCharacter:GetDescendants() do
    if not v:IsA("BasePart") then continue end
    v.CanCollide = false
    v.CanTouch = false
    v.CanQuery = false
    if v.Name == "Right Arm" or v.Name == "Left Arm" then continue end
    v.Transparency = 1
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

        CameraShakeSpeed = 1,
        CameraShakeIntenity = 0,

        CameraShakeDamping = 0,

        CameraOffset = Vector3.new(2,0,0),

        zoomLocked = false
    }

    return setmetatable(res, Camera)
end



function GetNoise(x)
    local value = 0
    local frequency = 1
    local amplitude = 0.5

    for i=1, 3 do
        value += math.sin(x * frequency) * amplitude
        amplitude *= 0.5
        frequency *= 2
    end

    return value
end



function Camera:Update(DeltaTime)
    if not self.Subject then
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        self.Subject = char.PrimaryPart
    end
    
    if Input.IsKeyDown(Enum.KeyCode.LeftControl, "Camera") then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    else
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end


    local Input = Input:GetMouseDelta() * math.rad(self.Sensitivity)

    self.xPosition = self.xPosition + Input.X
    self.yPosition = math.clamp(self.yPosition - Input.Y, math.rad(10), math.rad(170))

    local x = math.sin(self.yPosition) * math.cos(self.xPosition)
    local z = math.sin(self.yPosition) * math.sin(self.xPosition)
    local y = math.cos(self.yPosition)
    
    self.CameraShakeDamping = lerp(self.CameraShakeDamping, self.CameraShakeIntenity, DeltaTime)
    cam.FieldOfView = 70 + self.CameraShakeDamping * 2
    
    local ShakeOffset = Vector3.new(
        GetNoise(os.clock() * self.CameraShakeSpeed),
        GetNoise(os.clock() * self.CameraShakeSpeed + 10),
        GetNoise(os.clock() * self.CameraShakeSpeed + 20)
    ) / 10 * self.CameraShakeDamping

    MouseWheelInput = math.clamp(MouseWheelInput, self.MinZoom, self.MaxZoom)

    if not self.zoomLocked then
        self.Zoom = lerp(self.Zoom, MouseWheelInput, DeltaTime * self.ZoomSmoothing)
    end

    local CamOffset = self.CameraOffset

    if self.Arms then 
        self.CameraShakeIntenity = 0.1
        CamOffset = Vector3.new(0, 0.5, 0);
        self.Zoom = .1;
     end

    local Pos = self.Subject.Position + Vector3.new(x, y, z) * self.Zoom
    local cf = CFrame.new(Pos, self.Subject.Position) * CFrame.new(CamOffset  + ShakeOffset)
    cam.CFrame = cf

    if not self.Arms then return end
    
    local ArmsCF = CFrame.fromMatrix(self.Subject.Position, cf.RightVector, cf.UpVector:Lerp(Vector3.new(0,1,0), 0.3)) * CFrame.new(0,-2,0)
    
    self.Arms.PrimaryPart.CFrame = ArmsCF
end


function ChangeCharacterTranspareny(num)
   local Char = Plr.Character or Plr.CharacterAppearanceLoaded:Wait()
   for i,v in Char:GetDescendants() do
        if not v:IsA("BasePart") or v.Name == "HumanoidRootPart" then continue end
        v.Transparency = num
   end
end


function Camera:Spawnhands()
    self.Arms = FPVCharacter
    ChangeCharacterTranspareny(1)
end

function Camera:DeleteHands()
    FPVCharacter:PivotTo(CFrame.new(0,1000,0))
    self.Arms = nil
    ChangeCharacterTranspareny(0)
end



UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        MouseWheelInput -= input.Position.Z
    end
end)


Camera.FPVCharacter = FPVCharacter

return Camera