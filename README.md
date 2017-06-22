![Killah Potatoes](https://www.killahpotatoes.de/images/kp_banner.png)

# Small Scripts for ArmA 3 from KP

### KP Fuel Consumption Script
**File:** `kp_fuel_consumption.sqf`

This script handles the fuel consumption of vehicles, so that refueling will be necessary more often. It also checks if the vehicle is standing with running engine, driving in normal speed or max speed. With this script you'll have the need to refuel the vehicle during an evening session with a suitable setup by default (full configurable). So no more "never ending" fuel available due to the normal ArmA 3 fuel consumption mechanic.

### KP Distance Monitor Script
**File:** `kp_distancemonitor.sqf`

Adds actions to the player to start/stop/reset travelled map distance measuring. It will be shown as hint and you can configure the interval of the measuring. It works with a loop which you can leave via script command or debug console: `kp_distance_run = false;`

### KP Load Loadouts to Cargo Script
**File:** `kp_load_loadout_cargo.sqf`

Ability to load items from saved or predefined loadouts to a vehicle cargo. This functionality is available in the vicinity of objects which you've defined per classname in the script or via `this setVariable ["KP_loadout_cargo_object",1];` in an objects init line in the editor. To end the script on a client you've to run `KP_loadout_cargo_run = false;` on the clients machine.

### KP Random Wreckspawn Script
**File:** `kp_wreckspawn.sqf`

Place random wrecks on the roads of the map. You don't need to place anything in the editor or something. This script will place in a free configurable mininum and maximum distance random wrecks on the roads. Also with a adjustable chance to spawn more wrecks in the direct vicinity of the last spawned wreck, so it'll also create random roadblocks. 