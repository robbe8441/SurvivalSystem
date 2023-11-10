------------------------------- // Classes \\ -------------------------------

export type EventClass = {
    Connect: (func: () -> ()) -> (),
    Fire: () -> ()
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
    OnUpdate : (DeltaTime : number) -> (),
    Destroy : () -> (),
    SaveData : () -> (PlayerClass),

    GiveXP : (ammount : number) -> (number, number),
    ChangeHealth : (ammount : number) -> number,

    StatsChanged : EventClass,
    UserId : number,
}


------------------------------- // Storrage \\ -------------------------------

local module = {}

module.DefaultPlayerData = {
    Health = 100,
    Food = 100,
    Water = 100,
    Expirience = 0,
    Tempearture = 37,
    Stress = 5,
    Level = 0,
    Inventory = {},

    MaxHealth = 100,
    Walkspeed = 20,
    MaxWeight = 100,
    Stamina = 100,
    MaxFood = 100,
    MaxWater = 100,
}


return module