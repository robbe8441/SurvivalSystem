local GlobalVal = require(game.ReplicatedStorage.Modules.GlobalValues)
local Events = require(game.ReplicatedStorage.Modules.Events)

local Inventory = {} :: GlobalVal.InventoryClass
Inventory.__index = Inventory


function Inventory.new()
    local data = {
        Inventory = {},
        InventoryChanged = Events.new()
    }

    return setmetatable(data, Inventory)
end



function Inventory:AddToInventory(itemId:number, count:number?)
    self.InventoryChanged:Fire()

    count = count or 1
    local template = GlobalVal.Items[itemId]
    if not template then warn("Template does not exist") return end

    for i,v in self.Inventory do
        if v.itemId ~= itemId then continue end
        local fill = template.MaxStack - v.count
        v.count = math.min(template.MaxStack, v.count + count)
        count -= fill
        if count <= 0 then return end
    end


    for i=1, math.floor(count / template.MaxStack) do
        local item : GlobalVal.ItemClass = {count = template.MaxStack, itemId = itemId}
        table.insert(self.Inventory, item)
    end

    local remaining = count - math.floor(count / template.MaxStack) * template.MaxStack
    if remaining == 0 then return end

    local item : GlobalVal.ItemClass = {count = remaining, itemId = itemId}
    table.insert(self.Inventory, item)
end


function Inventory:RemoveFromInventory(itemId:number, count:number?) : boolean
    local OwnedItems = 0
    for i,v in self.Inventory do
        if v.itemId ~= itemId then continue end
        OwnedItems += v.count
    end

    if OwnedItems < count then return false end

    for i,v in self.Inventory do
        if v.itemId ~= itemId then continue end
        if count == v.count then self.Inventory[i] = nil; break end
        if count > v.count then self.Inventory[i] = nil; count -= v.count continue end
        local Remove = v.count
        v.count -= count
        count -= Remove
        if count <= 0 then break end
    end

    self.InventoryChanged:Fire()
    return true
end


function Inventory:CalculateWeight()
    local weight = 0

    for i,v in self.Inventory do
        local temp = GlobalVal.Items[v.itemId]
        weight += temp.Weight * v.count
    end

    return weight
end


function Inventory:MoveStack(NewInv, Index)
    local item = self[Index]
    table.insert(NewInv, item)
    self[Index] = nil
    self.InventoryChanged:Fire()
end


function SpawnItem(Position, ItemId, Count)
    if Count <= 0 then return end

    local new = Instance.new("Part")
    new.Position = Position
    new.Size = Vector3.one
    new:SetAttribute("ItemId", ItemId)
    new:SetAttribute("Count", Count)

    new.Parent = workspace
end


function Inventory:SpawnItem(Position, ItemId, Count)
    local temp = GlobalVal.Items[ItemId]

    for i=1, math.floor(Count / temp.MaxStack) do
        SpawnItem(Position, ItemId, temp.MaxStack)
    end

    local remaining = Count - math.floor(Count / temp.MaxStack) * temp.MaxStack
    SpawnItem(Position, ItemId, remaining)
end



return Inventory