Config = {}

Config.Locale = 'de' -- Translation en, de you can add more 

Config.ForceWeather = true --if true the script does the snow
Config.Weather = "XMAS" --set to "" or nil if only snow is wished on road 

Config.EnableSnowBalls = false --allow snowballs

Config.SnowballAsItem = true -- set to true if you use a inventory like ox_inventory
Config.SnowballItemName = "WEAPON_SNOWBALL"

Config.SnowBallAmount = 2 --snoballs per grab

Config.RemoveTraction = 2.5 --remove traction my x percentage 2.0 = 250% badder than usual. Everything < 1.0 means better traction

-- added by LuxCoding
Config.BetterTractionOnOffRoadWheels = true --set to true if you want to have Better Traction with Off Road Wheels 

Config.UseFreezingRain = true --set to true if you want to use FreezingRain
Config.FreezingRainChance = 5 --Chance for Freezing Rain 
Config.FreezingRainUpdateTime = 60 * 60 * 1000 --the time how long it takes whether there is a new draw and whether there is freezing rain
Config.FreezingRainRemoveTraction = 12.5 --traction loss Multiplier by Freezing Rain

Config.UseWebhooks = true
Config.WebhookURL = ""

Config.Trees = { --trees to spawn
	{
		model = "prop_xmas_tree_int",
		coords = {
			{vec = vector3(692,-515,15.5)}, -- this was just for testing!
			{vec = vector3(123,-123,102.5)} -- this was just for testing!
		}
	}
}


Translation = {
    ['de'] = {
		['snowball_help_text'] = 'Drücke ~INPUT_CONTEXT~ um ' .. Config.SnowBallAmount .. ' Schneebälle aufzuheben',
        ['freezing_rain_warning_bot_name'] = 'Wetterdienst',
		['freezing_rain_warning_author_name'] = 'Wetterdienst',
		['freezing_rain_warning_title_name'] = 'Blitzeis Gefahr',
		['freezing_rain_warning_description'] = 'Liebe Bürger aufgepasst Momentan herscht Blitzeis Gefahr. wir empfehlen die Straßen nicht zu befahren.',
		['freezing_rain_warning_over_bot_name'] = 'Wetterdienst',
		['freezing_rain_warning_over_author_name'] = 'Wetterdienst',
		['freezing_rain_warning_over_title_name'] = 'Keine Blitzeis Gefahr mehr',
		['freezing_rain_warning_over_description'] = 'Liebe Bürger aufgepasst es herscht keine Blitzeis Gefahr mehr. Die Straßen können wieder befahren werden.', 
		['no_permissions'] = '~r~Du Darfst diesen Command nicht nutzen',
		['command_delay'] = '~r~Der command wurde erst genutzt warte bis das Blitzeis vorbei ist',
    },
    ['en'] = {
		['snowball_help_text'] = 'Press ~INPUT_CONTEXT~ to pickup ' .. Config.SnowBallAmount .. ' snowball(s)!',
		['freezing_rain_warning_bot_name'] = 'Weather Service',
		['freezing_rain_warning_author_name'] = 'Weather Service',
		['freezing_rain_warning_title_name'] = 'Freezing Rain',
		['freezing_rain_warning_description'] = 'Dear citizens, be careful. There is currently a danger of Freezing Rain. we recommend not driving on the streets.',
		['freezing_rain_warning_over_bot_name'] = 'Weather Service',
		['freezing_rain_warning_over_author_name'] = 'Weather Service',
		['freezing_rain_warning_over_title_name'] = 'Freezing Rain Over',
		['freezing_rain_warning_over_description'] = 'Dear citizens, be careful, there is no longer any danger of Freezing Rain. The roads can be used again.',
		['no_permissions'] = '~r~you are not allowed to use this command',
		['command_delay'] = '~r~The command was first used: wait until the Freezing Rain is over',
	},
}