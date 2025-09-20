local function broadcastDensityMultipliers(target)
    local densityMultipliers = Config.DensityMultipliers

    if Config.Debug then
        print("[bcc-popdensity] Broadcasting density multipliers")
        for key, value in pairs(densityMultipliers) do
            print(string.format("[bcc-popdensity] %s: %s", key, tostring(value)))
        end
    end

    TriggerClientEvent("bcc-popdensity:updateDensityMultipliers", target or -1, densityMultipliers)
end

RegisterNetEvent("bcc-popdensity:syncDensityMultipliers", function()
    broadcastDensityMultipliers()
end)

RegisterNetEvent("bcc-popdensity:requestDensityMultipliers", function()
    local src = source
    if src and src ~= 0 then
        broadcastDensityMultipliers(src)
    end
end)

AddEventHandler("playerConnecting", function()
    local src = source
    if src and src ~= 0 then
        broadcastDensityMultipliers(src)
    end
end)
