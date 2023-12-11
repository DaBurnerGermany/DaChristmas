SpawnedTrees = {}

QBCore = nil
ESX = nil 

while ESX == nil and QBCore == nil do
	if GetResourceState('es_extended') == 'started' then
		ESX = exports["es_extended"]:getSharedObject()
	elseif GetResourceState('qb-core') == 'started' then 
		QBCore = exports["qb-core"]:GetCoreObject()	
	end
end 

local TractionMultiplier = nil

CreateThread(function()	
    while true and Config.ForceWeather do	
		ForceSnowPass(true)

		if Config.Weather ~= nil and Config.Weather ~= "" then 
			SetWeatherTypeNow(Config.Weather)
			SetWeatherTypeNowPersist(Config.Weather)
			SetWeatherTypeNow(Config.Weather)
			SetOverrideWeather(Config.Weather)
		end 
		
		SetForcePedFootstepsTracks(true)
		SetForceVehicleTrails(true)
		Wait(1)
	end
end)


-- edited by LuxCoding
CreateThread(function()
	while true and Config.RemoveTraction ~= 1.0 do
		if UseFreezingRain then
			if ESX ~= nil then 
				ESX.TriggerServerCallback('DaChristmas:getMultiplier', function(Multiplier) 
					TractionMultiplier = Multiplier
				end)
			else
				QBCore.Functions.TriggerCallback('Lux_VehiclePaper:isnotregistered', function(result)
					TractionMultiplier = Multiplier
				end)
			end
		else
			TractionMultiplier = Config.RemoveTraction
		end

		local ped = PlayerPedId(-1)
		if IsPedInAnyVehicle(ped) then
			local playerVehicle  = GetVehiclePedIsIn(ped, false)
			if DoesEntityExist(playerVehicle) then 
				if Config.BetterTractionOnOffRoadWheels then
					local VehicleWheelType = GetVehicleWheelType(playerVehicle)
					if VehicleWheelType == 4 then 
						if Config.RemoveTraction >= 2.0 then 
							TractionMultiplier = Config.RemoveTraction / 2
						else
							TractionMultiplier = 1.0
						end
					end
				end
				local defaultTractionLoss = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')
				SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult',1.0 * TractionMultiplier)
			end 
		end 
		Wait(100)
	end 
end)

CreateThread(function()
	RequestAnimDict('anim@mp_snowball')
	while true and Config.EnableSnowBalls and Config.SnowBallAmount > 0 do
		if not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then
			if IsControlJustReleased(0, 51) then -- check if the snowball should be picked up
				TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
				Citizen.Wait(1950)

				if Config.SnowballAsItem then 
					TriggerServerEvent('DaChristmas:addSnowballItem')
				else
					GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), Config.SnowBallAmount, false, true)	
				end 
			end
			BeginTextCommandDisplayHelp("STRING")
			AddTextComponentSubstringPlayerName(string.format(Translation[Config.Locale]['snowball_help_text']))
			EndTextCommandDisplayHelp(0, 0, 1, -1)
		end 
		
		Wait(1)
		
	end 
end)


CreateThread(function()
	for k,v in pairs(Config.Trees) do 
		RequestModel(v.model)
		while not HasModelLoaded(v.model) do
			Wait(0)
		end
		
		for _, coord in pairs(v.coords) do
			local obj = CreateObject(v.model,coord.vec.x,coord.vec.y, coord.vec.z -1.0 , false, true, true)
			FreezeEntityPosition(obj, true)
			table.insert(SpawnedTrees, obj)
		end 
		
	end 
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	for key, value in pairs(SpawnedTrees) do
		DeleteObject(value)
	end 
end)