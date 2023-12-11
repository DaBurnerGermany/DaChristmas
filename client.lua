SpawnedTrees = {}

CreateThread(function()	
    while true and Config.ForceWeather do
		SetWeatherTypePersist("XMAS")
        SetWeatherTypeNowPersist("XMAS")
        SetWeatherTypeNow("XMAS")
        SetOverrideWeather("XMAS")
		
		SetForcePedFootstepsTracks(true)
		
		SetForceVehicleTrails(true)
		Wait(1)
	end
end)

CreateThread(function()
	while true and Config.RemoveTraction ~= 1.0 do
	
		local TractionMultiplier = Config.RemoveTraction
	
		local ped = PlayerPedId(-1)
		
		if IsPedInAnyVehicle(ped) then
		
			local playerVehicle  = GetVehiclePedIsIn(ped, false)
				
			
			if DoesEntityExist(playerVehicle) then 
			
			
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
	
		if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
	
			
			if IsControlJustReleased(0, 51) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then -- check if the snowball should be picked up
				TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
				Citizen.Wait(1950)
				GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), Config.SnowBallAmount, false, true)
			end
			
			BeginTextCommandDisplayHelp("STRING")
			AddTextComponentSubstringPlayerName(Config.SnowBallHelperText)
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