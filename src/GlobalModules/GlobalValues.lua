------------------------------- // Classes \\ -------------------------------

export type EventClass = {
    new : () -> EventClass,
    Connect: (func: () -> ()) -> (),
    Fire: (self:EventClass) -> ()
}

export type ItemClass = {
    itemId : number,
    count : number,
    expiration : number?
}

export type PlayerClass = {
    Health : number,
    Food : number,
    Water : number,
    Weight : number,
    Expirience : number,
    Level : number,
    Tempearture : number,
    Stress : number,

    Inventory : {ItemClass},

    MaxHealth : number,
    Walkspeed : number,
    MaxWeight : number,
    Stamina : number,
    MaxFood : number,
    MaxWater : number,

    new : (Player : Player) -> (PlayerClass),
    OnUpdate : (self:PlayerClass, DeltaTime : number) -> (),
    Destroy : () -> (),
    SaveData : (self : PlayerClass) -> (),

    GiveXP : (self:PlayerClass, ammount : number) -> (number, number),
    ChangeHealth : (self:PlayerClass, ammount : number) -> number,

    AddToInventory : (self:PlayerClass, ItemId : number, count:number?) -> (),
    RemoveFromInventory : (self:PlayerClass, ItemId : number, count:number?) -> (boolean),
    CalculateWeight : () -> (),

    PlayerList : {PlayerClass},
    HealthChanged : EventClass,
    UserId : number,
}


------------------------------- // Storrage \\ -------------------------------

local module = {}

module.DefaultPlayerData = {
    Health = 100,
    Food = 100,
    Water = 100,
    Expirience = 0,
    Stamina = 100,
    Level = 1,
    Weight = 10,
    
    Tempearture = 37,
    Stress = 5,
    Inventory = {},

    MaxHealth = 100,
    MaxWater = 100,
    MaxWeight = 100,
    MaxFood = 100,
    MaxStamina = 100
}



type ItemTemplate = {
    Weight : number,
    Name : string,
    assetId : string,
    MaxStack : number,
    expiration : number?
}



module.Items = {
    [1] = {
        Weight = 0.5,
        Name = "Apple",
        assetId = "8221939340",
        expiration = 500,
        MaxStack = 10,
    };

    [2] = {
        Weight = 0.5,
        Name = "Bannana",
        assetId = "8860807930",
        expiration = 500,
        MaxStack = 30,
    };
}


return module