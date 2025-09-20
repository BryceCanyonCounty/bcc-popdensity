# bcc-popdensity

Simple population-density controller for RedM servers.

## Features
- Applies ambient ped, human, animal, and vehicle density multipliers every frame for consistent population control.
- Syncs multiplier values from the server whenever a player loads in or the server requests a refresh.
- Safe parsing of server-sent values with optional debug logging via `Config.Debug`.

## Configuration
- Edit `config.lua` to adjust the numeric multipliers for each density bucket.
- Set `Config.Debug = true` to view broadcast and application details in the console.

## Server Events
- `bcc-popdensity:syncDensityMultipliers` — broadcast current `Config.DensityMultipliers` to all players (useful after live config tweaks).
- `bcc-popdensity:requestDensityMultipliers` — client-triggered; responds with the latest multipliers for that player.

## Installation
1. Place `bcc-popdensity` in your `resources` folder.
2. Add `ensure bcc-popdensity` to your `server.cfg`.
3. Restart the resource or your server.

## Notes
- When changing values directly in `config.lua`, restart the resource or trigger `bcc-popdensity:syncDensityMultipliers` so connected players receive the update.
- Values outside the expected numeric range fall back to the defaults shipped with the resource.

- Need more help? Join the bcc discord here: https://discord.gg/VrZEEpBgZJ