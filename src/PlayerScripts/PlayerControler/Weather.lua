local Module = {}
local Hour = 60 * 60

Module.Settings = {
    Clouds = 0,
    Fog = 0,
    Wind = 0,
    TimeOffset = 0
}





function GetNoise(pos:Vector3, size:number)
    local noise = math.noise(pos.X/size, pos.Y/size, pos.Z/size)
    return math.clamp(noise+0.5, 0, 1)
end



function Module:Update()
    local Position = workspace.CurrentCamera.CFrame.Position
    Position += Vector3.one * (math.sin(tick()/500) * 3000)

    self.Settings.Fog = math.max(GetNoise(Position, 1000) / 2, 0.3)
    self.Settings.Clouds = GetNoise(Position, 2000)
    self.Wind = GetNoise(Position, 100)

    local Atmosphere : Atmosphere = game.Lighting:WaitForChild("Atmosphere")
    local Clouds : Clouds = workspace.Terrain:WaitForChild("Clouds")

    Clouds.Cover = self.Settings.Clouds
    Atmosphere.Density = self.Settings.Fog

    local Time = (self.Settings.TimeOffset + tick() * 100) % 1000000
    game.Lighting.TimeOfDay = os.date("%X", Time)

    workspace.GlobalWind = Vector3.one * (self.Wind * 30)
end


return Module