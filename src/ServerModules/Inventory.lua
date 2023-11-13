local GlobalVal = require(game.ReplicatedStorage.Modules.GlobalValues)
local Events = require(script.Parent.Events)

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
    count = count or 1
    local template = GlobalVal.Items[itemId]
    if not template then warn("Template does not exist") return end

    for i=1, math.floor(count / template.MaxStack) do
        local item : GlobalVal.ItemClass = {count = template.MaxStack, itemId = itemId}
        table.insert(self.Inventory, item)
    end

    local remaining = count - math.floor(count / template.MaxStack) * template.MaxStack
    if remaining == 0 then return end

    local item : GlobalVal.ItemClass = {count = remaining, itemId = itemId}
    table.insert(self.Inventory, item)
    self.InventoryChanged:Fire()
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

return Inventory