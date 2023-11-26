type CameraType = "Standard"

export type CameraClass = {
    __index : any,
    Type : CameraType,
    Subject : BasePart,
    MaxZoom : number,
    MinZoom : number,
    HorizontalSensitivity : number,
    VerticalSensitivity : number,
    
    xPosition : number,
    yPosition : number,
    Zoom : number,
    ZoomSmoothing : number,
    
    CameraOffset : Vector3,
    
    CameraShakeSpeed : number,
    CameraShakeIntensity : number,
    
    CameraShakeDamping : number,
    isFirstPerson : boolean,
    
    zoomLocked : boolean,
    
    new : (Subject : BasePart) -> CameraClass,
    Update : (self:CameraClass, DeltaTime:number) -> (),
    SetFirstPerson : (self:CameraClass) -> (),
    SetThirdPerson : (self:CameraClass) ->  (),
    UpdateAnimations : (self:CameraClass) -> (),
}


local Camera = {} :: CameraClass
Camera.__index = Camera
local MouseWheelInput = 0
local Input = require(script.Parent.input)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Plr = game.Players.LocalPlayer

local cam = workspace.CurrentCamera

local IdleAnimation = Instance.new("Animation")
IdleAnimation.AnimationId = "rbxassetid://15387322700"

--------------------------------- // Functions \\ ---------------------------------

function lerp(a, b, t)
    return a + (b - a) * t
end

--------------------------------- // Main Camera \\ ---------------------------------

function Camera.new(Subject) : CameraClass
    cam.CameraType = Enum.CameraType.Scriptable

    local res = {
        Type = "Standard",
        Subject = Subject,
        MaxZoom = 20,
        MinZoom = 2,
        HorizontalSensitivity = 0.5,
        VerticalSensitivity = 0.4,

        xPosition  = 0,
        yPosition = 0,
        Zoom = 5,
        ZoomSmoothing = 8,

        CameraShakeSpeed = 1,
        CameraShakeIntensity = 0,

        CameraShakeDamping = 0,

        CameraOffset = Vector3.new(2,0,0),

        zoomLocked = false,
        isFirstPerson = false
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

local track


function Camera:Update(DeltaTime)
    local plr = game.Players.LocalPlayer
    local Char = plr.Character or plr.CharacterAdded:Wait()
    self.Subject = Char.PrimaryPart
    
    if Input:IsKeyDown(Enum.KeyCode.LeftControl, "Camera") then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    else
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end

    local Input = Input:GetMouseDelta() * Vector2.new(math.rad(self.HorizontalSensitivity), math.rad(self.VerticalSensitivity))

    self.xPosition += Input.X
    self.yPosition = math.clamp(self.yPosition - Input.Y, math.rad(10), math.rad(170))

    local x = math.sin(self.yPosition) * math.cos(self.xPosition)
    local z = math.sin(self.yPosition) * math.sin(self.xPosition)
    local y = math.cos(self.yPosition)
    
    self.CameraShakeDamping = lerp(self.CameraShakeDamping, self.CameraShakeIntensity, DeltaTime)
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

    if self.isFirstPerson then 
        self.CameraShakeIntensity = 0.1
        CamOffset = Vector3.new(0, 0.5, 0);
        self.Zoom = .1;
     end

    local Pos = self.Subject.Position + Vector3.new(x, y, z) * self.Zoom
    local cf = CFrame.new(Pos, self.Subject.Position) * CFrame.new(CamOffset  + ShakeOffset)
    cam.CFrame = cf

    local CharCf = Char:GetPivot()
    CharCf = CFrame.fromMatrix(CharCf.Position, cf.RightVector, CharCf.UpVector)
    Char:PivotTo(CharCf)

    if not track then return end
    track:AdjustSpeed(0)
    track.TimePosition = (y + 1) / 2
end


function ChangeCharacterTransparency(num)
   local Char = Plr.Character or Plr.CharacterAppearanceLoaded:Wait()
   for i,v in Char:GetDescendants() do
    if v.Parent:IsA("Tool") then continue end
        if not v:IsA("BasePart") or v.Name == "HumanoidRootPart" then continue end
        if v.Name == "Right Arm" or v.Name == "Left Arm" then continue end

        v.LocalTransparencyModifier = num
   end
end


function Camera:SetFirstPerson()
    if track then track:Stop() end

    local Char = Plr.Character or Plr.CharacterAdded:Wait()
    local hum = Char:WaitForChild("Humanoid")
    local animator : Animator = hum:WaitForChild("Animator")
    local Tool = Char:FindFirstChildWhichIsA("Tool")

    if Tool and Tool:FindFirstChild("HoldAnimation") then 
        track = animator:LoadAnimation(Tool:FindFirstChild("HoldAnimation"))
    else
        track = animator:LoadAnimation(IdleAnimation)
    end

    track.Priority = Enum.AnimationPriority.Action2
    track:Play()

    ChangeCharacterTransparency(1)
    self.isFirstPerson = true
end

function Camera:SetThirdPerson()
    if track then track:Stop() end
    self.isFirstPerson = false
    ChangeCharacterTransparency(0)
end


function Camera:UpdateAnimations()
    if self.isFirstPerson then 
        self:SetFirstPerson() 
    else
        self:SetThirdPerson()
    end
    track:AdjustSpeed(0)
end


UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        MouseWheelInput -= input.Position.Z
    end
end)


return Camera