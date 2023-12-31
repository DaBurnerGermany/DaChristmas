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
local CommandIsUsed = false

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

RegisterServerEvent("DaChristmas:SupressMessage")
AddEventHandler("DaChristmas:SupressMessage",function()
    local _source = source
    CreateThread(function()
        Wait(Config.SupressMessageAfterSeconds * 1000)
        TriggerClientEvent("DaChristmas:SupressMessage:client", _source)
    end)
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

RegisterCommand('Blitzeis', function(source, args)
    if not CommandIsUsed then
        CommandIsUsed = true
        local xPlayer = ESX.GetPlayerFromId(source)
        local group = xPlayer.getGroup()
        local oldMultiplier = Multiplier
        local input = tonumber(args[1])
        

        if group == 'admin' then
            Multiplier = Config.FreezingRainRemoveTraction
            Citizen.Wait(input * 1000)
            Multiplier = oldMultiplier
            CommandIsUsed = false
        else
            xPlayer.showNotification(string.format(Translation[Config.Locale]['no_permissions']))
            CommandIsUsed = false
        end
    else
        xPlayer.showNotification(string.format(Translation[Config.Locale]['command_delay']))
    end
end, false)


CreateThread(function()
    local Name = GetResourceMetadata(GetCurrentResourceName(), 'name', 0)
    local GithubOrig = GetResourceMetadata(GetCurrentResourceName(), 'github', 0)
    local Version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    local Changelog, GithubL, NewestVersion    

    
    if Version == nil then
        Version = GetResourceMetadata(resource, 'version', 0)
    end
    
    if string.find(GithubOrig, "github") then
        if string.find(GithubOrig, "github.com") then
            Github = string.gsub(GithubOrig, "github", "raw.githubusercontent")..'/master/version'
        else
            GithubL = string.gsub(GithubOrig, "raw.githubusercontent", "github"):gsub("/master", "")
            Github = Github..'/version'
        end
    else
        Script['Github'] = Github..'/version'
    end
    PerformHttpRequest(Github, function(Error, V, Header)
        NewestVersion = V
    end)


    while NewestVersion == nil do 
        Wait(10)
    end
    
    local intVersion = NewestVersion:gsub("%.",""):gsub("\n","")
    local intCurVersion = Version:gsub("%.",""):gsub("\n","")

    if intVersion > intCurVersion then 
        print('^4'..GetCurrentResourceName()..' ('..Name..') ^1✗ ' .. 'Outdated (v'..Version..') ^5- Update found: Version ' .. NewestVersion:gsub("\n","") .. ' ^0('..GithubOrig..')')
    else
        print('^4'..GetCurrentResourceName()..' ('..Name..') ^2✓ ' .. 'Up to date - Version ' .. Version..'^0')
    end 
end)