QBCore = nil
ESX = nil 

while ESX == nil and QBCore == nil do
	if GetResourceState('es_extended') == 'started' then
		ESX = exports["es_extended"]:getSharedObject()
	elseif GetResourceState('qb-core') == 'started' then 
		QBCore = exports["qb-core"]:GetCoreObject()	
	end
end 

local Multiplier = Config.RemoveTraction
local FreezingRain = false

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

-- added by LuxCoding
if Config.UseFreezingRain then 
    Citizen.CreateThread(function()
        while true do
            local randint = math.random(1, 100)
            if randint <= Config.FreezingRainChance then 
                Multiplier = Config.FreezingRainRemoveTraction
                if Config.UseWebhooks then
                    if not FreezingRain then 
                        FreezingRain = true
                        FreezingRainWarning()
                    end
                end
            else
                if Config.UseWebhooks then
                    if FreezingRain then 
                        FreezingRain = false
                        FreezingRainWarningOver()
                    end
                end
                Multiplier = Config.RemoveTraction
            end
        Citizen.Wait(Config.FreezingRainUpdateTime)
        end
    end)

    if ESX ~= nil then 
        ESX.RegisterServerCallback('DaChristmas:getMultiplier', function(source, cb)
            cb(Multiplier)
        end)
    else
        QBCore.Functions.CreateCallback('DaChristmas:getMultiplier', function(source, cb)
            cb(Multiplier)
        end)
    end
end


if Config.UseWebhooks then
    function FreezingRainWarning()
        local message = {
            username = string.format(Translation[Config.Locale]['freezing_rain_warning_bot_name']), -- Bot Name
            embeds = {{
                color = 000000, -- Colour in Hex #000000
                author = {
                    name = string.format(Translation[Config.Locale]['freezing_rain_warning_author_name']),
                },
                title = string.format(Translation[Config.Locale]['freezing_rain_warning_title_name']),
                description = string.format(Translation[Config.Locale]['freezing_rain_warning_description']),
            }}, 
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) -- WEEBHOOK
        
    end, 'POST', json.encode(message), {
        ['Content-Type'] = 'application/json' 
    })

    end

    function FreezingRainWarningOver()
        local message = {
            username = string.format(Translation[Config.Locale]['freezing_rain_warning_over_bot_name']), -- Bot Name
            embeds = {{
                color = 000000, -- Colour in Hex #000000
                author = {
                    name = string.format(Translation[Config.Locale]['freezing_rain_warning_over_author_name']),
                },
                title = string.format(Translation[Config.Locale]['freezing_rain_warning_over_title_name']),
                description = string.format(Translation[Config.Locale]['freezing_rain_warning_over_description']),
            }}, 
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) -- WEEBHOOK
        
    end, 'POST', json.encode(message), {
        ['Content-Type'] = 'application/json' 
    })

    end
end