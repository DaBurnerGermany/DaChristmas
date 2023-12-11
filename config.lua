Config = {}

Config.ForceWeather = true --if true the script does the snow
Config.EnableSnowBalls = true --allow snowballs
Config.SnowBallAmount = 2 --snoballs per grab
Config.SnowBallHelperText = "Press ~INPUT_CONTEXT~ to pickup " .. Config.SnowBallAmount .. " snowball(s)!" --helptext outside vehicle

Config.RemoveTraction = 1.5 --remove traction my x percentage 2.0 = 250% badder than usual. Everything < 1.0 means better traction

Config.Trees = { --trees to spawn
	{
		model = "prop_xmas_tree_int"
		,coords = {
			--{vec = vector3(692,-515,15.5)} -- this was just for testing!
			--,{vec = vector3(123,-123,102.5)} -- this was just for testing!
		}
	}
}


