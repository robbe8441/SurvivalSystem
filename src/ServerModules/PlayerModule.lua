----- Modules -----
local DatastoreModule = require(script.Parent.Datastore)
local Events = require(script.Parent.Events)

--------------------------------- // Classes \\ ---------------------------------

type ItemClass = {
    itemId : number,
    count : number,
    expiration : number?
}

type PlayerClass = {
    Health : number,
    Food : number,
    Expirience : number,
    Level : number,
    Inventory : {ItemClass},

    MaxHealth : number,
    Walkspeed : number,
    MaxWeight : number,
    Stamina : number,
    MaxFood : number,

    new : (Player) -> (PlayerClass),
    Destroy : () -> (),
    SaveData : () -> (PlayerClass),

    GiveXP : (number) -> (number, number),
    ChangeHealth : (number) -> number,

    HealthChanged : Events.EventClass
}



--------------------------------- // Variables \\ ---------------------------------

local Player = {} :: PlayerClass
Player.__index = Player
Player.PlayerList = {}


local DefaultPlayerData = {
    Health = 100,
    Food = 100,
    Expirience = 0,
    Level = 0,
    Inventory = {},

    MaxHealth = 100,
    Walkspeed = 20,
    MaxWeight = 100,
    Stamina = 100,
    MaxFood = 100
}


local IgnoreOnSave = {
    "HealthChanged"
}


--------------------------------- // HandleData \\ ---------------------------------


function Player.new(Plr : Player) : PlayerClass
    local Datastore = DatastoreModule.new("PlayerData", Plr.UserId)

    while Datastore.State == false do
        if Datastore:Open(DefaultPlayerData) ~= DatastoreModule.Response.Success then task.wait(6) end
    end

    Datastore.Value = DefaultPlayerData --- // Overwrite data for testing

    local data = Datastore.Value
    
    -- // Add some values
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


function Player.FindPlayer(Val : string | number) : (PlayerClass & typeof(Player))?
    local id = type(Val) == "number" and Val or game.Players:FindFirstChild(Val)
    if not id then return end

    return Player.PlayerList[id]
end



--------------------------------- // Functions \\ ---------------------------------

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
    self.Health = math.clamp(self.Health, 0, self.MaxHealth)
    self.HealthChanged:Fire()

    return self.Health
end





return Player