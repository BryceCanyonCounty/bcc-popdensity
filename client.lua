local function devPrint(message)
    if Config.Debug then
        print("[bcc-popdensity] " .. message)
    end
end

local function cloneTable(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local defaultDensityMultipliers = cloneTable(Config.DensityMultipliers)
local densityMultipliers = cloneTable(defaultDensityMultipliers)
Config.DensityMultipliers = densityMultipliers

local function normaliseDensityMultipliers(incoming)
    if type(incoming) ~= "table" then
        return cloneTable(defaultDensityMultipliers)
    end

    local normalised = cloneTable(defaultDensityMultipliers)
    for key in pairs(normalised) do
        local value = incoming[key]
        local parsedValue = tonumber(value)
        if parsedValue then
            normalised[key] = parsedValue
        else
            devPrint(string.format("Missing or invalid multiplier '%s', using default %.2f", key, normalised[key]))
        end
    end

    return normalised
end

-- Function to apply density multipliers
local function applyDensityMultipliers()
    local multipliers = densityMultipliers

    -- Apply density multipliers using native functions
    Citizen.InvokeNative(0xC0258742B034DFAF, multipliers.ambientAnimals) -- SetAmbientAnimalDensityMultiplierThisFrame
    Citizen.InvokeNative(0xDB48E99F8E064E56, multipliers.scenarioAnimals) -- SetScenarioAnimalDensityMultiplierThisFrame
    Citizen.InvokeNative(0xBA0980B5C0A11924, multipliers.ambientHumans) -- SetAmbientHumanDensityMultiplierThisFrame
    Citizen.InvokeNative(0x28CB6391ACEDD9DB, multipliers.scenarioHumans) -- SetScenarioHumanDensityMultiplierThisFrame
    Citizen.InvokeNative(0xAB0D553FE20A6E25, multipliers.ambientPeds) -- SetAmbientPedDensityMultiplierThisFrame
    Citizen.InvokeNative(0x7A556143A1C03898, multipliers.scenarioPeds) -- SetScenarioPedDensityMultiplierThisFrame
    Citizen.InvokeNative(0xFEDFA97638D61D4A, multipliers.parkedVehicles) -- SetParkedVehicleDensityMultiplierThisFrame
    Citizen.InvokeNative(0x1F91D44490E1EA0C, multipliers.randomVehicles) -- SetRandomVehicleDensityMultiplierThisFrame
    Citizen.InvokeNative(0x606374EBFC27B133, multipliers.vehicles) -- SetVehicleDensityMultiplierThisFrame

    -- Debug prints for each multiplier
    devPrint("ambientAnimals: " .. tostring(multipliers.ambientAnimals))
    devPrint("scenarioAnimals: " .. tostring(multipliers.scenarioAnimals))
    devPrint("ambientHumans: " .. tostring(multipliers.ambientHumans))
    devPrint("scenarioHumans: " .. tostring(multipliers.scenarioHumans))
    devPrint("ambientPeds: " .. tostring(multipliers.ambientPeds))
    devPrint("scenarioPeds: " .. tostring(multipliers.scenarioPeds))
    devPrint("parkedVehicles: " .. tostring(multipliers.parkedVehicles))
    devPrint("randomVehicles: " .. tostring(multipliers.randomVehicles))
    devPrint("vehicles: " .. tostring(multipliers.vehicles))
end

-- Register event for when the player selects a character
RegisterNetEvent("vorp:SelectedCharacter", function(charid)
    devPrint("Character selected: " .. tostring(charid))
    -- Apply density multipliers on character selection
    TriggerServerEvent("bcc-popdensity:requestDensityMultipliers")
    applyDensityMultipliers()
end)

RegisterNetEvent("bcc-popdensity:updateDensityMultipliers", function(serverMultipliers)
    local normalised = normaliseDensityMultipliers(serverMultipliers)
    densityMultipliers = normalised
    Config.DensityMultipliers = normalised
    devPrint("Received density multipliers from server")
    applyDensityMultipliers()
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(250)
    end
    TriggerServerEvent("bcc-popdensity:requestDensityMultipliers")
end)

-- Main thread for continuously applying density multipliers
CreateThread(function()
    while true do
        Wait(0)
        applyDensityMultipliers() -- Apply multipliers every frame
    end
end)
