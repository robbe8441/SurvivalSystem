------------------------------- // Classes \\ -------------------------------

export type EventClass = {
    __index : any,
    new : () -> EventClass,
    Connect: (self:EventClass,func: () -> ()) -> (),
    Fire: (self:EventClass) -> (),
    Disconnect : (self:EventClass, EventId:number) -> ()
}

export type ItemClass = {
    itemId : number,
    count : number,
    expiration : number?
}

export type InventoryClass = {
    __index : any,
    new : () -> (InventoryClass),
    Inventory : {ItemClass},
    AddToInventory : (self:InventoryClass, itemId:number, count:number?) -> (),
    RemoveFromInventory : (self:InventoryClass, itemId:number, count:number?) -> boolean,
    CalculateWeight : (self:InventoryClass) -> number,
    MoveStack : (self:InventoryClass, NewInv:InventoryClass, index:number) -> (),
    SpawnItem : (self:InventoryClass, Position:Vector3, ItemId:number, Count:number) -> (),
    InventoryChanged : EventClass
}

export type PlayerClass = {
    __index : any,
    Health : number,
    Food : number,
    Water : number,
    Weight : number,
    Expirience : number,
    Level : number,
    Tempearture : number,
    Stress : number,

    Inventory : InventoryClass,

    MaxHealth : number,
    Walkspeed : number,
    MaxWeight : number,
    Stamina : number,
    MaxFood : number,
    MaxWater : number,

    new : (Player : Player) -> (PlayerClass),
    OnUpdate : (self:PlayerClass, DeltaTime : number) -> (),
    Destroy : (self:PlayerClass) -> (),
    SaveData : (self : PlayerClass) -> (),

    GiveXP : (self:PlayerClass, ammount : number) -> (number, number),
    ChangeHealth : (self:PlayerClass, ammount : number) -> number,

    FindPlayer : (Val : string | number) -> (PlayerClass),

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
    Stress = 0.5,
    Inventory = {Inventory = {}},

    MaxHealth = 100,
    MaxWater = 100,
    MaxWeight = 100,
    MaxFood = 100,
    MaxStamina = 100
}






module.Items = {
    [1] = {
        Weight = 0.5,
        Name = "Apple",
        assetId = "7978712756",
        expiration = 500,
        MaxStack = 10,
        Description = "dont you knwo what this is?",
        Category = 1,
    };

    [2] = {
        Weight = 0.5,
        Name = "Bannana",
        assetId = "14209254217",
        expiration = 500,
        MaxStack = 30,
        Description = "BANNANA",
        Category = 2,
    };
}


return module