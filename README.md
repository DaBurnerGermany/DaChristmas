# DaChristmas
A lightweight FiveM resource for seasonal snow effects, snowballs, and dynamic traction/weather simulation.

---

## Features

- **Dynamic Weather Control**
  - Full snow mode with ground snow and footprints
  - Optional `SnowFallOnly` mode for falling snow without ground snow
  - Configurable weather type (`XMAS`, `SNOW`, `BLIZZARD`, etc.)
- **Vehicle Traction Handling**
  - Adjustable traction loss on snow or freezing rain
  - Optional better grip for offroad vehicles
  - Blacklist for specific vehicle models
- **Snowballs**
  - Players can pick up and throw snowballs
  - Optional inventory integration (e.g., `ox_inventory`)
- **Freezing Rain System**
  - Random chance for icy conditions that further reduce traction
  - Automatic Discord webhook notifications when active
- **Christmas Trees**
  - Spawns decorative trees defined in `config.lua`
- **Version Checker**
  - Automatically checks for the latest version on GitHub

---

## Configuration

All configuration options are found in `config.lua`.

```lua
Config.ForceWeather = true      -- Enable weather control
Config.SnowFallOnly = false     -- If true: falling snow only, no ground snow
Config.Weather = "XMAS"         -- Weather type ("XMAS", "SNOW", "BLIZZARD", etc.)

Config.EnableSnowBalls = true   -- Allow picking up and throwing snowballs
Config.SnowballAsItem = true    -- Use item system for snowballs
Config.SnowBallAmount = 2       -- Amount of snowballs per pickup

Config.RemoveTraction = 2.5     -- Vehicle traction multiplier
Config.BetterTractionOnOffRoadWheels = true
Config.BlacklistedVehicle = { ['hauler'] = true }

Config.UseFreezingRain = true
Config.FreezingRainChance = 5
Config.FreezingRainUpdateTime = 60 * 60 * 1000
Config.FreezingRainRemoveTraction = 12.5

Config.UseWebhooks = true
Config.WebhookURL = ""          -- Discord webhook URL for freezing rain notifications

Config.SupressMessageAfterSeconds = 5  -- Hide help text after x seconds
```

### Tree Example
You can spawn custom trees anywhere on the map:
```lua
Config.Trees = {
    {
        model = "prop_xmas_tree_int",
        coords = {
            { vec = vector3(692, -515, 15.5) },
            { vec = vector3(123, -123, 102.5) }
        }
    }
}
```

---

## Commands

### `/Blitzeis [seconds]` (ESX only)
Temporarily activates the freezing rain effect for a given duration.  
Admin only.

---

## Dependencies

Supports both:
- **ESX (es_extended)**
- **QBCore (qb-core)**

---

## Installation

1. Place the folder into your server’s `resources` directory.
2. Ensure the resource is added to your `server.cfg`:
   ```
   ensure DaChristmas
   ```
3. Adjust your `config.lua` to fit your server’s setup.
4. Restart your server.

---

## Optional Settings

| Option | Description |
|--------|--------------|
| `SnowFallOnly` | Enables falling snow without ground snow |
| `UseFreezingRain` | Activates random icy road conditions |
| `BetterTractionOnOffRoadWheels` | Improves handling for offroad wheel types |
| `UseWebhooks` | Sends weather notifications to a Discord channel |

---

## Performance Notes

- Optimized threads with minimal `Wait` intervals to reduce CPU load.
- Client-side loops run at low frequency (1–5 seconds).
- All weather and traction logic is event-driven where possible.

---

## Credits

- **Original Author:** DaBurnerGermany  
- **Optimized and Extended by:** LuxCoding/KalleScripts, XenoKeks


## Acknowledgements

A big thank you to everyone who contributed ideas, improvements, code snippets, and feedback that helped make DaChristmas more stable, performant, and feature-rich.
Your effort and collaboration keep the community alive and this project evolving.

