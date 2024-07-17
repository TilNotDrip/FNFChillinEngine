package objects.menu;

import flixel.util.FlxSignal;
import flxanimate.FlxAnimate;

class DJBoyfriend extends FlxAnimate
{
	// Represents the sprite's current status.
	// Without state machines I would have driven myself crazy years ago.
	public var currentState:DJBoyfriendState = Intro;

	// A callback activated when the intro animation finishes.
	public var onIntroDone:FlxSignal = new FlxSignal();

	// A callback activated when Boyfriend gets spooked.
	public var onSpook:FlxSignal = new FlxSignal();

	// playAnim stolen from Character.hx, cuz im lazy lol!
	// TODO: Switch this class to use SwagSprite instead.
	public var animOffsets:Map<String, Array<Dynamic>>;

	var gotSpooked:Bool = false;

	static final SPOOK_PERIOD:Float = 120.0;
	static final TV_PERIOD:Float = 180.0;

	// Time since dad last SPOOKED you.
	var timeSinceSpook:Float = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y, Paths.location.atlas("freeplay/freeplay-boyfriend"));

		animOffsets = new Map<String, Array<Dynamic>>();

		anim.callback = function(name:String, frame:Int)
		{
			switch (name)
			{
				case "Boyfriend DJ watchin tv OG":
					if (frame == 80)
					{
						FlxG.sound.play(Paths.location.sound('remote_click'));
					}
					if (frame == 85)
					{
						runTvLogic();
					}
			}
		};

		setupAnimations();

		FlxG.debugger.track(this);
		FlxG.console.registerObject("dj", this);

		anim.onComplete = onFinishAnim;

		FlxG.console.registerFunction("tv", function()
		{
			currentState = TV;
		});
	}

	/*
		[remote hand under,boyfriend top head,brim piece,arm cringe l,red lazer,dj arm in,bf fist pump arm,hand raised right,forearm left,fist shaking,bf smile eyes closed face,arm cringe r,bf clenched face,face shrug,boyfriend falling,blue tint 1,shirt sleeve,bf clenched fist,head BF relaxed,blue tint 2,hand down left,blue tint 3,blue tint 4,head less smooshed,blue tint 5,boyfriend freeplay,BF head slight turn,blue tint 6,arm shrug l,blue tint 7,shoulder raised w sleeve,blue tint 8,fist pump face,blue tint 9,foot rested light,hand turnaround,arm chill right,Boyfriend DJ,arm shrug r,head back bf,hat top piece,dad bod,face surprise snap,Boyfriend DJ fist pump,office chair,foot rested right,chest down,office chair upright,body chill,bf dj afk,head mouth open dad,BF Head defalt HAIR BLOWING,hand shrug l,face piece,foot wag,turn table,shoulder up left,turntable lights,boyfriend dj body shirt blowing,body chunk turned,hand down right,dj arm out,hand shrug r,body chest out,rave hand,palm,chill face default,head back semi bf,boyfriend bottom head,DJ arm,shoulder right dad,bf surprise,boyfriend dj body,hs1,Boyfriend DJ watchin tv OG,spinning disk,hs2,arm chill left,boyfriend dj intro,hs3,hs4,chill face extra,hs5,remote hand upright,hs6,pant over table,face surprise,bf arm peace,arm turnaround,bf eyes 1,arm slammed table,eye squit,leg BF,head mid piece,arm backing,arm swoopin in,shoe right lowering,forearm right,hand out,blue tint 10,body falling back,remote thumb press,shoulder,hair spike single,bf bent
		arm,crt,foot raised right,dad hand,chill face 1,chill face 2,clenched fist,head SMOOSHED,shoulder left dad,df1,body chunk upright,df2,df3,df4,hat front piece,df5,foot rested right 2,hand in,arm spun,shoe raised left,bf 1 finger hand,bf mouth 1,Boyfriend DJ confirm,forearm down ,hand raised left,remote thumb up]
	 */
	public function listAnimations():Array<String>
	{
		var anims:Array<String> = [];
		@:privateAccess
		for (animKey in anim.symbolDictionary)
		{
			anims.push(animKey.name);
		}
		return anims;
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		switch (currentState)
		{
			case Intro:
				// Play the intro animation then leave this state immediately.
				if (getCurrentAnimation() != 'boyfriend dj intro')
					playFlashAnimation('boyfriend dj intro', true);
				timeSinceSpook = 0;
			case Idle:
				// We are in this state the majority of the time.
				if (getCurrentAnimation() != 'Boyfriend DJ')
				{
					playFlashAnimation('Boyfriend DJ', true);
				}

				if (getCurrentAnimation() == 'Boyfriend DJ' && this.isLoopFinished())
				{
					if (timeSinceSpook >= SPOOK_PERIOD && !gotSpooked)
					{
						currentState = Spook;
					}
					else if (timeSinceSpook >= TV_PERIOD)
					{
						currentState = TV;
					}
				}
				timeSinceSpook += elapsed;
			case Confirm:
				if (getCurrentAnimation() != 'Boyfriend DJ confirm')
					playFlashAnimation('Boyfriend DJ confirm', false);
				timeSinceSpook = 0;
			case Spook:
				if (getCurrentAnimation() != 'bf dj afk')
				{
					onSpook.dispatch();
					playFlashAnimation('bf dj afk', false);
					gotSpooked = true;
				}
				timeSinceSpook = 0;
			case TV:
				if (getCurrentAnimation() != 'Boyfriend DJ watchin tv OG')
					playFlashAnimation('Boyfriend DJ watchin tv OG', true);
				timeSinceSpook = 0;
			default:
				// I shit myself.
		}

		#if DEBUG
		if (FlxG.keys.pressed.CONTROL)
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				this.offsetX -= FlxG.keys.pressed.ALT ? 0.1 : (FlxG.keys.pressed.SHIFT ? 10.0 : 1.0);
			}

			if (FlxG.keys.justPressed.RIGHT)
			{
				this.offsetX += FlxG.keys.pressed.ALT ? 0.1 : (FlxG.keys.pressed.SHIFT ? 10.0 : 1.0);
			}

			if (FlxG.keys.justPressed.UP)
			{
				this.offsetY -= FlxG.keys.pressed.ALT ? 0.1 : (FlxG.keys.pressed.SHIFT ? 10.0 : 1.0);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				this.offsetY += FlxG.keys.pressed.ALT ? 0.1 : (FlxG.keys.pressed.SHIFT ? 10.0 : 1.0);
			}

			if (FlxG.keys.justPressed.SPACE)
			{
				currentState = (currentState == Idle ? TV : Idle);
			}
		}
		#end
	}

	public function isLoopFinished():Bool
	{
		if (this.anim == null)
			return false;
		if (!this.anim.isPlaying)
			return false;

		// Reverse animation finished.
		if (this.anim.reversed && this.anim.curFrame == 0)
			return true;
		// Forward animation finished.
		if (!this.anim.reversed && this.anim.curFrame >= (this.anim.length - 1))
			return true;

		return false;
	}

	function onFinishAnim():Void
	{
		var name = anim.curSymbol.name;
		switch (name)
		{
			case "boyfriend dj intro":
				trace('Finished intro');
				currentState = Idle;
				onIntroDone.dispatch();

			case "bf dj afk":
				currentState = Idle;

			case "Boyfriend DJ watchin tv OG":
				var frame:Int = FlxG.random.bool(33) ? 112 : 166;

				// BF switches channels when the video ends, or at a 10% chance each time his idle loops.
				if (FlxG.random.bool(5))
				{
					frame = 60;
					runTvLogic();
				}
				anim.play("Boyfriend DJ watchin tv OG", true, false, frame);
		}
	}

	public function resetAFKTimer():Void
	{
		timeSinceSpook = 0;
		gotSpooked = false;
	}

	var offsetX:Float = 0.0;
	var offsetY:Float = 0.0;

	function setupAnimations():Void
	{
		// Intro
		addOffset('boyfriend dj intro', 8.0 - 1.3, 3.0 - 0.4);

		// Idle
		addOffset('Boyfriend DJ', 0, 0);

		// Confirm
		addOffset('Boyfriend DJ confirm', 0, 0);

		// AFK: Spook
		addOffset('bf dj afk', 649.5, 58.5);

		// AFK: TV
		addOffset('Boyfriend DJ watchin tv OG', 0, 0);
	}

	var cartoonSnd:Null<FlxSound> = null;

	public var playingCartoon:Bool = false;

	public function runTvLogic()
	{
		if (cartoonSnd == null)
		{
			// tv is OFF, but getting turned on
			FlxG.sound.play(Paths.location.sound('tv_on'), 1.0, false, null, true, function()
			{
				loadCartoon();
			});
		}
		else
		{
			// plays it smidge after the click
			FlxG.sound.play(Paths.location.sound('channel_switch'), 1.0, false, null, true, function()
			{
				cartoonSnd.destroy();
				loadCartoon();
			});
		}

		// loadCartoon();
	}

	function loadCartoon()
	{
		cartoonSnd = FlxG.sound.load(Paths.location.sound(getRandomFlashToon()), 1.0, false, null, true, true, function()
		{
			anim.play("Boyfriend DJ watchin tv OG", true, false, 60);
		});

		// Fade out music to 40% volume over 1 second.
		// This helps make the TV a bit more audible.
		FlxG.sound.music.fadeOut(1.0, 0.4);

		// Play the cartoon at a random time between the start and 5 seconds from the end.
		cartoonSnd.time = FlxG.random.float(0, Math.max(cartoonSnd.length - (5 * 1000), 0.0));
	}

	final cartoonList:Array<String> = openfl.utils.Assets.list().filter(function(path) return path.startsWith("assets/sounds/cartoons/"));

	function getRandomFlashToon():String
	{
		var randomFile = FlxG.random.getObject(cartoonList);

		// Strip folder prefix
		randomFile = randomFile.replace("assets/sounds/", "");
		// Strip file extension
		randomFile = randomFile.substring(0, randomFile.length - 4);

		return randomFile;
	}

	public function confirm():Void
	{
		currentState = Confirm;
	}

	public function dance():Void
	{
		if (currentState == Idle)
			playFlashAnimation('Boyfriend DJ', true);
	}

	public inline function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function getCurrentAnimation():String
	{
		if (this.anim == null || this.anim.curSymbol == null)
			return "";
		return this.anim.curSymbol.name;
	}

	public function playFlashAnimation(id:String, ?Force:Bool = false, ?Reverse:Bool = false, ?Frame:Int = 0):Void
	{
		anim.play(id, Force, Reverse, Frame);
		applyAnimOffset();
	}

	function applyAnimOffset()
	{
		var AnimName = getCurrentAnimation();
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			var xValue = daOffset[0];
			var yValue = daOffset[1];
			if (AnimName == "Boyfriend DJ watchin tv OG")
			{
				xValue += offsetX;
				yValue += offsetY;
			}

			offset.set(xValue, yValue);
		}
		else
		{
			offset.set(0, 0);
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		if (cartoonSnd != null)
		{
			cartoonSnd.destroy();
			cartoonSnd = null;
		}
	}
}

enum DJBoyfriendState
{
	Intro;
	Idle;
	Confirm;
	Spook;
	TV;
}
