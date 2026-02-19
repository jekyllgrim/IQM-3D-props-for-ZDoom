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
		if (args[2] != 0)
		{
			bShootable = bNoBlood = bNoDamage = bDontThrust = true;
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
	enum EMoveCollision
	{
		MOVC_None,
		MOVC_OtherProps,
		MOVC_Full,
	}
	enum EAttackCollision
	{
		ATKC_None,
		ATKC_ProjectilesOnly,
		ATKC_HitscanOnly,
		ATKC_Full,
	}

	protected double user_objectScale;
	protected name dp_defaultAnimation;
	Property DefaultAnimation : dp_defaultAnimation;

	Default
	{
		//$Category "ZDoom 3D props"
		//$Angled
		//$Color Brown
		
		//$Arg0 "Disable gravity"
		//$Arg0Type 11
		//$Arg0Enum { 0 = "False"; 1 = "True"; }

		//$Arg1 "Movement collision"
		//$Arg1Type 11
		//$Arg1Enum { 0 = "None"; 1 = "Only other props"; 2 = "Fully solid"; }

		//$Arg2 "Attack collision"
		//$Arg2Type 11
		//$Arg2Enum { 0 = "None"; 1 = "Only projectiles"; 2 = "Only hitscans"; 3 = "Full"; }

		Scale 1.2;
		ZDP_Base.DefaultAnimation 'idle';
		+NOBLOOD
		+NODAMAGE
		+DONTTHRUST
		+SOLID
	}

	EMoveCollision GetMoveCollision()
	{
		return args[1];
	}

	EAttackCollision GetAttackCollision()
	{
		return args[2];
	}

	// This actor always has bSolid. This override is
	// only to handle some custom rules:
	override bool CanCollideWith(Actor other, bool passive)
	{
		/*Console.Printf("\cd%s\c- (%.1f) is trying to \cy%s\c- collide with \cd%s\c- (%.1f)",
			self.GetClassName(),
			self.pos.z,
			passive? "passively" : "actively",
			other.GetClassName(),
			other.pos.z
		);*/
		switch (GetMoveCollision())
		{
			// No collision - remain non-solid for non-projectiles.
			// For projectiles return true and let
			// bShootable/bNonShootable handle the actual collision:
			case MOVC_None:
				return other.bMissile;
				break;
			// Other propes - collide with them only if they also
			// use this collision rule:
			case MOVC_OtherProps:
				let prop = ZDP_Base(other);
				return prop && prop.GetMoveCollision() != MOVC_None;
				break;
		}
		// If movement collision is MOVC_Full, or the other is a
		// projectile, let the super call handle it as usual:
		return Super.CanCollideWith(other, passive);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		if (bDecoupledAnimations && dp_defaultAnimation != 'none')
		{
			SetAnimation(dp_defaultAnimation, flags:SAF_INSTANT);
		}

		if (user_objectScale > 0)
		{
			A_SetScale(user_objectScale);
			A_SetSize(radius * scale.x, height * scale.y);
		}

		bNogravity = args[0];

		// Disable all interactivity if it's indeed non-interactive:
		if (GetMoveCollision() == MOVC_None && GetAttackCollision() == ATKC_None && !(self is 'ZDP_BaseInteractive'))
		{
			bSolid = false;
			bShootable = false;
			A_ChangeLinkFlags(true);
			bNoInteraction = true;
			return;
		}

		bCanPass = GetMoveCollision() >= MOVC_OtherProps;

		switch(GetAttackCollision())
		{
			case ATKC_HitscanOnly:
				bNonShootable = true;
			case ATKC_Full:
				bShootable = true;
				break;
		}
		Console.Printf("\cy%s\c- | Solid \cd%d\c- | Canpass \cd%d\c- | Shootable \cd%d\c- | NonShootable \cd%d\c- | NoBlockMap \cd%d\c- | NoInteraction \cd%d\c-",
			self.GetClassName(),
			bSolid,
			bCanpass,
			bShootable,
			bNonShootable,
			bNoBlockmap,
			bNoInteraction
		);
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
		dp_interactive = args[3] == 0;
	}
}