class ZDP_Base : Actor abstract
{
	double user_objectScale;

	Default
	{
		//$Category "ZDoom 3D props"
		//$Angled
		//$Color Brown
		//$Arg0 "Solid"
		//$Arg0Enum { 0 = "True"; 1 = "False"}
		//$Arg1 "No gravity"
		//$Arg1Enum { 0 = "False"; 1 = "True"}
		//$Arg2 "Block hitscans (has to be solid)"
		//$Arg2Enum { 0 = "False"; 1 = "True"}
		Scale 1.2;
		+SOLID
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		bSolid = args[0] <= 0;
		bNogravity = args[1];
		if (args[2] > 0)
		{
			bSHOOTABLE = true;
			bNOBLOOD = true;
			bNODAMAGETHRUST = true;
		}
		if (user_objectScale > 0)
		{
			A_SetScale(user_objectScale);
			A_SetSize(radius * user_objectScale, height * user_objectScale);
		}
	}

	States {
	Spawn:
		M000 A -1;
		stop;
	}
}

class ZDP_BaseInteractive : ZDP_Base abstract
{
	bool df_interactive;

	Default
	{
		//$Arg3 "Interactive (has to be solid)"
		//$Arg3Enum { 0 = "True"; 1 = "False"}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		df_interactive = args[3] == 0;
	}

	override bool Used(Actor user)
	{
		return df_interactive;
	}
}

class ZDP_OfficeDesk : ZDP_Base
{
	Default
	{
		//$Title Office desk
		Radius 24;
		Height 24;
	}
}

class ZDP_OfficeDesk_Drawers : ZDP_OfficeDesk
{
	Default
	{
		//$Title Office desk with drawers
	}
}

class ZDP_OfficeChair_Black : ZDP_Base
{
	Default
	{
		//$Title Office chair (black)
		Radius 8;
		Height 14;
	}
}

class ZDP_OfficeChair_Green : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair (green)
	}
}

class ZDP_OfficeChair_Blue : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair (blue)
	}
}

class ZDP_OfficeChair_Red : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair (red)
	}
}

class ZDP_OfficeChair_Black_Norests : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair - no arm rests (black)
	}
}

class ZDP_OfficeChair_Green_Norests : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair - no arm rests (green)
	}
}

class ZDP_OfficeChair_Blue_Norests : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair - no arm rests (blue)
	}
}

class ZDP_OfficeChair_Red_Norests : ZDP_OfficeChair_Black
{
	Default
	{
		//$Title Office chair - no arm rests (red)
	}
}

class ZDP_ChairWoodFancy : ZDP_Base
{
	Default
	{
		//$Title Wooden chair - fancy
		Radius 12;
		Height 20;
	}
}

class ZDP_ChairWoodSimple : ZDP_Base
{
	Default
	{
		//$Title Wooden chair - simple
		Radius 12;
		Height 20;
	}
}

class ZDP_Stool : ZDP_Base
{
	Default
	{
		//$Title Wooden stool
		Radius 12;
		Height 20;
	}
}

class ZDP_TableWoodRect : ZDP_Base
{
	Default
	{
		//$Title Wooden table - rectangular
		Radius 30;
		Height 30;
	}
}

class ZDP_TableWoodRound : ZDP_Base
{
	Default
	{
		//$Title Wooden table - round
		Radius 30;
		Height 22;
	}
}

class ZDP_Generator : ZDP_Base
{
	Default
	{
		//$Title Generator
		Radius 20;
		Height 30;
	}
}

class ZDP_FilingCabinetGreen : ZDP_BaseInteractive
{
	int df_drawerState;
	enum EDrawerStates
	{
		ZDP_DS_Closed,
		ZDP_DS_Bottom,
		ZDP_DS_Mid,
		ZDP_DS_Top,
	}
	const ZDP_DRAWERTICS = 16;

	Default
	{
		//$Title Filing cabinet (green)
		//$Arg4 "Starting state"
		//$Arg4Enum { 0 = "Closed"; 1 = "Bottom drawer open"; 2 = "Middle drawer open"; 3 = "Top drawer open"}
		Height 45;
		Radius 10;
		Scale 1.4;
		Activesound "zdp/filingcabinet/activate";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		df_drawerState = clamp(args[4], ZDP_DS_Closed, ZDP_DS_Top);
		switch (df_drawerState)
		{
		case ZDP_DS_Bottom:
			SetStateLabel('DrawerBotOpen');
			break;
		case ZDP_DS_Mid:
			SetStateLabel('DrawerMidOpen');
			break;
		case ZDP_DS_Top:
			SetStateLabel('DrawerTopOpen');
			break;
		}
	}

	override bool Used (Actor user)
	{
		if (!Super.Used(user)) return false;

		df_drawerState++;
		if (df_drawerState > ZDP_DS_Top) df_drawerState = ZDP_DS_Closed;
		switch (df_drawerState)
		{
		case ZDP_DS_Bottom:
			SetStateLabel('DrawerBot');
			break;
		case ZDP_DS_Mid:
			SetStateLabel('DrawerMid');
			break;
		case ZDP_DS_Top:
			SetStateLabel('DrawerTop');
			break;
		case ZDP_DS_Closed:
			SetStateLabel('CloseDrawers');
			break;
		}
		return true;
	}
	
	States {
	Spawn:
		M000 A -1;
		stop;
	DrawerBot:
		M000 A ZDP_DRAWERTICS;
	DrawerBotOpen:
		M000 B -1;
		stop;
	DrawerMid:
		M000 B ZDP_DRAWERTICS;
	DrawerMidOpen:
		M000 C -1;
		stop;
	DrawerTop:
		M000 C ZDP_DRAWERTICS;
	DrawerTopOpen:
		M000 D -1;
		stop;
	CloseDrawers:
		M000 D ZDP_DRAWERTICS;
		goto Spawn;
	}
}

class ZDP_FilingCabinetWhite : ZDP_FilingCabinetGreen
{
	Default
	{
		//$Title Filing cabinet (white)
	}
}

class ZDP_FilingCabinetTan : ZDP_FilingCabinetGreen
{
	Default
	{
		//$Title Filing cabinet (tan)
	}
}

class ZDP_PC_Retro : ZDP_Base
{
	Default
	{
		//$Title PC (retro)
		Height 24;
		Radius 32;
	}
}

class ZDP_PC_Retro_Keyboard : ZDP_Base
{
	Default
	{
		//$Title PC (retro) keyboard
		Height 2;
		Radius 10;
		-SOLID
	}
}

class ZDP_PC_Retro_Monitor : ZDP_Base
{
	Default
	{
		//$Title PC (retro) monitor
		Height 20;
		Radius 10;
	}
}

class ZDP_PC_Retro_Tower : ZDP_Base
{
	Default
	{
		
		//$Title PC (retro) tower
		Height 24;
		Radius 10;
	}
}

class ZDP_PC_Modern : ZDP_Base
{
	Default
	{
		//$Title PC (modern)
		Height 24;
		Radius 32;
	}
}

class ZDP_PC_Modern_Keyboard : ZDP_Base
{
	Default
	{
		//$Title PC (modern) keyboard
		Height 2;
		Radius 10;
		-SOLID
	}
}

class ZDP_PC_Modern_Monitor : ZDP_Base
{
	Default
	{
		//$Title PC (modern) monitor
		Height 20;
		Radius 10;
	}
}

class ZDP_PC_Modern_Tower : ZDP_Base
{
	Default
	{
		//$Title PC (modern) tower
		Height 24;
		Radius 10;
	}
}

class ZDP_Lamp_Standing : ZDP_BaseInteractive
{
	bool df_lampOn;

	Default
	{
		//$Title Standing lamp
		//$Arg4 "Initial state"
		//$Arg4Enum { 0 = "Off"; 1 = "On" }
		Height 70;
		Radius 8;
		+ADDLIGHTLEVEL
		Activesound "zdp/standinglamp/activate";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		if (args[4] > 0)
		{
			ZDP_TurnOn();
		}
	}

	void ZDP_TurnOn()
	{
		A_AttachLight('lamplight',
			DynamicLight.PointLight,
			0xb48b69,
			64, 0,
			DYNAMICLIGHT.LF_ATTENUATE,
			(0,0,72)
		);
		SetStateLabel("TurnOn");
		lightlevel = 32;
		df_lampOn = true;
	}

	void ZDP_TurnOff()
	{
		A_RemoveLight('lamplight');
		SetStateLabel("TurnOff");
		lightlevel = 0;
		df_lampOn = false;
	}

	override bool Used (Actor user)
	{
		if (!Super.Used(user)) return false;

		if (!df_lampOn)
		{
			ZDP_TurnOn();
		}
		else
		{
			ZDP_TurnOff();
		}
		A_StartSound(activesound);
		return true;
	}

	States {
	TurnOff:
		M000 B 10;
	Spawn:
		M000 A -1;
		stop;
	TurnOn:
		M000 D 10;
		M000 C -1;
		stop;
	}
}

class ZDP_PottedPlant : ZDP_Base
{
	Default
	{
		height 48;
		Radius 6;
	}
}

class ZDP_Armchair_Black : ZDP_Base
{
	Default
	{
		//$Title "Armchair (black)"
	}
}

class ZDP_Armchair_Blue : ZDP_Base
{
	Default
	{
		//$Title "Armchair (blue)"
	}
}

class ZDP_Toilet : ZDP_BaseInteractive
{
	int df_toiletAction;
	int df_toiletActionDir;

	enum EToiletActions
	{
		ZDP_T_CloseLid,
		ZDP_T_MoveLid,
		ZDP_T_MoveSeat,
		ZDP_T_Flush,
	}

	Default
	{
		//$Title "Toilet (interactive)"
		//$Arg4 "Initial state"
		//$Arg4Enum { 0 = "Lid & seat closed"; 1 = "Lid raised"; 2 = "Lid & seat raised" }
		Activesound "zdp/toilet/flush";
	}

	override bool Used (Actor user)
	{
		if (!Super.Used(user)) return false;
		if (curstate.tics >= 0) return false;

		if (df_toiletActionDir == 0)
		{
			df_toiletActionDir = 1;
		}
		df_toiletAction += clamp(df_toiletActionDir, -1, 1);

		switch (df_toiletAction)
		{
		case ZDP_T_CloseLid:
			SetStateLabel('LidClose');
			df_toiletActionDir = 1;
			break;
		case ZDP_T_MoveLid:
			SetStateLabel('LidMove');
			break;
		case ZDP_T_MoveSeat:
			SetStateLabel('SeatMove');
			break;
		case ZDP_T_Flush:
			SetStateLabel('FlushWater');
			A_StartSound(Activesound);
			df_toiletActionDir = -1;
			df_toiletAction = ZDP_T_MoveSeat;
			break;
		}
		return true;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		switch (args[4])
		{
		case ZDP_T_MoveLid:
			SetStateLabel('LidOpened');
			df_toiletAction = ZDP_T_MoveLid;
			break;
		case ZDP_T_MoveSeat:
			SetStateLabel('SeatOpened');
			df_toiletAction = ZDP_T_MoveLid;
			break;
		}
	}

	States {
	LidClose:
		M000 # 15;
	Spawn:
		M000 A -1;
		stop;
	LidMove:
		M000 # 15;
	LidOpened:
		M000 B -1;
		stop;
	SeatMove:
		M000 # 15;
	SeatOpened:
		M000 C -1;
		stop;
	FlushWater:
		M000 # 20;
		M000 DD 20;
		goto SeatOpened;
	}
}