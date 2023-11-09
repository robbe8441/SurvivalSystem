local Module = {}
local BaseColor= Color3.fromRGB(255, 255, 255)
local Plr = game.Players.LocalPlayer
local Gui = Plr:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local StatsFrame = Gui:WaitForChild("PlayerStats")


Module.Values = {
    Health =    {val = 0.5, color = Color3.new(1, 0, 0.0156863),	        name = "5Helath"},
    Food =      {val = 0.5, color = Color3.new(0.0156863, 1, 0), 	        name = "4Food"},
	Stamina =   {val = 0.5, color = Color3.new(0.984314, 1, 0.00784314), 	name = "3Stamina"},
    XP =        {val = 0.5,	color = Color3.new(0, 0.984314, 1), 		    name = "1Xp"},
    Weight =    {val = 0.5,	color = Color3.new(1, 0.65098, 0.2509803),     name = "2Weight"}
}

function GetNumberSeq(v)
    local k1 = ColorSequenceKeypoint.new(0, v.color)
    local k2 = ColorSequenceKeypoint.new(math.clamp(v.val-0.05, 0.001, 0.98), v.color)
    local k3 = ColorSequenceKeypoint.new(math.clamp(v.val+0.05, 0.002, 0.99), BaseColor)
    local k4 = ColorSequenceKeypoint.new(1, BaseColor)

    return ColorSequence.new{k1, k2, k3, k4}
end

function Module.UpdateGui()
    for i,v in pairs(Module.Values) do
        v.val = math.random()
        local Frame = StatsFrame:WaitForChild(v.name)
        Frame:WaitForChild("UIGradient").Color = GetNumberSeq(v)
    end
end



return Module