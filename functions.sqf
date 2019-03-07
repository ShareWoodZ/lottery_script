Ultima_Lot_Create_Vehicle	=
	{
		Private ["_keyColor","_keyNumber","_keySelected","_isOk","_helipad","_location","_sign","_vehicle","_city"];
		_vehicle	=	_this select 0;		
		if (isNil "inTraderCity") then
			{_city	=	"Неизвестно"}
		else
			{_city	=	inTraderCity};
		_keyColor			=	["Green","Red","Blue","Yellow","Black"] call BIS_fnc_selectRandom;
		_keyNumber			=	(floor(random 2500)) + 1;
		_keySelected		=	format[("ItemKey%1%2"),_keyColor,_keyNumber];
		//	_isOk будет true если ключ добавился на пояс. false - если ячейки заняты или другие ошибки
		_isOk				=	[player,_keySelected] call BIS_fnc_invAdd;
		waitUntil {!isNil "_isOk"};
		_helipad			=	nearestObjects [player, ["HeliHCivil", "HeliHempty"], 100];
		if(count _helipad > 0) then
			{_location	=	(getPosATL (_helipad select 0));}
		else
			{
				if !(_vehicle isKindOf "Ship") then
					{_location	=	[([player] call FNC_GetPos),0,20,1,0,20,0] call BIS_fnc_findSafePos;}	//	Для наземных
				else
					{_location	=	[([player] call FNC_GetPos),0,20,2,0,20,1] call BIS_fnc_findSafePos;};	//	Для морских
			};
		_sign				=	createVehicle ["Sign_arrow_down_large_EP1", _location, [], 0, "CAN_COLLIDE"];
		_location			=	(getPosATL _sign);
		PVDZE_veh_Publish2	=	[_sign,[0,_location],_vehicle,false,_keySelected,player];
		PublicVariableServer  "PVDZE_veh_Publish2";
	};