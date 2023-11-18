type PrioType = "Menu" | "Inventory" | "Hud" | "Camera"
type EventType = "InputBegan" | "InputChanged" | "InpuEnded"

local PrioList = {
    "Menu",
    "Inventory",
    "Hud",
    "Camera"
}


local UIS = game:GetService("UserInputService")
local Events = require(game.ReplicatedStorage.Modules.Events)
local Module = {}
Module.Subscriptions = {}


function Module:GetMouseDelta()
    return UIS:GetMouseDelta()
end

function Module:IsKeyDown(key : Enum.KeyCode, prio:PrioType?) : boolean
    if not prio then return UIS:IsKeyDown(key) end

    local thisPrio = table.find(PrioList, prio)
    if not thisPrio then return false end

    local List = Module.Subscriptions[key]
    if not List then return UIS:IsKeyDown(key) end

    for i,v in List do
        if i > thisPrio then return false end
    end

    return UIS:IsKeyDown(key)
end

function Module:AddSub(key : Enum.KeyCode, prio:PrioType, EventType : EventType)
    local prio = table.find(PrioList, prio)
    local sub = Module.Subscriptions[key] or {}
    if sub[prio] then return sub[prio]  end

    local Event = Events.new()
    sub[prio] = {Event=Event, Type=EventType}

    Module.Subscriptions[key] = sub
    return Event
end


UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    local sub = Module.Subscriptions[input.KeyCode]
    if not sub then return end

    local i,v = next(sub)
    if not v or v.Type ~= "InputBegan" then return end
    v.Event:Fire()
end)

return Module