package funkin.stages.objects;

class TankmenBG extends FlxSprite
{
	public static var animationNotes:Array<Dynamic> = [];

	public var strumTime:Float = 0;
	public var goingRight:Bool = false;
	public var tankSpeed:Float = 0.7;

	public var endingOffset:Float;

	public function new(x:Float, y:Float, isGoingRight:Bool)
	{
		super(x, y);

		frames = Paths.content.autoAtlas('tankmanKilled1');
		animation.addByPrefix('run', 'tankman running', 24, true);
		animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);

		animation.play('run');
		animation.curAnim.curFrame = FlxG.random.int(0, animation.curAnim.numFrames - 1);

		updateHitbox();

		setGraphicSize(Std.int(width * 0.8));
		updateHitbox();
	}

	public function resetShit(x:Float, y:Float, isGoingRight:Bool)
	{
		setPosition(x, y);
		goingRight = isGoingRight;
		endingOffset = FlxG.random.float(50, 200);
		tankSpeed = FlxG.random.float(0.6, 1);

		if (goingRight)
			flipX = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (x >= FlxG.width * 1.2 || x <= FlxG.width * -0.5)
			visible = false;
		else
			visible = true;

		if (animation.curAnim.name == 'run')
		{
			var endDirection:Float = (FlxG.width * 0.74) + endingOffset;

			if (goingRight)
			{
				endDirection = (FlxG.width * 0.02) - endingOffset;

				x = (endDirection + (Conductor.songPosition - strumTime) * tankSpeed);
			}
			else
			{
				x = (endDirection - (Conductor.songPosition - strumTime) * tankSpeed);
			}
		}

		if (Conductor.songPosition > strumTime)
		{
			animation.play('shot');

			if (goingRight)
			{
				offset.y = 200;
				offset.x = 300;
			}
		}

		if (animation.curAnim.name == 'shot' && animation.curAnim.curFrame >= animation.curAnim.frames.length - 1)
			kill();
	}
}
