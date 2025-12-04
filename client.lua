local SpawnedTrees = {}
local QBCore, ESX
local SupressMessage = false
local TractionMultiplier = 1.0

-- =========================
--  Message Suppression
-- =========================
local function SetMessageTimeout()
    if Config.SupressMessageAfterSeconds then 
        TriggerServerEvent("DaChristmas:SupressMessage")
    end 
end 

RegisterNetEvent("DaChristmas:SupressMessage:client", function()
    SupressMessage = true
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    SetMessageTimeout()
end)

-- =========================
--  Framework Detection
-- =========================
CreateThread(function()
    while not (ESX or QBCore) do
        if GetResourceState('es_extended') == 'started' then
            ESX = exports["es_extended"]:getSharedObject()

            AddEventHandler('playerSpawned', function()
                SetMessageTimeout()
            end)
        elseif GetResourceState('qb-core') == 'started' then 
            QBCore = exports["qb-core"]:GetCoreObject()

            RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
                SetMessageTimeout()
            end)
        end
        Wait(500)
    end

    -- falls Resource später startet, einmalig auslösen
    SetMessageTimeout()
end)

-- =========================
--  Weather & Snow Effects
-- =========================
CreateThread(function()	
    if not Config.ForceWeather then return end

    while true do
        ForceSnowPass(true)

        if Config.SnowFallOnly then
            ForceSnowPass(false)
            local weather = "BLIZZARD"  -- or "SNOWLIGHT"
            SetWeatherTypeNowPersist(weather)
            SetOverrideWeather(weather)
            SetForcePedFootstepsTracks(false)
            SetForceVehicleTrails(false)
        else
            local weather = Config.Weather
            if weather and weather ~= "" then
                SetWeatherTypeNowPersist(weather)
                SetOverrideWeather(weather)
            end
            SetForcePedFootstepsTracks(true)
            SetForceVehicleTrails(true)
        end

        Wait(5000)
    end
end)

-- =========================
--  Traction / Grip Handling
-- =========================
CreateThread(function()
    if Config.RemoveTraction == 1.0 then
        return
    end

    while true do
        Wait(1000)

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            goto continue
        end

        local veh = GetVehiclePedIsIn(ped, false)
        if not DoesEntityExist(veh) then
            goto continue
        end

        local model = GetEntityModel(veh)
        if Config.BlacklistedVehicle[model] then
            goto continue
        end

        if Config.UseFreezingRain and (ESX or QBCore) then
            if ESX then 
                ESX.TriggerServerCallback('DaChristmas:getMultiplier', function(mult)
                    TractionMultiplier = mult or Config.RemoveTraction
                end)
            else
                QBCore.Functions.TriggerCallback('DaChristmas:getMultiplier', function(mult)
                    TractionMultiplier = mult or Config.RemoveTraction
                end)
            end
        else
            TractionMultiplier = Config.RemoveTraction
        end

        if Config.BetterTractionOnOffRoadWheels then
            local wheelType = GetVehicleWheelType(veh)
            if wheelType == 4 then -- OFFROAD
                if Config.RemoveTraction >= 2.0 then 
                    TractionMultiplier = Config.RemoveTraction / 2
                else
                    TractionMultiplier = 1.0
                end
            end
        end

        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', 1.0 * TractionMultiplier)
        ::continue::
    end
end)

-- =========================
--  Snowball System
-- =========================
CreateThread(function()
    if not Config.EnableSnowBalls or Config.SnowBallAmount <= 0 or Config.SnowFallOnly == true then
        return
    end

    RequestAnimDict('anim@mp_snowball')
    while not HasAnimDictLoaded('anim@mp_snowball') do
        Wait(0)
    end

    while true do
        Wait(0)

        local ped = PlayerPedId()

        if not IsPedInAnyVehicle(ped, true)
        and not IsPlayerFreeAiming(PlayerId())
        and not IsPedSwimming(ped)
        and not IsPedSwimmingUnderWater(ped)
        and not IsPedRagdoll(ped)
        and not IsPedFalling(ped)
        and not IsPedRunning(ped)
        and not IsPedSprinting(ped)
        and GetInteriorFromEntity(ped) == 0
        and not IsPedShooting(ped)
        and not IsPedUsingAnyScenario(ped)
        and not IsPedInCover(ped, false)
        then
            if IsControlJustReleased(0, 51) then -- E

                TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, 2000, 49, 1.0, 0, 0, 0)
                Wait(500)

                
                if Config.SnowballAsItem then 
                    TriggerServerEvent('DaChristmas:addSnowballItem')
                else
                    GiveWeaponToPed(ped, `WEAPON_SNOWBALL`, Config.SnowBallAmount, false, true)
                end 
            end

            if not SupressMessage and Config.DisplaySnowballHelp then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(Translation[Config.Locale]['snowball_help_text'])
                EndTextCommandDisplayHelp(0, 0, 1, -1)	
            end 
        end
    end 
end)

-- =========================
--  Tree Spawning
-- =========================
CreateThread(function()
    for _, v in pairs(Config.Trees) do 
        local model = v.model
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
		
        for _, coord in pairs(v.coords) do
            local vec = coord.vec
            local obj = CreateObject(model, vec.x, vec.y, vec.z - 1.0, false, true, true)
            FreezeEntityPosition(obj, true)
            table.insert(SpawnedTrees, obj)
        end 

        SetModelAsNoLongerNeeded(model)
    end 
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for _, obj in pairs(SpawnedTrees) do
        if DoesEntityExist(obj) then
            DeleteObject(obj)
        end
    end 
end)
