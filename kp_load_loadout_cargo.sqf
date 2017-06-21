/*
kp_load_loadout_cargo.sqf
Author: Wyqer
Website: https://www.killahpotatoes.de
Source & License: https://github.com/Wyqer/A3-Scripts
Date: 2017-06-20

Description:
Ability to load items from saved or predefined loadouts to a vehicle cargo.

Parameters:
NONE

Method:
execVM

Example for init.sqf:
[] execVM "kp_load_loadout_cargo.sqf";
*/

private ["_arsenal_loadouts","_predefined_loadouts","_object_classnames","_fnc_traverse_array"];

// CONFIG START
// Should loadouts from the arsenal of the player be available?
_arsenal_loadouts = true;

// Array for predefined loudouts
// Format: ["NAME",["ITEM CLASSNAME","ITEM CLASSNAME","ITEM CLASSNAME"]]
_predefined_loadouts = [
	["AT Pack",["launch_B_Titan_short_F","B_Carryall_mcamo","Titan_AT","Titan_AT","Titan_AT"]]
];

// Classnames of objects which should be provide loading functionality
// you can leave it empty, if you just want objects where you've written in the init line: this setVariable ["KP_loadout_cargo_object",1];
// if you want to add objects during a mission to the list of objects do: KP_loadout_cargo_objects pushBack X; publicVariable "KP_loadout_cargo_objects"; (X -> the spawned object which you want to add)
_object_classnames = [
	"B_supplyCrate_F"
];

// CONFIG END

// DO NOT EDIT BELOW
_fnc_traverse_array = {
	params ["_array"];
	private _content = [];
	{
		if ((typeName _x) == "ARRAY") then {
			_content append ([_x] call _fnc_traverse_array);
		} else {
			if ((isClass (configfile >> "CfgWeapons" >> _x)) || (isClass (configfile >> "CfgMagazines" >> _x))|| (isClass (configfile >> "CfgVehicles" >> _x))) then {
				_content pushBack _x;
			};
		};
	} forEach _array;
	_content;
};

kp_fnc_load_into_vehicle = {
	params ["_cargo"];
	private _vehicle = (nearestObjects [player, ["AllVehicles"], 10]);
	_vehicle = _vehicle select {!(_x isKindOf "Man")};
	if ((count _vehicle) > 0) then {
		{
			if(isClass (configfile >> "CfgVehicles" >> _x)) then {
				(_vehicle select 0) addBackpackCargoGlobal [_x,1];
			} else {
				(_vehicle select 0) addItemCargoGlobal [_x,1];
			};			
		} forEach _cargo;
		hint format ["Loaded into %1", (typeOf (_vehicle select 0))];
		uiSleep 3;
		hint "";
	} else {
		hint "No vehicle near";
		uiSleep 3;
		hint "";
	};
};

if (isServer) then {
	KP_loadout_cargo_objects = [];
	{
		if (((typeOf _x) in _object_classnames) || ((_x getVariable ["KP_loadout_cargo_object",0]) == 1)) then {
			KP_loadout_cargo_objects pushBack _x;
		};
	} forEach vehicles;
	publicVariable "KP_loadout_cargo_objects";
};

if !(isDedicated) then {
	private ["_loadout_cargo_list","_loadout","_giveAction","_action_ids"];
	KP_loadout_cargo_run = true;
	kp_loadout_cargo_menu = false;
	kp_loadout_cargo_list = [];
	_action_ids = [];

	_loadout = [];
	if (_arsenal_loadouts) then {
		{
			if (_forEachIndex % 2 == 0) then {
				_loadout pushBack _x;
			} else {
				_loadout pushBack ([_x] call _fnc_traverse_array);
			};

			if ((count _loadout) == 2) then {
				kp_loadout_cargo_list pushBack _loadout;
				_loadout = [];
			};
		} forEach (profileNamespace getVariable "bis_fnc_saveInventory_data");
	};

	_loadout = [];
	{
		_loadout pushBack (_x select 0);
		_loadout pushBack ([_x select 1] call _fnc_traverse_array);
		kp_loadout_cargo_list pushBack _loadout;
		_loadout = [];
	} forEach _predefined_loadouts;

	kp_loadout_cargo_list sort true;

	while {KP_loadout_cargo_run} do {
		_giveAction = false;
		{
			if (_x in KP_loadout_cargo_objects) exitWith {_giveAction = true;}
		} forEach (nearestObjects [player, [], 15]);

		if (_giveAction) then {
			if !((count _action_ids) == ((count kp_loadout_cargo_list) + 2)) then {
				_action_ids pushBack (player addAction ["<t color='#FF8000'>Open loading menu</t>",{kp_loadout_cargo_menu = true;},nil,-100,false,false,"","!kp_loadout_cargo_menu"]);
				_action_ids pushBack (player addAction ["<t color='#FF8000'>Close loading menu</t>",{kp_loadout_cargo_menu = false;},nil,-100,false,false,"","kp_loadout_cargo_menu"]);
				{
					_action_ids pushBack (player addAction ["Load " + (_x select 0),{[(_this select 3)] spawn kp_fnc_load_into_vehicle;},(_x select 1),(-101 - _forEachIndex),false,true,"","kp_loadout_cargo_menu"]);
				} forEach kp_loadout_cargo_list;
			};
		} else {
			if ((count _action_ids) == ((count kp_loadout_cargo_list) + 2)) then {
				{
					player removeAction _x;
				} forEach _action_ids;
				_action_ids = [];
				kp_loadout_cargo_menu = false;
			};
		};
		uiSleep 3;
	};
	{
		player removeAction _x;
	} forEach _action_ids;
};
