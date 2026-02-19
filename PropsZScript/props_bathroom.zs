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