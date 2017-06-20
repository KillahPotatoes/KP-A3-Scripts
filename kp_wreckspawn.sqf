/*
kp_wreckspawn.sqf
Author: Wyqer
Website: https://www.killahpotatoes.de
Source & License: https://github.com/Wyqer/A3-Scripts
Date: 2017-06-19

Description:
Place random wrecks on the roads of the map.

Parameters:
NONE

Method:
execVM

Example for initServer.sqf:
[] execVM "kp_wreckspawn.sqf";
*/

private ["_debug","_minDist","_maxDist","_multiChance","_multiMax","_placedWrecks","_wrecksArray","_size","_center","_marker","_roadsArray","_road","_count","_position","_wreck"];

// CONFIG START

// Enable Debug Markers
_debug = false;
// Minimum distance between wrecks
_minDist = 300;
// Maximum distance between wrecks
_maxDist = 600;
// Spawn chance of multiple wrecks
_multiChance = 40;
// Maximum count of wrecks at one spot
_multiMax = 3;

// CONFIG END

// DO NOT EDIT BELOW
if !(isServer) exitWith {};
_placedWrecks = [];

_wrecksArray = [
	"Land_Wreck_Car_F",
	"Land_Wreck_Car2_F",
	"Land_Wreck_Car3_F",
	"Land_Wreck_HMMWV_F",
	"Land_Wreck_Hunter_F",
	"Land_Wreck_Van_F",
	"Land_Wreck_Truck_dropside_F",
	"Land_Wreck_Offroad_F",
	"Land_Wreck_Offroad2_F",
	"Land_Wreck_Skodovka_F",
	"Land_Wreck_Truck_F",
	"Land_Wreck_UAZ_F",
	"Land_Wreck_Ural_F",
	"Land_Wreck_CarDismantled_F"
];

_size = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");

_center = [_size/2,_size/2,0];

if (_debug) then {
	_marker = createMarker ["center",_center];
	_marker setMarkerColor "ColorRED";
	_marker setMarkerType "mil_dot";
};

_roadsArray = _center nearRoads (_size/2);

diag_log format ["[KP WRECKS] [STARTED] Center: %1 - Size: %2 - Found Roads: %3",_center,(_size/2), count _roadsArray];

while {(count _roadsArray) > 0} do {
	_road = selectRandom _roadsArray;
	_roadsArray = _roadsArray select {_x distance2D _road > (ceil ((random (_maxDist - _minDist)) + _minDist))};
	_count = 0;
	while {(_count == 0) || ((_count < _multiMax) && ((random 100) <= _multiChance))} do {
		_position = (getPos _road) findEmptyPosition [1, 15, "B_MRAP_01_F"];
		if !(_position isEqualTo []) then {
			_wreck = (selectRandom _wrecksArray) createVehicle _position;
			_wreck setDir (round (random 360));
			_placedWrecks pushBack _wreck;
			if (_debug) then {
				_marker = createMarker [str _wreck,_wreck];
				_marker setMarkerColor "ColorBlack";
				_marker setMarkerType "mil_dot";
			};
		};
		_count = _count + 1;
	};
};

diag_log format ["[KP WRECKS] [FINISHED] Placed Wrecks: %1",count _placedWrecks];
