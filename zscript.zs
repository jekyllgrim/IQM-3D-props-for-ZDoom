version "4.14.0"

class ZDP_CollisionBox : Actor
{
	Default
	{
		//$Category "ZDoom 3D props"
		//$Title "Collision box (customizable size)"
		//$Angled
		//$Color Cyan
		//$Arg0 "Radius"
		//$Arg0Type 23
		//$Arg1 "Height"
		//$Arg1Type 24
		//$Arg2 "Block attacks"
		//$Arg2Type 11
		//$Arg2Enum { 0 = "False"; 1 = "True"; }
		+NOGRAVITY
		+SOLID
		+CANPASS
		Radius 1;
		Height 1;
	}

	override void PostBeginPlay()
	{
		A_SetRenderStyle(0, STYLE_None);
		Super.PostBeginPlay();
		if (args[2])
		{
			bShootable = bNoBlood = bNoDamage = bNoDamageThrust = true;
		}
		A_SetSize(args[0] > 0? args[0] : radius, args[1] > 0? args[1] : height);
	}

	States {
	Spawn:
		M000 A -1;
		stop;
	}
}

class ZDP_Base : Actor abstract
{
	protected double user_objectScale;
	protected name dp_defaultAnimation;
	Property DefaultAnimation : dp_defaultAnimation;

	Default
	{
		//$Category "ZDoom 3D props"
		//$Angled
		//$Color Brown
		
		//$Arg0 "No gravity"
		//$Arg0Type 11
		//$Arg0Enum { 0 = "False"; 1 = "True"; }

		//$Arg1 "Movement collision"
		//$Arg1Type 11
		//$Arg1Enum { 0 = "None"; 1 = "Can stand on others"; "Fully solid"; }

		//$Arg2 "Attack collision"
		//$Arg2Type 11
		//$Arg2Enum { 0 = "None"; "Only projectiles"; "Full"; }

		Scale 1.2;
		ZDP_Base.DefaultAnimation 'idle';
		+NOBLOOD
		+NODAMAGE
		+NODAMAGETHRUST
	}

	override bool CanCollideWith(Actor other, bool passive)
	{
		// specifically for cases where both SOLID and
		// SHOOTABLE are false, but "Attack collision"
		// is set to "Only projectiles":
		if (args[2] == 1 && passive && other && other.bMissile)
		{
			return true;
		}
		return Super.CanCollideWith(other, passive);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		bNogravity = args[0];

		if (user_objectScale > 0)
		{
			A_SetScale(user_objectScale);
			A_SetSize(radius * scale.x, height * scale.y);
		}

		bSolid = args[1] >= 2;
		bCanPass = args[1] >= 1;

		if (args[2] >= 2)
		{
			bShootable = true;
		}
		else if (args[2] == 0)
		{
			bNonShootable = true;
		}

		if (bDecoupledAnimations && dp_defaultAnimation != 'none')
		{
			SetAnimation(dp_defaultAnimation, flags:SAF_INSTANT);
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
	protected bool dp_interactive;
	protected uint dp_interactDelay;

	Default
	{
		//$Arg3 "Interactive"
		//$Arg3Type 11
		//$Arg3Enum { 0 = "True"; 1 = "False"; }
		+DECOUPLEDANIMATIONS
	}

	// Used() only works on solid objects. If the mapper sets
	// the object to be NON-solid but interactive, instead of
	// unsetting the bSolid flag, we keep it true and use this
	// override to make it *effectively* non-solid but still
	// let Used() be called:
	override bool CanCollideWith(Actor other, bool passive)
	{
		if (args[1] == 0)
		{
			return Super.CanCollideWith(other, passive);
		}
		return false;
	}

	override bool Used(Actor user)
	{
		if(dp_interactive && !dp_interactDelay)
		{
			dp_interactDelay = 2;
			ZDP_Interact(user);
			return true;
		}
		return false;
	}

	virtual void ZDP_Interact(Actor user)
	{}

	override void Activate(Actor activator)
	{
		dp_interactive = true;
	}

	override void Deactivate(Actor activator)
	{
		dp_interactive = false;
	}

	override void Tick()
	{
		Super.Tick();
		if (!isFrozen() && dp_interactDelay)
		{
			dp_interactDelay--;
		}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		// If the object is interactive, it has to be solid. If the user
		// wants it to be non-solid but still interactive, we use
		// the CanCollideWith() override instead of this flag:
		if (dp_interactive)
		{
			bSolid = true;
		}
		dp_interactive = args[3] == 0;
	}
}

class ZDP_OfficeDesk : ZDP_Base
{
	Default
	{
		//$Title Office desk
		Radius 24;
		Height 28.2;
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
		Height 17.63;
		Radius 6.58;
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
		Height 15.35;
	}
}

class ZDP_ChairWoodSimple : ZDP_Base
{
	Default
	{
		//$Title Wooden chair - simple
		Radius 12;
		Height 18;
	}
}

class ZDP_Stool : ZDP_Base
{
	Default
	{
		//$Title Wooden stool
		Radius 12;
		Height 24.3;
	}
}

class ZDP_TableWoodRect_Rough : ZDP_Base
{
	Default
	{
		//$Title Wooden table, rectangular (rough)
		Radius 30;
		Height 35;
	}
}

class ZDP_TableWoodRect_Smooth : ZDP_Base
{
	Default
	{
		//$Title Wooden table, rectangular (smooth)
		Radius 30;
		Height 32.34;
	}
}

class ZDP_TableWoodSquare : ZDP_Base
{
	Default
	{
		//$Title Wooden table, square
		Radius 20;
		Height 35;
	}
}

class ZDP_TableWoodRound : ZDP_Base
{
	Default
	{
		//$Title Wooden table, round (smooth)
		Radius 32;
		Height 34.4;
	}
}

class ZDP_TableCoffee : ZDP_Base
{
	Default
	{
		//$Title Wooden table, round (smooth)
		Height 22.3;
		Radius 19;
	}
}

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

class ZDP_PC_Retro : ZDP_Base
{
	Default
	{
		//$Title PC (retro)
		Height 30;
		Radius 25;
	}
}

class ZDP_PC_Retro_Keyboard : ZDP_Base
{
	Default
	{
		//$Title PC (retro) keyboard
		Height 2;
		Radius 10;
	}
}

class ZDP_PC_Retro_Monitor : ZDP_Base
{
	Default
	{
		//$Title PC (retro) monitor
		Height 23.5;
		Radius 10;
	}
}

class ZDP_PC_Retro_Tower : ZDP_Base
{
	Default
	{
		
		//$Title PC (retro) tower
		Height 30;
		Radius 6;
	}
}

class ZDP_PC_Modern : ZDP_Base
{
	Default
	{
		//$Title PC (modern)
		Height 28.5;
		Radius 6.6;
	}
}

class ZDP_PC_Modern_Keyboard : ZDP_PC_Modern
{
	Default
	{
		//$Title PC (modern) keyboard
		Height 2;
		Radius 10;
	}
}

class ZDP_PC_Modern_Monitor : ZDP_PC_Modern
{
	Default
	{
		//$Title PC (modern) monitor
		Height 25.6;
		Radius 16.5;
	}
}

class ZDP_PC_Modern_Tower : ZDP_PC_Modern
{
	Default
	{
		//$Title PC (modern) tower
		Height 28.5;
		Radius 10;
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

class ZDP_Armchair_Black : ZDP_Base
{
	Default
	{
		//$Title "Armchair (black)"
		Height 15.4;
		Radius 14;
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
	protected int dp_toiletState;
	protected int dp_toiletActDir;

	enum DPEToiletStates
	{
		DPT_AllClosed,
		DPT_LidOpen,
		DPT_SeatOpen,
	}

	Default
	{
		//$Title "Toilet (interactive)"
		//$Arg4 "Initial state"
		//$Arg4Type 11
		//$Arg4Enum { 0 = "Lid & seat closed"; 1 = "Lid raised"; 2 = "Lid & seat raised"; }
		Activesound "zdp/toilet/flush";
		ZDP_Base.DefaultAnimation 'toilet_idle';
		Height 20;
		Radius 13;
	}

	override void ZDP_Interact(Actor user)
	{
		switch(dp_toiletState)
		{
		case DPT_AllClosed:
			SetAnimation('toilet_lid_open');
			dp_toiletActDir = 1;
			break;
		case DPT_LidOpen:
			SetAnimation(dp_toiletActDir > 0? 'toilet_seat_open' : 'toilet_lid_close');
			break;
		case DPT_SeatOpen:
			if (dp_toiletActDir > 0)
			{
				SetAnimation('toilet_flush');
				dp_interactDelay = 62;
				dp_toiletActDir = 0;
			}
			else
			{
				SetAnimation('toilet_seat_close');
				dp_toiletActDir = -1;
			}
			A_StartSound(activesound);
			break;
		}
		dp_toiletState += dp_toiletActDir;
	}
}

class ZDP_Sink : ZDP_BaseInteractive
{
	protected FSpawnParticleParams dp_sinkwater;
	protected Vector3 dp_waterOfs;

	Default
	{
		//$Title "Sink (interactive)"
		Height 36;
		Radius 7.5;
		Activesound "zdp/sink/activate";
	}

	override void ZDP_Interact(Actor user)
	{
		SetAnimation('sink_activate');
		A_StartSound(activesound);
		dp_interactDelay = 148;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		dp_waterOfs = (8, 0, 40.88);
		dp_sinkwater.size = 2.4;
		dp_sinkwater.startalpha = 0.7;
		dp_sinkwater.vel.z = frandom[sinkwater](-1, -0.5);
		dp_sinkwater.lifetime = 12;
		dp_sinkwater.sizestep = 0.1;
		dp_sinkwater.color1 = 0x000080;
	}

	override void Tick()
	{
		Super.Tick();
		if (isFrozen() || !dp_interactDelay) return;

		
		dp_sinkwater.pos.xy = level.Vec2Offset(pos.xy, Actor.RotateVector(dp_waterOfs.xy, angle));
		dp_sinkwater.pos.z = pos.z + dp_waterOfs.z;
		dp_sinkwater.vel.x = frandom[sinkwater](-0.1, 0.1);
		dp_sinkwater.vel.y = frandom[sinkwater](-0.1, 0.1);
		level.SpawnParticle(dp_sinkwater);
	}
}

class ZDP_SinkWithBase : ZDP_Sink
{
	Default
	{
		//$Title "Sink with a base (interactive)"
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