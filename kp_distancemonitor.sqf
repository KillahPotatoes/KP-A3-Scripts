/*
kp_distancemonitor.sqf
Author: Wyqer
Website: https://www.killahpotatoes.de
Source & License: https://github.com/Wyqer/A3-Scripts
Date: 2017-06-20

Description:
Adds actions to the player to start/stop/reset travelled map distance measuring.
End the whole script via
kp_distance_run = false;
in a script or debug console.

Parameters:
NONE

Method:
execVM

Example for initPlayerLocal.sqf:
[] execVM "kp_distancemonitor.sqf";
*/

private ["_interval","_id_start","_id_stop","_id_reset","_pos"];

// CONFIG START

//Interval in seconds to update the distance
_interval = 1;

// CONFIG END

// DO NOT EDIT BELOW
kp_distance_run = true;
kp_distance_status = 0;
kp_distance = 0;

_id_start = player addAction ["Start measuring",{kp_distance_status = 1;},nil,-100,false,true,"","kp_distance_status == 0"];
_id_stop = player addAction ["Stop measuring",{kp_distance_status = 0;},nil,-101,false,true,"","kp_distance_status != 0"];
_id_reset = player addAction ["Reset measuring",{kp_distance_status = 2;},nil,-102,false,true,"","kp_distance != 0"];

while {kp_distance_run} do {
	if (kp_distance_status == 2) then {
		kp_distance = 0;
		kp_distance_status = 1;
	};
	
	if (kp_distance_status == 1) then {
		if (isNil "_pos") then {
			_pos = getPos player;
		};
		kp_distance = kp_distance + (_pos distance2D (getPos player));
		_pos = getPos player;
		hint format ["Travelled Distance:\n%1m",((round (kp_distance * 100)) / 100)];
	} else {
		hint "";
		_pos = nil;
	};
	uiSleep _interval;
};

player removeAction _id_start;
player removeAction _id_stop;
player removeAction _id_reset;
