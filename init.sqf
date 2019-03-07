Private ["_lot_object", "_lot_distance", "_lot_ticket", "_lot_random", "_lot_jeckpot", "_lot_jeckpot_prize", "_lot_pause", "_data", "_lottery_action", "_su_player_lottery"];
//	Список объектов, рядом с которыми работает меню лотереи(для примера добавлен закрытый сейф, и базовая постройка)
_lot_object	=
	[
		"VaultStorageLocked"
		,"Plastic_Pole_EP1_DZ"
	];
//	Расстояние в метрах, от объекта до игрока, на котором появится меню лотерея
_lot_distance	=	3;
//	Список вариантов ставок - текст|валюта|цена билета|множитель джек пота(не должен быть нулем)
//	Для баксов
_lot_ticket	=
	[
		["Купить билет - 10 баксов",10,10,1]
		,["Купить билет - 20 баксов",20,20,2]
		,["Купить билет - 30 баксов",30,30,5]
	];
//	Для золота
/* 
_lot_ticket	=
	[
		["Купить билет - 1 голд","itemGoldBar",1,1]
		,["Купить билет - 2 голд","itemGoldBar",2,2]
		,["Купить билет - 3 голд","itemGoldBar",3,5]
	];
*/
//	Число от 4 до ... - влияет на возможность выйгрыша предметов. 0 - оружие, 1 - магазины(вещи в магазинных ячейках), 2 - рюкзак, 3 - техника, 4 - скрипт. 5 и более - ничего.
_lot_random		=	5;	//	Чем выше число, тем меньше шансов что то выиграть
//	Точное число, при котором сработает Джек пот.
_lot_jeckpot	=	3;	//	Чем меньше число, тем больше шансов получить Джекпот
//	Приз при джекпот
//	Для баксов
_lot_jeckpot_prize	=	100;	//	Кол-во зависит от последней цифры в _lot_ticket
//	Для золота
/*
_lot_jeckpot_prize	=	"ItemBriefcase100oz";	//	Кол-во зависит от последней цифры в _lot_ticket
*/
//	Пауза лотереи, - время, в секундах которое должно пройти с момента покупки билета, до выдачи приза. - Если не нужна - 0.
_lot_pause	=	1;

//--------------------------------------------------------------------------------------------------------------------------

_data				=	[_lot_random, _lot_jeckpot, _lot_jeckpot_prize, _lot_pause];
su_player_lotterys	=	[];
[] call compile preprocessFileLineNumbers "custom\lottery\configs.sqf";
[] call compile preprocessFileLineNumbers "custom\lottery\functions.sqf";
lot_ticket	=	false;
while {true} do
	{
		_lottery_action	=	count (nearestObjects [(getPos player), _lot_object, _lot_distance]) > 0;
		if (_lottery_action) then
			{
				if ( (count su_player_lotterys) == 0 ) then
					{
						{
							_data				=	[_lot_random, _lot_jeckpot, _lot_jeckpot_prize, _lot_pause, (_x select 1), (_x select 2), (_x select 3)];
							_su_player_lottery	=	player addaction[(_x select 0), "custom\lottery\lottery.sqf", _data, 5, false, true, "", ""];
							su_player_lotterys set [count su_player_lotterys, _su_player_lottery];
						} forEach _lot_ticket;
					};
			}
		else
			{
				if ( (count su_player_lotterys) != 0 ) then
					{
						{player removeAction _x;} forEach su_player_lotterys;
						su_player_lotterys	=	[];
					};	
			};
		sleep 1;
	};
