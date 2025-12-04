local QBCore, ESX

-- =========================
--  Framework Detection
-- =========================
CreateThread(function()
    while not (ESX or QBCore) do
        if GetResourceState('es_extended') == 'started' then
            ESX = exports["es_extended"]:getSharedObject()
        elseif GetResourceState('qb-core') == 'started' then 
            QBCore = exports["qb-core"]:GetCoreObject()
        end
        Wait(250)
    end
end)

local Multiplier = Config.RemoveTraction
local FreezingRain = false
local CommandIsUsed = false

-- =========================
--  Snowball Item
-- =========================
RegisterNetEvent("DaChristmas:addSnowballItem")
AddEventHandler("DaChristmas:addSnowballItem", function()
    local src = source

    if not Config.SnowballAsItem then return end

    if ESX ~= nil then 
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(Config.SnowballItemName, Config.SnowBallAmount)
        end
    elseif QBCore ~= nil then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            xPlayer.Functions.AddItem(Config.SnowballItemName, Config.SnowBallAmount)
        end
    end
end)

-- =========================
--  Snowball Help Text Suppression
-- =========================
RegisterNetEvent("DaChristmas:SupressMessage")
AddEventHandler("DaChristmas:SupressMessage", function()
    local src = source
    if not Config.SupressMessageAfterSeconds then return end

    CreateThread(function()
        Wait(Config.SupressMessageAfterSeconds * 1000)
        TriggerClientEvent("DaChristmas:SupressMessage:client", src)
    end)
end)

-- =========================
--  Freezing Rain System
-- =========================
if Config.UseFreezingRain then 
    CreateThread(function()
        while true do
            local randint = math.random(1, 100)

            if randint <= Config.FreezingRainChance then 
                Multiplier = Config.FreezingRainRemoveTraction

                if Config.UseWebhooks and not FreezingRain then
                    FreezingRain = true
                    FreezingRainWarning()
                end
            else
                if Config.UseWebhooks and FreezingRain then
                    FreezingRain = false
                    FreezingRainWarningOver()
                end
                Multiplier = Config.RemoveTraction
            end

            Wait(Config.FreezingRainUpdateTime)
        end
    end)

    -- Callback für Client (ESX oder QBCore)
    CreateThread(function()
        -- warten bis Framework da ist
        while not (ESX or QBCore) do
            Wait(250)
        end

        if ESX then
            ESX.RegisterServerCallback('DaChristmas:getMultiplier', function(source, cb)
                cb(Multiplier)
            end)
        elseif QBCore then
            QBCore.Functions.CreateCallback('DaChristmas:getMultiplier', function(source, cb)
                cb(Multiplier)
            end)
        end
    end)
end

-- =========================
--  Webhook-Funktionen
-- =========================
if Config.UseWebhooks then
    function FreezingRainWarning()
        local message = {
            username = string.format(Translation[Config.Locale]['freezing_rain_warning_bot_name']),
            embeds = {{
                color = 0x000000,
                author = {
                    name = string.format(Translation[Config.Locale]['freezing_rain_warning_author_name']),
                },
                title = string.format(Translation[Config.Locale]['freezing_rain_warning_title_name']),
                description = string.format(Translation[Config.Locale]['freezing_rain_warning_description']),
            }},
        }

        PerformHttpRequest(Config.WebhookURL, function(err, text, headers)
        end, 'POST', json.encode(message), {
            ['Content-Type'] = 'application/json'
        })
    end

    function FreezingRainWarningOver()
        local message = {
            username = string.format(Translation[Config.Locale]['freezing_rain_warning_over_bot_name']),
            embeds = {{
                color = 0x000000,
                author = {
                    name = string.format(Translation[Config.Locale]['freezing_rain_warning_over_author_name']),
                },
                title = string.format(Translation[Config.Locale]['freezing_rain_warning_over_title_name']),
                description = string.format(Translation[Config.Locale]['freezing_rain_warning_over_description']),
            }},
        }

        PerformHttpRequest(Config.WebhookURL, function(err, text, headers)
        end, 'POST', json.encode(message), {
            ['Content-Type'] = 'application/json'
        })
    end
end

-- =========================
--  Blitzeis Command (ESX only)
-- =========================
RegisterCommand('Blitzeis', function(source, args)
    if not ESX then return end  -- nur für ESX-Server

    local src = source
    if CommandIsUsed then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.showNotification(string.format(Translation[Config.Locale]['command_delay']))
        end
        return
    end

    CommandIsUsed = true

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        CommandIsUsed = false
        return
    end

    local group = xPlayer.getGroup()
    local duration = tonumber(args[1])

    if group ~= 'admin' then
        xPlayer.showNotification(string.format(Translation[Config.Locale]['no_permissions']))
        CommandIsUsed = false
        return
    end

    if not duration or duration <= 0 then
        xPlayer.showNotification("~r~Bitte Zeit in Sekunden angeben, z.B.: /Blitzeis 60")
        CommandIsUsed = false
        return
    end

    local oldMultiplier = Multiplier
    Multiplier = Config.FreezingRainRemoveTraction

    CreateThread(function()
        Wait(duration * 1000)
        Multiplier = oldMultiplier
        CommandIsUsed = false
    end)
end, false)

-- =========================
--  Version Checker
-- =========================
CreateThread(function()
    local resName    = GetCurrentResourceName()
    local name       = GetResourceMetadata(resName, 'name', 0) or resName
    local githubOrig = GetResourceMetadata(resName, 'github', 0)
    local version    = GetResourceMetadata(resName, 'version', 0) or "0.0.0"

    if not githubOrig or githubOrig == "" then
        print(('[^4%s^0] ^3No github metadata set, skipping version check.'):format(resName))
        return
    end

    local githubUrl = githubOrig:gsub("github.com/", "raw.githubusercontent.com/") .. "/master/version"

    PerformHttpRequest(githubUrl, function(err, body, headers)
        if err ~= 200 or not body or body == "" then
            print(('[^4%s^0] ^3Could not check latest version. HTTP error: %s'):format(resName, tostring(err)))
            return
        end

        local newestVersion = body:gsub("\n", "")
        local intVersion    = newestVersion:gsub("%.", "")
        local intCurVersion = version:gsub("%.", "")

        if tonumber(intVersion) and tonumber(intCurVersion) and tonumber(intVersion) > tonumber(intCurVersion) then
            print(('^4%s (%s) ^1✗ Outdated (v%s) ^5- Update found: Version %s ^0(%s)')
                :format(resName, name, version, newestVersion, githubOrig))
        else
            print(('^4%s (%s) ^2✓ Up to date - Version %s^0')
                :format(resName, name, version))
        end
    end)
end)
