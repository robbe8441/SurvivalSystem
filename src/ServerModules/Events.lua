local Global = require(game.ReplicatedStorage.Modules.GlobalValues)

local Event = {} :: Global.EventClass
Event.__index = Event


function Event.new()
    return setmetatable({}, Event)
end

function Event:Connect(func: () -> ())
    table.insert(self, func)
end

function Event:Fire()
    for i,v in ipairs(self) do
        v()
    end
end

return Event