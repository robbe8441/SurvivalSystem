----- Modules -----
local DatastoreModule = require(script.Parent.Datastore)
local Events = require(script.Parent.Events)
local GlobalVal = require(game.ReplicatedStorage.Modules.GlobalValues)

--------------------------------- // Variables \\ ---------------------------------

local DefaultPlayerData = GlobalVal.DefaultPlayerData
local Player = {} :: GlobalVal.PlayerClass
Player.__index = Player
Player.PlayerList = {}


local SendDataRemote = game.ReplicatedStorage:FindFirstChild("UpdatePlayerDataRemote") or Instance.new("RemoteEvent")
SendDataRemote.Parent = game.ReplicatedStorage
SendDataRemote.Name = "UpdatePlayerDataRemote"


local IgnoreOnSave = {
    "HealthChanged",
    "UserId",
}


--------------------------------- // HandleData \\ ---------------------------------


function Player.new(Plr : Player) : GlobalVal.PlayerClass
    local Datastore = DatastoreModule.new("PlayerData", Plr.UserId)

    while Datastore.State == false do
        if Datastore:Open(DefaultPlayerData) ~= DatastoreModule.Response.Success then task.wait(6) end
    end

    Datastore.Value = DefaultPlayerData --- // Overwrite data for testing

    local data = Datastore.Value

    data.HealthChanged = Events.new()
    data.UserId = Plr.UserId

    setmetatable(data, Player)
    Player.PlayerList[Plr.UserId] = data

    return data
end



function Player:SaveData()
    local Datastore = DatastoreModule.find("Player", self.UserId)
    local ToSave = table.clone(self)

    for i,v in IgnoreOnSave do
        ToSave[v] = nil
    end

    Datastore.Value = ToSave
    return self
end



function Player:Destroy()
    self:SaveData()
    local Datastore = DatastoreModule.find("Player", self.UserId)
    if Datastore ~= nil then Datastore:Destroy() end
end


function Player.FindPlayer(Val : string | number) : (GlobalVal.PlayerClass & typeof(Player))?
    local id = type(Val) == "number" and Val or game.Players:FindFirstChild(Val)
    if not id then return end

    return Player.PlayerList[id]
end



--------------------------------- // Functions \\ ---------------------------------

function Player:OnUpdate(DeltaTime)
    local Change = DeltaTime * self.Stress

    self.Food = math.clamp(self.Food - Change, 0, self.MaxFood)
    self.Water = math.clamp(self.Water - Change, 0, self.MaxFood)

    local TemperatureIsRight = self.Tempearture > 30 and self.Tempearture < 40

    if self.Food <= 0 or self.Water <= 0 or not TemperatureIsRight then 
        self:ChangeHealth(-Change)
    end

    local plr = game.Players:GetPlayerByUserId(self.UserId)
    if not plr then return end
    SendDataRemote:FireClient(plr, self)
end



function Player:GiveXP(ammout : number)
    local NextLevelXP = (self.Level * 100) ^ 0.8
    self.Expirience += ammout

    if self.Expirience >= NextLevelXP then
        self.Level += 1
        self.Expirience = math.floor(self.Expirience - NextLevelXP)
    end

    return self.Level, self.Expirience
end



function Player:ChangeHealth(ammout : number)
    self.Health = math.clamp(self.Health + ammout, 0, self.MaxHealth)
    self.HealthChanged:Fire()

    return self.Health
end


return Player