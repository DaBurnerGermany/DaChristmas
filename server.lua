QBCore = nil
ESX = nil 

while ESX == nil and QBCore == nil do
	if GetResourceState('es_extended') == 'started' then
		ESX = exports["es_extended"]:getSharedObject()
	elseif GetResourceState('qb-core') == 'started' then 
		QBCore = exports["qb-core"]:GetCoreObject()	
	end
end 


RegisterServerEvent("DaChristmas:addSnowballItem")
AddEventHandler("DaChristmas:addSnowballItem",function()
    local _source = source

	if Config.SnowballAsItem then
        if ESX ~= nil then 
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.addInventoryItem(Config.SnowballItemName, Config.SnowBallAmount)
        else 
            local xPlayer = QBCore.Functions.GetPlayer(_source)
            xPlayer.Functions.AddItem(Config.SnowballItemName, Config.SnowBallAmount)     
        end 
	end
end)