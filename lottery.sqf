if (lot_ticket) exitWith
	{systemChat "Подождите, идет обновление лотереи..."};
//	Старт лотереи	
lot_ticket			=	true;
Private ["_data", "_lot_random", "_lot_jeckpot", "_lot_jeckpot_prize", "_lot_pause", "_lot_ticket_item", "_lot_ticket_price", "_lot_jeckpot_multi", "_random", "_i", "_weapon", "_rec", "_magazine", "_count", "_backpack", "_vehicle"];
_data				=	(_this select 3);
_lot_random			=	(_data select 0);
_lot_jeckpot		=	(_data select 1);
_lot_jeckpot_prize	=	(_data select 2);
_lot_pause			=	(_data select 3);
_lot_ticket_item	=	(_data select 4);
_lot_ticket_price	=	(_data select 5);
_lot_jeckpot_multi	=	(_data select 6);

//	Проверим, хватит ли денег на билет

//Для баксов
_count		=	player getVariable ["Ultima_Money", 0];
if (_count < _lot_ticket_price) exitWith
	{
		systemChat "Не хватает средств на покупку билета!";			
		sleep _lot_pause;
		lot_ticket = false;
	};
//	Снимаем деньги за билет	
Terminal_Server	=	[player, "trader_buy", (-1 * _lot_ticket_price)];
publicVariableServer "Terminal_Server";

//	Для золота
/*
_magazines	=	magazines player;
_count		=	{_x == _lot_ticket_item} count _magazines;
if (_count < _lot_ticket_price) exitWith
	{
		systemChat "Не хватает средств на покупку билета!";			
		sleep _lot_pause;
		lot_ticket = false;
	};
//	Снимаем деньги за билет	
for "_i" from 1 to _lot_ticket_price do
		{player removeMagazine _lot_ticket_item;};
*/

//	Проверяем джекпот
_random		=	floor(random(_lot_jeckpot)) + 1;
if (_random	>=	_lot_jeckpot) exitWith
	{
		//	Для баксов
		Terminal_Server	=	[player, "trader_buy", (_lot_jeckpot_prize * _lot_jeckpot_multi)];
		publicVariableServer "Terminal_Server";
		//	Для золота
		/*
		for "_i" from 1 to _lot_jeckpot_multi do 
			{player addMagazine _lot_jeckpot_prize;};
		*/			
		systemChat "Джекпот!";
		sleep _lot_pause;
		lot_ticket = false;
	};
//	Проверяем другие варианты
_random		=	floor(random(_lot_random));
if (_random	> 4) exitWith
	{
		systemChat "Вы ничего не выйграли!";
		sleep _lot_pause;
		lot_ticket = false;
	};
//	Если выпало от 0 до 4
switch (_random) do
	{
		case 0: //	Оружие
			{
				_random	=	floor(random(count(Ultima_Lottery_Weapons)));
				_weapon	=	(Ultima_Lottery_Weapons select _random);
				player addWeapon _weapon;
				systemChat format["Вы выйграли оружие: %1", _weapon];
			};
			
		case 1: //	Магазины
			{
				_random		=	floor(random(count(Ultima_Lottery_Magazines)));
				_rec		=	(Ultima_Lottery_Magazines select _random);
				_magazine	=	(_rec select 0);
				_count		=	(_rec select 1);
				for "_i" from 0 to _count do
					{player addMagazine _magazine;};
				systemChat format["Вы выйграли предмет: %1, в кол-ве: %2", _magazine, _count];
			};
		case 2:
			{
				_random		=	floor(random(count(Ultima_Lottery_Backpacks)));
				_backpack	=	(Ultima_Lottery_Backpacks select _random);
				player addBackpack _backpack;
				systemChat format["Вы выйграли рюкзак: %1", _backpack];
			};
		case 3:	
			{
				_random		=	floor(random(count(Ultima_Lottery_Vehicles)));
				_vehicle	=	(Ultima_Lottery_Vehicles select _random);
				[_vehicle] call Ultima_Lot_Create_Vehicle;
				systemChat format["Вы выйграли технику: %1", _vehicle];
			};
		case 4:
			{
				_random	=	floor(random(count(Ultima_Lottery_Scripts)));
				[_lot_pause] execVM (Ultima_Lottery_Scripts select _random);
			};
	};
if (_random != 4) then
	{
		sleep _lot_pause;
		lot_ticket = false;
	};