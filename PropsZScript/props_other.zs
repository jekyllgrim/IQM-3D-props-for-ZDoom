class ZDP_Generator : ZDP_Base
{
	Default
	{
		//$Title Generator
		Radius 14;
		Height 35.2;
	}
}

class ZDP_FilingCabinetGreen : ZDP_BaseInteractive
{
	int dp_drawerState;

	enum DPEDrawerStates
	{
		DPC_Closed,
		DPC_BottomOpen,
		DPC_MidOpen,
		DPC_TopOpen,
	}

	Default
	{
		//$Title Filing cabinet (green)
		//$Arg4 "Starting state"
		//$Arg4Type 11
		//$Arg4Enum { 0 = "Closed"; 1 = "Bottom drawer open"; 2 = "Middle drawer open"; 3 = "Top drawer open"; }
		Scale 1.4; //this is a bit too small
		Height 45.56 * 1.4;
		Radius 7.6 * 1.4;
		Activesound "zdp/filingcabinet/activate";
		ZDP_Base.DefaultAnimation 'cabinet_idle';
	}

	override void ZDP_Interact (Actor user)
	{
		switch (dp_drawerState)
		{
		case DPC_Closed:
			SetAnimation('cabinet_drawer_bottom');
			break;
		case DPC_BottomOpen:
			SetAnimation('cabinet_drawer_mid');
			break;
		case DPC_MidOpen:
			SetAnimation('cabinet_drawer_top');
			break;
		case DPC_TopOpen:
			SetAnimation('cabinet_close');
			break;
		}
		if (++dp_drawerState > 3)
		{
			dp_drawerState = 0;
		}
		dp_interactDelay = 10;
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

class ZDP_Lamp_Standing : ZDP_BaseInteractive
{
	bool dp_lampOn;

	Default
	{
		//$Title Standing lamp
		//$Arg4 "Initial state"
		//$Arg4Type 11
		//$Arg4Enum { 0 = "Off"; 1 = "On"; }
		Height 48.3;
		Radius 6.8;
		ZDP_Base.DefaultAnimation 'standinglamp_idle';
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
		lightlevel = 32;
		dp_lampOn = true;
		A_ChangeModel("", skinindex: 1, skin: "df/standinglamp/lampshade", flags:CMDL_USESURFACESKIN);
		A_ChangeModel("", skinindex: 3, skin: "df/standinglamp/lightbulb", flags:CMDL_USESURFACESKIN);
	}

	void ZDP_TurnOff()
	{
		A_RemoveLight('lamplight');
		lightlevel = 0;
		dp_lampOn = false;
		A_ChangeModel("", skinindex: 1, skin: "CRATOP2", flags:CMDL_USESURFACESKIN);
		A_ChangeModel("", skinindex: 3, skin: "CRATOP1", flags:CMDL_USESURFACESKIN);
	}

	override void ZDP_Interact (Actor user)
	{
		if (!dp_lampOn)
		{
			ZDP_TurnOn();
		}
		else
		{
			ZDP_TurnOff();
		}
		A_StartSound(activesound);
		SetAnimation('standinglamp_pull');
	}
}

class ZDP_PottedPlant : ZDP_Base
{
	Default
	{
		Scale 1.5;
		Height 36.74 * 1.5;
		Radius 5.95 * 1.5;
	}
}

class ZDP_Trashcan : ZDP_BaseInteractive
{
	Default
	{
		//$Title "Trashcan (interactive)"
		Height 29.4;
		Radius 5;
		ActiveSound "zdp/trashcan/push";
	}

	override void ZDP_Interact(Actor user)
	{
		SetAnimation('trashcan_push');
		A_StartSound(activesound);
	}
}

class ZDP_TrashcanCylindrical : ZDP_BaseInteractive
{
	bool dp_trashcanOpen;

	Default
	{
		//$Title "Trashcan, cylindrical (interactive)"
		Height 30;
		Radius 6;
	}

	override void ZDP_Interact(Actor user)
	{
		if (!dp_trashcanOpen)
		{
			SetAnimation('trashcanCyl_open');
			A_StartSound("zdp/trashcan_cyl/open");
		}
		else
		{
			SetAnimation('trashcanCyl_close');
			A_StartSound("zdp/trashcan_cyl/close");
		}
		dp_interactDelay = 8;
		dp_trashcanOpen = !dp_trashcanOpen;
	}
}

class ZDP_Stretcher : ZDP_Base
{
	Default
	{
		//$Title "Hospital stretcher"
		Height 35;
		Radius 20;
	}
}